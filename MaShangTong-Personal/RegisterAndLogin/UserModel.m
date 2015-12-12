//
//  UserModel.m
//  MaShangTong-Personal
//
//  Created by NY on 15/11/27.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.user_id = [aDecoder decodeObjectForKey:@"user_id"];
        self.user_name = [aDecoder decodeObjectForKey:@"user_name"];
        self.money = [aDecoder decodeObjectForKey:@"money"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.user_id forKey:@"user_id"];
    [aCoder encodeObject:self.user_name forKey:@"user_name"];
    [aCoder encodeObject:self.money forKey:@"money"];
}

@end
/*
 @property (nonatomic,strong) NSString <Optional> *mobile;
 @property (nonatomic,strong) NSString <Optional> *user_id;
 @property (nonatomic,strong) NSString <Optional> *user_name;
 @property (nonatomic,strong) NSString <Optional> *money;
 */