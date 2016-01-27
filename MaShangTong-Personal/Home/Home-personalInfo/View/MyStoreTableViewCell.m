//
//  MyStoreTableViewCell.m
//  MaShangTong
//
//  Created by q on 15/12/11.
//  Copyright © 2015年 NY. All rights reserved.
//

#import "MyStoreTableViewCell.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation MyStoreTableViewCell

- (void)awakeFromNib {
    _zongleiLabel.layer.borderWidth = 1.f;    
    _zongleiLabel.layer.borderColor = RGBColor(93, 195, 255, 1.f).CGColor;
    _zongleiLabel.layer.cornerRadius = 3.f;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
