//
//  UserCenterHeaderView.m
//  宠汪
//
//  Created by 滕呈斌 on 16/8/10.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "UserCenterHeaderView.h"
#import <AVOSCloud/AVOSCloud.h>
#import "UserInfoController.h"
#import "AttentionController.h"

@interface UserCenterHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIButton *myStory;
@property (weak, nonatomic) IBOutlet UIButton *myFocus;
@property (weak, nonatomic) IBOutlet UIButton *myFans;

@end

@implementation UserCenterHeaderView

- (void)awakeFromNib {
    
    _userImg.layer.cornerRadius = _userImg.frame.size.width/2;
    _userImg.clipsToBounds = YES;
    _userImg.layer.masksToBounds = YES;
    AVQuery *query = [AVQuery queryWithClassName:@"_user"];
    AVObject *user = [query getObjectWithId:[AVUser currentUser].objectId];
    
    NSString *imageUrl = [user valueForKey:@"uImage"];
    [_userImg sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    _userName.text = [user objectForKey:@"uAlais"];
    
}

- (IBAction)myStoryAction:(UIButton *)sender {
    UserInfoController *myStoryVC = [[UserInfoController alloc] init];
    myStoryVC.userId = [AVUser currentUser].objectId;
    myStoryVC.hasHeaderview = YES;
    [self.viewController.navigationController pushViewController:myStoryVC animated:YES];
}
- (IBAction)myFocusAction:(UIButton *)sender {
    
    AttentionController *attentionVC = [[AttentionController alloc] init];
    attentionVC.uId = [AVUser currentUser].objectId;
    attentionVC.isAttention = YES;
    [self.viewController.navigationController pushViewController:attentionVC animated:YES];
}
- (IBAction)myFansAction:(UIButton *)sender {
    
    AttentionController *attentionVC = [[AttentionController alloc] init];
    attentionVC.uId = [AVUser currentUser].objectId;
    [self.viewController.navigationController pushViewController:attentionVC animated:YES];
}



@end
