//
//  AppDelegate.h
//  MaShangTong-Personal
//
//  Created by jeaner on 15/11/10.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ValuationRuleModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

//微信支付类型
typedef enum{
    NonePayed,//都没有支付
    RechargePayed,//充值
    Payed,//支付
    Buyed//购买套餐
}weChatPayed;

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,assign) CLLocationCoordinate2D sourceCoordinate;

@property (nonatomic,assign) CLLocationCoordinate2D destinationCoordinate;

@property (nonatomic,strong) NSString *currentCity;

// 计价规则
@property (nonatomic,strong) ValuationRuleModel *model1;

@property (nonatomic,strong) ValuationRuleModel *model2;

@property (nonatomic,strong) ValuationRuleModel *model3;

@property (nonatomic,strong) NSArray *valuationRuleArr;

// 实际行驶距离
@property (nonatomic,assign) NSInteger actualDistance;

// 用户的位置
@property (nonatomic,assign) CLLocationCoordinate2D passengerCoordinate;

@property (nonatomic,strong) NSString *payMoney;
//微信支付付的钱
@property (nonatomic,strong) NSString *paymoney;

@property (nonatomic,assign)weChatPayed weChatPayType;

@end

