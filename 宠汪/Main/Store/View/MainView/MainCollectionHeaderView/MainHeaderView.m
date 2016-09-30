//
//  headerView.m
//  Oupie
//
//  Created by 滕呈斌 on 16/7/13.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "MainHeaderView.h"
#import "XRCarouselView.h"
#import "MMDrawerController.h"
#import "MainViewController.h"
#import "SearchVC.h"

@interface MainHeaderView ()

@end

@implementation MainHeaderView

- (void)awakeFromNib {
    // Initialization code
    //图片
    [_leftButtion setBackgroundImage:[UIImage imageNamed:@"0000"] forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"logo"];
    [_rightButtion setBackgroundImage:[UIImage imageNamed:@"wana"]forState:UIControlStateNormal];
    _logo.image = image;
    
    //代码创建按钮
    NSArray *buttonNames = @[@"泰迪", @"哈士奇", @"阿拉斯加", @"边境牧羊犬", @"藏獒", @"金毛", @"京巴", @"比特", @"沙皮", @"贵宾", @"松狮", @"秋田"];
    for (int i = 0; i < buttonNames.count; ++i) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(30+(i%3)*((kScreenW-100)/3+20), 100+(i/3)*((kScreenW-100)/3+20), (kScreenW-100)/3, (kScreenW-100)/3);
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 10000+i;
        button.layer.cornerRadius = (kScreenW- 100)/3/2;
        button.layer.masksToBounds = YES;
        button.clipsToBounds = YES;
        button.backgroundColor = [UIColor colorWithRed:rand()%10*0.1 green:rand()%10*0.1 blue:rand()%10*0.1 alpha:1];
        button.transform = CGAffineTransformMakeScale(0, 0);
        [self addSubview:button];
    }
    
}

- (void)buttonAction:(UIButton *)button {
    
    
}

- (IBAction)leftButtionAction:(UIButton *)sender {
   
    sender.selected = !sender.selected;
    __weak typeof(self) weakSelf = self;
    if (sender.selected) {
        self.height = kScreenH;
        [UIView animateWithDuration:.2f animations:^{
            
            MainViewController *storeVC = (MainViewController *)weakSelf.viewController;
            storeVC.swipeTableView.transform = CGAffineTransformMakeTranslation(0, kScreenH);
        } completion:^(BOOL finished) {
            self.height = 44;
            for (int i = 0; i < 12; ++i) {
                UIButton *button = (UIButton *)[weakSelf viewWithTag:10000+i];
                [UIView animateWithDuration:.15f delay:.035f*i options:UIViewAnimationOptionLayoutSubviews animations:^{
                    button.transform = CGAffineTransformIdentity;
                } completion:nil];
            }
        }];
        
    } else {
        [UIView animateWithDuration:.2f animations:^{
            MainViewController *storeVC = (MainViewController *)weakSelf.viewController;
            storeVC.swipeTableView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            for (int i = 0; i < 12; ++i) {
                UIButton *button = (UIButton *)[weakSelf viewWithTag:10000+i];
                [UIView animateWithDuration:.01f animations:^{
                    button.transform = CGAffineTransformMakeScale(0, 0);
                }];
            }
        }];
    }
}
- (IBAction)rightButtionAction:(UIButton *)sender {
    
    SearchVC *searchViewController = [[SearchVC alloc] init];
    [self.viewController.navigationController pushViewController:searchViewController animated:YES];
}


//抽屉视图控制器的寻找
- (MMDrawerController *)MMDrawerController {
    
    UIResponder *responder = self;
    
    do {
        if ([responder isKindOfClass:[MMDrawerController class]]) {
            
            return  (MMDrawerController *)responder;
        }
        responder = responder.nextResponder;
    } while (responder != nil);
    
    return nil;
}

@end
