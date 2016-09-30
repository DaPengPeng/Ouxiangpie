//
//  UserInfoHeaderView.m
//  宠汪
//
//  Created by 滕呈斌 on 16/9/14.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "UserInfoHeaderView.h"
#import "AttentionController.h"

@implementation UserInfoHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    _userImg.layer.cornerRadius = self.height*0.35/2.0;
    _userImg.layer.masksToBounds = YES;
    _userImg.clipsToBounds = YES;
}
- (IBAction)moreAction:(UIButton *)sender {
}
- (IBAction)backAction:(UIButton *)sender {
    [self.viewController.navigationController popViewControllerAnimated:YES];
}
- (IBAction)focusAction:(UIButton *)sender {
    
    AttentionController *attentionVC = [[AttentionController alloc] init];
    attentionVC.uId = _userModel.uId;
    attentionVC.isAttention = YES;
    [self.viewController.navigationController pushViewController:attentionVC animated:YES];
}
- (IBAction)fansAction:(UIButton *)sender {
    
    AttentionController *attentionVC = [[AttentionController alloc] init];
    attentionVC.uId = _userModel.uId;
    [self.viewController.navigationController pushViewController:attentionVC animated:YES];
}


- (void)setUserModel:(UserModel *)userModel {
    _userModel = userModel;
    [_userImg sd_setImageWithURL:[NSURL URLWithString:userModel.uImage]];
    _name.text = userModel.uAlais;
    
    [_foucsBtn setTitle:[NSString stringWithFormat:@"关注  %ld",[userModel.uAttCount integerValue]] forState:UIControlStateNormal];
    [_fansBtn setTitle:[NSString stringWithFormat:@"粉丝  %ld",[userModel.uFanCount integerValue]] forState:UIControlStateNormal];
    _info.text = userModel.uInfo;
    
}

@end
