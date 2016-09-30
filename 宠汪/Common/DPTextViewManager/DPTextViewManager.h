//
//  DPTextViewManager.h
//  宠汪
//
//  Created by 滕呈斌 on 16/9/8.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CNLabel.h"

@interface DPTextViewManager : NSObject

@property (nonatomic, retain) NSMutableString *string;

@property (nonatomic, retain) NSMutableArray *attInfo;

+ (instancetype)shareManager;

- (NSMutableAttributedString *)attributedStringWtihName:(NSString *)string;

- (NSString *)stringWithAttString:(NSString *)attStr;


@end
