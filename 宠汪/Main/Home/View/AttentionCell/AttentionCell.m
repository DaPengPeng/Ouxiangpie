//
//  AttentionCell.m
//  宠汪
//
//  Created by 滕呈斌 on 16/9/15.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "AttentionCell.h"
#import <AVOSCloud/AVOSCloud.h>

@interface AttentionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userInfo;


@end

@implementation AttentionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _userImg.layer.cornerRadius = 35;
    _userImg.clipsToBounds = YES;
}


- (void)setModel:(UserModel *)model {
    _model = model;
    [_userImg sd_setImageWithURL:[NSURL URLWithString:model.uImage]];
    _userName.text = model.uAlais;
    _userInfo.text = model.uInfo;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
