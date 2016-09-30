//
//  NSString+Check.m
//  宠汪
//
//  Created by 滕呈斌 on 16/8/31.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "NSString+Check.h"

@implementation NSString (Check)

- (BOOL)checkPhoneNumberInput {
    
    NSString *MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9]|70|77)\\d{8}$";
    
    NSString *CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    NSString *CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    NSString *CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    BOOL res1 = [regextestmobile evaluateWithObject:self];
    
    BOOL res2 = [regextestcm evaluateWithObject:self];
    
    BOOL res3 = [regextestcu evaluateWithObject:self];
    
    BOOL res4 = [regextestct evaluateWithObject:self];
    
    if (res1 || res2 || res3 || res4 ){
        
        return YES;
        
    } else {
        
        return NO;
        
    }
}

@end
