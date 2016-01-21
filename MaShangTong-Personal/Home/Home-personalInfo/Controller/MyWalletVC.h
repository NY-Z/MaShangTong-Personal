//
//  MyWalletVC.h
//  MaShangTong
//
//  Created by q on 15/12/10.
//  Copyright © 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyMoney;
@class MyChit;
@class myWalletModel;
@class GSrechargeVC;


@interface MyWalletVC : UIViewController<UIAlertViewDelegate>

@property (nonatomic,strong)MyMoney *moneyView;

@property (nonatomic,strong)MyChit *chitView;

@property (nonatomic,strong)GSrechargeVC *rechargeVC;

@property (nonatomic,strong)myWalletModel *myWallet;




@end
