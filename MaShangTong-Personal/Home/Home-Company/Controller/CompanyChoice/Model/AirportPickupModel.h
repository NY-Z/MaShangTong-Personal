//
//  AirportPickupModel.h
//  MaShangTong-Personal
//
//  Created by apple on 15/12/13.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface AirportPickupModel : JSONModel

@property (nonatomic,strong) NSString <Optional> *airport_name;
@property (nonatomic,strong) NSString <Optional> *car_type_id;
@property (nonatomic,strong) NSString <Optional> *rule_type;
@property (nonatomic,strong) NSString <Optional> *once_price;

@end
