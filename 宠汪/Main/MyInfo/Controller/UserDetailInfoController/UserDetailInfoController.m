//
//  UserDetailInfoController.m
//  宠汪
//
//  Created by 滕呈斌 on 16/9/28.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "UserDetailInfoController.h"

@interface UserDetailInfoController ()

@end

@implementation UserDetailInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataList = @[@[@"昵称", @"性别", @"个人简介"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
