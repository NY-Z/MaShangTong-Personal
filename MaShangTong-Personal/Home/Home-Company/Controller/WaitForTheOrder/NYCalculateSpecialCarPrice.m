//
//  NYCalculateSpecialCarPrice.m
//  MaShangTong-Personal
//
//  Created by NY on 16/1/13.
//  Copyright © 2016年 jeaner. All rights reserved.
//

#import "NYCalculateSpecialCarPrice.h"

@interface NYCalculateSpecialCarPrice ()

@property (nonatomic,assign) float long_mileage;
@property (nonatomic,assign) float low_speed;
@property (nonatomic,assign) float mileage;
@property (nonatomic,assign) float night;
@property (nonatomic,assign) float step;

@property (nonatomic,strong) NSDateFormatter *formatter;

@property (nonatomic,assign) float distance;
@property (nonatomic,assign) float price;
@property (nonatomic,assign) NSInteger lowSpeedTime;

@end

@implementation NYCalculateSpecialCarPrice

- (NSDateFormatter *)formatter
{
    if (_formatter == nil) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = @"HH";
    }
    return _formatter;
}

+ (instancetype)sharedPrice
{
    static NYCalculateSpecialCarPrice *price = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        price = [[NYCalculateSpecialCarPrice alloc] init];
    });
    return price;
}

- (void)setModel:(ValuationRuleModel *)model
{
    _model = model;
    _long_mileage = [model.long_mileage floatValue];
    _low_speed = [model.low_speed floatValue];
    _mileage = model.mileage.floatValue;
    _night = model.night.floatValue;
    _step = model.step.floatValue;
    
    _price = model.step.floatValue;
}

- (NSArray *)calculatePriceWithParams:(NSDictionary *)params
{
    float speed = [[NSString stringWithFormat:@"%@",params[@"distance"]] floatValue];
    _distance += speed;
    if (speed <= 3.333334) {
        _lowSpeedTime++;
    }
    if (_distance>=10000) {
        _price += _long_mileage/1000;
    } else {
        if ([self isNightDrive]) {
            _price += _night/1000;
        } else {
            if ([self isRushHour]) {
                _price += 1.2/60;
            } else {
                _price += 0.5/60;
            }
        }
    }
    return @[[NSString stringWithFormat:@"%.2f",_distance],[NSString stringWithFormat:@"%ld",_lowSpeedTime],[NSString stringWithFormat:@"%.2f",_price]];
}

// 是否是高峰期
- (BOOL)isRushHour
{
    NSDate *currentDate = [NSDate date];
    NSInteger currentHour = [_formatter stringFromDate:currentDate].integerValue;
    if ((currentHour >= 7&&currentHour < 10) ||(currentHour >= 17&&currentHour < 19)) {
        return YES;
    }
    return NO;
}

// 是否为夜间行驶
- (BOOL)isNightDrive
{
    NSDate *currentDate = [NSDate date];
    NSInteger currentHour = [_formatter stringFromDate:currentDate].integerValue;
    if (currentHour >= 23 && currentHour< 5) {
        return YES;
    }
    return NO;
}

@end
