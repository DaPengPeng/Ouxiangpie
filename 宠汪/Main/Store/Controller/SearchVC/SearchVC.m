//
//  SearchVC.m
//  Oupie
//
//  Created by 滕呈斌 on 16/7/19.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "SearchVC.h"
#import "SearchCell.h"

@interface SearchVC () <UITableViewDataSource, UITableViewDelegate>{
    
    UITableView *_tableView;
    UITextField *_textField;
    NSArray *_hotSearch;
    NSArray *_searchWord;
    CGFloat _width;
    
}

@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    NSUserDefaults *userDefaulte = [NSUserDefaults standardUserDefaults];
    _searchWord = [userDefaulte objectForKey:@"searchHistory"];
    
    [self createTableView];
    
    [self setNavigationBar];
}

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}
- (void)setNavigationBar {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 40, 40);
    [backButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    backButton.tag = 200;
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.titleLabel.textColor = [UIColor blueColor];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(0, 0, 40, 40);
    [searchButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    searchButton.tag = 201;
    [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    searchButton.titleLabel.textColor = [UIColor redColor];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kScreenW-140, 25)];
    _textField.backgroundColor = [UIColor grayColor];
    self.navigationItem.titleView = _textField;
}

- (void)buttonAction:(UIButton *)button {
    
    if (button.tag == 200) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        if (![_textField.text isEqualToString:@""]) {
            NSLog(@"搜索内容");
            //搜索内容添加到本地
            NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
            NSArray *array = [userdefaults objectForKey:@"searchHistory"];
            if (array) {
                NSMutableArray *mArray = [array mutableCopy];
                [mArray addObject:_textField.text];
                
                [userdefaults setObject:mArray forKey:@"searchHistory"];
                
            }else {
                NSMutableArray *mArray = [[NSMutableArray alloc] init];
                [mArray addObject:_textField.text];
                [userdefaults setObject:mArray forKey:@"searchHistory"];
            }
            
            
        }
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return _searchWord.count;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SearchCell" owner:nil options:nil] firstObject];
        }
        
        CGFloat wordLenth = 0;
        NSUInteger wordLine = 0;
        BOOL isFirstLine = YES;
        NSUInteger newIndex = 0;
        for (int i = 0; i < _hotSearch.count; i++) {
            if (wordLine == 0) {
                isFirstLine = YES;
            }else {
                isFirstLine = NO;
            }
            NSString *hotWord = _hotSearch[i];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60*isFirstLine+newIndex*10+wordLenth*20, 10+wordLine*40, hotWord.length*20, 25)];
            wordLenth += hotWord.length;
            [cell.contentView addSubview:label];
            label.text = hotWord;
            label.layer.borderColor = [UIColor redColor].CGColor;
            label.layer.borderWidth = 2;
            label.textAlignment = NSTextAlignmentCenter;
            newIndex ++;
            if (i < _hotSearch.count - 1) {
                
                NSString *nextHotWord = _hotSearch[i+1];
                if ((label.frame.origin.x+label.width+20+nextHotWord.length*20 > kScreenW) ) {
                    wordLine++;
                    wordLenth = 0;
                    newIndex = newIndex - i;
                }
                
            }
            
        }
        return cell;
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            
        }
        cell.textLabel.text = _searchWord[indexPath.row];
        return cell;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CGFloat wordLenth = 0;
        NSUInteger wordLine = 0;
        BOOL isFirstLine = YES;
        NSUInteger newIndex = 0;
        
        for (int i = 0; i < _hotSearch.count; i++) {
            
            if (wordLine == 0) {
                isFirstLine = YES;
            }else {
                isFirstLine = NO;
            }
            NSString *hotWord = _hotSearch[i];
            CGFloat labelX = 60*isFirstLine+newIndex*10+wordLenth*20;
            wordLenth += hotWord.length;

            newIndex ++;
            if (i < _hotSearch.count - 1) {
                
                NSString *nextHotWord = _hotSearch[i+1];
                if ((labelX+10+wordLine*30+20+nextHotWord.length*20 > kScreenW) ) {
                    wordLine++;
                    wordLenth = 0;
                    newIndex = newIndex - i;
                    return (wordLine+1)*45;
                }
            }
        }
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 25;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    _hotSearch = @[@"短袖", @"牛仔裤", @"短裤", @"连衣裙", @"生活神器",@"生活神器",@"生活神器",@"生活神器",@"生活神器",];
    
    self.tabBarController.tabBar.hidden = YES;

}

@end
