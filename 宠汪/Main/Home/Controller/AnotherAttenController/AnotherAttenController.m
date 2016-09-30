//
//  AnotherAttenController.m
//  宠汪
//
//  Created by 滕呈斌 on 16/9/19.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "AnotherAttenController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "UserModel.h"
#import "AnotherAttenCell.h"

@interface AnotherAttenController () <UITableViewDelegate, UITableViewDataSource> {
 
    UITableView *_tableView;
    
    NSMutableDictionary *_dataDic;
    
    NSArray *_dataList;
}

@end

@implementation AnotherAttenController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self setupUI];
    
}

- (void)loadData {
    
    NSMutableArray * dataList = [NSMutableArray array];
    _dataDic = [NSMutableDictionary dictionary];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        AVQuery *query = [AVQuery queryWithClassName:kAttention];
        [query whereKey:kAttUId equalTo:[AVUser currentUser].objectId];
        NSArray *array = [query findObjects];
        
        for (AVObject *object in array) {
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
                NSMutableString *mString = [[NSMutableString alloc] initWithString:name];
                if (CFStringTransform((__bridge CFMutableStringRef)mString, 0, kCFStringTransformToLatin, NO)) {
                    
                };
                if (CFStringTransform((__bridge CFMutableStringRef)mString, 0, kCFStringTransformStripDiacritics, NO)) {
                    NSString *bigStr = [mString uppercaseString];
                    model.upCaseAlais = bigStr;
                    
                    model.firstWord = [self firstWordOfString:bigStr];
                }
                [dataList addObject:model];
            }
        }
        //排序
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"upCaseAlais" ascending:YES];
         NSArray *sortDescriptors = [NSArray arrayWithObject:descriptor];
        [dataList sortUsingDescriptors:sortDescriptors];
        

        for (int i = 0; i < dataList.count; ++i) {
            UserModel *model = dataList[i];
            NSMutableArray *userArray = [_dataDic objectForKey:model.firstWord];
            if (userArray) {
                [userArray addObject:model];
                [_dataDic setObject:userArray forKey:model.firstWord];
            } else {
                userArray = [NSMutableArray array];
                [userArray addObject:model];
                [_dataDic setObject:userArray forKey:model.firstWord];
            }
        }
        
        _dataList = [_dataDic.allKeys sortedArrayUsingSelector:@selector(compare:)];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_tableView reloadData];
        });
        
    });
}

- (void)setupUI {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
}

#pragma mark - UITabelViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = _dataList[section];
    NSArray *array = [_dataDic objectForKey:key];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AnotherAttenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnotherAttenCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AnotherAttenCell" owner:nil options:nil] firstObject];
    }
    NSString *key = _dataList[indexPath.section];
    NSArray *array = [_dataDic objectForKey:key];
    UserModel *model = array[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_block) {
        NSString *key = _dataList[indexPath.section];
        NSArray *array = [_dataDic objectForKey:key];
        UserModel *model = array[indexPath.row];
        _block([NSString stringWithFormat:@"@%@",model.uAlais]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section  {
    return 25;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _dataList[section];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (NSString *)firstWordOfString:(NSString *)string {
    
    //将传入的字符串初始化为正则表达式对象
    NSRegularExpression *reguler = [[NSRegularExpression alloc] initWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    //通过正则表达式到字符串中匹配正确对象
    if (string != nil) {
        NSArray *results = [reguler matchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length)];
        NSTextCheckingResult *result = [results firstObject];
        NSRange range = result.range;
        
        NSString *firstWord = [string substringWithRange:range];
        return firstWord;
    }
    return nil;
}

@end
