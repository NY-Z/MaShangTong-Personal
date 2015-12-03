//
//  InputViewController.h
//  MaShangTong
//
//  Created by niliu1h  on 15/10/21.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, InputViewControllerType) {
    InputViewControllerTypeSpecialCarSource = 0,
    InputViewControllerTypeCharteredBusSource,
    InputViewControllerTypeAirportPickUpSource,
    InputViewControllerTypeAirportDropOffSource,
    InputViewControllerTypeSpecialCarDestination,
    InputViewControllerTypeCharteredBusDestination,
    InputViewControllerTypeAirportPickUpDestination,
    InputViewControllerTypeAirportDropOffDestination,
};
@interface InputViewController : UIViewController

@property (nonatomic,strong) NSString *textFieldText;

@property (nonatomic,strong) void (^destAddress) (NSString *destination);
@property (nonatomic,strong) void (^sourceAddress) (NSString *source);

@property (nonatomic,assign) InputViewControllerType type;

@end
