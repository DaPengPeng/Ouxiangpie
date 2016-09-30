//
//  CustomTabBarController.h
//  项目一
//
//  Created by bever on 16/2/19.
//  Copyright © 2016年 我是清风. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTabBarController : UITabBarController {

    //自定义选择图片
    UIImageView *_selectedImageView;
    //自定义tabBar
    UIImageView *_newTabBar;
}

@end

@interface buttonItem : UIControl

- (instancetype)initWithFrame:(CGRect)frame withItem:(UITabBarItem *)item;

@end
