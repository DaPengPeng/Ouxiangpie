//
//  DetailTopicController.m
//  宠汪
//
//  Created by 滕呈斌 on 16/9/12.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "DetailTopicController.h"
#import "HomeTableViewCell.h"
#import "CNLabel.h"
#import "DPPlaceHoldTextView.h"
#import "ReplayModel.h"
#import "DetailCell.h"

#import <AVOSCloud/AVOSCloud.h>

@interface DetailTopicController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate> {
    UITableView *_tableView;
    
    NSMutableArray *_dataList;
}

@end

@implementation DetailTopicController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self addObserver];
    
    [self loadData];
    
    [self setupUI];
    
}

- (void)changeReplayViewFrame:(NSNotification *)notification {
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        //获取键盘高度
        NSValue *value = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect rect = [value CGRectValue];
        CGFloat keyBoardHeiht = rect.size.height;
        NSValue *time = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval duration;
        [time getValue:&duration];
        [UIView animateWithDuration:duration animations:^{
            
            _replayView.frame = CGRectMake(0, kScreenH-40-keyBoardHeiht, kScreenW, 40);
        }];
    } else {
        _replayView.frame = CGRectMake(0, kScreenH-40, kScreenW, 40);
    }
}

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeReplayViewFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeReplayViewFrame:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)loadData {
    _dataList = [NSMutableArray array];
    //更新model数据
    AVQuery *queryModel = [AVQuery queryWithClassName:kMessage];
    [queryModel whereKey:kMId equalTo:_messageModle.mId];
    AVObject *object = [[queryModel findObjects] firstObject];
    NSDictionary *dic = [object dictionaryForObject];
    
    MessageModel *messageModel = [[MessageModel alloc] initWithDictionary:dic];

    _messageModle = messageModel;
    //更新评论数据
    AVQuery *query = [AVQuery queryWithClassName:kRePlay];
    [query whereKey:kRMId equalTo:_messageModle.mId];
    NSArray *array = [query findObjects];
    for (AVObject *replay in array) {
        NSString *rContent = [replay objectForKey:kRcontent];
        NSString *rId = [replay objectForKey:kRRId];
        NSString *rUId = [replay objectForKey:kRUid];
        NSString *createdAt = [replay objectForKey:kRCreatedAt];
        
        NSDictionary *dic = @{kRcontent:rContent, kRRId:rId, kRUid:rUId, kRRId:rId, kRCreatedAt:createdAt};
        ReplayModel *model = [[ReplayModel alloc] initWithDictionary:dic];
        [_dataList addObject:model];
    }
    
}

- (void)setupUI {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [_tableView addGestureRecognizer:tap];
    [self.view addSubview:_tableView];
    
    HomeTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:nil options:nil] firstObject];
    cell.messageModel = _messageModle;
    cell.height = [self heightForModel:_messageModle];
    _tableView.tableHeaderView = cell;
    
    _replayView = [[[NSBundle mainBundle] loadNibNamed:@"ReplayView" owner:nil options:nil] firstObject];
    _replayView.frame = CGRectMake(0, kScreenH-40, kScreenW, 40);
    _replayView.textView.placehold = @"请再此输入";
    _replayView.isReplay = YES;
    _replayView.backgroundColor = [UIColor grayColor];
    _replayView.textView.textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20]};
    _replayView.textView.font = [UIFont systemFontOfSize:20];
    _replayView.textView.delegate = self;
    
    __weak typeof (_tableView) weakTabView = _tableView;
    __weak typeof(self) weakself = self;
    _replayView.reloadBlock = ^() {
        [weakself loadData];
        [weakTabView reloadData];
    };
    [self.view addSubview:_replayView];
    
}
- (void)tapAction {
    [_replayView.textView resignFirstResponder];
    _replayView.frame = CGRectMake(0, kScreenH-40, kScreenW, 40);
}

- (CGFloat)heightForModel:(MessageModel *)model {
    
    CGFloat labelH = 0;
    if (model.mContent != nil && ![model.mContent isEqualToString:@""]) {
        CNLabel *label = [[CNLabel alloc] init];
        label.text = model.mContent;
        labelH = label.height;
    }
    
    CGFloat photoH = 0;
    if (model.mPhotos.count > 0) {
        switch (model.mPhotos.count) {
            case 1:case 2:case 3:
                photoH = (kScreenW-6)/3;
                break;
            case 4: case 5: case 6:
                photoH = (kScreenW-6)/3*2 + 3;
                break;
            case 7: case 8: case 9:
                photoH = (kScreenW-6)/3*3 + 6;
            default:
                photoH = 0;
                break;
        }
    }
    
    CGFloat videoH = 0;
    if ([model.mType integerValue] == 2) {
        PlayerView *playerView = [[PlayerView alloc] init];
        playerView.url = model.mVideo;
        videoH = playerView.height;
    }
    
    return 55 + labelH + photoH + 30 + videoH;
    
}
#pragma mark - UITableDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailCell" owner:nil options:nil] firstObject];
    }
    cell.model = _dataList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightOfContent:_dataList[indexPath.row]];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UITextViewChangeWithValue" object:nil userInfo:@{@"text":_replayView.textView.text}];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
}

//这里成为第一响应者需要在这里使用，否则会有错误。
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_isFirst) {
        [_replayView.textView becomeFirstResponder];
    }
}

- (CGFloat)heightOfContent:(ReplayModel *)model {
    CGFloat labelH = 0;
    if (model.rContent != nil && ![model.rContent isEqualToString:@""]) {
        CNLabel *label = [[CNLabel alloc] init];
        label.text = model.rContent;
        labelH = label.height;
    }
    
    return 48 + labelH;
}

@end
