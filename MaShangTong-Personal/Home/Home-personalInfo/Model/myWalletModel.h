//
//  myWalletModel.h
//  MaShangTong
//
//  Created by q on 15/12/18.
//  Copyright © 2015年 NY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myWalletModel : NSObject

@property (nonatomic,copy) NSString *user_id;
@property (nonatomic,copy) NSString *money;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *group_id;

+(NSDictionary *)getDicWith:(myWalletModel *)myWallet;

@end
