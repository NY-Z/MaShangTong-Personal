//
//  NYCommentViewController.h
//  MaShangTong-Personal
//
//  Created by NY on 15/12/31.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DriverInfoModel;

@interface NYCommentViewController : UIViewController

@property (nonatomic,strong) DriverInfoModel *driverInfoModel;
@property (nonatomic,strong) NSString *route_id;

@end
