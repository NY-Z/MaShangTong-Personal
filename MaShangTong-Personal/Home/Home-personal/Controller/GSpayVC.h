//
//  GSpayVC.h
//  MaShangTong
//
//  Created by q on 15/12/25.
//  Copyright © 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DriverInfoModel.h"

typedef enum{
    UseOrderPay,//用优惠券支付方式
    DisUseOrderPay//不用优惠券支付方式
}OrderPayType;

@interface GSpayVC : UIViewController

@property (nonatomic,assign) OrderPayType orderPayType;
@property (nonatomic,copy) NSString *ticket_id;
@property (nonatomic,copy) NSString *ticket_money;

@property (weak, nonatomic) IBOutlet UIImageView *touxiangImage;
@property (weak, nonatomic) IBOutlet UILabel *sijiName;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *compareName;
@property (weak, nonatomic) IBOutlet UIView *starBottomView;
@property (nonatomic,strong) UIView *starView;
@property (weak, nonatomic) IBOutlet UILabel *danLabel;

@property (weak, nonatomic) IBOutlet UIButton *callBtn;

@property (weak, nonatomic) IBOutlet UILabel *fareLabel;
@property (weak, nonatomic) IBOutlet UILabel *youhuiLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *carbonLabel;

@property (weak, nonatomic) IBOutlet UIButton *selfMoneyBtn;
@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;
@property (weak, nonatomic) IBOutlet UIButton *weChatBtn;

@property (weak, nonatomic) IBOutlet UIButton *makeSureBtn;


@property (nonatomic,copy) NSString *route_id;

@property (nonatomic,strong) DriverInfoModel *driverModel;

- (IBAction)chooseOrder:(id)sender;


- (IBAction)call:(id)sender;

- (IBAction)selfMoneyAction:(id)sender;
- (IBAction)aliPayAction:(id)sender;
- (IBAction)weChatPayAction:(id)sender;


- (IBAction)makeSureAction:(id)sender;

@end
