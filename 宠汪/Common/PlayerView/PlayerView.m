//
//  PlayerView.m
//  PlayerView
//
//  Created by 滕呈斌 on 16/7/29.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "PlayerView.h"

@interface PlayerView () {
    CGFloat _nowTime;
    BOOL _hasPlay;
}

@property (nonatomic, strong) UIProgressView *progressView;//进度条

@property (nonatomic, strong) UISlider *slider;//滑块

@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) UIView *bgView;//底部背景视图

@property (nonatomic, strong) UIButton *playOrPauseBtn;//播放暂停按钮

@property (nonatomic, strong) AVPlayerItem *playerItem;

@property (nonatomic, copy) NSString *totalTime;//播放时间

@property (nonatomic, strong) id playbackTimeObserver;

@property (nonatomic, strong) UILabel *leftLabel;//当前播放时间

@end

@implementation PlayerView



- (instancetype)initWithURL:(NSString *)url frame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.url = url;
    }
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self readySomeThing];
    }
    return self;
}

- (void)pause {
    _nowTime = _slider.value;
    [self.player pause];
    _playOrPauseBtn.hidden = NO;
}

- (void)readySomeThing {
    //开启触摸
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES;
    
//    //视频截图的捕捉
//    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:self.playerItem.asset];
//    CMTime time = CMTimeMakeWithSeconds(1, 1);
//    CGImageRef cgImage = [generator copyCGImageAtTime:time actualTime:nil error:nil];
//    UIImage *image = [UIImage imageWithCGImage:cgImage];
//    self.image = image;
//    self.height = [UIScreen mainScreen].bounds.size.width/image.size.width * image.size.height;
//    self.contentMode = UIViewContentModeScaleAspectFit;
//    CGImageRelease(cgImage);
    
    //UI
    [self setUI];
    //添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
}

- (void)setUI {
    
    //底部进度背景
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 30, self.frame.size.width, 30)];
    [self addSubview:_bgView];
    _bgView.backgroundColor = [UIColor grayColor];
    _bgView.alpha = 0.70;
    self.bgView.hidden = YES;
    
    //进度条
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(90, _bgView.frame.size.height/2, _bgView.frame.size.width-90, 0)];
    [_bgView addSubview:_progressView];
    
    [_progressView setTrackTintColor:[UIColor redColor]];
    
    //滑块
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(90, _bgView.frame.size.height-30, self.progressView.frame.size.width, 30)];
    [_bgView addSubview:_slider];
    [_bgView bringSubviewToFront:_slider];
    _slider.continuous = NO;
    [_slider addTarget:self action:@selector(changePlayerCurrentTime:) forControlEvents:UIControlEventValueChanged];
    
    //播放按钮
    _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _playOrPauseBtn.frame = CGRectMake((self.frame.size.width-100)/2, (self.frame.size.height-100)/2, 100, 100);
    [_playOrPauseBtn setBackgroundImage:[UIImage imageNamed:@"activity_resume@2x"] forState:UIControlStateNormal];
    [self addSubview:_playOrPauseBtn];
    [self bringSubviewToFront:_playOrPauseBtn];
    [_playOrPauseBtn addTarget:self action:@selector(buttonAct:) forControlEvents:UIControlEventTouchUpInside];
    //左右时间显示
    _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 90, 20)];
    _leftLabel.textAlignment = NSTextAlignmentRight;
    _leftLabel.text = @"00:00";
    [_bgView addSubview:_leftLabel];
    _leftLabel.font = [UIFont systemFontOfSize:14];
    
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            self.playOrPauseBtn.enabled = YES;
            CMTime duration = self.playerItem.duration;// 获取视频总长度
            CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;// 转换成秒
            _totalTime = [self convertTime:totalSecond];// 转换成播放时间
            [self customVideoSlider:duration];// 自定义UISlider外观
            NSLog(@"movie total duration:%f",CMTimeGetSeconds(duration));
            [self monitoringPlayback:self.playerItem];// 监听播放状态
        } else if ([playerItem status] == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
        CMTime duration = self.playerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        [self.progressView setProgress:timeInterval / totalDuration animated:YES];
    }
}

- (AVPlayer *)player {
    
    if (!_player) {
        
        _player = [AVPlayer playerWithPlayerItem:self.playerItem];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];//添加观察者，观察视频是否播放完毕
    }
    
    return _player;
}

- (AVPlayerLayer *)playerLayer {
    
    if (!_playerLayer) {
        
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.frame = self.bounds;
        [self.layer addSublayer:_playerLayer];
        [self bringSubviewToFront:self.bgView];
    }
    return _playerLayer;
}

- (void)moviePlayDidEnd {
    NSLog(@"playerDidEnd");
    
    self.playOrPauseBtn.hidden = NO;
    self.playerLayer.hidden = YES;
}

- (AVPlayerItem *)playerItem {
    if (!_playerItem) {
        _playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.url]];
        [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];//监听status属性
        [_playerItem addObserver:self forKeyPath:@"loadedTimeRanges"  options:NSKeyValueObservingOptionNew context:nil];//监听缓存进度
        
    }
    return _playerItem;
}

- (void)buttonAct:(UIButton *)button {
    self.player;
    self.playerLayer.hidden = NO;
    self.playerItem;
    _hasPlay = YES;
    
    [_player seekToTime:[@(_nowTime) CMTimeValue]];
    [self.player play];
    
    _slider.value = _nowTime;
    self.playOrPauseBtn.hidden = YES;
    button.hidden = YES;
    self.bgView.hidden = NO;
    [self performSelector:@selector(bgViewHidden) withObject:nil afterDelay:5];
}

- (void)bgViewHidden {
    self.bgView.hidden = YES;
}

- (void)bgViewShow {
    self.bgView.hidden = NO;
    [self performSelector:@selector(bgViewHidden) withObject:nil afterDelay:5];
}

- (void)tapAction {
    if (!_bgView.hidden) {
        _bgView.hidden = YES;
    } else {
        [self bgViewShow];
    }
}
//时间的转换
- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
}

//计算缓冲进度
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

- (void)monitoringPlayback:(AVPlayerItem *)playerItem {
    self.playbackTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        if (!self.slider.highlighted) {//高亮状态不做滑块调动
            CGFloat currentSecond = playerItem.currentTime.value/playerItem.currentTime.timescale;// 计算当前在第几秒
            NSLog(@"current_time_is :%f",currentSecond);
            [self updateVideoSlider:currentSecond];
            NSString *timeString = [self convertTime:currentSecond];
            self.leftLabel.text = [NSString stringWithFormat:@"%@/%@",timeString,_totalTime];
        }
    }];
}

//更新滑块的位置
- (void)updateVideoSlider:(CGFloat)currentSecond {
    self.slider.value = currentSecond;
}

//自定义滑块
- (void)customVideoSlider:(CMTime)duration {

    self.slider.maximumValue = CMTimeGetSeconds(duration);
    UIGraphicsBeginImageContextWithOptions((CGSize){ 1, 1 }, NO, 0.0f);
    UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.slider setMinimumTrackImage:transparentImage forState:UIControlStateNormal];
    [self.slider setMaximumTrackImage:transparentImage forState:UIControlStateNormal];
}

- (void)changePlayerCurrentTime:(UISlider *)slider {
    
    [self.player seekToTime:[@(slider.value) CMTimeValue]];
    
}

//观察者的移除
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_hasPlay) {
        
        [self.player removeTimeObserver:self];
    }
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}
@end
