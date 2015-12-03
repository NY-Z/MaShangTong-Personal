//
//  LoginViewController.h
//  MaShangTong
//
//  Created by niliu1h  on 15/10/15.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger,LoginType) {
    LoginTypePerson,
    LoginTypeCompany,
};

@interface LoginViewController : UIViewController

@property (nonatomic,assign) LoginType type;

@end
