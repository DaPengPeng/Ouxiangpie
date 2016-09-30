//
//  InterestController.m
//  宠汪
//
//  Created by 滕呈斌 on 16/8/26.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "InterestController.h"
#import "MessageViewController.h"

#import <AVOSCloud/AVOSCloud.h>

@interface InterestController () <UITableViewDelegate, UITableViewDataSource>{
    UITableView *_tableView;
    
    NSArray *_dataList;
}

@end


@implementation InterestController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tabBarItem.image = [UIImage imageNamed:@"discover"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"discover_on"];
        self.title = @"我的圈子";
        self.tabBarItem.title = @"兴趣";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    [self loadData];
    [self setUpUI];
}

- (void)loadData {
    _dataList = @[@"狗狗", @"猫猫", @"问答", @"其他宠物"];
}

- (void)setUpUI {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 49, 49);
    [rightButton setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
}

- (void)rightButtonAction {
    
    MessageViewController * messageViewController = [[MessageViewController alloc] init];
    [self.navigationController pushViewController:messageViewController animated:YES];
    
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _dataList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
//    
//    NSArray *emoticonArray = [[NSArray alloc] initWithContentsOfFile:path];
//    for (NSDictionary *emoticonDic in emoticonArray) {
//        
//        NSString *cht = [emoticonDic objectForKey:@"cht"];
//        NSString *gif = [emoticonDic objectForKey:@"gif"];
//        NSNumber *type = [emoticonDic objectForKey:@"type"];
//        NSString *chs = [emoticonDic objectForKey:@"chs"];
//        NSString *png = [emoticonDic objectForKey:@"png"];
//        AVObject *emoticon = [[AVObject alloc] initWithClassName:@"Emoticon"];
//        [emoticon setObject:cht forKey:@"cht"];
//        [emoticon setObject:gif forKey:@"gif"];
//        [emoticon setObject:type forKey:@"type"];
//        [emoticon setObject:chs forKey:@"chs"];
//        [emoticon setObject:png forKey:@"png"];
//        NSString *gifPath = [[NSBundle mainBundle] pathForResource:[gif substringToIndex:3] ofType:@"gif"];
//        AVFile *gifFile = [AVFile fileWithData:[NSData dataWithContentsOfFile:gifPath]];
//        [gifFile save];
//        [emoticon setObject:gifFile.url forKey:@"gifFace"];
//        NSString *pngPath = [[NSBundle mainBundle] pathForResource:[png substringToIndex:3] ofType:@"png"];
//        AVFile *pngFile = [AVFile fileWithData:[NSData dataWithContentsOfFile:pngPath]];
//        [pngFile save];
//        [emoticon setObject:pngFile.url forKey:@"pngFace"];
//        NSString *index = [png substringToIndex:3];
//        NSString *fileName = [index stringByAppendingFormat:@"@2x"];
//        NSString *pngpathH = [[NSBundle mainBundle] pathForResource:fileName ofType:@"png"];
//        AVFile *pngHFile = [AVFile fileWithData:[NSData dataWithContentsOfFile:pngpathH]];
//        [pngHFile save];
//        [emoticon setObject:pngHFile.url forKey:@"pngFaceH"];
//        
//        [emoticon saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            if (succeeded) {
//                NSLog(@"save succeeded");
//            } else {
//                NSLog(@"save unSucceeded error: %@",[error localizedDescription]);
//            }
//        }];
//    
//    }
//
//}



@end
