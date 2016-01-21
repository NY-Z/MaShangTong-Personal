//
//  MyMoney.h
//  MaShangTong
//
//  Created by q on 15/12/10.
//  Copyright © 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMoney : UIView

//我剩余的钱
@property (nonatomic,strong) UILabel *MyDalanceLabel;

@property (nonatomic,strong) void(^recharge)();

@end
