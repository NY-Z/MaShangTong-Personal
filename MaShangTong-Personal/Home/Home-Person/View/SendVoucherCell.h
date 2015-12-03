//
//  SendVoucherCell.h
//  MaShangTong
//
//  Created by niliu1h  on 15/10/22.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendVoucherCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
- (IBAction)selectBtnClicked:(id)sender;

@property (nonatomic,strong) void (^cellIsSelected) (BOOL isSelected);

@end
