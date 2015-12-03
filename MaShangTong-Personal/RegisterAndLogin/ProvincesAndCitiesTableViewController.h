//
//  ProvincesAndCitiesTableViewController.h
//  MaShangTong-Personal
//
//  Created by NY on 15/11/23.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ProvinceType) {
    ProvinceTypeProvince,
    ProvinceTypeCity,
};

@interface ProvincesAndCitiesTableViewController : UITableViewController

@property (nonatomic,assign) ProvinceType type;
@property (nonatomic,strong) NSString *province;

@property (nonatomic,strong) void (^transProvince) (NSString *province);
@property (nonatomic,strong) void (^transCity) (NSString *city);

@end
