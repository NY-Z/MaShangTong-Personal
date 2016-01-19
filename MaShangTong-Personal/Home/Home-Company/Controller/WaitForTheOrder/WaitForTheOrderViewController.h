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

@interface WaitForTheOrderViewController : UIViewController

@property (nonatomic,strong) PassengerMessageModel *model;
@property (nonatomic,strong) NSString *route_id;
@property (nonatomic,assign) DriverState driverState;
@property (nonatomic,assign) CLLocationCoordinate2D passengerCoordinate;


@property (nonatomic,strong) ValuationRuleModel *specialCarRuleModel;
@property (nonatomic,strong) CharteredBusRule *charteredBusRule;
@property (nonatomic,strong) AirportPickupModel *airportModel;
@property (nonatomic,assign) ReservationType type;

@end
