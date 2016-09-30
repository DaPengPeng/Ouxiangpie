//
//  PhotoView.m
//  PhotoView
//
//  Created by bever on 16/4/14.
//  Copyright © 2016年 贝沃. All rights reserved.
//

#import "PhotoView.h"
#import "PhotoImageView.h"
#import "UIViewExt.h"
#import "UIImageView+WebCache.h"
#import "PhotoViewPresentController.h"
#import "HomeTableViewCell.h"

#define kScreenH [UIScreen mainScreen].bounds.size.height
#define kScreenW [UIScreen mainScreen].bounds.size.width

@interface PhotoView () {

    NSMutableArray *_imageArray;
}

@end

@implementation PhotoView

//复写set方法
- (void)setDataList:(NSArray *)dataList {

    _dataList = dataList;
    
    //将自己拿到单元格的最上层（防止其他label的遮盖）
    [[[self superview] superview] bringSubviewToFront:[self superview]];
    
    //单元格复用（就数据的删除）
    for (UIView *view in self.subviews) {
        
        [view removeFromSuperview];
    }
    
    //创建imageView
    [self createImageViews];
    
}


- (void)createImageViews {

    //photoView高度的设定
    CGFloat minspacing = 3;
    BOOL hasY = _dataList.count%3;
    self.height = (self.width-minspacing*2)/3*((_dataList.count/3)+1*hasY)+(((_dataList.count/3)+1*hasY)-1)*minspacing;
    _subViewsDic = [[NSMutableDictionary alloc] init];
    _imageArray = [NSMutableArray array];
    for (int i = 0; i < _dataList.count; i++) {
    
        PhotoImageView *imageView = [[PhotoImageView alloc] initWithFrame:CGRectMake(((self.width - minspacing*2)/3 + 3) * (i % 3), ((self.width - minspacing*2)/3 + 3) * (i / 3), (self.width - minspacing*2)/3, (self.width - minspacing*2)/3)];
        imageView.index = i;
        NSString *indexString = [NSString stringWithFormat:@"%d",i];
        [_subViewsDic setObject:imageView forKey:indexString];
        imageView.oldFrame = imageView.frame;
        imageView.userInteractionEnabled = YES;
        
        //根据数据设置图片
        if ([_dataList[i] isKindOfClass:[UIImage class]]) {
            imageView.image = _dataList[i];
        } else if ([_dataList[i] isKindOfClass:[NSString class]]) {
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:_dataList[i]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (!error) {
                    [_imageArray addObject:image];
                }
            }];
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:tap];
        [self addSubview:imageView];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap {

    //将单元格拿到最上层
    [self bringCellToFrontOfTableView];
    
    //实例控制器
    PhotoViewPresentController *presentController = [[PhotoViewPresentController alloc] init];
    PhotoImageView *imageView = (PhotoImageView *)tap.view;
    presentController.imageView = imageView;
    if ([[_dataList firstObject] isKindOfClass:[UIImage class]]) {
        presentController.dataList = _dataList;
    } else {
        
        presentController.dataList = _imageArray;
    }
    presentController.photoView = self;
    [[self viewController] presentViewController:presentController animated:NO completion:^{
        
    }];
}

//将单元格拿到最上层
- (void)bringCellToFrontOfTableView {

    UIResponder *responder = self;
    
    
    do {
        if ([responder isKindOfClass:[UITableViewCell class]]) {
            
            [[(HomeTableViewCell *)responder superview] bringSubviewToFront:(HomeTableViewCell *)responder];
            return;
        }
        
        responder = responder.nextResponder;
        
    } while (responder != nil);
}

@end
