//
//  CustomTabBarController.m
//  项目一
//
//  Created by bever on 16/2/19.
//  Copyright © 2016年 我是清风. All rights reserved.
//

#import "CustomTabBarController.h"
#define kScreen_W [UIScreen mainScreen].bounds.size.width
#define kScreen_H [UIScreen mainScreen].bounds.size.height

@interface CustomTabBarController ()

@end

@implementation CustomTabBarController {
    
    NSInteger _index;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _index = 100;
    
    //创建自定义的tabBar
    _newTabBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_W, 49)];
    _newTabBar.userInteractionEnabled = YES;
    _newTabBar.multipleTouchEnabled = YES;
//    _newTabBar.image = [UIImage imageNamed:@"navbg"];
    _newTabBar.backgroundColor = [UIColor grayColor];
    [self.tabBar addSubview:_newTabBar];
    
}

#pragma mark - 复写viewControllers的set方法
- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    
    [super setViewControllers:viewControllers];
    
    //按钮的创建
    [self createButton];
}
#pragma mark - 按钮的创建
- (void)createButton {
    
    //获取控制器的数量
    int controllerCount = (int)self.viewControllers.count;
    
    //设置背景图片
    _selectedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_W/self.viewControllers.count, 49)];
    _selectedImageView.image = [UIImage imageNamed:@"选中"];
    [self.tabBar addSubview:_selectedImageView];
    
    int i = 0;
    
    //创建按钮
    for (UIViewController *viewController in self.viewControllers) {
        
        buttonItem *button = [[buttonItem alloc] initWithFrame:CGRectMake(kScreen_W/controllerCount*i, 0, kScreen_W/controllerCount, 49) withItem:viewController.tabBarItem];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100+i;

        i++;
        [self.tabBar addSubview:button];
        
    }
}
//使用for循环的话无法传递tabBarItem

#pragma mark - 删除系统的tabBarButton
-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    //删除系统的tabBarItem
    for(UIView *vv in [self.tabBar subviews])
    {
        for(UIView *v in [vv subviews])
        {

            if([v isKindOfClass:NSClassFromString(@"UITabBarButtonLabel")]) {
                [v setHidden:YES];
            } else if([v isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
                [v setHidden:YES];
            }
        }
    }
}



#pragma mark - 按钮的响应事件
- (void)buttonAction:(UIButton *)button {
    
    //更改控制器
    self.selectedIndex = button.tag - 100;
    
    //获取当前控制器的按钮
    UIButton *oldButton = [self.tabBar viewWithTag:_index];
    UIImageView *oldImageView = [oldButton.subviews firstObject];
    
    if (oldButton.subviews.count >= 2) {
        
        UILabel *oladLabel  = [oldButton.subviews objectAtIndex:1];
    
        if (button.tag != _index) {
            
            oldImageView.image = [self.viewControllers objectAtIndex:(_index-100)].tabBarItem.image;
            oladLabel.textColor = [UIColor whiteColor];
            UIImageView *imageView = [button.subviews firstObject];
            imageView.image = self.selectedViewController.tabBarItem.selectedImage;
            UILabel *label = [button.subviews objectAtIndex:1];
            label.textColor = [UIColor redColor];
        }
    }
    
    //记录上一次点击按钮的tag值
    _index = button.tag;
    
    //添加背景动画
    [UIView animateWithDuration:0.3 animations:^{
        
        _selectedImageView.frame = CGRectMake(kScreen_W/self.viewControllers.count*self.selectedIndex, 0, kScreen_W/self.viewControllers.count, 49);
    }];
    
}

@end


@implementation buttonItem

#pragma mark - 重写buttonItem的方法
- (instancetype)initWithFrame:(CGRect)frame withItem:(UITabBarItem *)item {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        //创建UIImageView
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width-20)/2, 8, 20, 20)];
        imageView.image = item.image;
        
        //防止图片拉伸
//        imageView.contentMode = UIViewContentModeCenter;//图片大小合适的时候使用
        
        //创建UILabel
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bounds.size.height + imageView.frame.origin.y, frame.size.width, 20)];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = item.title;
        
        //imageView与label的添加
        if (item.title) {
            
            if ([item.title  isEqual: @"首页"]) {
                
                imageView.image = [UIImage imageNamed:@"home_on@2x"];
                label.textColor = [UIColor redColor];
                [self addSubview:imageView];
            }
            
            [self addSubview:imageView];
            [self addSubview:label];
            
        } else {
            
            [self addSubview:imageView];
            imageView.frame = CGRectMake((frame.size.width - 40)/2, 5, 40, 40);
        }
    }
    return self;
}

@end