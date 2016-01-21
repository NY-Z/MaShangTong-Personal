//
//  CallCarView.h
//  MaShangTong
//
//  Created by niliu1h  on 15/10/16.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeViewController;
@class searchViewController;

@interface CallCarView : UIView<UITextFieldDelegate>

//价格展示的label
@property (nonatomic,strong) UILabel *priceLabel;

//起始点的label
@property (nonatomic,strong) UILabel *startTextFled;
//终点的label
@property (nonatomic,strong) UILabel *endTextFlied;
//出发时间
@property (nonatomic,strong) UIButton *goOffBtn;
//给司机捎话
@property (nonatomic,strong) UITextField *textField;

//block回调
@property (nonatomic,strong) void (^priceTapBlock) ();

@property (nonatomic,strong) void (^dateTapBlock)();

@property (nonatomic,strong) void (^pushWordVC)();

@property (nonatomic,strong) void(^pushSearchVC)(NSInteger whichOne);

@property (nonatomic,strong) void(^chooseCarType)(NSInteger carTyper);

@property (nonatomic,strong) void(^submitOrders)();


@property (nonatomic,strong) searchViewController *searchVC;


@end
