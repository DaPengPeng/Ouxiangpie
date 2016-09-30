//
//  PhotoViewPresentController.m
//  PhotoView
//
//  Created by bever on 16/4/14.
//  Copyright © 2016年 贝沃. All rights reserved.
//

#import "PhotoViewPresentController.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Rect.h"
#import "ScaleImageView.h"

#define kScreenH [UIScreen mainScreen].bounds.size.height
#define kScreenW [UIScreen mainScreen].bounds.size.width


@interface PhotoViewPresentController () <UIScrollViewDelegate> {

    UIScrollView *_scrollView;
    
    NSInteger _currentIndex;
    
    BOOL _isScale;
    
    UILabel *_indexLabel;
    
    ScaleImageView *_scaleImg;
}

@end

@implementation PhotoViewPresentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)setPhotoView:(PhotoView *)photoView {

    _photoView = photoView;
    
    CGRect newFrame = [_photoView convertRect:self.imageView.frame toView:self.view];
    _imageView.frame = newFrame;
    [self.view addSubview:_imageView];
}

- (void)setDataList:(NSArray *)dataList {

    _dataList = dataList;
    
    //创建scrollView
    [self createScrollView];
}

- (void)setImageView:(PhotoImageView *)imageView {

    _imageView = imageView;
    _currentIndex = _imageView.index;
}

//创建scrollView
- (void)createScrollView {

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    [self.view addSubview:_scrollView];
    
    //scrollView的设置
    _scrollView.contentSize = CGSizeMake(kScreenW*_dataList.count, kScreenH);
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.hidden = YES;

    //创建ImageView
    for (int i = 0 ; i < _dataList.count; i++) {
        
        //图片
        UIImage *image = _dataList[i];
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
        imageView.image = _dataList[i];
        imageView.tag = 100 + i;
        imageView.index = i;
        [subScrollView addSubview:imageView];
        
        //手势
        //单击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        [singleTap setNumberOfTapsRequired:1];
        [imageView addGestureRecognizer:singleTap];
        
        //双击
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
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
    _indexLabel.text = [NSString stringWithFormat:@"%ld/%ld",(NSInteger)(_scrollView.contentOffset.x/kScreenW+1),_dataList.count];
    _indexLabel.textColor = [UIColor redColor];
    _indexLabel.font = [UIFont boldSystemFontOfSize:24];
    
}

//tapAction
- (void)singleTapAction:(UITapGestureRecognizer *)tap {
    
    PhotoImageView *currentImageView = (PhotoImageView *)[_photoView.subViewsDic objectForKey:[NSString stringWithFormat:@"%ld",_currentIndex]];
    UIImageView *imageView = [_scrollView viewWithTag:100+_currentIndex];
    CGRect rect = [imageView.image rect];
    CGRect newFrame = [self.view convertRect:rect toView:_photoView];
    currentImageView.frame = newFrame;
    [_photoView bringSubviewToFront:currentImageView];
    
    //将_photoView拿到单元格的最上层（防止其他label的遮盖）
    [[_photoView superview] bringSubviewToFront:_photoView];

    [self dismissViewControllerAnimated:NO completion:^{
        
        [UIView animateWithDuration:0.2 animations:^{
           
        currentImageView.frame = currentImageView.oldFrame;
        }];
    }];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
    CGRect rect = [_imageView.image rect];
    //放大动画
    [UIView animateWithDuration:0.2 animations:^{
        
        [self.imageView setFrame:rect];
        
        
    } completion:^(BOOL finished) {
        
        _scrollView.hidden = NO;
        
        //还原Item
        self.imageView.frame = self.imageView.oldFrame;
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        [self.photoView addSubview:self.imageView];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView == _scrollView) {
        _currentIndex = _scrollView.contentOffset.x/kScreenW;

    }
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
        
        _indexLabel.text = [NSString stringWithFormat:@"%ld/%ld",(NSInteger)(_scrollView.contentOffset.x/kScreenW+1),_dataList.count];
        NSInteger CurImgIndex = _scrollView.contentOffset.x/kScreenW;
        
        if ((CurImgIndex - _scaleImg.index) > 1 || (_scaleImg.index - CurImgIndex) > 1) {
            [self reduce:_scaleImg];
            
        }
        
    }
}



////单击入口
//- (void)singleTapAction {
//    
//    self.block();//有数据的传递最好使用代理，block。
//}
//双击入口
- (void)doubleTapAction:(UITapGestureRecognizer *)doubleTap {
    
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
