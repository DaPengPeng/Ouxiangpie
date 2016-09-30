//
//  MainViewController.h
//  Oupie
//
//  Created by 滕呈斌 on 16/7/12.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainHeaderView.h"
#import "SwipeTableView.h"

@interface MainViewController : UIViewController

@property (nonatomic, retain) MainHeaderView *headerView;

@property (nonatomic, retain) SwipeTableView *swipeTableView;

@end
