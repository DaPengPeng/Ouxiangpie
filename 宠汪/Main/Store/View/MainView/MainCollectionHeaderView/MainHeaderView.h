//
//  headerView.h
//  Oupie
//
//  Created by 滕呈斌 on 16/7/13.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonsView.h"

@interface MainHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet ButtonsView *buttonsView;
@property (weak, nonatomic) IBOutlet UIButton *rightButtion;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UIButton *leftButtion;


@end
