//
//  SuperVC.m
//  Oupie
//
//  Created by 滕呈斌 on 16/7/20.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "SuperVC.h"

@interface SuperVC ()

@end

@implementation SuperVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = NO;
}
@end
