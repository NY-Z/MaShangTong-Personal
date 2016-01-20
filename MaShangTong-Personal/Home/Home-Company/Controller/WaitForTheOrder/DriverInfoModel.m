//
//  DriverInfoModel.m
//  MaShangTong-Personal
//
//  Created by apple on 15/12/17.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "DriverInfoModel.h"

@implementation DriverInfoModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.create_time = [aDecoder decodeObjectForKey:@"create_time"];
        self.driver_id = [aDecoder decodeObjectForKey:@"driver_id"];
        self.end_coordinates = [aDecoder decodeObjectForKey:@"end_coordinates"];
        self.end_name = [aDecoder decodeObjectForKey:@"end_name"];
        self.license_plate = [aDecoder decodeObjectForKey:@"license_plate"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.num = [aDecoder decodeObjectForKey:@"num"];
        self.origin_coordinates = [aDecoder decodeObjectForKey:@"origin_coordinates"];
        self.origin_name = [aDecoder decodeObjectForKey:@"origin_name"];
        self.owner_name = [aDecoder decodeObjectForKey:@"owner_name"];
        self.averagePoint = [aDecoder decodeObjectForKey:@"averagePoint"];
        self.head_image = [aDecoder decodeObjectForKey:@"head_image"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.create_time forKey:@"create_time"];
    [aCoder encodeObject:self.driver_id forKey:@"driver_id"];
    [aCoder encodeObject:self.end_coordinates forKey:@"end_coordinates"];
    [aCoder encodeObject:self.end_name forKey:@"end_name"];
    [aCoder encodeObject:self.license_plate forKey:@"license_plate"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.num forKey:@"num"];
    [aCoder encodeObject:self.origin_coordinates forKey:@"origin_coordinates"];
    [aCoder encodeObject:self.origin_name forKey:@"origin_name"];
    [aCoder encodeObject:self.owner_name forKey:@"owner_name"];
    [aCoder encodeObject:self.averagePoint forKey:@"averagePoint"];
    [aCoder encodeObject:self.head_image forKey:@"head_image"];
}

@end
