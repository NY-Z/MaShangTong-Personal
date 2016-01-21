//
//  GSPayModel.m
//  MaShangTong-Personal
//
//  Created by q on 15/12/31.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "GSPayModel.h"

#import "ActualPriceModel.h"
#import "DriverInfoModel.h"

@implementation GSPayModel

-(instancetype)initWithActualPriceModel:(ActualPriceModel *)priceModel andPassengerDriverInfoModel:(DriverInfoModel *)driverModel
{
    if (self = [super init]) {
        self->_touxiangData = UIImagePNGRepresentation([UIImage imageNamed:@"sijitouxiang"]);
        self->_DriverName = driverModel.owner_name;
        self->_DriverNumber = driverModel.license_plate;
        self->_CompayName = @"友联出租";
        self->_pinfenNumberStr = [NSString stringWithFormat:@"%f",4.7];
        self->_NumberStr = driverModel.num;
        self->_PhoneNumberStr = driverModel.mobile;
        
        
        self->_PriceStr = priceModel.total_price;
        self->_preferentialStr = @"0";
        self->_milesStr = priceModel.mileage;
        self->_carbonStr = @"0.0";
    }
    return self;
}

@end
