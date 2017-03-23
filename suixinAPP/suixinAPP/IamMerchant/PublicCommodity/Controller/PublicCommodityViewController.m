//
//  PublicCommodityViewController.m
//  suixinAPP
//
//  Created by 刘殿武 on 2017/3/10.
//  Copyright © 2017年 YGTechnology. All rights reserved.
//

#import "PublicCommodityViewController.h"

@interface PublicCommodityViewController ()

@end

@implementation PublicCommodityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
- (IBAction)action:(id)sender {
  
    UIViewController * vc = [[UIStoryboard storyboardWithName:@"show" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ReportStateViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
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
