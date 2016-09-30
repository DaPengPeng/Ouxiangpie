//
//  userCenterTableViewSectionZero.m
//  宠汪
//
//  Created by 滕呈斌 on 16/8/10.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "UserCenterTableViewSectionZero.h"
#import "ControlView.h"

@interface UserCenterTableViewSectionZero ()
@property (weak, nonatomic) IBOutlet ControlView *controlViewOne;
@property (weak, nonatomic) IBOutlet ControlView *controlViewTwo;

@property (weak, nonatomic) IBOutlet ControlView *controlViewThree;
@property (weak, nonatomic) IBOutlet ControlView *controlViewFour;

@end

@implementation UserCenterTableViewSectionZero

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    _controlViewOne.titleAndController = titleArray[0];
    _controlViewTwo.titleAndController = titleArray[1];
    _controlViewThree.titleAndController = titleArray[2];
    _controlViewFour.titleAndController = titleArray[3];
}

@end
