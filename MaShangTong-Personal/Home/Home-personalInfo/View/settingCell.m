//
//  settingCell.m
//  MaShangTong
//
//  Created by q on 15/12/12.
//  Copyright © 2015年 NY. All rights reserved.
//

#import "settingCell.h"
#import "Masonry.h"
#import "KLSwitch.h"

@implementation settingCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _leftTitleLabel = [[UILabel alloc] init];
        _leftTitleLabel.textColor = RGBColor(159, 159, 159, 1.f);
        _leftTitleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_leftTitleLabel];
        [_leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(300, 30));
        }];
        
        _rightSwitch = [[KLSwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 20) ];
        [_rightSwitch setOn:YES];
        [self.contentView addSubview:_rightSwitch];
        
        [_rightSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.top.equalTo(self.contentView).offset(7);
            make.size.mas_equalTo(CGSizeMake(51, 31));
        }];
        
        _rightSwitch.onTintColor = RGBColor(98, 190, 254, 1.f);
        
        _rightSwitch.hidden = YES;
    }
    return self;
}

@end
