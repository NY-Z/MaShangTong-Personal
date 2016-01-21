//
//  HomeViewController.h
//  MaShangTong
//
//  Created by niliu1h  on 15/10/15.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapSearchKit/AMapSearchObj.h>

@class PersonCenterViewController;

@class searchViewC;
@class CallCarView;

@class AMapSearchAPI;
@class AMapInputTipsSearchRequest;

@class personOrderModel;
@class GSPriceRuleModel;

@interface HomeViewController : UIViewController

//实例化一个反地理编码的对象，获取地理详细位置
@property (nonatomic,strong) CLGeocoder *geocoder;
//实例化一个收索的对象，获取收索位置的经纬度
@property (nonatomic,strong) AMapSearchAPI *search;
//实例化一个收缩结果的对象
@property (nonatomic,strong) AMapInputTipsSearchRequest *request;
//实例化一个路线收索的对象
@property (nonatomic,strong) AMapDrivingRouteSearchRequest *driveSearch;

@property (nonatomic,strong) CallCarView *callCarView;
@property (nonatomic,strong) searchViewC *searchVC;

@property (nonatomic,strong) void(^reloadSearchTableView)();

@property (nonatomic,strong) personOrderModel *personModel;
@property (nonatomic,strong) GSPriceRuleModel *priceRuleModel;

@property (nonatomic,strong) CLLocation *location;


@end

