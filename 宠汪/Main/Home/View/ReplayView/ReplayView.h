//
//  ReplayView.h
//  宠汪
//
//  Created by 滕呈斌 on 16/9/12.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPPlaceHoldTextView.h"

typedef void(^ReloadData)(void);
typedef void(^SendPriMessBlock)(NSString *message);

@interface ReplayView : UIView

@property (weak, nonatomic) IBOutlet DPPlaceHoldTextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *sendReplay;

@property (nonatomic, copy) ReloadData reloadBlock;

@property (nonatomic, copy) SendPriMessBlock sendPriMessBlock;

@property (nonatomic, assign) BOOL isReplay;

@end
