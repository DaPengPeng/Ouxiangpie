//
//  PrivateMessageCell.m
//  宠汪
//
//  Created by 滕呈斌 on 16/9/26.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "PrivateMessageCell.h"
#import <AVOSCloud/AVOSCloud.h>

static NSString *_selfImgUrl;

@implementation PrivateMessageCell

+ (NSString *)selfImgUrl {
    
    if (_selfImgUrl == nil) {
        AVQuery *query = [AVQuery queryWithClassName:kUserInfo];
        [query whereKey:kUserInfoId equalTo:[AVUser currentUser].objectId];
        NSArray *array = [query findObjects];
            AVObject *object = [array firstObject];
            NSString *imgUrl = [object objectForKey:kUImage];
            _selfImgUrl = imgUrl;
        
    }
    return _selfImgUrl;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _contentCellOne = [[UIImageView alloc] initWithFrame:CGRectMake(8+50+5, 8, 0, 0)];
        [self.contentView addSubview:_contentCellOne];
        _userImgCellOne = [[UserImageView alloc] initWithFrame:CGRectMake(8, 8, 50, 50)];
        [self.contentView addSubview:_userImgCellOne];
        
        _summary = [[CNLabel alloc] initWithFrame:CGRectMake(0, 0, _contentCellOne.width, _contentCellOne.height)];
        _summary.textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20]};
        [_contentCellOne addSubview:_summary];
    
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setModel:(PrivateMessageModel *)model {
    _model = model;
    _summary.text = model.text;
    _contentCellOne.height = _summary.height;
    _contentCellOne.width = _summary.width;
    if ([[model.type stringValue] isEqualToString:@"1"]) {
        _userImgCellOne.frame = CGRectMake(kScreenW-50-8, 8, 50, 50);
    

        _contentCellOne.image = [[UIImage imageNamed:@"SenderTextNodeBkg.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:40];
        [_userImgCellOne sd_setImageWithURL:[NSURL URLWithString:[PrivateMessageCell selfImgUrl]]];
        _contentCellOne.frame = CGRectMake(kScreenW-50-8-5-_summary.width-10, 8, _summary.width+10, _summary.height+5);
        } else {
            _userImgCellOne.frame = CGRectMake(8, 8, 50, 50);
            _contentCellOne.frame = CGRectMake(8+50+5, 8, _summary.width+10, _summary.height);
            _contentCellOne.image = [[UIImage imageNamed:@"ReceiverTextNodeBkg.png"]stretchableImageWithLeftCapWidth:15 topCapHeight:40];
            [_userImgCellOne sd_setImageWithURL:[NSURL URLWithString:_userModel.uImage]];
    }
    _summary.frame = CGRectMake(10, 0, _summary.frame.size.width, _summary.frame.size.height);
}

@end
