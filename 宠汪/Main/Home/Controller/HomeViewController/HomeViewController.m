//
//  HomeViewController.m
//  宠汪
//
//  Created by 滕呈斌 on 16/8/8.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "HomeViewController.h"
#import "MMDrawerController.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshAutoNormalFooter.h"
#import "HomeTableViewCell.h"
#import "SendTopicController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "LoginViewController.h"
#import "CNLabel.h"
#import "PlayerView.h"
#import "DetailTopicController.h"

#import "MessageModel.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"


@interface HomeViewController () {
    UITableView *_moreTableView;
    NSArray *_moreDataList;
    MessageModel *_model; //存储点击信息
    
    UITableView *_reportTableView;
    NSArray *_reportDataList;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HomeViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tabBarItem.image = [UIImage imageNamed:@"home"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"home_on"];
        self.tabBarItem.title = @"首页";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [[NSNotificationCenter defaultCenter] addObserverForName:kVideoCorLoadOver object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
//        
//        NSIndexPath *indexPath = [note.userInfo objectForKey:@"indexPath"];
//        NSLog(@"indexPath.section:%lu",indexPath.section);
//        [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
////        [self tableView:_tableView heightForRowAtIndexPath:indexPath];
//    }];
    
    [self loadData];
    
    //导航栏的UI
    [self setNaviBarUI];
    
    //下拉刷新和上拉加载
    [self setRefresh];
    
}

- (void)loadData {

    _moreDataList = @[@"收藏", @"分享", @"举报"];
    _reportDataList = @[@"垃圾营销", @"不实信息", @"有害信息", @"违法信息", @"淫秽色情", @"人身攻击我"];
    _dataList = [NSMutableArray array];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        AVQuery *query = [AVQuery queryWithClassName:kMessage];
        NSArray *array = [query findObjects];
        if (array.count > 0) {
            for (AVObject *object in array) {
                
                NSMutableDictionary *mdic = [object dictionaryForObject];
                MessageModel *messageModel = [[MessageModel alloc] initWithDictionary:mdic];
                [_dataList addObject:messageModel];
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
        });
    });


}

#pragma mark - SetNaviBarUI
- (void)setNaviBarUI {
    
    //左侧按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 44, 44);
    [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"button_icon_group"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //中间logo
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    logo.image = [UIImage imageNamed:@""];
    self.navigationItem.titleView = logo;
    
    //右侧搜索
    UIButton *rightSearchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightSearchButton.frame = CGRectMake(0, 0, 44, 44);
    [rightSearchButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightSearchButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    
    _moreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    _moreView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreViewTapAction)];
    [_moreView addGestureRecognizer:tap];
    [self.view addSubview:_moreView];
    _moreView.hidden = YES;
    
    _moreTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW*0.6, kScreenH*0.2)];
    _moreTableView.center = _moreView.center;
    _moreTableView.scrollEnabled = NO;
    _moreTableView.hidden = YES;
    [self.view addSubview:_moreTableView];
    _moreTableView.dataSource = self;
    _moreTableView.delegate = self;
//    _moreTableView.rowHeight = kScreenH * (0.2/3.0);
    
    _reportTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW*0.6, kScreenH*0.4)];
    [self.view addSubview:_reportTableView];
    _reportTableView.center = _moreView.center;
    _reportTableView.hidden = YES;
    _reportTableView.dataSource = self;
    _reportTableView.delegate = self;
    _reportTableView.scrollEnabled = NO;
}

- (void)moreViewTapAction {
    _moreView.hidden = YES;
    _moreTableView.hidden = YES;
    _reportTableView.hidden = YES;
}

//leftButtonAction
- (void)leftButtonAction:(UIButton *)button {
    
    MMDrawerController *MMDrawerController = [self MMDrawerController];
    [MMDrawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        
    }];
    
}
//rightButtonAction
- (void)rightButtonAction:(UIButton *)button {
    
    AVUser *user = [AVUser currentUser];
    if (user) {
        SendTopicController *sendTopicController = [[SendTopicController alloc] init];
        [self.navigationController pushViewController:sendTopicController animated:YES];
    } else {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
    
    
}

//抽屉视图控制器的寻找
- (MMDrawerController *)MMDrawerController {
    
    UIResponder *responder = self;
    
    do {
        if ([responder isKindOfClass:[MMDrawerController class]]) {
            
            return  (MMDrawerController *)responder;
        }
        responder = responder.nextResponder;
    } while (responder != nil);
    
    return nil;
}

#pragma mark - TabelView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tableView) {
        return 1;
    } else if (tableView == _reportTableView) {
        return _reportDataList.count;
    } else {
        return _moreDataList.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tableView) {
        
        HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeTableViewCell" owner:nil options:nil] firstObject];
        }
        cell.messageModel = _dataList[indexPath.section];
        
        __weak typeof(_moreView) weakMoreView = _moreView;
        __weak typeof (_dataList) weakDtaList = _dataList;
        __weak typeof (_moreTableView) weakMoreTabView = _moreTableView;
        cell.block = ^() {
            weakMoreView.hidden = NO;
            _model = weakDtaList[indexPath.section];
            weakMoreTabView.hidden = NO;
            
        };
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] init];
        }
        if (tableView == _reportTableView) {
            cell.textLabel.text = _reportDataList[indexPath.row];
        } else {
            cell.textLabel.text = _moreDataList[indexPath.row];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _tableView) {
        DetailTopicController *detailTopicVC = [[DetailTopicController alloc] init];
        detailTopicVC.messageModle = _dataList[indexPath.section];
        [self.navigationController pushViewController:detailTopicVC animated:YES];
    } else if (tableView == _moreTableView){
     
        if (indexPath.row == 0) {
            //收藏
            AVObject *object = [[AVObject alloc] initWithClassName:kFav];
            [object setObject:[AVUser currentUser].objectId forKey:kFUId];
            [object setObject:_model.mId forKey:kFMId];
            [object saveInBackground];
            _moreTableView.hidden = YES;
            _moreView.hidden = YES;
        } else if (indexPath.row == 1) {
            //分享
            // 显示分享界面
//            [UMSocialSnsService presentSnsIconSheetView:self appKey:@"57baa4fee0f55adfe200231b" shareText:@"PICC" shareImage:[UIImage imageNamed:@"Icon"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession, UMShareToWechatTimeline, UMShareToQQ, UMShareToQzone, UMShareToSina, nil, nil] delegate:self];
            _moreView.hidden = YES;
            _moreTableView.hidden = YES;
        } else if (indexPath.row == 2) {
            //举报
            _reportTableView.hidden = NO;
            _moreTableView.hidden = YES;
            
        }
    } else {
        //举报内容的点击
        
        AVObject *report = [[AVObject alloc] initWithClassName:kReport];
        [report setObject:kMessage forKey:kRepObject];
        [report setObject:_model.mId forKey:kRepObjectId];
        [report setObject:_reportDataList[indexPath.row] forKey:kRepReason];
        [report setObject:[AVUser currentUser].objectId forKey:kRepUId];
        [report saveInBackground];
        _reportTableView.hidden = YES;
        _moreView.hidden = YES;
        _moreTableView.hidden = YES;
    }
}


//- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
// 
//    if (tableView == _tableView) {
//        HomeTableViewCell *newCell = (HomeTableViewCell *)cell;
//        [newCell.playerView pause];
//    }
//    
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _tableView) {
        return _dataList.count;
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == _tableView) {
        return 5;
    } else {
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _tableView) {
        MessageModel *model = _dataList[indexPath.section];
        return [self heightForModel:model];
    } else {
        return kScreenH * (0.2/3.0);
    }
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//}

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
            case 1: case 2: case 3:
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
        
        videoH = kScreenW * (9.0/16.0);
    }

    return 55 + labelH + photoH + 30 + videoH;
    
}



#pragma mark - SetRefresh
- (void)setRefresh {
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
}

- (void)refresh {
    
    [self loadData];
    [self.tableView.mj_header endRefreshing];
}

- (void)loadMore {
    
    [self.tableView.mj_footer endRefreshing];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
