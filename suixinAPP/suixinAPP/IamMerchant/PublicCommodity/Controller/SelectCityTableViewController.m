//
//  SelectCityTableViewController.m
//  suixinAPP
//
//  Created by 刘殿武 on 2017/3/23.
//  Copyright © 2017年 YGTechnology. All rights reserved.
//

#import "SelectCityTableViewController.h"

@interface SelectCityTableViewController ()
@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, copy) NSMutableArray *titleMArray;
@property (nonatomic, copy) NSMutableArray *citiesMArry;

@end

@implementation SelectCityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//读取plist 文件
    NSString * filePath = [[NSBundle mainBundle]pathForResource:@"YGCityList" ofType:@"plist"];
    
    NSMutableDictionary * data = [[NSMutableDictionary alloc]initWithContentsOfFile:filePath];;
    
    self.dataArray = data[@"cities"];
    for (NSDictionary * dic in self.dataArray) {
        
        [self.titleMArray addObject:dic[@"initial"]];
        [self.citiesMArry addObject:dic[@"cities"]];
        
        
    }
    
     self.title = @"选择城市";
    
}

- (NSArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)titleMArray
{
    if (_titleMArray == nil) {
        _titleMArray = [NSMutableArray array];
    }
    return _titleMArray;
}

- (NSMutableArray *)citiesMArry
{
    if (_citiesMArry == nil) {
        _citiesMArry = [NSMutableArray array];
    }
    return _citiesMArry;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    

    return _titleMArray.count;
;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray * arr =  _citiesMArry[section];
    
    return arr.count;
}
// 返回每行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

// 设置header的title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _titleMArray[section];
}

// 设置索引
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _titleMArray;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cell_id = @"city_select";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"city_select"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
    }
    NSArray *array = self.citiesMArry[indexPath.section];
    cell.textLabel.text = array[indexPath.row];
    
    return cell;


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
    NSArray *array = self.citiesMArry[indexPath.section];
    NSString *cityName = array[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(cityDidSelectWithCityName:)]) {
        
         [self.delegate cityDidSelectWithCityName:cityName];
        
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
