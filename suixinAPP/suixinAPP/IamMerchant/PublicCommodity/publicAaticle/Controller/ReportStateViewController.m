//
//  ReportStateViewController.m
//  MyFamily
//
//  Created by 陆洋 on 15/7/3.
//  Copyright (c) 2015年 maili. All rights reserved.
//

#import "ReportStateViewController.h"
#import "UITableView+Improve.h"
#import "UIImage+ReSize.h"
#import "HeaderContent.h"
#import "ImagePickerChooseView.h"
#import "AGImagePickerController.h"
#import "ShowImageViewController.h"
#import "AFNetworking.h"
#import "WhoCanSeeViewController.h"
#import "CommodityPriceTableViewCell.h"
#import "categoryTableViewCell.h"
#import <MBProgressHUD.h>
#import "CommodityDescriptionViewController.h"
#import "SelectCityTableViewController.h"
#import "SelectCommodityCategaryTableViewController.h"
#define MAX_LIMIT_NUMS  60


@interface ReportStateViewController ()<UITextViewDelegate,UIGestureRecognizerDelegate,WhoCanSeeViewControllerDelegate,MBProgressHUDDelegate,YGCitySelectVCDelegate,YGCategarySelectVCDelegate>

@property (nonatomic,weak)UITextView *reportStateTextView;
@property (nonatomic,weak)UILabel *pLabel;
@property (nonatomic,weak)UIButton *addPictureButton;
@property (nonatomic,weak)ImagePickerChooseView *IPCView;
@property (nonatomic,strong)AGImagePickerController *imagePicker;
@property (nonatomic,strong)NSOperationQueue * quene;//多线程
@property (nonatomic,strong)UILabel * textNumLab;
@property (nonatomic,strong)NSString * belongType;
//imagePicker队列
@property (nonatomic,strong)NSMutableArray *imagePickerArray;
@property (nonatomic,strong)WhoCanSeeViewController * whocanseeC;


//@property (nonatomic,strong)CommunityShowDataManger *CSDM;

@property (nonatomic,strong)MBProgressHUD * HUD;

@property (nonatomic,strong)UIView * HUDSuperView;
@property (strong,nonatomic)NSString * cityname ;//城市名
@property (strong,nonatomic)NSString * categaryname ;//类目名

@end

@implementation ReportStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0/255 green:149.0/255 blue:135.0/255 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    [self.tableView improveTableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardDismiss:)];
    tap.delegate = self;
    [self.tableView addGestureRecognizer:tap];
    [self initHeaderView];
    //初始化多线程队列
    self.quene = [[NSOperationQueue alloc]init];
    self.quene.maxConcurrentOperationCount = 3;
    
    self.whocanseeC= [[WhoCanSeeViewController alloc]init];
    
    self.whocanseeC.WhoCanSeeDelegate = self;
    
//    self.CSDM = [CommunityShowDataManger sharedManager];
    [self networkReachabilityBOOL];
    
    
    
}




#define textViewHeight 65
#define pictureHW (screenWidth - 5*padding)/4
#define MaxImageCount 9
#define deleImageWH 25 // 删除按钮的宽高
#pragma mark - 初始化内容输入框 ,图片选择展示框
//大图特别耗内存，不能把大图存在数组里，存类型或者小图
-(void)initHeaderView
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectZero];
    UITextView *reportStateTextView = [[UITextView alloc]initWithFrame:CGRectMake(padding, padding, screenWidth - 2*padding, textViewHeight)];
    reportStateTextView.text = self.reportStateTextView.text;  //防止用户已经输入了文字状态
    reportStateTextView.returnKeyType = UIReturnKeyDone;
    reportStateTextView.font = [UIFont systemFontOfSize:15];
    self.reportStateTextView = reportStateTextView;
    self.reportStateTextView.delegate = self;
    [headView addSubview:reportStateTextView];
    
    UILabel *pLabel = [[UILabel alloc]initWithFrame:CGRectMake(padding+5, 2 * padding, screenWidth, 10)];
    pLabel.text = @"输入商品标题";
    pLabel.hidden = [self.reportStateTextView.text length];
    pLabel.font = [UIFont systemFontOfSize:15];
    pLabel.textColor = [UIColor colorWithRed:152/255.0 green:152/255.0 blue:152/255.0 alpha:1];
    self.pLabel = pLabel;
    [headView addSubview:pLabel];
    
    self.textNumLab = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth - 80, padding + textViewHeight, 50, 20)];
    
    self.textNumLab.backgroundColor = [UIColor clearColor];
    
    self.textNumLab.text = @"0/60";
    self.textNumLab.textColor = [UIColor colorWithRed:152/255.0 green:152/255.0 blue:152/255.0 alpha:1];
    [headView addSubview:self.textNumLab];
    
    NSInteger imageCount = [self.imagePickerArray count];
    for (NSInteger i = 0; i < imageCount; i++) {
        UIImageView *pictureImageView = [[UIImageView alloc]initWithFrame:CGRectMake(padding + (i%4)*(pictureHW+padding),25+ CGRectGetMaxY(reportStateTextView.frame) + padding +(i/4)*(pictureHW+padding), pictureHW, pictureHW)];
        //用作放大图片
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
        [pictureImageView addGestureRecognizer:tap];
        
        //添加删除按钮
        UIButton *dele = [UIButton buttonWithType:UIButtonTypeCustom];
        dele.frame = CGRectMake(pictureHW - deleImageWH + 5, -10, deleImageWH, deleImageWH);
        [dele setImage:[UIImage imageNamed:@"deletePhoto"] forState:UIControlStateNormal];
        [dele addTarget:self action:@selector(deletePic:) forControlEvents:UIControlEventTouchUpInside];
        [pictureImageView addSubview:dele];
        
        pictureImageView.tag = imageTag + i;
        pictureImageView.userInteractionEnabled = YES;
        pictureImageView.image = [UIImage imageWithCGImage:((ALAsset *)[self.imagePickerArray objectAtIndex:i]).thumbnail];
        [headView addSubview:pictureImageView];
    }
    if (imageCount < MaxImageCount) {
        UIButton *addPictureButton = [[UIButton alloc]initWithFrame:CGRectMake(padding + (imageCount%4)*(pictureHW+padding), 25+CGRectGetMaxY(reportStateTextView.frame) + padding +(imageCount/4)*(pictureHW+padding), pictureHW, pictureHW)];
        [addPictureButton setBackgroundImage:[UIImage imageNamed:@"addPictures"] forState:UIControlStateNormal];
        [addPictureButton addTarget:self action:@selector(addPicture) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:addPictureButton];
        self.addPictureButton = addPictureButton;
    }
    
    NSInteger headViewHeight = 25+120 + (10 + pictureHW)*([self.imagePickerArray count]/4 + 1);
    headView.frame = CGRectMake(0, 0, screenWidth, headViewHeight);
    self.tableView.tableHeaderView = headView;
}






//- (void)viewWillAppear:(BOOL)animated
//{
//    
//    NSLog(@"belongType : %@",_belongType);
//    
//    
//    
//}
#pragma mark -初始化上传时的hud,以及其父视图
-(void)initProgressHUDAndSuperView{
    if (_HUDSuperView == nil) {
        
          _HUDSuperView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-280, SCREENWIDTH, 150)];
        _HUDSuperView.backgroundColor = [UIColor whiteColor];
        [self.tableView addSubview:_HUDSuperView];

    }
    
    if (_HUD == nil) {
        
        _HUD = [MBProgressHUD showHUDAddedTo:_HUDSuperView animated:YES];
        _HUD.labelText = @"正在上传,请稍后";
        _HUD.mode = MBProgressHUDModeIndeterminate;
        _HUD.delegate = self;
        
        
    }
    
 
}
-(void)hideHUD:(MBProgressHUD*)hud{


    [hud hide:YES afterDelay:0.8f];
    

}



-(void)hudWasHidden:(MBProgressHUD *)hud{

    [hud removeFromSuperview];
    hud = nil;
    [UIView animateWithDuration:0.5f animations:^{
        
        [_HUDSuperView setBackgroundColor:[UIColor clearColor]];
        
    }completion:^(BOOL finished) {
        
        [_HUDSuperView removeFromSuperview];
        
        _HUDSuperView = nil;
        
    }];

}




#pragma mark - 网络判断


- (BOOL)networkReachabilityBOOL
{
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    
    // 如果没有网络
    if (mgr.networkReachabilityStatus == -1 || mgr.networkReachabilityStatus == 0) {
        
        UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络连接中断,请检查您的网络" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"提示用户检查网络");
        }]];
        
        
        
        [self presentViewController:alertC animated:YES completion:nil];
        
        return NO;
    }else if (mgr.networkReachabilityStatus == 1 || mgr.networkReachabilityStatus == 2) {
        //有网
        return YES;
    }else{
        
        
        return NO;
        
    }
    
    
}




#pragma mark - 上传按钮
- (IBAction)uploadImageToServer:(UIBarButtonItem *)sender {
    //    sender.enabled = NO;
    
    if (self.belongType  == nil) {
        
        self.belongType = [NSString stringWithFormat:@"二次元"];
        
        
        
    }
    NSDictionary * parameters = @{
                                  
                                  @"username" :@"测试用户名lalaall",
                                  @"articleContent": self.reportStateTextView.text,
                                  @"belongType" : self.belongType,
                                  //                                  @"limit":@10
                                  
                                  
                                  };
    
    if ([self networkReachabilityBOOL]) {
        //有网
         [self initProgressHUDAndSuperView];
    
    [self uploadImageWithImageArray:_imagePickerArray WithParameter:parameters];

    }else{
  
//        提示用户检查网络
        UIAlertController * alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络连接中断,请检查您的网络" preferredStyle:UIAlertControllerStyleAlert];
        
        [alertC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"提示用户检查网络");
        }]];
        
        
        
        [self presentViewController:alertC animated:YES completion:nil];
    
    
    }
       
    
    NSLog(@"hahhahaha");
    
}

//  GCD dispatch group   多线程上传多张图片

#pragma mark - 上传内容方法

- (void)uploadImageWithImageArray:(NSArray*)iamgeArray WithParameter:(NSDictionary*)parameter{
    
//    
//    [self.quene addOperationWithBlock:^{
//        
//        [self.CSDM uploadContentWithParameter:parameter withImageArray:iamgeArray withBlock:^(NSNumber *request) {
//            
//            [self hideHUD:_HUD];
//            
//            if ([request isEqualToNumber:@1]) {
//                NSLog(@"########上传成功##########");
//                UIAlertController * alertViewController = [UIAlertController alertControllerWithTitle:@"上传成功" message:@"上传成功了,是否返回主页进行查看" preferredStyle:UIAlertControllerStyleAlert];
//                
//                [alertViewController addAction:[UIAlertAction actionWithTitle:@"去首页" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    
//                    NSLog(@"去首页");
//                    
//                    
//                    [self.navigationController popViewControllerAnimated:YES];
//
//                }]];
//
//                [self presentViewController:alertViewController animated:YES completion:nil];
//
//            }else{
//            //保存草稿
//                
//                
//                
//                UIAlertController * alertViewController = [UIAlertController alertControllerWithTitle:@"上传失败" message:@"上传失败了,请稍后再试" preferredStyle:UIAlertControllerStyleAlert];
//                
//                [alertViewController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    
//                    NSLog(@"去首页");
//                    
//                    
//                    [self.navigationController popViewControllerAnimated:YES];
//                    
//                }]];
//                
//                [self presentViewController:alertViewController animated:YES completion:nil];
//            
//            
//            
//            
//            
//            }
//  
//        }];
//        
//    }];
    
}



#pragma mark - addPicture
-(void)addPicture
{
    if ([self.reportStateTextView isFirstResponder]) {
        [self.reportStateTextView resignFirstResponder];
    }
    self.tableView.scrollEnabled = NO;
    [self initImagePickerChooseView];
}




#pragma mark - gesture method
-(void)tapImageView:(UITapGestureRecognizer *)tap
{
    self.navigationController.navigationBarHidden = YES;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"show" bundle:[NSBundle mainBundle]];
    ShowImageViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ShowImage"];
    vc.clickTag = tap.view.tag;
    vc.imageViews = self.imagePickerArray;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - keyboard method
-(void)keyboardDismiss:(UITapGestureRecognizer *)tap
{
    [self.reportStateTextView resignFirstResponder];
}

#pragma mark -  删除图片
-(void)deletePic:(UIButton *)btn
{
    if ([(UIButton *)btn.superview isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)(UIButton *)btn.superview;
        [self.imagePickerArray removeObjectAtIndex:(imageView.tag - imageTag)];
        [imageView removeFromSuperview];
    }
    [self initHeaderView];
}

#define IPCViewHeight 120
#pragma mark - 初始化图片选择界面
-(void)initImagePickerChooseView
{
    ImagePickerChooseView *IPCView = [[ImagePickerChooseView alloc]initWithFrame:CGRectMake(0, screenHeight - 64, screenWidth, IPCViewHeight) andAboveView:self.view];
    //IPCView.frame = CGRectMake(0, screenHeight - IPCViewHeight - 64, screenWidth, IPCViewHeight);
    [IPCView setImagePickerBlock:^{
        self.imagePicker = [[AGImagePickerController alloc] initWithFailureBlock:^(NSError *error) {
            
            if (error == nil)
            {
                [self dismissViewControllerAnimated:YES completion:^{}];
                [self.IPCView disappear];
            } else
            {
                NSLog(@"Error: %@", error);
                
                // Wait for the view controller to show first and hide it after that
                double delayInSeconds = 0.5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self dismissViewControllerAnimated:YES completion:^{}];
                });
            }
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            
        } andSuccessBlock:^(NSArray *info) {
            [self.imagePickerArray addObjectsFromArray:info];
            [self dismissViewControllerAnimated:YES completion:^{}];
            [self.IPCView disappear];
            [self initHeaderView];
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        }];
        
        self.imagePicker.maximumNumberOfPhotosToBeSelected = 9 - [self.imagePickerArray count];
        
        [self presentViewController:self.imagePicker animated:YES completion:^{}];
    }];
    [UIView animateWithDuration:0.25f animations:^{
        IPCView.frame = CGRectMake(0, screenHeight - IPCViewHeight-64, screenWidth, IPCViewHeight);
    } completion:^(BOOL finished) {
    }];
    [self.view addSubview:IPCView];
    self.IPCView = IPCView;
    
    //不能添加约束，因为会导致frame暂时为0，后面的tableview cellfor......不会执行
    //添加约束
    /*self.IPCView.translatesAutoresizingMaskIntoConstraints = NO;
     NSArray *IPCViewConstraintH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_IPCView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_IPCView)];
     [self.view addConstraints:IPCViewConstraintH];
     
     NSArray *IPCViewConstraintV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_IPCView(60)]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_IPCView)];
     [self.view addConstraints:IPCViewConstraintV];*/
    
    [self.IPCView addImagePickerChooseView];
}


-(NSMutableArray *)imagePickerArray
{
    if (!_imagePickerArray) {
        _imagePickerArray = [[NSMutableArray alloc]init];
    }
    return _imagePickerArray;
}



#pragma mark - UIGesture Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

#pragma mark - Text View Delegate
-(void)textViewDidChange:(UITextView *)textView
{
    self.pLabel.hidden = [textView.text length];
    
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
    
    //不让显示负数 口口日
    self.textNumLab.text = [NSString stringWithFormat:@"%d/%d",MAX(0,MAX_LIMIT_NUMS - existTextNum),MAX_LIMIT_NUMS];
    
    
    
}

#pragma mark - 添加字数限制
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //回车换行 结束
    if ([@"\n" isEqualToString:text])
    {
        if ([self.reportStateTextView.text length]) {
            [self.reportStateTextView resignFirstResponder];
        }
        else
        {
            return NO;
        }
    }
    //    return YES;
    
    
    
    
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < MAX_LIMIT_NUMS) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }
            else
            {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                          
                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break，提高效率
                                              return ;
                                          }
                                          
                                          trimString = [trimString stringByAppendingString:substring];
                                          
                                          idx++;
                                      }];
                
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
            self.textNumLab.text = [NSString stringWithFormat:@"%d/%ld",0,(long)MAX_LIMIT_NUMS];
        }
        return NO;
    }
}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }else if (section ==1)
    {
    
    return 3;
    
    }else{
    
        return 2;
    
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell1 = [[UITableViewCell alloc]init];

    if (indexPath.section == 1) {

        if (indexPath.row == 0) {
            
            
//            cell1 = [tableView dequeueReusableCellWithIdentifier:@"CommodityPriceTableViewCell"];
//            if (cell1 == nil) {
                NSArray * cellArr = [[NSBundle mainBundle]loadNibNamed:@"CommodityPriceTableViewCell" owner:self options:nil];
                CommodityPriceTableViewCell * ccell = cellArr[0];
            
                ccell.LabelName.text = @"价格";
            
                
                cell1 = ccell;
                
//                [tableView registerNib:[UINib nibWithNibName:@"CommodityPriceTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CommodityPriceTableViewCell"];
                
//            }
            

            
            
            
        }else if (indexPath.row == 1){
        
//            cell1 = [tableView dequeueReusableCellWithIdentifier:@"CommodityPriceTableViewCell"];
//            if (cell1 == nil) {
                NSArray * cellArr = [[NSBundle mainBundle]loadNibNamed:@"CommodityPriceTableViewCell" owner:self options:nil];
                CommodityPriceTableViewCell * ccell = cellArr[0];
                ccell.LabelName.text = @"库存";
                
                cell1 = ccell;
//                
//                [tableView registerNib:[UINib nibWithNibName:@"CommodityPriceTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CommodityPriceTableViewCell"];
                
//            }
            

        
        
        }else if (indexPath.row == 2){
        
        
//            cell1 = [tableView dequeueReusableCellWithIdentifier:@"CommodityPriceTableViewCell"];
//            if (cell1 == nil) {
                NSArray * cellArr = [[NSBundle mainBundle]loadNibNamed:@"CommodityPriceTableViewCell" owner:self options:nil];
                CommodityPriceTableViewCell * ccell = cellArr[0];
                ccell.LabelName.text = @"运费";
                
                cell1 = ccell;
//                
//                [tableView registerNib:[UINib nibWithNibName:@"CommodityPriceTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CommodityPriceTableViewCell"];
                
//            }
            

        
        
        }
       
        
        
        
    }
    else if(indexPath.section == 0)
    {
      
//        cell1 = [tableView dequeueReusableCellWithIdentifier:@"categoryTableViewCell"];
//        if (cell1 == nil) {
            NSArray * cellArr = [[NSBundle mainBundle]loadNibNamed:@"categoryTableViewCell" owner:self options:nil];
            categoryTableViewCell * cells =cellArr[0];
            cells.LabelName.text = @"类目";
        if (_categaryname == nil) {
            
            cells.discription.text = @"";
        }else{
            cells.discription.text = _categaryname;
        
        }
            cell1 = cells;
        
        
            
//            [tableView registerNib:[UINib nibWithNibName:@"categoryTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"categoryTableViewCell"];
//            
//        }
        
     
    } else if(indexPath.section == 2){
    
    
        if (indexPath.row == 0) {
            
       
    
    
//        cell1 = [tableView dequeueReusableCellWithIdentifier:@"categoryTableViewCell"];
//        if (cell1 == nil) {
            NSArray * cellArr = [[NSBundle mainBundle]loadNibNamed:@"categoryTableViewCell" owner:self options:nil];
            
        categoryTableViewCell * cells =cellArr[0];
        cells.LabelName.text = @"商品描述";
            cells.LabelName.adjustsFontSizeToFitWidth = YES;
        cells.discription.text = @"";
        cell1 = cells;

        
//            [tableView registerNib:[UINib nibWithNibName:@"categoryTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"categoryTableViewCell"];
//            
//        }

    
        }else if (indexPath.row == 1){
        
            NSArray * cellArr = [[NSBundle mainBundle]loadNibNamed:@"categoryTableViewCell" owner:self options:nil];
            
            categoryTableViewCell * cells =cellArr[0];
            cells.LabelName.text = @"发货地";
            cells.LabelName.adjustsFontSizeToFitWidth = YES;
            if (_cityname == nil) {
                cells.discription.text = @"";
            }else{
            cells.discription.text = _cityname;
            }

            cell1 = cells;

        
        
        }
    
    
    
    
    
    }

    
    
    return cell1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 5;
    }
    else
    {
        return 5;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0)
    {//类目界面
        [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中状态

        SelectCommodityCategaryTableViewController * vc = [[SelectCommodityCategaryTableViewController alloc]init];
        vc.delegate = self;
        
        [self presentViewController:vc animated:YES completion:nil];
        
    } else if(indexPath.section == 2){
        
        
        if (indexPath.row == 0) {
            //描述界面
            [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中状态

            CommodityDescriptionViewController * vc = [[CommodityDescriptionViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
            
            
            
        }else if (indexPath.row == 1){
            //发货地
            [tableView deselectRowAtIndexPath:indexPath animated:YES];//取消选中状态
            
            SelectCityTableViewController * vc = [[SelectCityTableViewController alloc]init];
            
            vc.delegate = self;
            
             [self presentViewController:vc animated:YES completion:nil];
       
        }
    
    }
 
    }

#pragma mark selectcity 代理

- (void)cityDidSelectWithCityName:(NSString *)cityName
{
//    UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//    
//    categoryTableViewCell * cells = (categoryTableViewCell*)cell;
//    
//    cells.discription.text = cityName;
//    
//    cell = cells;
    _cityname = cityName;
    

    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:2];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
        NSLog(@"cityname : %@",cityName);


}

#pragma mark 商品类目 代理

- (void)CategaryDidSelectWithCategaryName:(NSString *)CategaryName{


    _categaryname = CategaryName;
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
   
    
    NSLog(@"cityname : %@",CategaryName);


}
- (NSString *)categaryname{
    if (_categaryname == nil) {
        _categaryname = [NSString string];
    }
    return _categaryname;
}
- (NSString *)cityname{
    if (_cityname == nil) {
        _cityname = [NSString string];
    }
    return _cityname;

}


@end
