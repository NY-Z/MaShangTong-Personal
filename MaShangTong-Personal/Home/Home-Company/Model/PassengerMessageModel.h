//
//  PassengerMessageModel.h
//  MaShangTong-Personal
//
//  Created by NY on 15/11/26.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface PassengerMessageModel : JSONModel

@property (nonatomic,strong) NSString <Optional> *user_id;
@property (nonatomic,strong) NSString <Optional> *mobile_phone;
@property (nonatomic,strong) NSString <Optional> *reservation_time;
@property (nonatomic,strong) NSString <Optional> *origin_name;
@property (nonatomic,strong) NSString <Optional> *origin_coordinates;
@property (nonatomic,strong) NSString <Optional> *end_name;
@property (nonatomic,strong) NSString <Optional> *end_coordinates;
@property (nonatomic,strong) NSString <Optional> *reservation_type;
@property (nonatomic,strong) NSString <Optional> *car_type_id;
@property (nonatomic,strong) NSString <Optional> *leave_message;
@property (nonatomic,strong) NSString <Optional> *reserva_type;
@property (nonatomic,strong) NSString <Optional> *create_time;
@property (nonatomic,strong) NSString <Optional> *driver_id;
@property (nonatomic,strong) NSString <Optional> *order_sn;
@property (nonatomic,strong) NSString <Optional> *orders_time;
@property (nonatomic,strong) NSString <Optional> *route_id;

@end
// user_id
// mobile_phone
// reservation_time
// origin_name
// origin_coordinates
// end_name
// end_coordinates
// reservation_type
// car_type_id
// leave_message
// reserva_type
