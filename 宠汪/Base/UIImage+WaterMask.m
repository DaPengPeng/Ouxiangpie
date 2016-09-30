//
//  UIImage+WaterMask.m
//  宠汪
//
//  Created by 滕呈斌 on 16/8/11.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "UIImage+WaterMask.h"

@implementation UIImage (WaterMask)

- (UIImage *)addWaterMask:(NSString *)maskName atPoint:(CGPoint)point {
 
    UIImage *logo = [UIImage imageNamed:maskName];
    
    //创建一个基于位图的上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    [self drawAsPatternInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    [logo drawAtPoint:point];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
    
}

@end
