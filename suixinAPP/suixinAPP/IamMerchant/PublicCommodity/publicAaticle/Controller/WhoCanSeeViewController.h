
//九阴真经：（代理传值）--适用于从后一个界面跳转到前一个界面过程中
//(1)后一个界面指定协议，声明用来传值的方法
//(2)后一个界面设置代理人，用来存储代理人对象
//(3)前一个界面遵守协议，
//(4)前一个界面来实现对应的协议方法
//(5)将前一个界面对象指定为后一个界面对象的代理人
//(6)后一个界面在相应的时机调用代理人对象去执行相应的操作。

#import <UIKit/UIKit.h>

@protocol WhoCanSeeViewControllerDelegate;


@interface WhoCanSeeViewController : UITableViewController



@property(weak,nonatomic)id <WhoCanSeeViewControllerDelegate> WhoCanSeeDelegate;//设置代理



@end


@protocol  WhoCanSeeViewControllerDelegate<NSObject>

-(void)setBelongTypeValue:(NSString *)delegateText;

@end

