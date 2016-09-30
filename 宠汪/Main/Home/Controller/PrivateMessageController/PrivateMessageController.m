//
//  PrivateMessageController.m
//  宠汪
//
//  Created by 滕呈斌 on 16/9/26.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "PrivateMessageController.h"

#import <AVOSCloudIM.h>
#import <AVOSCloud.h>

#import "ReplayView.h"
#import "PrivateMessageCell.h"
#import "PrivateMessageModel.h"
#import "UserModel.h"

@interface PrivateMessageController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, AVIMClientDelegate> {
    UITableView *_tableView;
    
    AVIMClient *_client;
    ReplayView *_replayView;
    
    NSMutableArray *_dataList;
    
    AVIMConversation *_conversation;
    
    
}

@end

@implementation PrivateMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setClient];
    
    [self addObserver];
    
    [self loadData];
    
    [self setupUI];
}

- (void)setClient {
    _client = [[AVIMClient alloc] initWithClientId:[AVUser currentUser].objectId];
    _client.delegate = self;
}

- (void)setupUI {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-40) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    __weak typeof(_client) weakClient = _client;
    __weak typeof(_model) weakModel = _model;
    _replayView = [[[NSBundle mainBundle] loadNibNamed:@"ReplayView" owner:nil options:nil] firstObject];
    [self.view addSubview:_replayView];
    _replayView.backgroundColor = [UIColor grayColor];
    _replayView.textView.textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20]};
    _replayView.frame = CGRectMake(0, kScreenH-40, kScreenW, 40);
    _replayView.textView.placehold = @"请再此输入";
    _replayView.textView.font = [UIFont systemFontOfSize:20];
    _replayView.textView.delegate = self;
    __weak typeof (_dataList) weakDataList = _dataList;
    __weak typeof(_tableView) weakTableView = _tableView;
    _replayView.sendPriMessBlock = ^(NSString *content) {
        //打开client
        [weakClient openWithCallback:^(BOOL succeeded, NSError *error) {
            
            AVIMConversationQuery *query = [weakClient conversationQuery];
            [query whereKey:@"m" containsAllObjectsInArray:@[[AVUser currentUser].objectId, weakModel.uId]];
            [query findConversationsWithCallback:^(NSArray *objects, NSError *error) {
                if (objects.count > 0) {
                    AVIMConversation *conversation = [objects firstObject];
                    _conversation = conversation;
                    //发送一条消息
                    if (content == nil || [content isEqualToString:@""]) {
                        return ;
                    }
                    AVIMTextMessage *message = [AVIMTextMessage messageWithText:content attributes:nil];
                    [conversation sendMessage:message callback:^(BOOL succeeded, NSError *error) {
                        
                        if (succeeded) {
                            NSLog(@"发送成功");
                            NSDictionary *dic = nil;
                            if ([message.clientId isEqualToString:weakModel.uId]) {
                                dic = @{@"text":message.text, @"type":@0};
                            } else {
                                dic = @{@"text":message.text, @"type":@1};
                            }
                            PrivateMessageModel *model = [[PrivateMessageModel alloc] initWithDictionary:dic];
                            [weakDataList addObject:model];
                            
                            [weakTableView reloadData];
                            [weakTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_dataList.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                        } else {
                            NSLog(@"发送失败：%@",[error localizedDescription]);
                        }
                    }];
                } else {
                    
                    //创建对话
                    [weakClient createConversationWithName:@"与的对话" clientIds:@[weakModel.uId] callback:^(AVIMConversation *conversation, NSError *error) {
                        
                        AVIMTextMessage *message = [AVIMTextMessage messageWithText:content attributes:nil];
                        //发送一条消息
                        [conversation sendMessage:message callback:^(BOOL succeeded, NSError *error) {
                            if (succeeded) {
                                NSLog(@"发送成功");
                                NSDictionary *dic = nil;
                                if ([message.clientId isEqualToString:weakModel.uId]) {
                                    dic = @{@"text":message.text, @"type":@0};
                                } else {
                                    dic = @{@"text":message.text, @"type":@1};
                                }
                                PrivateMessageModel *model = [[PrivateMessageModel alloc] initWithDictionary:dic];
                                [weakDataList addObject:model];
                                
                                [weakTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakDataList.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                                [weakTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_dataList.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                            }
                        }];
                    }];
                }

            }];
            
        }];

    };
    
    
}
- (void)changeReplayViewFrame:(NSNotification *)notification {
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        //获取键盘高度
        NSValue *value = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect rect = [value CGRectValue];
        CGFloat keyBoardHeiht = rect.size.height;
        NSValue *time = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSTimeInterval duration;
        [time getValue:&duration];
        [UIView animateWithDuration:duration animations:^{
            
            _replayView.frame = CGRectMake(0, kScreenH-40-keyBoardHeiht, kScreenW, 40);
            _tableView.frame = CGRectMake(0, 0, kScreenW, kScreenH-40-keyBoardHeiht);
        }];
    } else {
        _replayView.frame = CGRectMake(0, kScreenH-40, kScreenW, 40);
        _tableView.frame = CGRectMake(0, 0, kScreenW, kScreenH-40);
    }
}

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeReplayViewFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeReplayViewFrame:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)loadData {
    _dataList = [NSMutableArray array];
    __weak typeof (_dataList) weakDataList = _dataList;
    __weak typeof(_model) weakModel = _model;
    [_client openWithCallback:^(BOOL succeeded, NSError *error) {
        AVIMConversationQuery *query = [_client conversationQuery];
        [query whereKey:@"m" containsAllObjectsInArray:@[[AVUser currentUser].objectId, weakModel.uId]];
        [query findConversationsWithCallback:^(NSArray *objects, NSError *error) {
            AVIMConversation *conversation = [objects firstObject];
            if (error) {
                NSLog(@"m error:%@",[error localizedDescription]);
            }
            [conversation queryMessagesWithLimit:30 callback:^(NSArray *objects, NSError *error) {
                
                for (AVIMTextMessage *message in objects) {
                    NSDictionary *dic = nil;
                    if ([message.clientId isEqualToString:weakModel.uId]) {
                        dic = @{@"text":message.text, @"type":@0};
                    } else {
                        dic = @{@"text":message.text, @"type":@1};
                    }
                    PrivateMessageModel *model = [[PrivateMessageModel alloc] initWithDictionary:dic];
                    [weakDataList addObject:model];
                }
                
                [_tableView reloadData];
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakDataList.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }];
            
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PrivateMessageModel *model = _dataList[indexPath.row];
    
    PrivateMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrivateMessageCellOne"];
    if (!cell) {
        cell = [[PrivateMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PrivateMessageCellOne"];
    }
    cell.userModel = _model;
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PrivateMessageModel *model = _dataList[indexPath.row];
    
    CGRect frame = [model.text boundingRectWithSize:CGSizeMake(kScreenW, 9999.f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil];
    if (frame.size.height+20 > 50) {
        return frame.size.height+16+14;
    } else {
        return 66;
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UITextViewChangeWithValue" object:nil userInfo:@{@"text":_replayView.textView.text}];
}

#pragma mark - AVIMClientDelegate
- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message {
    if ([conversation.conversationId isEqualToString:_conversation.conversationId]) {
        PrivateMessageModel *model = [[PrivateMessageModel alloc] initWithDictionary:@{@"type":@2, @"text":message.text}];
        [_dataList addObject:model];
        [_tableView reloadData];
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_dataList.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}


@end
