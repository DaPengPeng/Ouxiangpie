//
//  ShoppingCartVC.m
//  Oupie
//
//  Created by 滕呈斌 on 16/7/18.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "ShoppingCartVC.h"
#import "ShoppingCartTabelViewCell.h"

@interface ShoppingCartVC () <UITableViewDataSource, UITableViewDelegate>{
    
    UITableView *_tableView;
}

@end

@implementation ShoppingCartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"购物车";
    //tableView
    [self createTabelView];
    
    [self createBottomView];
    
    [self addCustomBackButton];
}

- (void)createTabelView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}
- (void)createBottomView {
    
    UIView *bottomView = [[[NSBundle mainBundle] loadNibNamed:@"ShoppingCartfootView" owner:nil options:nil] firstObject];
    bottomView.frame = CGRectMake(0, kScreenH-50, kScreenW, 50);
    [self.view addSubview:bottomView];
}

//添加自定义返回按钮
- (void)addCustomBackButton {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 20, 20);
    [button setImage:[UIImage imageNamed:@"top_back_white"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
}
//按钮的相应事件
- (void)buttonAction:(UIButton *)button {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingCartTabelViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingCartTabelViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ShoppingCartTabelViewCell" owner:nil options:nil] firstObject];
    }
    
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.01;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
@end
