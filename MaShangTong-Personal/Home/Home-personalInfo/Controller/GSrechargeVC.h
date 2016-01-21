//
//  GSrechargeVC.h
//  MaShangTong
//
//  Created by q on 15/12/23.
//  Copyright © 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GSrechargeVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *monryTextFiled;

@property (weak, nonatomic) IBOutlet UIButton *alipayBtn;
@property (weak, nonatomic) IBOutlet UIButton *weChatBtn;
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;


- (IBAction)doAlipay:(id)sender;

- (IBAction)doWeChat:(id)sender;

- (IBAction)doRecharge:(id)sender;

@end
