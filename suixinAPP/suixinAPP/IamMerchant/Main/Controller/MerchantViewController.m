//
//  MerchantViewController.m
//  suixinAPP
//
//  Created by 刘殿武 on 2017/3/8.
//  Copyright © 2017年 YGTechnology. All rights reserved.
//

#import "MerchantViewController.h"
#import "PublicCommodityViewController.h"
@interface MerchantViewController ()
@property(strong,nonatomic)UIView * MerchantInfoView;

@property (weak, nonatomic) IBOutlet UIButton *publicCommodity;
@property (weak, nonatomic) IBOutlet UIButton *manageCommodity;
@property (weak, nonatomic) IBOutlet UIButton *SettingButton;
@property (weak, nonatomic) IBOutlet UIButton *manageIndent;
@property (weak, nonatomic) IBOutlet UIImageView *userHeadImage;//掌柜头像
@property (weak, nonatomic) IBOutlet UILabel *StoreName;//店铺名

@property (weak, nonatomic) IBOutlet UILabel *StoreNumber;//店铺号






@end

@implementation MerchantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我是商家";
  
    
}
-(void)viewWillAppear:(BOOL)animated{


    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    self.navigationController.navigationBar.translucent = NO;
 
//
    [self.navigationController.navigationBar setTitleTextAttributes:
  @{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];



}
//发布商品按钮
- (IBAction)PublicCommodity:(UIButton *)sender {
    
    PublicCommodityViewController * vc = [[PublicCommodityViewController alloc]initWithNibName:@"PublicCommodityViewController" bundle:[NSBundle mainBundle]];
    
    [self.navigationController  pushViewController:vc animated:YES];
    
    
    
}
//管理按钮
- (IBAction)ManageCommdity:(id)sender {
    
   
    
    
}
//设置
- (IBAction)SettingButton:(UIButton *)sender {
    
  
    
    
}
//订单管理

- (IBAction)MangeIndent:(UIButton *)sender {
    
    
    
    
}





- (void)initMerchantInfoView{


//    [self.view addSubview:_MerchantInfoView];



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
