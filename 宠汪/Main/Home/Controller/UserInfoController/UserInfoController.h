//
//  UserInfoController.h
//  宠汪
//
//  Created by 滕呈斌 on 16/9/14.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "SuperVC.h"

@interface UserInfoController : SuperVC

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, assign) BOOL hasHeaderview;

@property (nonatomic, retain) NSMutableArray *dataList;
@end
