//
//  HomeViewController.h
//  宠汪
//
//  Created by 滕呈斌 on 16/8/8.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "SuperVC.h"

@interface HomeViewController : SuperVC <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) NSMutableArray *dataList;

@property (nonatomic, retain) UIView *moreView;

@end
