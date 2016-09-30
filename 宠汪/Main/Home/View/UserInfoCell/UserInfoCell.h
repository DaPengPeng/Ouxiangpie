//
//  UserInfoCell.h
//  宠汪
//
//  Created by 滕呈斌 on 16/9/14.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
#import "CNLabel.h"
#import "PlayerView.h"
#import "PhotoView.h"

@interface UserInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet CNLabel *content;
@property (weak, nonatomic) IBOutlet UIButton *replayBtn;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

@property (nonatomic, retain) PlayerView *playerView;

@property (nonatomic, retain) PhotoView *photoView;

@property (nonatomic, retain) MessageModel *model;

@end
