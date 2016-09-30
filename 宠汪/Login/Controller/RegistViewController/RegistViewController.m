//
//  RegistViewController.m
//  宠汪
//
//  Created by 滕呈斌 on 16/8/11.
//  Copyright © 2016年 dapengpeng. All rights reserved.
//

#import "RegistViewController.h"
#import "NSString+Check.h"
#import <AVOSCloud/AVOSCloud.h>

@interface RegistViewController ()
@property (weak, nonatomic) IBOutlet UITextField *telephoneNum;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UITextField *eMail;
@property (weak, nonatomic) IBOutlet UITextField *relayName;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UITextField *testWord;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUI];
}
- (IBAction)sendTestWord:(UIButton *)sender {
    
    NSError *error = nil;
    if ([_telephoneNum.text checkPhoneNumberInput] && _relayName.text != nil && _passWord.text != nil && _eMail.text != nil) {
        AVUser *user = [AVUser user];
        user.username = _relayName.text;
        user.email = _eMail.text;
        user.mobilePhoneNumber = _telephoneNum.text;
        user.password = _passWord.text;
        [user signUp:&error];
    }
    if (error) {
        NSLog(@"注册失败：%@",error);
    }
    
}
- (IBAction)registeAcrion:(UIButton *)sender {
    
    [AVUser verifyMobilePhone:_testWord.text withBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"注册成功");
        } else{
            NSLog(@"Error：%@",error);
        }
    }];
}

- (void)setUI {
    
    self.title = @"注册";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
