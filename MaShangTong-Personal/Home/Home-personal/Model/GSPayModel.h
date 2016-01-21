//
//  GSPayModel.h
//  MaShangTong-Personal
//
//  Created by q on 15/12/31.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ActualPriceModel;
@class DriverInfoModel;

@interface GSPayModel : NSObject

@property (nonatomic,copy) NSData *touxiangData;
@property (nonatomic,copy) NSString *DriverName;
@property (nonatomic,copy) NSString *DriverNumber;
@property (nonatomic,copy) NSString *CompayName;
@property (nonatomic,copy) NSString *pinfenNumberStr;
@property (nonatomic,copy) NSString *NumberStr;
@property (nonatomic,copy) NSString *PhoneNumberStr;


@property (nonatomic,copy) NSString *PriceStr;
@property (nonatomic,copy) NSString *preferentialStr;
@property (nonatomic,copy) NSString *milesStr;
@property (nonatomic,copy) NSString *carbonStr;

-(instancetype)initWithActualPriceModel:(ActualPriceModel *)priceModel andPassengerDriverInfoModel:(DriverInfoModel *)driverModel;

@end
