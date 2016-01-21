//
//  personOrderModel.m
//  MaShangTong
//
//  Created by q on 15/12/16.
//  Copyright © 2015年 NY. All rights reserved.
//

#import "personOrderModel.h"

@implementation personOrderModel

+(NSDictionary *)getDictionaryWith:(personOrderModel *)person
{
    if (!person.duration_times) {
        person.duration_times = @"";
    }
    if (!person.leave_message) {
        person.leave_message = @"";
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjects: @[person.user_id,person.mobile_phone,person.reservation_time,
                                                               person.origin_name,person.origin_coordinates,person.end_name,person.end_coordinates,
                                                               person.reservation_type,person.duration_times,
                                                               person.car_type_id,person.leave_message,person.reserva_type]
                                                    forKeys:@[@"user_id",@"mobile_phone",@"reservation_time",
                                                              @"origin_name",@"origin_coordinates",@"end_name",@"end_coordinates",
                                                              @"reservation_type",@"duration_times",
                                                              @"car_type_id",@"leave_message",@"reserva_type"]];
    
    return dic;
}

@end
