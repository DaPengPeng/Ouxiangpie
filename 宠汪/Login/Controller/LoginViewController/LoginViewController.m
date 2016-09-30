//
//  LoginViewController.m
//  宠汪
//
//  Created by 滕呈斌 on 16/8/11.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import <AVOSCloud/AVOSCloud.h>

#import "UMSocial.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UITextField *userId;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *forgeyPassword;
@property (weak, nonatomic) IBOutlet UIImageView *weixinLogin;
@property (weak, nonatomic) IBOutlet UIImageView *qqLogin;
@property (weak, nonatomic) IBOutlet UIImageView *weiboLogin;

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUI];
}

- (void)setUI {
    
    self.title = @"登录";
    
    //导航栏
    //注册
    UIButton *registButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registButton.frame = CGRectMake(0, 0, 44, 44);
    [registButton setTitle:@"注册" forState:UIControlStateNormal];
    [registButton addTarget:self action:@selector(registButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:registButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //用户头像
    _userImg.layer.cornerRadius = _userImg.frame.size.width/2;
    _userImg.clipsToBounds = YES;
    _userImg.layer.masksToBounds = YES;
    [_userImg sd_setImageWithURL:[NSURL URLWithString:@"http://www.ld12.com/upimg358/20160130/121054223155174.jpg"]];
    
    //为图片添加手势
    UITapGestureRecognizer *weixinTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weixinMain)];
    [_weixinLogin addGestureRecognizer:weixinTap];
    
    UITapGestureRecognizer *weiboTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weiboMain)];
    [_weiboLogin addGestureRecognizer:weiboTap];
    
    UITapGestureRecognizer *qqTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(QQLogin)];
    [_qqLogin addGestureRecognizer:qqTap];
    
}



- (void)weixinMain {
    
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            
        }
        
    });
}

- (void)QQLogin {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            
        }});
}

- (void)weiboMain {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            
        }});
}


- (void)registButtonAction {
    
    RegistViewController *registViewController = [[RegistViewController alloc] init];
    [self.navigationController pushViewController:registViewController animated:NO];
    
}
- (IBAction)LoginButtonAction:(UIButton *)sender {
    
    NSError *error = nil;
    [AVUser logInWithMobilePhoneNumber:_userId.text password:_passWord.text error:&error];
    if (error) {
        NSLog(@"%@",error);
    } else {
        NSLog(@"登陆成功：%@",[AVUser currentUser].mobilePhoneNumber);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}



@end
