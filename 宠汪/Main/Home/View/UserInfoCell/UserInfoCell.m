//
//  UserInfoCell.m
//  宠汪
//
//  Created by 滕呈斌 on 16/9/14.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "UserInfoCell.h"
#import <AVOSCloud/AVOSCloud.h>
#import "UIUtils.h"

@implementation UserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _content.textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    
    _playerView = [[PlayerView alloc] initWithFrame:CGRectMake(0, 20, kScreenW, 260)];
    [self addSubview:_playerView];
    
    _photoView = [[PhotoView alloc] initWithFrame:CGRectMake(0, 20, kScreenW, 0)];
    [self addSubview:_photoView];
    _photoView.hidden = YES;
    _playerView.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)likeBtnAction:(UIButton *)sender {
}
- (IBAction)replayAction:(UIButton *)sender {
}

- (void)setModel:(MessageModel *)model {
    _model = model;
    //删除控件
    for (UIView *view in _photoView.subviews) {
        [view removeFromSuperview];
    }
    
    _content.height = 0;
    AVQuery *query = [[AVQuery alloc] initWithClassName:kUserInfo];
    [query whereKey:kUserInfoId equalTo:model.mUId];
    AVObject *object = [[query findObjects] firstObject];
    
    NSDate *date = [object objectForKey:kMCreatedAt];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    _time.text = [UIUtils formatDateString:dateString];
    
    if (_model.mContent && ![_model.mContent isEqualToString:@""]) {
        _content.text = _model.mContent;
    } else {
        _content.height = 5;
    }
    
    switch ([_model.mType integerValue]) {
        case 0:
            
            break;
        case 1:
            _photoView.frame = CGRectMake(0, 20+_content.height, kScreenW, _photoView.height);
            _photoView.dataList = _model.mPhotos;
            _photoView.hidden = NO;
            _playerView.hidden = YES;
            break;
        default:
            break;
    }
    
    if ([_model.mType integerValue] == 2) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            _playerView.url = _model.mVideo;
            _playerView.frame = CGRectMake(0, 20+_content.height, kScreenW, _playerView.height);
        });
        _playerView.hidden = NO;
        _photoView.hidden = YES;
    }
    
    
}

@end
