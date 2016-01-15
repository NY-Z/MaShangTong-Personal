//
//  RuleViewController.h
//  MaShangTong
//
//  Created by niliu1h  on 15/10/17.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, Type) {
    TypeSpecialCar,
    TypeCharteredBus,
    TypeAirportPickup,
    TypeAirportDropoff
};

@interface RuleViewController : UIViewController

@property (nonatomic,copy) NSString *car_type; // 车型
@property (nonatomic,copy) NSString *step;          // 起步价
@property (nonatomic,copy) NSString *mileage;       // 10km以内里程费
@property (nonatomic,copy) NSString *long_mileage;  // 10km以外里程费
@property (nonatomic,assign) CGFloat distance;      // 距离
@property (nonatomic,assign) Type type;

@end
