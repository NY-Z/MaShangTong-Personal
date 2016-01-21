//
//  settingVC.h
//  MaShangTong
//
//  Created by q on 15/12/12.
//  Copyright © 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GSfeedBackViewController;
@class GSguideVC;
@class contactVC;
@class GSaboutUsVC;

@interface settingVC : UIViewController

@property (nonatomic,strong) UIView  *tempView;


@property (nonatomic,strong) GSfeedBackViewController *feddBackVC;
@property (nonatomic,strong) GSguideVC *guideVC;
@property (nonatomic,strong) contactVC *contactVC;
@property (nonatomic,strong) GSaboutUsVC *aboutUsVC;

@end
