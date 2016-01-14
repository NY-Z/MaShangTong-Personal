//
//  ActualPriceModel.h
//  MaShangTong-Driver
//
//  Created by apple on 15/12/17.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ActualPriceModel : JSONModel

@property (nonatomic,strong) NSString <Optional> *far_mileage;      // 远途里程
@property (nonatomic,strong) NSString <Optional> *far_price;        // 远途费
@property (nonatomic,strong) NSString <Optional> *low_price;        // 低速价格
@property (nonatomic,strong) NSString <Optional> *low_time;         // 低速时间
@property (nonatomic,strong) NSString <Optional> *mileage;          // 总里程
@property (nonatomic,strong) NSString <Optional> *mileage_price;    // 总里程费
@property (nonatomic,strong) NSString <Optional> *night_mileage;    // 夜间行驶距离
@property (nonatomic,strong) NSString <Optional> *night_price;      // 夜间费
@property (nonatomic,strong) NSString <Optional> *start_price;      // 起步价
@property (nonatomic,strong) NSString <Optional> *total_price;      // 总价

@end
