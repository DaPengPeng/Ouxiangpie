//
//  CommentCell.m
//  宠汪
//
//  Created by 滕呈斌 on 16/8/10.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "CommentCell.h"
#import "UserImageView.h"

@interface CommentCell ()

@property (weak, nonatomic) IBOutlet UserImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *from;
@property (weak, nonatomic) IBOutlet UIButton *answerButton;

@property (weak, nonatomic) IBOutlet UIView *content;


@end

@implementation CommentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)answerAction:(UIButton *)sender {
}

@end
