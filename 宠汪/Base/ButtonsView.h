//
//  ButtonsView.h
//  ButtonDamo
//
//  Created by bever on 16/2/23.
//  Copyright © 2016年 我是清风. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonsBlock)(NSInteger index);

@interface ButtonsView : UIScrollView

@property (nonatomic,strong) NSArray *titleArray;//标题数组

@property (nonatomic,copy) NSString *selectedImage;//选中图片

@property (nonatomic,assign) NSInteger currentIndex;//当前控制器下标

@property (nonatomic,copy) ButtonsBlock buttonBlock;//回调block

-(instancetype)initWithFrame:(CGRect)frame withTitleArray:(NSArray *)titleArray withSelectedImage:(NSString *)selectedImage;

@end
