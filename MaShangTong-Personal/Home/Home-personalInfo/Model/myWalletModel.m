//
//  myWalletModel.m
//  MaShangTong
//
//  Created by q on 15/12/18.
//  Copyright © 2015年 NY. All rights reserved.
//

#import "myWalletModel.h"

@implementation myWalletModel

+(NSDictionary *)getDicWith:(myWalletModel *)myWallet
{
    
    if (!myWallet.money) {
        myWallet.money = @"";
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[myWallet.user_id,myWallet.money,myWallet.type,myWallet.group_id]
                                                    forKeys:@[@"user_id",@"money",@"type",@"group_id"] ];
    return dic;
}

@end
