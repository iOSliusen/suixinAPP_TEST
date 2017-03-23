//
//  SXRegisterViewController.m
//  suixinAPP
//
//  Created by 刘殿武 on 2017/3/9.
//  Copyright © 2017年 YGTechnology. All rights reserved.
//

#import "SXRegisterViewController.h"
#import "VerificationPhoneNumberViewController.h"
@interface SXRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *PhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *Passworld;
@property (weak, nonatomic) IBOutlet UITextField *SurePassword;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end

@implementation SXRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:NO];
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchAction)];
    tapGesture.numberOfTapsRequired = 1;
    
    tapGesture.numberOfTouchesRequired = 1;
    
    [self.backgroundImageView addGestureRecognizer:tapGesture];
    
    //注册通知
    [self.PhoneNumber addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.username addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.Passworld addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.SurePassword addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

}
- (IBAction)registerButton:(UIButton *)sender {
    //手机号验证界面
    
//    if ([self isRegular]) {
//     
//        
//        
//        
//        
//    }
//    
    
VerificationPhoneNumberViewController *vc = [[VerificationPhoneNumberViewController alloc]initWithNibName:@"VerificationPhoneNumberViewController" bundle:[NSBundle mainBundle]];
    
    
[self.navigationController pushViewController:vc animated:YES];
    
    
    
    
    
    
}
-(void)touchAction{
    
    
    [self.view endEditing:YES];//结束编辑
   
}

#pragma mark -对输入的内容做判断


#pragma mark - uitextfield 的回调 增加字数限制


- (void)textFieldDidChange:(UITextField *)textField
{
    //手机号输入框增加字数限制
    if (textField == self.PhoneNumber) {
        if (textField.text.length > 11) {
            UITextRange *markedRange = [textField markedTextRange];
            if (markedRange) {
                return;
            }
            //Emoji占2个字符，如果是超出了半个Emoji，用15位置来截取会出现Emoji截为2半
            //超出最大长度的那个字符序列(Emoji算一个字符序列)的range
            NSRange range = [textField.text rangeOfComposedCharacterSequenceAtIndex:11];
            textField.text = [textField.text substringToIndex:range.location];
        }
    }
    //昵称输入框增加字数限制
    if (textField == self.username) {
        if (textField.text.length > 32) {
            UITextRange *markedRange = [textField markedTextRange];
            if (markedRange) {
                return;
            }
            //Emoji占2个字符，如果是超出了半个Emoji，用15位置来截取会出现Emoji截为2半
            //超出最大长度的那个字符序列(Emoji算一个字符序列)的range
            NSRange range = [textField.text rangeOfComposedCharacterSequenceAtIndex:32];
            textField.text = [textField.text substringToIndex:range.location];
        }
    }
    //密码输入框增加字数限制
    if (textField == self.Passworld) {
        if (textField.text.length > 18) {
            UITextRange *markedRange = [textField markedTextRange];
            if (markedRange) {
                return;
            }
            //Emoji占2个字符，如果是超出了半个Emoji，用15位置来截取会出现Emoji截为2半
            //超出最大长度的那个字符序列(Emoji算一个字符序列)的range
            NSRange range = [textField.text rangeOfComposedCharacterSequenceAtIndex:18];
            textField.text = [textField.text substringToIndex:range.location];
        }
    }
    //确认密码输入框增加字数限制
    if (textField == self.SurePassword) {
        if (textField.text.length > 18) {
            UITextRange *markedRange = [textField markedTextRange];
            if (markedRange) {
                return;
            }
            //Emoji占2个字符，如果是超出了半个Emoji，用15位置来截取会出现Emoji截为2半
            //超出最大长度的那个字符序列(Emoji算一个字符序列)的range
            NSRange range = [textField.text rangeOfComposedCharacterSequenceAtIndex:18];
            textField.text = [textField.text substringToIndex:range.location];
        }
    }
 
}




#pragma mark - 判断所输入的内容是否合规
-(BOOL)isRegular{
    
    //手机号
    // 编写正则表达式：只能是数字
    NSString *regex1 = @"^[1][34578][0-9]{9}$";
    // 创建谓词对象并设定条件的表达式
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
 
    //密码
    //以字母开头，只能包含“字母”，“数字”，“下划线”，长度6~18
    NSString *regex2 = @"^([a-zA-Z0-9_]|[0-9]){6,18}$";
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    
    // 昵称 表情

    if (![predicate1 evaluateWithObject:self.PhoneNumber.text]) {
        
        //手机号不合规
        //        [self alertview:@"手机号码不正确"];
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"手机号输入不正确" message:@"请输入符合规范的手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"手机号输入不正确" message:@"请输入符合规范的手机号" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        
        
        
        
        
        return NO;
    }

    if (![self.Passworld.text isEqualToString:self.SurePassword.text] ){
        //密码不一致
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"两次输入的密码不一致"] message:[NSString stringWithFormat:@"请输入相同的密码"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"两次输入的密码不一致" message:@"请输入相同的密码" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];

        return NO;
        
    }else{
        
        if (![predicate2 evaluateWithObject:self.Passworld.text]) {
            //密码不符合规范
            
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"密码输入格式不正确" message:@"请输入只能包含“字母”，“数字”，“下划线”，长度6~18的文字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alertView show];
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"密码输入格式不正确" message:@"请输入只能包含“字母”，“数字”，“下划线”，长度6~18的文字" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
            return NO;
        }
      
    }
    
    if ([self stringContainsEmoji:self.username.text]) {

//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"昵称输入不正确" message:@"请输入不包含表情的文字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"昵称输入不正确" message:@"请输入不包含表情的文字" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        return NO;
     
    }
 
    return YES;
   
}





#pragma mark - 表情检测


-(BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                // surrogate pair
                                if (0xd800 <= hs && hs <= 0xdbff)
                                {
                                    if (substring.length > 1)
                                    {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f918)
                                        {
                                            returnValue = YES;
                                        }
                                    }
                                }
                                else if (substring.length > 1)
                                {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3 || ls == 0xFE0F || ls == 0xd83c)
                                    {
                                        returnValue = YES;
                                    }
                                }
                                else
                                {
                                    // non surrogate
                                    if (0x2100 <= hs && hs <= 0x27ff)
                                    {
                                        returnValue = YES;
                                    }
                                    else if (0x2B05 <= hs && hs <= 0x2b07)
                                    {
                                        returnValue = YES;
                                    }
                                    else if (0x2934 <= hs && hs <= 0x2935)
                                    {
                                        returnValue = YES;
                                    }
                                    else if (0x3297 <= hs && hs <= 0x3299)
                                    {
                                        returnValue = YES;
                                    }
                                    else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50)
                                    {
                                        returnValue = YES;
                                    }
                                }
                            }];
    return returnValue;
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
