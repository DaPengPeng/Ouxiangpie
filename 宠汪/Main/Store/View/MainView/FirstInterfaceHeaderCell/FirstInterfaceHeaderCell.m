//
//  FirstInterfaceHeaderCell.m
//  Oupie
//
//  Created by 滕呈斌 on 16/7/18.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "FirstInterfaceHeaderCell.h"
#import "XRCarouselView.h"

@interface FirstInterfaceHeaderCell ()

@property (weak, nonatomic) IBOutlet XRCarouselView *carouselView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;

@end

@implementation FirstInterfaceHeaderCell

- (void)awakeFromNib {
    
//    _carouselView.frame = CGRectMake(0, 0, kScreenW, kScreenH*0.4);
//    _imageView1.frame = CGRectMake(5, kScreenH*0.4+5, (kScreenW-26)/3, (kScreenW-26)/3);
//    _imageView2.frame = CGRectMake(5+(kScreenW-26)/3+3, kScreenH*0.4+5, (kScreenW-26)/3, (kScreenW-26)/3);
//    _imageView3.frame = CGRectMake(5+(kScreenW-26)/3*2+6, kScreenH*0.4+5, (kScreenW-26)/3, (kScreenW-26)/3);
//    _imageView1.frame = CGRectMake(0, 0, 100, 200);
    
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 1; i < 4; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i]];
        if (image) {
            
            [imageArray addObject:image];
        }
    }
    self.carouselView.imageArray = imageArray;
    
    self.imageView1.image = [UIImage imageNamed:@"4"];
    self.imageView2.image = [UIImage imageNamed:@"5"];
    self.imageView3.image = [UIImage imageNamed:@"6"];
}


//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
