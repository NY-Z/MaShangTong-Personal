//
//  CharteredBusViewController.h
//  MaShangTong
//
//  Created by niliu1h  on 15/10/19.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassengerMessageModel.h"

@interface CharteredBusViewController : UIViewController
{
    @public
//    UILabel *priceLabel;
}

@property (nonatomic,strong) void (^durationBtnBlock) ();
@property (nonatomic,strong) void (^timeBtnBlock) (NSArray *descArr);
@property (nonatomic,strong) void (^sourceBtnBlock) ();
@property (nonatomic,strong) void (^confirmBtnBlock) (PassengerMessageModel *model,NSString *route_id);

@property (nonatomic,strong) UIButton *timeBtn;
@property (nonatomic,strong) UIButton *sourceBtn;
@property (nonatomic,strong) UIButton *durationBtn;

- (void)changeThePrice;

- (void)requestTheRules;

@end
