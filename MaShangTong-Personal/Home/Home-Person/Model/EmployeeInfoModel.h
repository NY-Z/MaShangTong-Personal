//
//  EmployeeInfoModel.h
//  MaShangTong-Personal
//
//  Created by apple on 15/12/16.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol EmployeeInfoDetailModel;
@interface EmployeeInfoDetailModel : JSONModel

@property (nonatomic,strong) NSString <Optional> *mobile;
@property (nonatomic,strong) NSString <Optional> *pid_name;
@property (nonatomic,strong) NSString <Optional> *user_name;

@end

@interface EmployeeInfoModel : JSONModel

@property (nonatomic,strong) NSArray <Optional,EmployeeInfoDetailModel> *detail;
@property (nonatomic,strong) NSString <Optional> *pid_name;

@end

//{
//data = 1;
//info =     (
//{
//detail =             (
//{
//mobile = 1328311817;
//"pid_name" = "\U7b2c\U4e00\U7ec4";
//"user_name" = "\U65b9\U7ef4o2o";
//}
//);
//"pid_name" = "\U7b2c\U4e00\U7ec4";
//},
//{
//    detail =             (
//                          {
//                              mobile = 1328311810;
//                              "pid_name" = "\U7b2c\U4e8c\U7ec4";
//                              "user_name" = fzmatthew;
//                          },
//                          {
//                              mobile = 1330109634;
//                              "pid_name" = "\U7b2c\U4e8c\U7ec4";
//                              "user_name" = fanwe;
//                          },
//                          {
//                              mobile = 15900627176;
//                              "pid_name" = "\U7b2c\U4e8c\U7ec4";
//                              "user_name" = 0;
//                          }
//                          );
//    "pid_name" = "\U7b2c\U4e8c\U7ec4";
//}
//);
//status = 1;
//}


