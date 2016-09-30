//
//  PresentViewControlller.h
//  Oupie
//
//  Created by 滕呈斌 on 16/7/15.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^PresentVCBlock)();

@interface PresentViewControlller : UIViewController

@property (nonatomic, retain)NSArray *imageArray;// 图片数组

@property (nonatomic, assign)NSInteger currentIndex;// 当前图片下标

@property (nonatomic, copy)PresentVCBlock block;// 回调

@end
