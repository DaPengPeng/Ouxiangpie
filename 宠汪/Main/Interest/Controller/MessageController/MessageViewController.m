//
//  MessageViewController.m
//  宠汪
//
//  Created by 滕呈斌 on 16/8/8.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "MessageViewController.h"
#import "UIImage+WaterMask.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"
#import "PlayerView.h"

@interface MessageViewController () <UITableViewDataSource, UITableViewDelegate, UMSocialUIDelegate>{
    UITableView *_tableView;
    
    NSArray *_dataList;
}

@end

@implementation MessageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"消息";
    
    [self setUpUI];
    [self loadData];
    
    [self creatTableView];
    
    
    UIImageView *iamgeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 200, kScreenW, 300)];
    [iamgeView sd_setImageWithURL:[NSURL URLWithString:@"http://g.hiphotos.baidu.com/image/h%3D360/sign=bd50578441a98226a7c12d21ba83b97a/54fbb2fb43166d2219dec065442309f79152d292.jpg"]];
    [self.view addSubview:iamgeView];
    
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 150, kScreenW, 400)];
//    UIImage *image = [UIImage imageNamed:@"1"];
//    CGPoint point = CGPointMake(imageView.frame.size.width, imageView.frame.size.height );
//    UIImage *newImage = [image addWaterMask:@"偶像一派.png" atPoint:point];
//    imageView.image = newImage;
//    [self.view addSubview:imageView];
}

- (void)setUpUI {
    //返回
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 25, 25);
    [backButton setBackgroundImage:[UIImage imageNamed:@"top_back_white@2x"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)backButtonAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData {
    _dataList = @[@"回复我的", @"喜欢我的", @"系统消息",@"分享"];
}

#pragma mark - TableView
- (void)creatTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = _dataList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        
//        [UMSocialData defaultData].extConfig.wechatSessionData.title = @"标题";// 微信title
//        [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"标题";// 微信朋友圈title
//        [UMSocialData defaultData].extConfig.qqData.title = @"标题";// QQ分享title
//        [UMSocialData defaultData].extConfig.qzoneData.title = @"标题";// Qzone分享title
        // 显示分享界面
        [UMSocialSnsService presentSnsIconSheetView:self appKey:@"57baa4fee0f55adfe200231b" shareText:@"PICC" shareImage:[UIImage imageNamed:@"Icon"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession, UMShareToWechatTimeline, UMShareToQQ, UMShareToQzone, UMShareToSina, nil, nil] delegate:self];
    }
}

@end
