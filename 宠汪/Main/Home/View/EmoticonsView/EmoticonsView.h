//
//  EmoticonsView.h
//  Moron
//
//  Created by bever on 16/4/28.
//  Copyright © 2016年 清风. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyBlock) (NSString *name);

@interface EmoticonsView : UIView

- (instancetype)initWithFrame:(CGRect)frame withBlock:(MyBlock)block;


@end

@interface EmoticonImageView : UIImageView

@property (nonatomic, copy) MyBlock block;

@property (nonatomic, copy) NSString *emoticonText;

@end