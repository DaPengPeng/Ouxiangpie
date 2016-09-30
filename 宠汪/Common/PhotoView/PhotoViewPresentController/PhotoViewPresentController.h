//
//  PhotoViewPresentController.h
//  PhotoView
//
//  Created by bever on 16/4/14.
//  Copyright © 2016年 贝沃. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoImageView.h"
#import "PhotoView.h"

@interface PhotoViewPresentController : UIViewController

@property (nonatomic,retain) NSArray *dataList;

@property (nonatomic,retain) PhotoImageView *imageView;

@property (nonatomic,retain) PhotoView *photoView;

@end
