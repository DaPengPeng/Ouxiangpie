//
//  DetailTopicController.h
//  宠汪
//
//  Created by 滕呈斌 on 16/9/12.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import <UIkit/UIKit.h>
#import "MessageModel.h"
#import "ReplayView.h"


@interface DetailTopicController : UIViewController

@property (nonatomic, retain) ReplayView *replayView;


@property (nonatomic, retain) MessageModel *messageModle;
@property (nonatomic, assign) BOOL isFirst;

@end
