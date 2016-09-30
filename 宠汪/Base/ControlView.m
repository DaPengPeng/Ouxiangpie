//
//  ControlView.m
//  宠汪
//
//  Created by 滕呈斌 on 16/8/10.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "ControlView.h"

@implementation ControlView

- (void)awakeFromNib {
    
    
    _img = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width*0.2, 5, self.frame.size.width*0.6, self.frame.size.width*0.6)];
    _img.layer.cornerRadius = _img.frame.size.width/2;
    _img.clipsToBounds = YES;
    _img.userInteractionEnabled = YES;
    _img.multipleTouchEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [_img addGestureRecognizer:tap];
    [_img sd_setImageWithURL:[NSURL URLWithString:@"http://www.ld12.com/upimg358/20160130/121054223155174.jpg"]];
    [self addSubview:_img];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.width*0.6+10, self.frame.size.width, 21)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
}

- (void)tapAction {
    
}

- (void)setTitleAndController:(NSDictionary *)titleAndController {
    NSString *key = [titleAndController.allKeys firstObject];
    _titleLabel.text = titleAndController[key];
    
    
    
}






@end
