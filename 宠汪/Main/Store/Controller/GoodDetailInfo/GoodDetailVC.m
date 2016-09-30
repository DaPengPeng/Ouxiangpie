//
//  GoodDetailVC.m
//  Oupie
//
//  Created by 滕呈斌 on 16/7/14.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "GoodDetailVC.h"
#import "GoodHeaderView.h"
#import "ButtonsView.h"

@interface GoodDetailVC ()<UITableViewDataSource, UITableViewDelegate> {
    
    UITableView *_tableView;
    
    UIScrollView *_scrollView;
}

@end

@implementation GoodDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createTableView];
//    [self createScrollView];
    
    [self createBottomMoudel];
    
}

//创建tableView
- (void)createTableView {

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    
    GoodHeaderView *view = [[GoodHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 900)];

    
//    ButtonsView *buttonsView = [[ButtonsView alloc] initWithFrame:CGRectMake(15, 780, kScreenW-30, 40) withTitleArray:@[@"卖家秀", @"买家秀", @"评价详情"] withSelectedImage:nil];
//    buttonsView.buttonBlock = ^(NSInteger index) {
//        
//    };
//    [view addSubview:buttonsView];
    _tableView.tableHeaderView = view;
}

- (void)createBottomMoudel {
    //shoppingCart
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(kScreenW-48, kScreenH-170, 40, 40)];
    view.backgroundColor = [UIColor grayColor];
    view.layer.cornerRadius = 20;
    view.clipsToBounds = YES;
    UIButton *shoppingCart = [UIButton buttonWithType:UIButtonTypeCustom];
    shoppingCart.frame = CGRectMake(5, 5, 30, 30);
    [shoppingCart setBackgroundImage:[UIImage imageNamed:@"shoppingcart2"] forState:UIControlStateNormal];
    [shoppingCart addTarget:self action:@selector(shoppingCartInterface:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:shoppingCart];
    [self.view addSubview:view];
    
//    //backTop
//    UIButton *backTop = [UIButton buttonWithType:UIButtonTypeCustom];
//    backTop.frame = CGRectMake(kScreenW-48, kScreenH-120, 40, 40);
//    backTop.backgroundColor = [UIColor grayColor];
//    backTop.layer.cornerRadius = 20;
//    backTop.clipsToBounds = YES;
//    [backTop addTarget:self action:@selector(backTopAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backTop];
    
    //底部的背景视图
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH-53, kScreenW, 53)];
    [self.view addSubview:bgView];
    bgView.backgroundColor = [UIColor grayColor];
    
    //addShoppingCart
    UIButton *addShoppingCart = [UIButton buttonWithType:UIButtonTypeCustom];
    addShoppingCart.frame = CGRectMake(kScreenW*0.03, 5, kScreenW*0.44, 40);
    addShoppingCart.backgroundColor = [UIColor greenColor];
    [addShoppingCart setTitle:@"加入购物车" forState:UIControlStateNormal];
    addShoppingCart.layer.cornerRadius = 5;
    addShoppingCart.clipsToBounds = YES;
    [addShoppingCart addTarget:self action:@selector(addShoppingCart:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:addShoppingCart];
    
    //buy
    UIButton *buy = [UIButton buttonWithType:UIButtonTypeCustom];
    buy.frame = CGRectMake(kScreenW-kScreenW*0.47, 5, kScreenW*0.44, 40);
    buy.backgroundColor = [UIColor orangeColor];
    [buy setTitle:@"立即购买" forState:UIControlStateNormal];
    buy.layer.cornerRadius = 5;
    buy.clipsToBounds = YES;
    [buy addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:buy];
}

#pragma mark - shoppingCart
//购物车
- (void)shoppingCartInterface:(UIButton *)button {
    
    
}
////返回到顶部
//- (void)backTopAction:(UIButton *)button {
//    
//    [UIView animateWithDuration:0.25 animations:^{
//        
//        _tableView.contentOffset = CGPointMake(0, 0);
//    }];
//}
//立即购买
- (void)buy:(UIButton *)button {
    
}
//加入购物车
- (void)addShoppingCart:(UIButton *)button {
    
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//        ButtonsView *buttonsView = [[ButtonsView alloc] initWithFrame:CGRectMake(15, 0, kScreenW-30, 40) withTitleArray:@[@"卖家秀", @"买家秀", @"评价详情"] withSelectedImage:nil];
//        buttonsView.buttonBlock = ^(NSInteger index) {
//        
//        };
//        [cell.contentView addSubview:buttonsView];
//    }
//    return cell;
    return nil;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
@end
