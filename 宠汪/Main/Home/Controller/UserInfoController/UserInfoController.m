//
//  UserInfoController.m
//  宠汪
//
//  Created by 滕呈斌 on 16/9/14.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "UserInfoController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "MessageModel.h"
#import "UserInfoHeaderView.h"
#import "UserInfoCell.h"
#import "UserModel.h"
#import "DetailTopicController.h"
#import "PrivateMessageController.h"

@interface UserInfoController () <UITableViewDelegate, UITableViewDataSource>{
    UITableView *_tableView;
    
    UserModel *_userModel;
    
    UIButton *_addAttBtn;
    
    UserInfoHeaderView *_headerView;
}

@end

@implementation UserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //数据的加载
    [self loadData];
    
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor grayColor];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    if (!_hasHeaderview) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoHeaderView" owner:nil options:nil] firstObject];
        _tableView.tableHeaderView = _headerView;
    }
    
    if (![_userId isEqualToString:[AVUser currentUser].objectId]) {
        _addAttBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addAttBtn.frame = CGRectMake(0, kScreenH-30, kScreenW/2, 30);
        [_addAttBtn addTarget:self action:@selector(addAttentionAction:) forControlEvents:UIControlEventTouchUpInside];
        [_addAttBtn setTitle:@"加关注" forState:UIControlStateNormal];
        _addAttBtn.backgroundColor = [UIColor redColor];
        _addAttBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.view addSubview:_addAttBtn];
        
        UIButton *priMesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        priMesBtn.frame = CGRectMake(kScreenW/2, kScreenH-30, kScreenW/2, 30);
        [priMesBtn addTarget:self action:@selector(addPrivateMessageAction:) forControlEvents:UIControlEventTouchUpInside];
        [priMesBtn setTitle:@"私信" forState:UIControlStateNormal];
        priMesBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        priMesBtn.backgroundColor = [UIColor greenColor];
        [self.view addSubview:priMesBtn];
    }
    
    //判断用户是否已关注
    AVQuery *query = [AVQuery queryWithClassName:kAttention];
    [query whereKey:kAttedUId equalTo:_userId];
    [query whereKey:kAttUId equalTo:[AVUser currentUser].objectId];
    NSArray *array = [query findObjects];
    if (array.count > 0) {
        [_addAttBtn setTitle:@"已关注" forState:UIControlStateNormal];
        _addAttBtn.userInteractionEnabled = NO;
    }
    
    
    
}

- (void)addAttentionAction:(UIButton *)button {
    
    AVObject *object = [[AVObject alloc] initWithClassName:kAttention];
    [object setObject:[AVUser currentUser].objectId forKey:kAttUId];
    [object setObject:_userId forKey:kAttedUId];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [button setTitle:@"已关注" forState:UIControlStateNormal];
            button.userInteractionEnabled = NO;
            //更改关注数量
            AVQuery *queryAtt1 = [AVQuery queryWithClassName:kAttention];
            [queryAtt1 whereKey:kAttUId equalTo:[AVUser currentUser].objectId];
            NSArray *queryAttArray1 = [queryAtt1 findObjects];
            
            AVQuery *query = [AVQuery queryWithClassName:kUserInfo];
            [query whereKey:kUserInfoId equalTo:[AVUser currentUser].objectId];
            AVObject *object2 = [[query findObjects] firstObject];
            
            [object2 setObject:@(queryAttArray1.count) forKey:kUAttCount];
            [object2 saveInBackground];
            //更改被关注着的粉丝数量
            AVQuery *queryAtt2 = [AVQuery queryWithClassName:kAttention];
            [queryAtt2 whereKey:kAttedUId equalTo:_userModel.uId];
            NSArray *queryAttArray2 = [queryAtt2 findObjects];
            
            AVQuery *otherQuery = [AVQuery queryWithClassName:kUserInfo];
            [otherQuery whereKey:kUserInfoId equalTo:_userId];
            AVObject *otherObject = [[otherQuery findObjects] firstObject];
            ;
            [otherObject setObject:@(queryAttArray2.count) forKey:kUFanCount];
            [otherObject saveInBackground];
        }
    }];
}

- (void)addPrivateMessageAction:(UIButton *)button {
    PrivateMessageController *privateMessVC = [[PrivateMessageController alloc] init];
    privateMessVC.model = _userModel;
    [self.navigationController pushViewController:privateMessVC animated:YES];
}
- (void)loadData {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //加载用户信息
        AVQuery *userQuery =[[AVQuery alloc] initWithClassName:kUserInfo];
        [userQuery whereKey:kUserInfoId equalTo:_userId];
        [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            AVUser *user = [objects firstObject];
            NSString *name = [user objectForKey:kUAlais];
            NSString *sex = [user objectForKey:kUSex];
            NSString *info = [user objectForKey:kUInfo];
            NSNumber *attCount = [user objectForKey:kUAttCount];
            NSNumber *fanCount = [user objectForKey:kUFanCount];
            NSString *address = [user objectForKey:kUAddress];
            NSString *uid = [user objectForKey:kUserInfoId];
            NSString *uImage = [user objectForKey:kUImage];
            NSDictionary *dic = @{kUAlais:name, kUSex:sex, kUInfo:info, kUAttCount:attCount, kUFanCount:fanCount, kUAddress:address, kUserInfoId:uid, kUImage:uImage};
            self.userModel = [[UserModel alloc] initWithDictionary:dic];
        }];
        //加载用户的message
        _dataList = [NSMutableArray array];
        
        AVQuery *query = [[AVQuery alloc] initWithClassName:kMessage];
        [query whereKey:kMUId equalTo:_userId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            for (int i = 0; i < objects.count; i++) {
                AVObject *object = objects[i];
                NSString *mContent = [object valueForKey:kMContent];
                NSNumber *mFav = [object valueForKey:kMFavCount];
                NSNumber *mReplay = [object valueForKey:kMReplayCount];
                NSNumber *mPrise = [object valueForKey:kMPriseCount];
                NSArray *photos = [object valueForKey:kMPhotos];
                NSString *video = [object valueForKey:kMVideo];
                NSNumber *type = [object valueForKey:kMType];
                NSString *mId = [object valueForKey:kMId];
                NSString *uId = [object valueForKey:kMUId];
                NSDate *createdAt = [object valueForKey:kMCreatedAt];
                NSDictionary *dic;
                if (photos) {
                    
                    dic = @{kMContent:mContent, kMFavCount:mFav, kMReplayCount:mReplay, kMPriseCount:mPrise, kMPhotos:photos, kMType:type, kMId:mId, kMUId:uId, kMCreatedAt:createdAt};
                } else if (video) {
                    
                    dic = @{kMContent:mContent, kMFavCount:mFav, kMReplayCount:mReplay, kMPriseCount:mPrise, kMType:type, kMId:mId, kMUId:uId, kMCreatedAt:createdAt, kMVideo:video};
                } else {
                    
                    dic = @{kMContent:mContent, kMFavCount:mFav, kMReplayCount:mReplay, kMPriseCount:mPrise, kMType:type, kMId:mId, kMUId:uId, kMCreatedAt:createdAt};
                }
                
                MessageModel *messageModel = [[MessageModel alloc] initWithDictionary:dic];
                [_dataList addObject:messageModel];
            }
            [_tableView reloadData];
        }];

    });
    
}

- (void)setUserModel:(UserModel *)userModel {
    _userModel = userModel;
    _headerView.userModel = _userModel;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserInfoCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"UserInfoCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoCell" owner:nil options:nil] firstObject];
    }
    cell.model = _dataList[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailTopicController *detailTopicVC = [[DetailTopicController alloc] init];
    detailTopicVC.messageModle = _dataList[indexPath.section];
    [self.navigationController pushViewController:detailTopicVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [self heightForModel:_dataList[indexPath.section]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
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
    
    return 20 + labelH + photoH + 30 + videoH;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    if (!_hasHeaderview) {
        self.navigationController.navigationBar.hidden = YES;
    } else {
        self.navigationController.navigationBar.hidden = NO;
    }
}


@end
