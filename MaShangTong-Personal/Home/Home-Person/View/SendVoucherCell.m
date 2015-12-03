//
//  SendVoucherCell.m
//  MaShangTong
//
//  Created by niliu1h  on 15/10/22.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import "SendVoucherCell.h"

@implementation SendVoucherCell

- (IBAction)selectBtnClicked:(id)sender {
    
    self.selectBtn.selected = !self.selectBtn.selected;
    if (self.cellIsSelected) {
        self.cellIsSelected(self.selectBtn.selected);
    }
}
@end
