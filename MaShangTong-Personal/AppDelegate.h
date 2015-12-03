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
#import "UserModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,assign) CLLocationCoordinate2D sourceCoordinate;

@property (nonatomic,assign) CLLocationCoordinate2D destinationCoordinate;

@property (nonatomic,strong) NSString *currentCity;

@property (nonatomic,strong) ValuationRuleModel *model1;

@property (nonatomic,strong) ValuationRuleModel *model2;

@property (nonatomic,strong) ValuationRuleModel *model3;

@property (nonatomic,strong) NSArray *valuationRuleArr;

@property (nonatomic,strong) UserModel *userModel;

@property (nonatomic,assign) NSInteger actualDistance;

@end

