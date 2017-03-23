



//九阴真经：（代理传值）--适用于从后一个界面跳转到前一个界面过程中
//(1)后一个界面指定协议，声明用来传值的方法
//(2)后一个界面设置代理人，用来存储代理人对象
//(3)前一个界面遵守协议，
//(4)前一个界面来实现对应的协议方法
//(5)将前一个界面对象指定为后一个界面对象的代理人
//(6)后一个界面在相应的时机调用代理人对象去执行相应的操作。



#import "WhoCanSeeViewController.h"
#import "UITableView+Improve.h"
#import "UIImage+ReSize.h"
//#import "ReportStateViewController.h"
@interface WhoCanSeeViewController ()
@property(strong,nonatomic)NSString * belongType;
@end

@implementation WhoCanSeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"要发表到哪个频道呢";
    
    //nav右边发布按钮
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    finishButton.frame = CGRectMake(0, 0, 30, 20);
    [finishButton setTitle:@"完成" forState:normal];
    [finishButton addTarget:self action:@selector(finishWhoCanSee) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *finishButtonItem = [[UIBarButtonItem alloc] initWithCustomView:finishButton];
    self.navigationItem.rightBarButtonItem = finishButtonItem;
    
    [self.tableView improveTableView];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:246.0/255 green:247.0/255 blue:247.0/255 alpha:1]];
    
    self.belongType = [NSString stringWithFormat:@"二次元"];
    
    
}




-(void)finishWhoCanSee
{
    NSLog(@"ssssbelongType : %@",_belongType);
    

    if (self.WhoCanSeeDelegate) {
        if ([self.WhoCanSeeDelegate respondsToSelector:@selector(setBelongTypeValue:)]) {
            
            [self.WhoCanSeeDelegate setBelongTypeValue:_belongType];
        }else
        {
            NSLog(@"代理方法未实现");
        }
        
        
        
    }else{
        
        
        NSLog(@"未设置代理");
        
        
    }
    
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
    
}
- (void)viewDidDisappear:(BOOL)animated{




    [self finishWhoCanSee];




}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    static NSString *CellIdentifier = @"WhoCanSee";
    //
    //
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSArray * arr = [[NSBundle mainBundle]loadNibNamed:@"WhoCanSeeTableViewCell" owner:self options:nil];
    
    UITableViewCell * cell = arr[0];
    
    
    
    
    
    //    if (!cell) {
    //        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    //    }
    cell.detailTextLabel.textColor = [UIColor colorWithRed:152/255.0 green:152/255.0 blue:152/255.0 alpha:1];
    cell.imageView.image = [[UIImage imageNamed:@"choose"] reSizeImagetoSize:CGSizeMake(20, 20)];
    cell.imageView.hidden = YES;
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"二次元";
        cell.detailTextLabel.text = @"人不中二枉少年";
        _belongType = @"二次元";
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"包包";
        cell.detailTextLabel.text = @"网罗天下包包";
        _belongType = @"包包";
    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = @"减肥";
        cell.detailTextLabel.text = @"坚持就是胜利";
        
        _belongType =@"减肥";
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        cell.textLabel.text = @"星座";
        cell.detailTextLabel.text = @"处女座程序员前来报到😭";
        _belongType = @"星座";
        
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView reloadData]; //数据不多，直接reloadData消除已有的勾
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.imageView.hidden = NO;
    
    if (indexPath.row == 0) {
        
        _belongType = @"二次元";
    }
    else if (indexPath.row == 1)
    {
        _belongType = @"包包";
    }
    else if (indexPath.row == 2)
    {
        
        _belongType =@"减肥";
    }
    else
    {
        _belongType = @"星座";
        
        
    }
    
    
}



@end
