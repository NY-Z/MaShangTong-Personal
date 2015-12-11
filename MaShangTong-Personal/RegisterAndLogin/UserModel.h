//
//  UserModel.h
//  MaShangTong-Personal
//
//  Created by NY on 15/11/27.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface UserModel : JSONModel

@property (nonatomic,strong) NSString <Optional> *mobile;
@property (nonatomic,strong) NSString <Optional> *user_id;
@property (nonatomic,strong) NSString <Optional> *user_name;
@property (nonatomic,strong) NSString <Optional> *money;

@end
