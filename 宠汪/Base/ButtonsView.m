//
//  ButtonsView.m
//  ButtonDamo
//
//  Created by bever on 16/2/23.
//  Copyright © 2016年 我是清风. All rights reserved.
//

#import "ButtonsView.h"

#define TITLEINTERVAL 20

@implementation ButtonsView {

    int _buttonCount;
    UIImageView *_imageView;
    
    NSMutableArray *_buttonsArray;//button数组
}



-(void)setTitleArray:(NSArray *)titleArray {
    
    _titleArray = titleArray;
    _buttonCount = (int)titleArray.count;
    self.backgroundColor = [UIColor grayColor];
    [self creatButton];

}

-(void)awakeFromNib {

    self.bounces = NO;
    //添加观察者
    [[NSNotificationCenter defaultCenter] addObserverForName:kIdenxChange object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        NSNumber *indexNumber = [note.userInfo objectForKey:@"index"];
        NSInteger index = [indexNumber integerValue];
        [self buttonAction:_buttonsArray[index]];

    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(indexChangeAction:) name:kIdenxChange object:nil];
}

- (void)indexChangeAction:(NSNotification *)notification {
    NSInteger index = [notification.userInfo[@"index"] integerValue];
    [self buttonAction:_buttonsArray[index]];
    [self contentOffSet:index];
}

-(instancetype)initWithFrame:(CGRect)frame withTitleArray:(NSArray *)titleArray withSelectedImage:(NSString *)selectedImage {

    self = [super initWithFrame:frame];
    if (self) {
        
        _buttonCount = (int)titleArray.count;
        _titleArray = titleArray;
        _selectedImage = selectedImage;
        self.backgroundColor = [UIColor grayColor];
        
        //添加观察者
        [[NSNotificationCenter defaultCenter] addObserverForName:kIdenxChange object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            
            NSNumber *indexNumber = [note.userInfo objectForKey:@"index"];
            NSInteger index = [indexNumber integerValue];
            [self buttonAction:_buttonsArray[index]];
        }];
        [self creatButton];
    }
    return self;

}

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        //添加观察者
        [[NSNotificationCenter defaultCenter] addObserverForName:kIdenxChange object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            
            NSNumber *indexNumber = [note.userInfo objectForKey:@"index"];
            NSInteger index = [indexNumber integerValue];
            [self buttonAction:_buttonsArray[index]];
        }];
    }
    return self;
}

- (void)contentOffSet:(NSInteger)index {
    
    UIButton *button = [self viewWithTag:index+100];
    if (button.frame.origin.x + button.frame.size.width/2 > kScreenW/2 && self.contentSize.width - (button.frame.origin.x + button.frame.size.width/2) > kScreenW/2) {
        [UIView animateWithDuration:0.2f animations:^{
            self.contentOffset = CGPointMake(button.frame.origin.x+button.frame.size.width/2-kScreenW/2, 0);
        }];
    } else if (button.frame.origin.x + button.frame.size.width/2 < kScreenW/2) {
        [UIView animateWithDuration:0.2f animations:^{
            self.contentOffset = CGPointMake(0, 0);
        }];
    } else if (self.contentSize.width - (button.frame.origin.x + button.frame.size.width/2) < kScreenW/2) {
        [UIView animateWithDuration:0.2f animations:^{
            self.contentOffset = CGPointMake(self.contentSize.width - kScreenW, 0);
        }];
    }
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)creatButton {
    
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    NSInteger sumTitleLength = 0;
    for (NSString *title in _titleArray) {
        sumTitleLength += title.length;
    }
    NSInteger titleWidth = sumTitleLength * 20 + (_titleArray.count+1)*TITLEINTERVAL;
    
    NSInteger deviceScreenHeight = (NSInteger)[UIScreen mainScreen].bounds.size.height;
    NSInteger fontSize = 0;
    switch (deviceScreenHeight) {
        case 480:
            fontSize = 13.5;
            break;
        case 568:
            fontSize = 13.5;
            break;
        case 667:
            fontSize = 16;
            break;
        case 736:
            fontSize = 18;
        default:
            fontSize = 18;
            break;
    }
    CGFloat orignX = TITLEINTERVAL;
    _buttonsArray = [[NSMutableArray alloc] init];
    if (titleWidth < self.width) {
        
        CGFloat titleInterval = titleWidth - sumTitleLength * 20 / (_titleArray.count + 1);
        orignX = titleInterval;
        
        self.contentSize = CGSizeMake(self.width, 0);
        
        for (int i = 0; i < _buttonCount; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString *title = _titleArray[i];
            button.frame = CGRectMake(orignX, 0, title.length*20, self.height);
            button.tag = 100 + i;
            [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [_buttonsArray addObject:button];
            
            button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
            if ( i == _currentIndex) {
                
                button.titleLabel.font = [UIFont systemFontOfSize:fontSize+2];
                button.selected = YES;
            }
            [self addSubview:button];
            
            CGFloat length = title.length * 20;
            orignX = orignX + length + titleInterval;
            
        }
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width/_buttonCount * _currentIndex, self.bounds.size.height-7, self.bounds.size.width/_buttonCount, 7)];
        _imageView.contentMode = UIViewContentModeCenter;//图片的自适应
        _imageView.image = [UIImage imageNamed:_selectedImage];
        [self addSubview:_imageView];
        
        
    } else {
        self.contentSize = CGSizeMake(titleWidth, 0);
        
        for (int i = 0; i < _buttonCount; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            NSString *title = _titleArray[i];
            button.frame = CGRectMake(orignX, 0, title.length*20, self.height);
            button.tag = 100 + i;
            [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [_buttonsArray addObject:button];
            
            button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
            if ( i == _currentIndex) {
                
                button.titleLabel.font = [UIFont systemFontOfSize:fontSize+2];
                button.selected = YES;
            }
            [self addSubview:button];
            
            CGFloat length = title.length * 20;
            orignX = orignX + length + TITLEINTERVAL;
        }
    }

}

- (void)buttonAction:(UIButton *)button {

    [self changeButtonView:button];
    _currentIndex = (NSInteger)button.tag-100;
    if (_buttonBlock) {
        
        _buttonBlock((NSInteger)button.tag-100);
    } else {
        NSLog(@"buttonsView has no block");
    }
    [self contentOffSet:button.tag-100];

}

- (void)changeButtonView:(UIButton *)button {
    
    NSInteger deviceScreenHeight = (NSInteger)[UIScreen mainScreen].bounds.size.height;
    NSInteger fontSize = 0;
    switch (deviceScreenHeight) {
        case 480:
            fontSize = 13.5;
            break;
        case 568:
            fontSize = 13.5;
            break;
        case 667:
            fontSize = 16;
            break;
        case 736:
            fontSize = 18;
        default:
            fontSize = 18;
            break;
    }
    NSArray *buttonArray = [self subviews];
    
    for (UIView *view in buttonArray) {
        
        if ([view isKindOfClass:[UIButton class]]) {
            
            UIButton *button1 = (UIButton *)view;
            button1.titleLabel.font = [UIFont systemFontOfSize:fontSize];
            button1.selected = NO;
            
        }
    }
    button.selected = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize+2];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _imageView.frame = CGRectMake(button.frame.origin.x, button.frame.size.height-7, button.frame.size.width, 7);
    }];
}



@end
