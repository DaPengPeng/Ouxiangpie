//
//  DPPlaceHoldTextView.m
//  宠汪
//
//  Created by 滕呈斌 on 16/9/12.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "DPPlaceHoldTextView.h"

@interface DPPlaceHoldTextView () {
    UILabel *_placeholdLabel;
}

@end

@implementation DPPlaceHoldTextView

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hiddenPlaceholdLabel:) name:@"UITextViewChangeWithValue" object:nil];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hiddenPlaceholdLabel:) name:@"UITextViewChangeWithValue" object:nil];
    }
    return self;
}

- (void)awakeFromNib {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hiddenPlaceholdLabel:) name:@"UITextViewChangeWithValue" object:nil];
}

- (void)hiddenPlaceholdLabel:(NSNotification *)notification {

    NSString *text = [notification.userInfo objectForKey:@"text"];
    if ([text isEqualToString:@""] || text == nil) {
        _placeholdLabel.hidden = NO;
    } else {
        _placeholdLabel.hidden = YES;
    }
}

- (void)setPlacehold:(NSString *)placehold {
    _placehold = placehold;
    
    [self addPlaceholdLabel];
}

- (void)addPlaceholdLabel {
    _placeholdLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, kScreenW, 20)];
    [self addSubview:_placeholdLabel];
    _placeholdLabel.text = _placehold;
    _placeholdLabel.font = [UIFont systemFontOfSize:20];
    _placeholdLabel.textColor = [UIColor grayColor];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end


//显示视图层次的解决办法
@implementation UITextView (Category)

- (void)_firstBaselineOffsetFromTop
{
}

- (void)_baselineOffsetFromBottom
{
}

@end
