//
//  AirportDropOffViewController.h
//  MaShangTong
//
//  Created by niliu1h  on 15/10/19.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AirportDropOffViewController : UIViewController

@property (nonatomic,strong) void (^sourceBtnBlock) ();
@property (nonatomic,strong) void (^destinationBlock) ();
@property (nonatomic,strong) void (^timeBtnBlock) ();
@property (nonatomic,strong) void (^confirmBtnBlock) ();

@property (nonatomic,strong) UIButton *timeBtn;
@property (nonatomic,strong) UIButton *sourceBtn;
@property (nonatomic,strong) UIButton *destinationBtn;

@end
