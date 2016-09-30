//
//  ReplayView.m
//  宠汪
//
//  Created by 滕呈斌 on 16/9/12.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "ReplayView.h"
#import "EmoticonsView.h"
#import "DPTextViewManager.h"
#import "DetailTopicController.h"

#import <AVOSCloud/AVOSCloud.h>

@interface ReplayView ()

@property (weak, nonatomic) IBOutlet UIButton *emotcionBtn;

@property (nonatomic, retain) EmoticonsView *faceView;//表情包

@property (nonatomic, retain) DPTextViewManager *manager;//表情混编管理


@end

@implementation ReplayView
- (EmoticonsView *)faceView {
    
    self.manager;
    __weak typeof (_textView) weakTextView = _textView;
    __weak typeof (_manager) weakManager = _manager;
    if (_faceView == nil) {
        _faceView = [[EmoticonsView alloc] initWithFrame:CGRectMake(0, self.height, kScreenW, 220) withBlock:^(NSString *name) {
            //将name插入到文本中
            //获取光标的位置
            NSRange range = weakTextView.selectedRange;
            
            //重新设置光标位置
            NSMutableAttributedString *mAttString = [[NSMutableAttributedString alloc]initWithAttributedString:weakTextView.attributedText];
            [mAttString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, mAttString.length)];
            NSAttributedString *attStr = [weakManager attributedStringWtihName:name];
            [mAttString insertAttributedString:attStr atIndex:range.location];
            weakTextView.attributedText = mAttString;
            
            range.location = range.location + 1;
            //发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UITextViewChangeWithValue" object:nil userInfo:@{@"text":_textView.text}];
        }];
    }
    return _faceView;
}

- (DPTextViewManager *)manager {
    if (!_manager) {
        _manager = [DPTextViewManager shareManager];
    }
    return _manager;
}

- (IBAction)emotcionAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.faceView;
    if (sender.selected) {
        [_textView resignFirstResponder];
        _textView.inputView = _faceView;
        _textView.font = [UIFont systemFontOfSize:20];
        [_textView becomeFirstResponder];
    }
    else
    {
        [_textView resignFirstResponder];
        _textView.inputView = nil;
        _textView.font = [UIFont systemFontOfSize:20];
        [_textView becomeFirstResponder];
    }
}
- (IBAction)sendReplay:(UIButton *)sender {
    
    self.manager;
    if (_isReplay) {
        AVObject *repaly = [[AVObject alloc] initWithClassName:kRePlay];
        //拿到控制器
        DetailTopicController *detailVC = (DetailTopicController *)self.viewController;
        NSString *mid = detailVC.messageModle.mId;
        [repaly setObject:mid forKey:kRMId];
        [repaly setObject:[AVUser currentUser].objectId forKey:kRUid];
        NSString *content = [_manager stringWithAttString:_textView.text];
        [repaly setObject:content forKey:kRcontent];
        if (content == nil) {
            NSLog(@"user not input content");
            return;
        }
        NSError *error = nil;
        [repaly save:&error];
        if (error) {
            NSLog(@"replay saver error:%@",[error localizedDescription]);
        } else {
            [_textView resignFirstResponder];
            _textView.text = @"";
            [_manager.attInfo removeAllObjects];
            if (_reloadBlock) {
                _reloadBlock();
            }
            
            //更新评论次数
            AVQuery *query = [[AVQuery alloc] initWithClassName:kMessage];
            [query whereKey:kMId equalTo:detailVC.messageModle.mId];
            NSArray *array = [query findObjects];
            NSLog(@"array.count:%lu",array.count);
            AVObject *object = [array firstObject];
            NSNumber *number = [object objectForKey:kMReplayCount];
            NSInteger count = [number integerValue];
            NSInteger newCount = 1+count;
            [object setObject:@(newCount) forKey:kMReplayCount];
            BOOL isSucceed = [object save];
            if (isSucceed) {
                NSLog(@"update replay count succeed");
            } else {
                NSLog(@"update replay count unSucceed");
            }
            
        }
    } else {
        NSString *content = [_manager stringWithAttString:_textView.text];
        if (_sendPriMessBlock) {
            _sendPriMessBlock(content);
            _textView.text = @"";
            [_manager.attInfo removeAllObjects];
        }
    }
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
