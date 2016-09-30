//
//  PrivateMessageCell.h
//  宠汪
//
//  Created by 滕呈斌 on 16/9/26.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrivateMessageModel.h"
#import "CNLabel.h"
#import "UserModel.h"
#import "UserImageView.h"

@interface PrivateMessageCell : UITableViewCell

@property (nonatomic, retain)  UserImageView *userImgCellOne;
@property (nonatomic, retain)  UIImageView *contentCellOne;
//@property (nonatomic, retain)  UIImageView *contentCellTwo;
//@property (nonatomic, retain)  UserImageView *userImgCellTwo;

@property (nonatomic, retain) UserModel *userModel;

@property (nonatomic, retain) CNLabel *summary;

@property (nonatomic, retain) PrivateMessageModel *model;

+ (NSString *)selfImgUrl;

@end
