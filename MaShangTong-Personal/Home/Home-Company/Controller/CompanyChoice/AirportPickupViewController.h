//
//  AirportPickupViewController.h
//  MaShangTong
//
//  Created by niliu1h  on 15/10/19.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassengerMessageModel.h"

@class AirportPickupModel;

@interface AirportPickupViewController : UIViewController

@property (nonatomic,strong) void (^flightBtnBlock) ();
@property (nonatomic,strong) void (^timeBtnBlock) ();
@property (nonatomic,strong) void (^destinationBtnBlock) ();
@property (nonatomic,strong) void (^sourceBtnBlock) ();
@property (nonatomic,strong) void (^addressBtnBlock) ();
@property (nonatomic,strong) void (^confirmBtnBlock) (PassengerMessageModel *model,NSString *route_id,AirportPickupModel *airportModel);

// Test
//@property (nonatomic,strong) UIButton *sourceBtn;

@property (nonatomic,strong) UIButton *timeBtn;
@property (nonatomic,strong) UIButton *destinationBtn;
@property (nonatomic,strong) UIButton *flightBtn;

@end
