//
//  VerificationPhoneNumberViewController.m
//  suixinAPP
//
//  Created by 刘殿武 on 2017/3/9.
//  Copyright © 2017年 YGTechnology. All rights reserved.
//

#import "VerificationPhoneNumberViewController.h"
#import <SMS_SDK/SMSSDK.h>
@interface VerificationPhoneNumberViewController ()
@property (weak, nonatomic) IBOutlet UILabel *UserPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *VerificationNuber;

@end

@implementation VerificationPhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - 获取验证码
- (IBAction)getVerificationNumberButton:(UIButton *)sender {
    
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:@"17667936243" zone:@"86" customIdentifier:nil result:^(NSError *error) {
        
        if (!error) {
            NSLog(@"获取验证码成功");
        } else {
            NSLog(@"错误信息：%@",error);
        }
        
    }];
    
    
    
    
    
}
#pragma mark - 注册
- (IBAction)RegisterButton:(UIButton *)sender {
    
    
    [SMSSDK commitVerificationCode:self.VerificationNuber.text phoneNumber:@"17667936243" zone:@"86" result:^(NSError *error) {
        
        if (!error)
        {
            
            NSLog(@"验证成功");
        }
        else
        {
            NSLog(@"错误信息:%@",error);
        }

    }];
    
  
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
