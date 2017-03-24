//
//  SelectCityTableViewController.h
//  suixinAPP
//
//  Created by 刘殿武 on 2017/3/23.
//  Copyright © 2017年 YGTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YGCitySelectVCDelegate <NSObject>

- (void)cityDidSelectWithCityName:(NSString *)cityName;

@end
@interface SelectCityTableViewController : UITableViewController

@property (nonatomic, weak) id<YGCitySelectVCDelegate> delegate;
@end
