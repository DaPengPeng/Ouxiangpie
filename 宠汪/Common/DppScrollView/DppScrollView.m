//
//  DppScrollView.m
//  Oupie
//
//  Created by 滕呈斌 on 16/7/15.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "DppScrollView.h"
#import "DppImageView.h"

@interface DppScrollView () <UIScrollViewDelegate>

@end

@implementation DppScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.pagingEnabled = YES;
        
    }
    return self;
}

- (void)setImageArray:(NSArray *)imageArray {
    
    _imageArray = imageArray;
    
    for (NSUInteger i = 0; i < imageArray.count; i++) {
        
        DppImageView *imageView = [[DppImageView alloc] initWithFrame:CGRectMake(kScreenW*i, 0, self.width, self.height)];
        imageView.userInteractionEnabled = YES;
        imageView.multipleTouchEnabled = YES;
        imageView.index = i;
        [self addSubview:imageView];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageArray[i]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!error) {
                [self.mImageArray addObject:image];
            }
        }];
    }
}

- (NSMutableArray *)mImageArray {
    if (!_mImageArray) {
        _mImageArray = [NSMutableArray array];
    }
    return _mImageArray;
}

@end
