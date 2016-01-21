//
//  PersonInfoViewController.h
//  MaShangTong
//
//  Created by niliu1h  on 15/10/17.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GSsexView;
@class GSageView;
@class GScityView;
@class GSauthenticationVC;

@class GSchangePassWordVC;

@interface PersonInfoViewController : UIViewController

@property (nonatomic ,strong) GSchangePassWordVC *changePassWordVC;

@property (nonatomic,strong) GSsexView *sexV;
@property (nonatomic,strong) GSageView *ageV;
@property (nonatomic,strong) GScityView *cityV;

@property (nonatomic,strong) GSauthenticationVC *authenticationVC;
@end
