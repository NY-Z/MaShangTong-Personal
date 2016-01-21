//
//  personOrderModel.h
//  MaShangTong
//
//  Created by q on 15/12/16.
//  Copyright © 2015年 NY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface personOrderModel : NSObject

@property (nonatomic,strong) NSString  *user_id;
@property (nonatomic,strong) NSString  *mobile_phone;
@property (nonatomic,strong) NSString  *reservation_time;
@property (nonatomic,strong) NSString  *origin_name;
@property (nonatomic,strong) NSString  *origin_coordinates;
@property (nonatomic,strong) NSString  *end_name;
@property (nonatomic,strong) NSString  *end_coordinates;
@property (nonatomic,strong) NSString  *reservation_type;
@property (nonatomic,strong) NSString  *duration_times;
@property (nonatomic,strong) NSString  *car_type_id;
@property (nonatomic,strong) NSString  *leave_message;
@property (nonatomic,strong) NSString  *reserva_type;


+(NSDictionary *)getDictionaryWith:(personOrderModel *)person;


@end
