//
//  WaitForTheOrderViewController.h
//  MaShangTong-Personal
//
//  Created by NY on 15/11/26.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassengerMessageModel.h"

typedef NS_ENUM (NSInteger,DriverState) {
    DriverStateNone,
    DriverStateOrderReceive = 1,
    DriverStateReachAppointment,
    DriverStateBeginCharge,
    DriverStateArriveDestination,
    DriverStatePayOver,
    DriverStateComplete,
};

@interface WaitForTheOrderViewController : UIViewController

@property (nonatomic,strong) PassengerMessageModel *model;
@property (nonatomic,strong) NSString *route_id;
@property (nonatomic,assign) DriverState driverState;
@property (nonatomic,assign) CLLocationCoordinate2D passengerCoordinate;

@end
