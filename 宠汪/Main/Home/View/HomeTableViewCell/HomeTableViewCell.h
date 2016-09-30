//
//  HomeTableViewCell.h
//  宠汪
//
//  Created by 滕呈斌 on 16/8/9.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
#import "PlayerView.h"

typedef void(^MoreBlock)();

@interface HomeTableViewCell : UITableViewCell

@property (nonatomic, retain) MessageModel *messageModel;

@property (nonatomic, retain) PlayerView *playerView;

@property (nonatomic, copy) MoreBlock block;

@end
