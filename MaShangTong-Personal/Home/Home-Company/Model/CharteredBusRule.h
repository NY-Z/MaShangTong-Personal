//
//  CharteredBusRule.h
//  MaShangTong-Personal
//
//  Created by apple on 15/12/7.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CharteredBusRule : JSONModel

@property (nonatomic,strong) NSString <Optional> *car_type_id;
@property (nonatomic,strong) NSString <Optional> *once_price;
@property (nonatomic,strong) NSString <Optional> *rule_type;
@property (nonatomic,strong) NSString <Optional> *times;
@property (nonatomic,strong) NSString <Optional> *contain_mileage;
@property (nonatomic,strong) NSString <Optional> *over_mileage_money;
@property (nonatomic,strong) NSString <Optional> *over_time_money;

@end
