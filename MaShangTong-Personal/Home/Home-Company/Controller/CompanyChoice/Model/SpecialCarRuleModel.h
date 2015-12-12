//
//  SpecialCarRuleModel.h
//  MaShangTong-Personal
//
//  Created by apple on 15/12/12.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SpecialCarRuleModel : JSONModel

@property (nonatomic,strong) NSString <Optional> *car_type_id;
@property (nonatomic,strong) NSString <Optional> *long_mileage;
@property (nonatomic,strong) NSString <Optional> *low_speed;
@property (nonatomic,strong) NSString <Optional> *mileage;
@property (nonatomic,strong) NSString <Optional> *night;
@property (nonatomic,strong) NSString <Optional> *rule_type;
@property (nonatomic,strong) NSString <Optional> *step;

@end
