//
//  GSshopPayViewController.h
//  MaShangTong-Personal
//
//  Created by q on 16/1/5.
//  Copyright © 2016年 jeaner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSshopPayViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalPrice;

@property (weak, nonatomic) IBOutlet UIButton *moneyBtn;
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;
@property (weak, nonatomic) IBOutlet UIButton *bankBtn;


@property (weak, nonatomic) IBOutlet UIButton *makeSureBtn;


@property (nonatomic,copy) NSString *goodsName;
@property (nonatomic,copy) NSArray *route_id;
@property (nonatomic,copy) NSString *company_id;
@property (nonatomic,copy) NSString *ticket_id;

@property (nonatomic,copy) NSString *priceStr;


- (IBAction)moneyPay:(id)sender;

- (IBAction)wechatPay:(id)sender;

- (IBAction)alipay:(id)sender;

- (IBAction)bankPay:(id)sender;



- (IBAction)makeSure:(id)sender;



@end
