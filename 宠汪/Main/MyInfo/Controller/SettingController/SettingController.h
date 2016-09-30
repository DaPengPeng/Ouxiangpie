//
//  SettingController.h
//  宠汪
//
//  Created by 滕呈斌 on 16/9/28.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) NSArray *dataList;

@property (nonatomic, retain) UITableView *tableView;

@end
