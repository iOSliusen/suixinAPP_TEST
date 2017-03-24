//
//  SelectCommodityCategaryTableViewController.m
//  suixinAPP
//
//  Created by 刘殿武 on 2017/3/24.
//  Copyright © 2017年 YGTechnology. All rights reserved.
//

#import "SelectCommodityCategaryTableViewController.h"

@interface SelectCommodityCategaryTableViewController ()<UISearchBarDelegate,UISearchResultsUpdating>
@property (copy,nonatomic)NSArray * commodityCategaryDataArray;
//搜索控制器
@property (nonatomic, strong) UISearchController *searchController;

//存放搜索列表中显示数据的数组
@property (strong,nonatomic) NSMutableArray  *searchList;
@end

@implementation SelectCommodityCategaryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadCategaryData];
    
    [self initSearchBar];
    
}
//读取商品类目列表
- (void)loadCategaryData{
    NSError *error=nil;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"taobaoShangpinleimu" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSLog(@"%@",error.localizedDescription);
    self.commodityCategaryDataArray = dic[@"data"];

}

//添加搜索栏
- (void)initSearchBar{

    //初始化UISearchController并为其设置属性
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    //设置代理对象
    _searchController.searchResultsUpdater = self;
    //设置搜索时，背景变暗色            _searchController.dimsBackgroundDuringPresentation = NO;
    //设置搜索时，背景变模糊
    _searchController.obscuresBackgroundDuringPresentation = NO;
    //隐藏导航栏                  _searchController.hidesNavigationBarDuringPresentation = NO;
    //设置搜索框的frame
    _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    //将搜索框设置为tableView的组头
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
 
}





- (NSArray *)commodityCategaryDataArray{

    if (_commodityCategaryDataArray == nil) {
        _commodityCategaryDataArray = [NSArray array];
    }
    return _commodityCategaryDataArray;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //如果searchController被激活就返回搜索数组的行数，否则返回数据数组的行数
    if (self.searchController.active) {
        return [self.searchList count];
    }else{
        return [self.commodityCategaryDataArray count];
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * Identifier = @"commodity_select";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commodity_select"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    //如果搜索框被激活，就显示搜索数组的内容，否则显示数据数组的内容
    if (self.searchController.active) {
        [cell.textLabel setText:self.searchList[indexPath.row]];
    }
    else{
        [cell.textLabel setText:self.commodityCategaryDataArray[indexPath.row]];
    }
    

    return cell;
}
//执行过滤操作
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{


    //获取搜索框中用户输入的字符串
    NSString *searchString = [self.searchController.searchBar text];
    //指定过滤条件，SELF表示要查询集合中对象，contain[c]表示包含字符串，%@是字符串内容
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    //如果搜索数组中存在对象，即上次搜索的结果，则清除这些对象
    if (self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    //通过过滤条件过滤数据
    self.searchList= [NSMutableArray arrayWithArray:[_commodityCategaryDataArray filteredArrayUsingPredicate:preicate]];
    //刷新表格
    [self.tableView reloadData];


}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //进行代理传值
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSString *CategaryName = _commodityCategaryDataArray[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(CategaryDidSelectWithCategaryName:)]) {
        
        [self.delegate CategaryDidSelectWithCategaryName:CategaryName];
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
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
