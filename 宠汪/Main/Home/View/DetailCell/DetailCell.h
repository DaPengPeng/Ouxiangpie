//
//  DetailCell.h
//  宠汪
//
//  Created by 滕呈斌 on 16/9/13.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReplayModel.h"
#import "CNLabel.h"
#import "UserImageView.h"

@interface DetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UserImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *createdAt;
@property (weak, nonatomic) IBOutlet CNLabel *content;

@property (nonatomic, retain) ReplayModel *model;

@end
