//
//  SendTopicController.m
//  宠汪
//
//  Created by 滕呈斌 on 16/9/1.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "SendTopicController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "LoginViewController.h"
#import "AnotherAttenController.h"
#import "CNLabel.h"
#import "DPPlaceHoldTextView.h"
#import "EmoticonsView.h"

#import "TZImagePickerController.h"
#import <CoreData/CoreData.h>
#import "DPTextViewManager.h"
#import "PhotoView.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void(^Result)(NSString *path);

// caches路径
#define KCachesPath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

// 照片原图路径
#define KOriginalPhotoImagePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"OriginalPhotoImages"]

@interface SendTopicController ()<UITextViewDelegate, TZImagePickerControllerDelegate> {
    DPPlaceHoldTextView *_textView;//文本输入
    
    PhotoView *_photoView;//添加图片完成后的载体
    
    UIImageView *_imageView;//添加图片或者视频的入口
    
    UIImage *_image;//视频的截图
    
    AVObject *_message;//learn cloud对象
    
    NSMutableArray *_photoPaths;//上传原图图片的地址
    
    NSArray *_photos;//选择图片image数组
    
    NSMutableArray *_imageUrls;//保存图片之后返回的url数组
    
    UIView *_maskView;//发表上传图片等显示的视图
    
    UIButton *_rightButton;//导航栏右侧按钮
    UIButton *_leftButton;//导航栏左侧按钮
    
    UILabel *_locationLabel;//位置标签
    
    UIView *_toolBar;
    
}

@property (nonatomic, retain) EmoticonsView *faceView;//表情包

@property (nonatomic, retain) DPTextViewManager *manager;//表情混编管理

@property (nonatomic, retain) NSString *videoPath;//上传文件的地址

@end

@implementation SendTopicController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUI];
};

- (void)setUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //textView
    _textView = [[DPPlaceHoldTextView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    _textView.placehold = @"分享你的信仰！";
    [self.view addSubview:_textView];
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:20];
    [_textView becomeFirstResponder];
    
    _photoView = [[PhotoView alloc] initWithFrame:CGRectMake(0, kScreenH*0.2, kScreenW, kScreenH*0.8)];
    [_textView addSubview:_photoView];
    
    //addImage
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenH*0.2, (kScreenW-6)/3, (kScreenW-6)/3)];
    _imageView.userInteractionEnabled = YES;
    [_textView addSubview:_imageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [_imageView addGestureRecognizer:tap];
    //    imageView.image = [UIImage imageNamed:@"timeline_relationship_icon_addattention@3x"];
    _imageView.backgroundColor =  [UIColor greenColor];
    
    //sendButton
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(0, 0, 49, 49);
    [_rightButton setTitle:@"发送" forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //返回
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 0, 25, 25);
    [_leftButton setBackgroundImage:[UIImage imageNamed:@"top_back_white@2x"] forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:_leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //设置富文本属性
    _textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20]};
    
    [self createToolBar];
    
    //相关对象的初始化
    _manager = [DPTextViewManager shareManager];
    _message = [[AVObject alloc] initWithClassName:@"Message"];
    _photoPaths = [NSMutableArray array];
    _imageUrls = [NSMutableArray array];

}
- (void)backButtonAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tapAction {
    [self alumb];
}
- (void)rightButtonAction {
    
    [self addInfoOfMessage];
    //显示maskView
    [self showMaskView];
    //图片上传
    if (_photoPaths.count > 0) {
        dispatch_group_t dispatchGroup = dispatch_group_create();
        for (int i = 0; i < _photoPaths.count; ++i) {
            NSString *photoPath = _photoPaths[i];
            dispatch_group_async(dispatchGroup, dispatch_get_global_queue(0, 0), ^{
                AVFile *photo = [AVFile fileWithName:@"photo.png" contentsAtPath:photoPath];
                NSError *error = nil;
                BOOL isSucceed = [photo save:&error];
                if (isSucceed) {
                    [_imageUrls addObject:photo.url];
                    NSString *PATH_MOVIE_FILE = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"photo%d.png",i]];
                    [[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE  error:nil];
                } else {
                    NSLog(@"error: %@",[error localizedDescription]);
                }
                
            });
        }
        dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^{
            [_message setObject:_imageUrls forKey:kMPhotos];
            [_message setObject:@1 forKey:kMType];
            [_message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [self.navigationController popViewControllerAnimated:YES];

                }
            }];
        });
    } else if (_photos.count > 0){
        dispatch_group_t dispatchGroup = dispatch_group_create();
        for (UIImage *image in _photos) {
            dispatch_group_async(dispatchGroup, dispatch_get_global_queue(0, 0), ^{
                NSData *data = UIImageJPEGRepresentation(image, 1);
                AVFile *photo = [AVFile fileWithName:@"photo.png" data:data];
                if ([photo save]) {
                    [_imageUrls addObject:photo.url];
                }
            });
        }
        dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^{
            [_message setObject:_imageUrls forKey:kMPhotos];
            [_message setObject:@1 forKey:kMType];
            [_message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"save succeed");
                    [self.navigationController popViewControllerAnimated:YES];

                }
            }];
        });
        
    }
    
    //视频上传
    //上传视频覆盖图片
    if (_image) {
        NSData *data = UIImageJPEGRepresentation(_image, 1);
        AVFile *corImg = [AVFile fileWithName:@"corImg.png" data:data];
        [corImg saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
              
                [_message setObject:corImg.url forKey:kMVideoCor];
                if (_videoPath) {
                    AVFile *file = [AVFile fileWithName:@"video.mov" contentsAtPath:_videoPath];
                    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            
                            [_message addObject:file.url forKey:kMVideo];
                            
                            
                            [_message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                
                                [_message setObject:@2 forKey:kMType];
                                if (!succeeded) {
                                    NSLog(@"save false, error:%@",error);
                                    [self.navigationController popViewControllerAnimated:YES];
                                } else {
                                    NSLog(@"save succeeded");
                                }
                            }];
                            
                        }
                    } progressBlock:^(NSInteger percentDone) {
                        NSLog(@"%ld%%",percentDone);
                    }];
                }

            }
        }];
    }
    
    if (!_image && !_photos && !(_photoPaths.count > 0)) {
        [_message setObject:@0 forKey:kMType];
        [_message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (succeeded) {
                
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                NSLog(@"save error");
            }
        }];
    }
}

- (void)showMaskView {
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = .7;
    [self.view addSubview:_maskView];
    [self.view bringSubviewToFront:_maskView];
    UIActivityIndicatorView *indecatorView =[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    indecatorView.center = _maskView.center;
    indecatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [indecatorView startAnimating];
    [_maskView addSubview:indecatorView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 20)];
    label.center = CGPointMake(_maskView.center.x, _maskView.center.y+30);
    label.text = @"正在火速上传";
    label.textColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:24];
    [_maskView addSubview:label];
    
    //按钮的失效
    _rightButton.userInteractionEnabled = NO;
    _leftButton.userInteractionEnabled = NO;
}

//文件上传成功之后，组织message信息
- (void)addInfoOfMessage {
    NSString *string = [_manager stringWithAttString:_textView.text];
    if (![string isEqualToString:@""] && string != nil) {
        
        [_message setObject:string forKey:kMContent];
    }
    [_message setObject:@0 forKey:kMFavCount];
    [_message setObject:@0 forKey:kMPriseCount];
    [_message setObject:@0 forKey:kMReplayCount];
    [_message setObject:[AVUser currentUser].objectId forKey:kMUId];
    
}

//添加键盘上方的view
//添加工具按钮栏
-(void)createToolBar
{
    _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 64)];
    
    _toolBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
    
    NSArray *imgNames = @[@"compose_toolbar_1",@"compose_toolbar_3",@"compose_toolbar_4",@"compose_toolbar_5",@"compose_toolbar_6"];
    
    for (int i = 0; i<5; i++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*kScreenW/5, 20, kScreenW/5, 44)];
        
        [btn setImage:[UIImage imageNamed:imgNames[i]] forState:UIControlStateNormal];
        
        btn.tag = 100+i;
        
        [btn addTarget:self action:@selector(toolBarBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [_toolBar addSubview:btn];
        
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 20)];
    view.backgroundColor = [UIColor whiteColor];
    [_toolBar addSubview:view];
    _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 20)];
    _locationLabel.font = [UIFont systemFontOfSize:15];
    _locationLabel.textColor = [UIColor grayColor];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *location = [userDefaults objectForKey:@"location"];
    _locationLabel.text = [userDefaults objectForKey:@"location"];
    if (location == nil || [location isEqualToString:@""]) {
        _locationLabel.text = @"未能定位成功";
    }
    [view addSubview:_locationLabel];
    
    _textView.inputAccessoryView = _toolBar;//将工具栏放在textView的上方
    
}


-(void)toolBarBtn:(UIButton *)btn
{
    switch (btn.tag) {
            
        case 100:
            break;
            
        case 101:
            //添加关注列表
            [self pushAttentionViewController];
            break;
        case 104:
            
            //添加表情包
            [self addFaceView];
            
            break;
            
        default:
            break;
    }
}

- (void)pushAttentionViewController {
    AnotherAttenController *attenController = [[AnotherAttenController alloc] init];
    __weak typeof (_textView) weakTextView = _textView;
    attenController.block = ^(NSString *name) {
        NSMutableAttributedString *mutableAttStr = [[NSMutableAttributedString alloc] initWithAttributedString:weakTextView.attributedText];
        NSAttributedString *attName = [[NSAttributedString alloc] initWithString:name attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:[UIColor blueColor]}];
        [mutableAttStr insertAttributedString:attName atIndex:weakTextView.attributedText.length];
        weakTextView.attributedText = mutableAttStr;
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UITextViewChangeWithValue" object:nil userInfo:@{@"text":_textView.text}];
    };
    [self.navigationController pushViewController:attenController animated:YES];
}

- (void)alumb {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (EmoticonsView *)faceView {
    
    __weak typeof (_textView) weakTextView = _textView;
    __weak typeof (_manager) weakManager = _manager;
    if (_faceView == nil) {
        _faceView = [[EmoticonsView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 220) withBlock:^(NSString *name) {
            
            //将name插入到文本中
            //获取光标的位置
            NSRange range = weakTextView.selectedRange;
        
            //重新设置光标位置
            NSMutableAttributedString *mAttString = [[NSMutableAttributedString alloc]initWithAttributedString:weakTextView.attributedText];
            [mAttString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, mAttString.length)];
            NSAttributedString *attStr = [weakManager attributedStringWtihName:name];
            [mAttString insertAttributedString:attStr atIndex:range.location];
            weakTextView.attributedText = mAttString;
            
            range.location = range.location + 1;
            //发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UITextViewChangeWithValue" object:nil userInfo:@{@"text":_textView.text}];
        }];
    }
    return _faceView;
}
-(void)addFaceView
{
 
    self.faceView;
    if (!_textView.inputView) {
        [_textView resignFirstResponder];
        _textView.inputView = _faceView;
        _textView.font = [UIFont systemFontOfSize:20];
        [_textView becomeFirstResponder];
    }
    else
    {
        [_textView resignFirstResponder];
        _textView.inputView = nil;
        _textView.font = [UIFont systemFontOfSize:20];
        [_textView becomeFirstResponder];
    }
    
}


#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        _textView.font = [UIFont systemFontOfSize:20];
    }
    if (_textView.font != [UIFont systemFontOfSize:20]) {
        
        _textView.font = [UIFont systemFontOfSize:20];

    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    //更改图片层的高度
    if (_textView.contentSize.height > kScreenH*0.2) {
        
        _imageView.frame = CGRectMake(0, _textView.contentSize.height, (kScreenW-6)/3, (kScreenW-6)/3);
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UITextViewChangeWithValue" object:nil userInfo:@{@"text":_textView.text}];
}


#pragma mark - TZImagePickerControllerDelegate
//用户选择了图片
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    if (![[assets firstObject]isKindOfClass:[NSNumber class]]) {
        
        __weak typeof (self) weakSelf = self;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            for (int i = 0; i < assets.count; ++i) {
                PHAsset *phAsset = assets[i];
                [weakSelf getImageFromPHAsset:phAsset flieName:[NSString stringWithFormat:@"photo%d.png",i] Complete:^(NSString *path) {
                    [_photoPaths addObject:path];
                }];
            }
        } else {
            for (int i = 0; i < assets.count; ++i) {
                ALAsset *alAsset = assets[i];
                NSURL *url = [[alAsset defaultRepresentation] url];
                NSString *fileName = [NSString stringWithFormat:@"tempAssetPhoto%d.png",i];
                [self imageWithUrl:url withFileName:fileName];
            }
        }
    } else {
        _photos = photos;
    }
    _imageView.hidden = NO;
    _photoView.dataList = photos;
    _imageView.frame = CGRectMake(((kScreenW - 6)/3 + 3) * (photos.count % 3), (_textView.contentSize.height > kScreenH*0.2 ? _textView.contentSize.height : kScreenH*0.2) + ((kScreenW - 6)/3 + 3) * (photos.count / 3), (kScreenW - 6)/3, (kScreenW - 6)/3);
}
//用户选择了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    NSLog(@"用户没有选择图片，选择了取消");
}

//用户选择了视频。如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        PHAsset *phAsset = (PHAsset *)asset;
        __weak typeof (self) weakSelf = self;
        [self getVideoFromPHAsset:phAsset Complete:^void(NSString *path) {
            weakSelf.videoPath = path;
        }];
    } else {
        ALAsset *alAsset = (ALAsset *)asset;
        NSURL *url = [[alAsset defaultRepresentation] url];
        NSString *fileName = @"tempAssetVideo.mov";
        [self videoWithUrl:url withFileName:fileName];
    }
    _imageView.hidden = YES;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:_imageView.frame];
    imageView.image = coverImage;
    _image = coverImage;
    
    [_textView addSubview:imageView];
}

#pragma mark - 获得视频
//获得视频
- (void)getVideoFromPHAsset:(PHAsset *)asset Complete:(Result)result {
    NSArray *assetResources = [PHAssetResource assetResourcesForAsset:asset];
    PHAssetResource *resource;
    
    for (PHAssetResource *assetRes in assetResources) {
        if (assetRes.type == PHAssetResourceTypePairedVideo ||
            assetRes.type == PHAssetResourceTypeVideo) {
            resource = assetRes;
        }
    }
    NSString *fileName = @"tempAssetVideo.mov";
    if (resource.originalFilename) {
        fileName = resource.originalFilename;
    }
    
    if (asset.mediaType == PHAssetMediaTypeVideo || asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        NSString *PATH_MOVIE_FILE = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        [[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE error:nil];
        [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource
                                                                    toFile:[NSURL fileURLWithPath:PATH_MOVIE_FILE]
                                                                   options:nil
                                                         completionHandler:^(NSError * _Nullable error) {
                                                             if (error) {
                                                                 result(nil);
                                                             } else {
                                                                                            result(PATH_MOVIE_FILE);
                                                             }
                                                        
                                                         }];
    } else {
        result(nil);
    }
}

// 将原始视频的URL转化为NSData数据,写入沙盒
- (void)videoWithUrl:(NSURL *)url withFileName:(NSString *)fileName
{
    // 解析一下,为什么视频不像图片一样一次性开辟本身大小的内存写入?
    // 想想,如果1个视频有1G多,难道直接开辟1G多的空间大小来写?
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    if (url) {
        [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
            ALAssetRepresentation *rep = [asset defaultRepresentation];
            NSString * videoPath = [KCachesPath stringByAppendingPathComponent:fileName];
            char const *cvideoPath = [videoPath UTF8String];
            FILE *file = fopen(cvideoPath, "a+");
            if (file) {
                const int bufferSize = 1024 * 1024;
                // 初始化一个1M的buffer
                Byte *buffer = (Byte*)malloc(bufferSize);
                NSUInteger read = 0, offset = 0, written = 0;
                NSError* err = nil;
                if (rep.size != 0)
                {
                    do {
                        read = [rep getBytes:buffer fromOffset:offset length:bufferSize error:&err];
                        written = fwrite(buffer, sizeof(char), read, file);
                        offset += read;
                    } while (read != 0 && !err);//没到结尾，没出错，ok继续
                }
                // 释放缓冲区，关闭文件
                free(buffer);
                buffer = NULL;
                fclose(file);
                file = NULL;
                self.videoPath = videoPath;
            }
        } failureBlock:nil];
    }
        
}

//获取图片
- (void)getImageFromPHAsset:(PHAsset *)asset flieName:(NSString *)fileName Complete:(Result)result {
    PHAssetResource *resource = [[PHAssetResource assetResourcesForAsset:asset] firstObject];
    if (asset.mediaType == PHAssetMediaTypeImage) {
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        options.synchronous = YES;
        NSString *PATH_MOVIE_FILE = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        [[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE error:nil];
        [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource
                                                                    toFile:[NSURL fileURLWithPath:PATH_MOVIE_FILE]
                                                                   options:nil
                                                         completionHandler:^(NSError * _Nullable error) {
                                                             if (error) {
                                                                 result(nil);
                                                             } else {
                                                                 result(PATH_MOVIE_FILE);
                                                             }
                                                             
                                                         }];
    }
    
}

// 将原始图片的URL转化为NSData数据,写入沙盒
- (void)imageWithUrl:(NSURL *)url withFileName:(NSString *)fileName
{
    // 进这个方法的时候也应该加判断,如果已经转化了的就不要调用这个方法了
    // 如何判断已经转化了,通过是否存在文件路径
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    // 创建存放原始图的文件夹--->OriginalPhotoImages
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:KOriginalPhotoImagePath]) {
        [fileManager createDirectoryAtPath:KOriginalPhotoImagePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
        if (url) {
            // 主要方法
            [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
                ALAssetRepresentation *rep = [asset defaultRepresentation];
                Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
                NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:((unsigned long)rep.size) error:nil];
                NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
                NSString * imagePath = [KOriginalPhotoImagePath stringByAppendingPathComponent:fileName];
                [data writeToFile:imagePath atomically:YES];
                [_photoPaths addObject:imagePath];
            } failureBlock:nil];
        }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = YES;

}


@end
