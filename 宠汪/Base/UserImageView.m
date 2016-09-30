//
//  UserImageView.m
//  宠汪
//
//  Created by 滕呈斌 on 16/8/10.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "UserImageView.h"
#import "UserInfoController.h"

@implementation UserImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setUI];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUI];
}

- (void)setUI {
    self.layer.cornerRadius = self.frame.size.width/2;
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    
    [self addGestureRecognizer:tap];
}

- (void)tapAction {
    
    UserInfoController *userInfoController =[[UserInfoController alloc] init];
    userInfoController.userId = _userId;
    [self.viewController.navigationController pushViewController:userInfoController animated:YES];
}



@end
