//
//  NYMyTripsModel.h
//  MaShangTong-Personal
//
//  Created by apple on 15/12/18.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface NYMyTripsModel : JSONModel

@property (nonatomic,strong) NSString <Optional> *car_type_id;
@property (nonatomic,strong) NSString <Optional> *carbon_emission;
@property (nonatomic,strong) NSString <Optional> *end_name;
@property (nonatomic,strong) NSString <Optional> *origin_name;
@property (nonatomic,strong) NSString <Optional> *route_id;
@property (nonatomic,strong) NSString <Optional> *trip_distance;
@property (nonatomic,strong) NSString <Optional> *reserva_type;

@end
