//
//  AccountNumSafeController.m
//  宠汪
//
//  Created by 滕呈斌 on 16/9/28.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "AccountNumSafeController.h"

@interface AccountNumSafeController ()

@end

@implementation AccountNumSafeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataList = @[@[@"密保手机", @"密保邮箱"], @[@"修改密码", @"账号状态"]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UItableViewDelegate


@end
