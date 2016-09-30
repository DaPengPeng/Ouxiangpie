//
//  SettingController.m
//  宠汪
//
//  Created by 滕呈斌 on 16/9/28.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "SettingController.h"

#import "AccountNumSafeController.h"
#import "UserDetailInfoController.h"
#import "AccountNumManageController.h"
#import "AssistFunctionController.h"

@interface SettingController ()

@end

@implementation SettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

- (void)setupUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    NSArray *arrayOne = @[@"账号安全"];
    NSArray *arrayTwo = @[@"个人资料", @"账号管理"];
    NSArray *arrayThree = @[@"浏览设置", @"消息提醒", @"隐私设置", @"辅助功能"];
    NSArray *arrayFour = @[@"版本信息", @"意见反馈"];
    _dataList = @[arrayOne, arrayTwo, arrayThree, arrayFour];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITabelViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = _dataList[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    NSArray *array = _dataList[indexPath.section];
    cell.textLabel.text = array[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath == [NSIndexPath indexPathForRow:0 inSection:0]) {
        AccountNumSafeController *controller = [[AccountNumSafeController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    } else if (indexPath == [NSIndexPath indexPathForRow:0 inSection:1]) {
        UserDetailInfoController *controller = [[UserDetailInfoController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    } else if (indexPath == [NSIndexPath indexPathForRow:1 inSection:1]) {
        AccountNumManageController *controller = [[AccountNumManageController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    } else if (indexPath == [NSIndexPath indexPathForRow:3 inSection:2]) {
        AssistFunctionController *controller = [[AssistFunctionController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

@end
