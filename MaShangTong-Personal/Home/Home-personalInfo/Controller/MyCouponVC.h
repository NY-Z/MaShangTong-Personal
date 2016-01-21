//
//  MyCouponVC.h
//  MaShangTong
//
//  Created by q on 15/12/14.
//  Copyright © 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCouponVC : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy) NSArray *dataAry;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
