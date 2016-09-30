//
//  AnotherAttenController.h
//  宠汪
//
//  Created by 滕呈斌 on 16/9/19.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BlockName)(NSString *name);

@interface AnotherAttenController : UIViewController

@property (nonatomic, copy) BlockName block;

@end
