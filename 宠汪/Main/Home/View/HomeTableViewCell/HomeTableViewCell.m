//
//  HomeTableViewCell.m
//  宠汪
//
//  Created by 滕呈斌 on 16/8/9.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "CNLabel.h"
#import "PhotoView.h"
#import "UIUtils.h"
#import "UserImageView.h"
#import "DetailTopicController.h"

#import <AVOSCloud/AVOSCloud.h>

@interface HomeTableViewCell () {
    PhotoView *_photoView;
}
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UserImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *createTime;

@property (weak, nonatomic) IBOutlet CNLabel *summary;
@property (weak, nonatomic) IBOutlet UIButton *rePlay;
@property (weak, nonatomic) IBOutlet UIButton *prise;

@end

@implementation HomeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _summary.textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    _playerView = [[PlayerView alloc] initWithFrame:CGRectMake(0, 55, kScreenW, 260)];
    [self addSubview:_playerView];
    
    _photoView = [[PhotoView alloc] initWithFrame:CGRectMake(0, 55, kScreenW, kScreenW*(9.0/16.0))];
    [self addSubview:_photoView];
    _photoView.hidden = YES;
    _playerView.hidden = YES;
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessageModel:(MessageModel *)messageModel {
    _messageModel = messageModel;
    
    //删除控件
    for (UIView *view in _photoView.subviews) {
        [view removeFromSuperview];
    }
    _summary.height = 0;
    AVQuery *query = [AVQuery queryWithClassName:kUserInfo];
    [query whereKey:kUserInfoId equalTo:messageModel.mUId];
    AVObject *user = [[query findObjects] firstObject];
    _userName.text = [user objectForKey:kUAlais];
    _userImg.userId = [user objectForKey:kUserInfoId];
    [_userImg sd_setImageWithURL:[NSURL URLWithString:[user objectForKey:kUImage]]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [formatter stringFromDate:_messageModel.createdAt];
    _createTime.text = [UIUtils formatDateString:time];
    
    CGFloat contentH = 0;
    if (_messageModel.mContent && ![_messageModel.mContent isEqualToString:@""]) {
        _summary.text = _messageModel.mContent;
        contentH = _summary.height;
    } else {
        _summary.height = 5;
        contentH = _summary.height;
    }
    CGFloat phoetViewH = 0;
    if ([_messageModel.mType integerValue] == 0) {
        _photoView.hidden = YES;
        _playerView.hidden = YES;
    } else if ([_messageModel.mType integerValue] == 1) {
        _photoView.frame = CGRectMake(0, 55+_summary.height, kScreenW, _photoView.height);
        _photoView.dataList = _messageModel.mPhotos;
        if (_messageModel.mPhotos.count > 0) {
            switch (_messageModel.mPhotos.count) {
                case 1:case 2:case 3:
                    phoetViewH = (kScreenW-6)/3;
                    break;
                case 4: case 5: case 6:
                    phoetViewH = (kScreenW-6)/3*2 + 3;
                    break;
                case 7: case 8: case 9:
                    phoetViewH = (kScreenW-6)/3*3 + 6;
                default:
                    phoetViewH = 0;
                    break;
            }
        }
        _photoView.hidden = NO;
        _playerView.hidden = YES;
    } else if ([_messageModel.mType integerValue] == 2) {
        
        _photoView.top = 55 + _summary.height;
        [_playerView sd_setImageWithURL:[NSURL URLWithString:_messageModel.mVideoCorImg] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!error) {
                CGFloat height = (image.size.height/image.size.width)*kScreenW;
                _playerView.frame = CGRectMake(0, 55+contentH, kScreenW, height);
            }
        }];
        _playerView.url = _messageModel.mVideo;
        _photoView.hidden = YES;
        _playerView.hidden = NO;
    }
    
    [_rePlay setTitle:[messageModel.mReplayCount stringValue] forState:UIControlStateNormal];
    [_prise setTitle:[messageModel.mFavCount stringValue] forState:UIControlStateNormal];

}
- (IBAction)replayAction:(UIButton *)sender {
    
    DetailTopicController *detailTopicVC = [[DetailTopicController alloc] init];
    detailTopicVC.messageModle = _messageModel;
    detailTopicVC.isFirst = YES;
    [self.viewController.navigationController pushViewController:detailTopicVC animated:YES];
    
}
- (IBAction)priseAction:(UIButton *)sender {
    
    AVObject *priase = [[AVObject alloc] initWithClassName:kPriase];
    [priase setObject:_messageModel.mId forKey:kPriMId];
    [priase setObject:[AVUser currentUser].objectId forKeyedSubscript:kPriUId];
    [priase saveInBackground];
    
}
- (IBAction)moreAction:(UIButton *)sender {
    _block();
}

@end
