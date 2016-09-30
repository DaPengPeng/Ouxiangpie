//
//  MyInfoViewController.m
//  宠汪
//
//  Created by 滕呈斌 on 16/8/8.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "MyInfoViewController.h"
#import "UserCenterTableViewSectionZero.h"
#import "LoginViewController.h"
#import "SettingController.h"

#import <AVOSCloud/AVOSCloud.h>

@interface MyInfoViewController () <UITableViewDelegate, UITableViewDataSource> {
    
    UITableView *_tableView;
    
    NSDictionary *_dataDic;
    NSArray *_dataList;
}

@end

@implementation MyInfoViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tabBarItem.image = [UIImage imageNamed:@"myinfo"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"myinfo_on"];
        self.title = @"用户中心";
        self.tabBarItem.title = @"我";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //加载数据
    [self loadData];
    
    //创建表视图
    [self setupUI];
    
//    [_tableView registerNib:[UINib nibWithNibName:@"UserCenterTableViewSectionZero" bundle:nil] forCellReuseIdentifier:@"UserCenterTableViewSectionZero"];
    
    
    
}

- (void)loadData {
    
    _dataDic = @{@"section0": @[@""], @"section1": @[@"收藏的帖子"], @"section2":@[@"客服中心", @"关于偶像一派"]};
    _dataList = @[@"section0", @"section1", @"section2"];
    
}

//创建表视图
- (void)setupUI{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    UIView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"UserCenterHeaderView" owner:nil options:nil] objectAtIndex:1];
    _tableView.tableHeaderView = headerView;
    
    //setting按钮
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.frame = CGRectMake(0, 0, 44, 44);
    [settingBtn addTarget:self action:@selector(settingButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:settingBtn];
    self.navigationItem.rightBarButtonItem = buttonItem;
    
}

- (void)settingButtonAction:(UIButton *)button {
    SettingController *settingController = [[SettingController alloc] init];
    [self.navigationController pushViewController:settingController animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = _dataDic[_dataList[section]];
    return array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        UserCenterTableViewSectionZero *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCenterTableViewSectionZero"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UserCenterTableViewSectionZero" owner:nil options:nil] firstObject];
        }
        cell.titleArray = @[@{@"ShoppingCartVC": @"购物车"}, @{@"MyOrder": @"我的订单"}, @{@"MyCollect": @"收藏的宝贝"}, @{@"MyBag": @"我的卡券"}];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSArray *array = _dataDic[_dataList[indexPath.section]];
        cell.textLabel.text = array[indexPath.row];
        return cell;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _dataList.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    AVUser *user = [AVUser currentUser];
    if (user) {
       
        
    } else {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return kScreenW/4*0.6+15+21;
    }
    return 44;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

@end
