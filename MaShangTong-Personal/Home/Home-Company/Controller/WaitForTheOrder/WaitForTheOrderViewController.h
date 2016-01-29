//
//  WaitForTheOrderViewController.h
//  MaShangTong-Personal
//
//  Created by NY on 15/11/26.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PassengerMessageModel;
@class ValuationRuleModel;
@class CharteredBusRule;
@class AirportPickupModel;

typedef NS_ENUM (NSInteger,DriverState) {
    DriverStateNone,
    DriverStateOrderReceive = 1,
    DriverStateReachAppointment,
    DriverStateBeginCharge,
    DriverStateArriveDestination,
    DriverStatePayOver,
    DriverStateComplete,
};

typedef NS_ENUM(NSInteger,ReservationType) {
    ReservationTypeSpecialCar,
    ReservationTypeCharteredBus,
    ReservationTypeAirportPickUp,
    ReservationTypeAirportDropOff,
};

typedef enum{
    NotExit,//没有退出程序
    HadExit//退出程序重新进来
}IsHadExit;

@interface WaitForTheOrderViewController : UIViewController

@property (nonatomic,strong) PassengerMessageModel *model;
@property (nonatomic,strong) NSString *route_id;
@property (nonatomic,assign) DriverState driverState;
@property (nonatomic,assign) CLLocationCoordinate2D passengerCoordinate;


@property (nonatomic,strong) ValuationRuleModel *specialCarRuleModel;
@property (nonatomic,strong) CharteredBusRule *charteredBusRule;
@property (nonatomic,strong) AirportPickupModel *airportModel;
@property (nonatomic,assign) ReservationType type;


@property (nonatomic,strong) NSString *gonePrice;
@property (nonatomic,assign) BOOL HaveOrder;

//是否退出程序
@property (nonatomic,assign) IsHadExit isHadExit;
//退出程序之前的低速时间
@property (nonatomic,strong) NSString *low_time;
//退出之前行驶的距离
@property (nonatomic,strong) NSString *mileage;
//开始计费的时间（时间戳）
@property (nonatomic,strong) NSString *boardingTime;
@end
