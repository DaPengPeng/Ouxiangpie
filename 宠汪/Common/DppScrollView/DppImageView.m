//
//  DppImageView.m
//  Oupie
//
//  Created by 滕呈斌 on 16/7/15.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "DppImageView.h"
#import "PresentViewControlller.h"
#import "DppScrollView.h"

@implementation DppImageView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapAction {
    
    PresentViewControlller *presentVC = [[PresentViewControlller alloc] init];
    DppScrollView *scrollView = [self dppScrollView];
    presentVC.currentIndex = self.index;
    presentVC.imageArray = scrollView.mImageArray;
    //回调
    presentVC.block = ^(){
        [self.viewController dismissViewControllerAnimated:NO completion:nil];
    };
    
    [self.viewController presentViewController:presentVC animated:NO completion:nil];
}

- (DppScrollView *)dppScrollView {
    
    UIResponder *responder = self;
    do {
        
        if ([responder isKindOfClass:[DppScrollView class]]) {
            return (DppScrollView *)responder;
        }
        responder = responder.nextResponder;
    } while (responder != nil);
    return nil;
}

@end
