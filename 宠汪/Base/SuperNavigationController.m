//
//  SuperNavigationController.m
//  宠汪
//
//  Created by 滕呈斌 on 16/8/8.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "SuperNavigationController.h"

@interface SuperNavigationController ()

@end

@implementation SuperNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end
