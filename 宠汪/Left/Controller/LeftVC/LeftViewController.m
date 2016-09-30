//
//  LeftViewController.m
//  Oupie
//
//  Created by 滕呈斌 on 16/7/15.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "LeftViewController.h"
#import "DetialClassVC.h"
#import "MMDrawerController.h"

@interface LeftViewController () <UITableViewDataSource, UITableViewDelegate>{

    NSDictionary *_dataDic;
    NSArray *_dataList;
    
//    UITableView *_tableView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    _dataDic = @{@"section1":@[@"炫酷男生", @"上装", @"裤装", @"鞋子"], @"section2":@[@"优雅女生", @"裙装", @"鞋子", @"包包"], @"section3":@[@"生活神器", @"美妆护肤", @"数码产品", @"服饰配件"]};
    
    _dataList = @[@"section1", @"section2", @"section3"];
}
- (IBAction)buttonAction:(UIButton *)sender {
}

#pragma mark - UITableViewDataSource
//单元格个数的返回
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSArray *array = _dataDic[_dataList[section]];
    return array.count;
}
//单元格的返回
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSArray *array = _dataDic[_dataList[indexPath.section]];
    cell.textLabel.text = array[indexPath.row];


    return cell;
}
//组数的返回
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 30;
}

//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MMDrawerController *MMDrawerController = [self MMDrawerController];
    [MMDrawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        
    }];
    
    DetialClassVC *detailClassVC = [[DetialClassVC alloc] init];
    UINavigationController *navigationController = (UINavigationController *)MMDrawerController.centerViewController;
    [navigationController pushViewController:detailClassVC animated:YES];
}

//抽屉视图控制器的寻找
- (MMDrawerController *)MMDrawerController {
    
    UIResponder *responder = self;
    
    do {
        if ([responder isKindOfClass:[MMDrawerController class]]) {
            
            return  (MMDrawerController *)responder;
        }
        responder = responder.nextResponder;
    } while (responder != nil);
    
    return nil;
}


@end
