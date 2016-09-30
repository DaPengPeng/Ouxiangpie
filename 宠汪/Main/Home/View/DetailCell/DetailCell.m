//
//  DetailCell.m
//  宠汪
//
//  Created by 滕呈斌 on 16/9/13.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "DetailCell.h"
#import "UIUtils.h"
#import <AVOSCloud/AVOSCloud.h>

@implementation DetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _content.textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    _userImg.layer.cornerRadius = 20;
    _userImg.layer.masksToBounds = YES;
    _userImg.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(ReplayModel *)model {
    _model = model;
    _content.text = model.rContent;
    AVQuery *query = [AVQuery queryWithClassName:kUserInfo];
    [query whereKey:kUserInfoId equalTo:model.rUId];
    AVObject *object = [[query findObjects] firstObject];
    _userName.text = [object objectForKey:kUAlais];
    [_userImg sd_setImageWithURL:[NSURL URLWithString:[object objectForKey:kUImage]]];
    _userImg.userId = model.rUId;
    
    NSDate *date = model.createdAt;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    _createdAt.text = [UIUtils formatDateString:dateString];
}

@end
