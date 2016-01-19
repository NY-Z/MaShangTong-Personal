//
//  AirportDropOffViewController.h
//  MaShangTong
//
//  Created by niliu1h  on 15/10/19.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AirportPickupModel;
@class PassengerMessageModel;

@interface AirportDropOffViewController : UIViewController

@property (nonatomic,strong) void (^sourceBtnBlock) ();
@property (nonatomic,strong) void (^destinationBlock) ();
@property (nonatomic,strong) void (^timeBtnBlock) ();
@property (nonatomic,strong) void (^confirmBtnBlock) (PassengerMessageModel *model,NSString *route_id,AirportPickupModel *airportModel);
@property (nonatomic,strong) void (^priceLabelBlock) (NSDictionary *ruleDic);

@property (nonatomic,strong) UIButton *timeBtn;
@property (nonatomic,strong) UIButton *sourceBtn;
@property (nonatomic,strong) UIButton *destinationBtn;

@end
