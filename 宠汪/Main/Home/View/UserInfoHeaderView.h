//
//  UserInfoHeaderView.h
//  宠汪
//
//  Created by 滕呈斌 on 16/9/14.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface UserInfoHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *foucsBtn;
@property (weak, nonatomic) IBOutlet UIButton *fansBtn;
@property (weak, nonatomic) IBOutlet UILabel *info;

@property (nonatomic, retain) UserModel *userModel;

@end
