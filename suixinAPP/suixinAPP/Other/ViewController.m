//
//  ViewController.m
//  suixinAPP
//
//  Created by 刘殿武 on 2017/3/7.
//  Copyright © 2017年 YGTechnology. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController ()
@property(strong,nonatomic)WKWebView * webview;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //********************商城主页,加载HTML5完成
//    if (self.webview == nil) {
//        
//        self.webview = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0,SCREENWIDTH, SCREENHEIGHT)];
//        
//        [_webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.suixinweb.com/"]]];
//        
//    }
//
//    
//      [self.view addSubview:_webview];
//

    
    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{


 



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
