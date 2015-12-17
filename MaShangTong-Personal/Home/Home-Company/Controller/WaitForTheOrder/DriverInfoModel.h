//
//  DriverInfoModel.h
//  MaShangTong-Personal
//
//  Created by apple on 15/12/17.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DriverInfoModel : JSONModel

@property (nonatomic,strong) NSString <Optional> *create_time;
@property (nonatomic,strong) NSString <Optional> *driver_id;
@property (nonatomic,strong) NSString <Optional> *end_coordinates;
@property (nonatomic,strong) NSString <Optional> *end_name;
@property (nonatomic,strong) NSString <Optional> *license_plate;
@property (nonatomic,strong) NSString <Optional> *mobile;
@property (nonatomic,strong) NSString <Optional> *num;
@property (nonatomic,strong) NSString <Optional> *origin_coordinates;
@property (nonatomic,strong) NSString <Optional> *origin_name;
@property (nonatomic,strong) NSString <Optional> *owner_name;

@end
