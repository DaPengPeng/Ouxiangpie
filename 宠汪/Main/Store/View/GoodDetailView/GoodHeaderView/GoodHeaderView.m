//
//  GoodHeaderView.m
//  Oupie
//
//  Created by 滕呈斌 on 16/7/14.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "GoodHeaderView.h"
#import "GoodInfo.h"
#import "DppScrollView.h"

@interface GoodHeaderView () <UIScrollViewDelegate>{
    
    DppScrollView *_scrollView;// 滑动视图
    
    UILabel *_pageLabel;// 图片页码
    
    UILabel *_titleLabel;// 商品标题
    
    UILabel *_piceLabel;// 商品价格
}

@end

@implementation GoodHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        //创建scrollView
        [self createScrolllView];
        
    }
    return self;
}

- (void)createScrolllView {
    
    _scrollView = [[DppScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW)];
    [self addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(kScreenW * 3, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.imageArray = @[@"http://pic.4j4j.cn/upload/pic/20130815/31e652fe2d.jpg",@"http://pic.4j4j.cn/upload/pic/20130815/31e652fe2d.jpg",@"http://pic.4j4j.cn/upload/pic/20130815/31e652fe2d.jpg"];
    
    //图片下标
    _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW-45, kScreenW-40, 30, 20)];
    [self addSubview:_pageLabel];
    _pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",(NSInteger)(_scrollView.contentOffset.x/kScreenW+1),_scrollView.imageArray.count];
    _pageLabel.textAlignment = NSTextAlignmentCenter;
    _pageLabel.textColor = [UIColor redColor];
    _pageLabel.backgroundColor = [UIColor grayColor];
    _pageLabel.layer.cornerRadius = 3;
    _pageLabel.clipsToBounds = YES;
    
//    //临时创建几个图片
//    for (int i = 0; i < 3; i++) {
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW*i, 0, _scrollView.width, _scrollView.height)];
//        imageView.image = [UIImage imageNamed:@"yanshi.jpg"];
//        [_scrollView addSubview:imageView];
//    }
    
    //backBtn
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 18, 40, 40)];
    view.backgroundColor = [UIColor grayColor];
    view.layer.cornerRadius = 20;
    view.clipsToBounds = YES;
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:view];
    backBtn.frame = CGRectMake(5, 5, 30, 30);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"top_back_white@2x"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:backBtn];
    
    GoodInfo *goodInfoView = [[[NSBundle mainBundle] loadNibNamed:@"GoodInfo" owner:nil options:nil] firstObject];
    goodInfoView.frame = CGRectMake(0, _scrollView.height, kScreenW, 300);
    [self addSubview:goodInfoView];
    
}

- (void)backBtnAction:(UIButton *)button {
    
    UIViewController *viewController = self.viewController;
    [viewController.navigationController popToRootViewControllerAnimated:YES];
}

- (void)setModel:(GoodHeaderModel *)model {
    
    _model = model;
    
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    _pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",(NSInteger)(_scrollView.contentOffset.x/kScreenW+1),_scrollView.imageArray.count];
}



@end
