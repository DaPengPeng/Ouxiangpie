//
//  PresentViewControlller.m
//  Oupie
//
//  Created by 滕呈斌 on 16/7/15.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "PresentViewControlller.h"
#import "ScaleImageView.h"


@interface PresentViewControlller () <UIScrollViewDelegate> {
    
    UIScrollView *_scrollView;
    
    BOOL _isScale;
    
    UILabel *_indexLabel;
    
    ScaleImageView *_scaleImg;
    
}

@end

@implementation PresentViewControlller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor blackColor];
}


- (void)setImageArray:(NSArray *)imageArray {
    _imageArray = imageArray;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(kScreenW * imageArray.count, 0);
    for (NSUInteger i = 0; i < imageArray.count; i++) {
        
        //图片
        UIImage *image = _imageArray[i];
        CGRect rect = [image rect];
        UIScrollView *subScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(kScreenW * i, 0, kScreenW, kScreenH)];
        subScrollView.contentSize = CGSizeMake(rect.size.width, rect.size.height);
        subScrollView.delegate = self;
        subScrollView.minimumZoomScale = 1;
        subScrollView.maximumZoomScale = MAXSCALE;
        subScrollView.bouncesZoom = NO;
        subScrollView.bounces = NO;
        subScrollView.showsHorizontalScrollIndicator = NO;
        subScrollView.showsVerticalScrollIndicator = NO;
        
        [_scrollView addSubview:subScrollView];
        
        ScaleImageView *imageView = [[ScaleImageView alloc] initWithFrame:rect];
        imageView.userInteractionEnabled = YES;
        imageView.multipleTouchEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = image;
        imageView.tag = 100 + i;
        imageView.index = i;
        [subScrollView addSubview:imageView];
        
        //手势
        //单击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
        [singleTap setNumberOfTapsRequired:1];
        [imageView addGestureRecognizer:singleTap];
        
        //双击
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction)];
        [doubleTap setNumberOfTapsRequired:2];
        [imageView addGestureRecognizer:doubleTap];
        //在双击失败的情况下执行单击
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
    }
    
    //scrollView的偏移
    _scrollView.contentOffset = CGPointMake(kScreenW*_currentIndex, 0);
    
    //添加下标提示
    _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW-60, kScreenH-80, 50, 30)];
    [self.view addSubview:_indexLabel];
    _indexLabel.text = [NSString stringWithFormat:@"%ld/%ld",(NSInteger)(_scrollView.contentOffset.x/kScreenW+1),_imageArray.count];
    _indexLabel.textColor = [UIColor redColor];
    _indexLabel.font = [UIFont boldSystemFontOfSize:24];
    
}

#pragma mark - UIScrollViewDelegate
//缩放返回图片
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (scrollView != _scrollView) {
        NSInteger imageViewIndex = _scrollView.contentOffset.x/kScreenW;
        UIImageView *imageView = [self.view viewWithTag:imageViewIndex+100];
        return imageView;
    }
    return nil;
}
//缩放中执行
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (scrollView != _scrollView) {
        NSInteger imageViewIndex = _scrollView.contentOffset.x/kScreenW;
        UIImageView *imageView = [self.view viewWithTag:imageViewIndex+100];
        
        CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width)/2 : 0.0;
        CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0.0;
        imageView.center = CGPointMake(scrollView.contentSize.width/2+offsetX, scrollView.contentSize.height/2+offsetY);
    }
    
}
//结束放大时调用
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    if (scale > 1.0) {
        ScaleImageView *imageView = (ScaleImageView *)view;
        imageView.isScale = YES;
        _scaleImg = imageView;
        
    }
    
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == _scrollView) {
        
        _indexLabel.text = [NSString stringWithFormat:@"%ld/%ld",(NSInteger)(_scrollView.contentOffset.x/kScreenW+1),_imageArray.count];
        NSInteger CurImgIndex = _scrollView.contentOffset.x/kScreenW;
        
        if ((CurImgIndex - _scaleImg.index) > 1 || (_scaleImg.index - CurImgIndex) > 1) {
            [self reduce:_scaleImg];
            
        }

    }
}



//单击入口
- (void)singleTapAction {
    
    self.block();//有数据的传递最好使用代理，block。
}
//双击入口
- (void)doubleTapAction {
    
    NSInteger imageViewIndex = _scrollView.contentOffset.x/kScreenW;
    ScaleImageView *imageView = [self.view viewWithTag:imageViewIndex+100];
    
    //双击放大缩小的判断
    if (imageView.isScale) {
        
        [self reduce:imageView];
    }else {
        
        [self enlarge:imageView];
    }
    
    
}
//放大
- (void)enlarge:(ScaleImageView *)imageView {
    UIScrollView *scrollView = (UIScrollView *)[imageView superview];

    imageView.transform = CGAffineTransformMakeScale(MAXSCALE, MAXSCALE);
    scrollView.contentSize = CGSizeMake(scrollView.contentSize.width*MAXSCALE, scrollView.contentSize.height*MAXSCALE);
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width)/2 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0.0;
    
    imageView.center = CGPointMake(scrollView.contentSize.width/2+offsetX, scrollView.contentSize.height/2+offsetY);
    imageView.isScale = YES;
    _scaleImg = imageView;
    //将scrollView偏移
    scrollView.contentOffset = CGPointMake((scrollView.contentSize.width-kScreenW)/2, (scrollView.contentSize.height > kScreenH) ? (scrollView.contentSize.height-kScreenH)/2 : 0);
}
//缩小
- (void)reduce:(ScaleImageView *)imageView {
    
    UIScrollView *scrollView = (UIScrollView *)[imageView superview];
    imageView.transform = CGAffineTransformIdentity;
    imageView.isScale = NO;
    _scaleImg = nil;
    scrollView.contentSize = CGSizeMake(scrollView.contentSize.width/MAXSCALE, scrollView.contentSize.height/MAXSCALE);
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0.0;
    imageView.center = CGPointMake(scrollView.contentSize.width/2+offsetX, scrollView.contentSize.height/2+offsetY);
    
}

@end
