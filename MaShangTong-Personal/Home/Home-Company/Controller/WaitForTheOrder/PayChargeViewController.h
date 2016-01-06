//
//  PayChargeViewController.h
//  MaShangTong-Personal
//
//  Created by q on 15/12/2.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActualPriceModel.h"
#import "PassengerMessageModel.h"
#import "DriverInfoModel.h"

@interface PayChargeViewController : UIViewController

//@property (nonatomic,strong) NSArray *detailInfoArr;
@property (nonatomic,strong) ActualPriceModel *actualPriceModel;

@property (nonatomic,strong) PassengerMessageModel *passengerMessageModel;

@property (nonatomic,strong) NSString *route_id;
@property (nonatomic,strong) DriverInfoModel *driverInfoModel;

@end
