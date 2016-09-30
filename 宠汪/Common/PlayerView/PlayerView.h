//
//  PlayerView.h
//  PlayerView
//
//  Created by 滕呈斌 on 16/7/29.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PlayerView : UIImageView

@property (nonatomic, copy) NSString *url;

@property (nonatomic, weak) AVPlayer *player;


- (instancetype)initWithURL:(NSString *)url frame:(CGRect)frame;

- (void)pause;


@end
