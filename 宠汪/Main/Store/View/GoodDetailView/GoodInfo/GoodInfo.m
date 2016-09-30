//
//  GoodInfo.m
//  Oupie
//
//  Created by 滕呈斌 on 16/7/14.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "GoodInfo.h"
#import "ButtonsView.h"

@interface GoodInfo ()

@property (weak, nonatomic) IBOutlet ButtonsView *buttonsView;

@end


@implementation GoodInfo



- (void)awakeFromNib {
    
    _buttonsView.titleArray = @[@"卖家秀", @"买家秀", @"评价详情"];
    _buttonsView.buttonBlock = ^(NSInteger index) {
        
        NSLog(@"...........");
        
    };
    
}
@end
