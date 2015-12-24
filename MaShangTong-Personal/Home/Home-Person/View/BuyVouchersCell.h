//
//  BuyVouchersCell.h
//  MaShangTong
//
//  Created by niliu1h  on 15/10/23.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NYStepper;
@interface BuyVouchersCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (nonatomic,strong) NYStepper *stepper;

@end
