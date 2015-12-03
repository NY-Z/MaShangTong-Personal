//
//  AirPortViewController.h
//  MaShangTong
//
//  Created by niliu1h  on 15/10/21.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AirPortViewControllerType) {
    AirPortViewControllerTypePickUp = 0,
    AirPortViewControllerTypeDropOff
};

@interface AirPortViewController : UIViewController

@property (nonatomic,assign) AirPortViewControllerType type;

@end
