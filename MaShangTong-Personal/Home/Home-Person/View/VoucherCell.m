//
//  VoucherCell.m
//  MaShangTong
//
//  Created by niliu1h  on 15/10/22.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import "VoucherCell.h"

@implementation VoucherCell
- (IBAction)sendBtnClicked:(id)sender {
    if (self.sendBtnBlock) {
        self.sendBtnBlock();
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
