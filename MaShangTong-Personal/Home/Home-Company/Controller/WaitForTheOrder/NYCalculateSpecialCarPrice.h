//
//  NYCalculateSpecialCarPrice.h
//  MaShangTong-Personal
//
//  Created by NY on 16/1/13.
//  Copyright © 2016年 jeaner. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ValuationRuleModel;

@interface NYCalculateSpecialCarPrice : NSObject

@property (nonatomic,strong) ValuationRuleModel *model;

+ (instancetype)sharedPrice;

- (NSArray *)calculatePriceWithParams:(NSDictionary *)params;

@end
