//
//  VoucherCell.h
//  MaShangTong
//
//  Created by niliu1h  on 15/10/22.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoucherCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@property (nonatomic,strong) void (^sendBtnBlock) ();

@end
