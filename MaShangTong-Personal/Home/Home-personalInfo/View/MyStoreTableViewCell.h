//
//  MyStoreTableViewCell.h
//  MaShangTong
//
//  Created by q on 15/12/11.
//  Copyright © 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyStoreTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *hengxian;
@property (weak, nonatomic) IBOutlet UILabel *yuanjiaLabel;

@property (weak, nonatomic) IBOutlet UILabel *zongleiLabel;



@end
