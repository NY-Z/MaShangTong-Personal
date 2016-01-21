//
//  GSPriceRuleModel.h
//  MaShangTong-Personal
//
//  Created by q on 15/12/29.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSPriceRuleModel : NSObject

@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *step;
@property (nonatomic,copy) NSString *mileage;
@property (nonatomic,copy) NSString *long_mileage;
@property (nonatomic,assign) CGFloat distance;

@end
