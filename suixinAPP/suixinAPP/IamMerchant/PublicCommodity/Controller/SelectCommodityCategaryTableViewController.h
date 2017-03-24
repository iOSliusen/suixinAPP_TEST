//
//  SelectCommodityCategaryTableViewController.h
//  suixinAPP
//
//  Created by 刘殿武 on 2017/3/24.
//  Copyright © 2017年 YGTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YGCategarySelectVCDelegate <NSObject>

- (void)CategaryDidSelectWithCategaryName:(NSString *)CategaryName;

@end

@interface SelectCommodityCategaryTableViewController : UITableViewController
@property (nonatomic, weak) id<YGCategarySelectVCDelegate> delegate;

@end
