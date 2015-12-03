//
//  BuyVouchersCell.m
//  MaShangTong
//
//  Created by niliu1h  on 15/10/23.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import "BuyVouchersCell.h"
#import "NYStepper.h"
#import "Masonry.h"

@implementation BuyVouchersCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        NYStepper *stepper = [[NYStepper alloc] init];
        [self.contentView addSubview:stepper];
        [stepper mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-8);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(61, 18));
        }];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        NYStepper *stepper = [[NYStepper alloc] init];
        [self.contentView addSubview:stepper];
        [stepper mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-8);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(61, 18));
        }];
    }
    return self;
}

@end
