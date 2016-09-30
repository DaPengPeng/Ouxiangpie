//
//  AttentionController.m
//  宠汪
//
//  Created by 滕呈斌 on 16/9/15.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "AttentionController.h"
#import "UserModel.h"
#import "AttentionCell.h"

#import <AVOSCloud/AVOSCloud.h>

@interface AttentionController () <UITableViewDelegate, UITableViewDataSource>{
    UITableView *_tableView;
    
    NSMutableArray *_dataList;
}

@end

@implementation AttentionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
    
    [self setupUI];
}

- (void)loadData {
    
    _dataList = [NSMutableArray array];
    
    if (_isAttention) {
        AVQuery *query = [AVQuery queryWithClassName:kAttention];
        [query whereKey:kAttUId equalTo:_uId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            for (AVObject *object in objects) {
               
                NSString *attedUId = [object objectForKey:kAttedUId];
                
                AVQuery *query = [AVQuery queryWithClassName:kUserInfo];
                [query whereKey:kUserInfoId equalTo:attedUId];
                NSArray *array = [query findObjects];
                
                for (int i = 0; i < array.count; ++i) {
        
                    AVObject *user = array[i];
                    NSString *name = [user objectForKey:kUAlais];
                    NSString *sex = [user objectForKey:kUSex];
                    NSString *info = [user objectForKey:kUInfo];
                    NSNumber *attCount = [user objectForKey:kUAttCount];
                    NSNumber *fanCount = [user objectForKey:kUFanCount];
                    NSString *address = [user objectForKey:kUAddress];
                    NSString *uid = [user objectForKey:kUserInfoId];
                    NSString *uImage = [user objectForKey:kUImage];
                    NSDictionary *dic = @{kUAlais:name, kUSex:sex, kUInfo:info, kUAttCount:attCount, kUFanCount:fanCount, kUAddress:address, kUserInfoId:uid, kUImage:uImage};
                    UserModel *model = [[UserModel alloc] initWithDictionary:dic];
                    [_dataList addObject:model];
                }
            }
            [_tableView reloadData];
        }];
    } else {
        AVQuery *query = [AVQuery queryWithClassName:kAttention];
        [query whereKey:kAttedUId equalTo:_uId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            for (AVObject *object in objects) {
                NSString *attId = [object objectForKey:kAttUId];
                
                AVQuery *query = [AVQuery queryWithClassName:kUserInfo];
                [query whereKey:kUserInfoId equalTo:attId];
                NSArray *array = [query findObjects];
                
                for (int i = 0; i < array.count; ++i) {
                    
                    AVObject *user = array[i];
                    NSString *name = [user objectForKey:kUAlais];
                    NSString *sex = [user objectForKey:kUSex];
                    NSString *info = [user objectForKey:kUInfo];
                    NSNumber *attCount = [user objectForKey:kUAttCount];
                    NSNumber *fanCount = [user objectForKey:kUFanCount];
                    NSString *address = [user objectForKey:kUAddress];
                    NSString *uid = [user objectForKey:kUserInfoId];
                    NSString *uImage = [user objectForKey:kUImage];
                    NSDictionary *dic = @{kUAlais:name, kUSex:sex, kUInfo:info, kUAttCount:attCount, kUFanCount:fanCount, kUAddress:address, kUserInfoId:uid, kUImage:uImage};
                    UserModel *model = [[UserModel alloc] initWithDictionary:dic];
                    [_dataList addObject:model];
                }
            }
            [_tableView reloadData];
        }];
    }
}

- (void)setupUI {
    self.navigationController.navigationBar.hidden = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
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
    
    AttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AttentionCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AttentionCell" owner:nil options:nil] firstObject];
    }
    cell.model = _dataList[indexPath.section];
    
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}



@end
