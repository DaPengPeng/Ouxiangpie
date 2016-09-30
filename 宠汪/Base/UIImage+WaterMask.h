//
//  UIImage+WaterMask.h
//  宠汪
//
//  Created by 滕呈斌 on 16/8/11.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WaterMask)

- (UIImage *)addWaterMask:(NSString *)maskName atPoint:(CGPoint)point;

@end
