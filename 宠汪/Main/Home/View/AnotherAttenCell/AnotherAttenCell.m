//
//  AnotherAttenCell.m
//  宠汪
//
//  Created by 滕呈斌 on 16/9/19.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "AnotherAttenCell.h"

@interface AnotherAttenCell ()
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *userName;


@end

@implementation AnotherAttenCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(UserModel *)model {
    _model = model;
    [_userImg sd_setImageWithURL:[NSURL URLWithString:model.uImage]];
    _userName.text = model.uAlais;
    
}

@end
