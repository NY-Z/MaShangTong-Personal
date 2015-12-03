//
//  BaseNavViewController.h
//  MaShangTong
//
//  Created by niliu1h  on 15/10/15.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNavViewController : UINavigationController

- (void)addNavTitle:(NSString *)title andTitleColor:(UIColor *)color;

- (void)changeNavigationBarTintColorWithColor:(UIColor *)color;

@end
