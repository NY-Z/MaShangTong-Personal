//
//  EstimateViewController.h
//  MaShangTong
//
//  Created by niliu1h  on 15/10/17.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RuleType) {
    RuleTypeSpecialCar,
    RuleTypeCharteredBus,
    RuleTypeAirportPickup,
    RuleTypeAirportDropoff
};

@interface EstimateViewController : UIViewController

//@property (nonatomic,copy) NSString *estimatePrice;
//@property (nonatomic,copy) NSString *step;
//@property (nonatomic,assign) CGFloat distnce;

@property (nonatomic,strong) NSDictionary *estimateDic;

@property (nonatomic,strong) void (^ruleLabelClick) (NSArray *ruleArr);

@property (nonatomic,assign) RuleType type;

@end

