//
//  NYMyTripsTableViewCell.m
//  MaShangTong-Personal
//
//  Created by apple on 15/12/18.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "NYMyTripsTableViewCell.h"
#import "NYMyTripsModel.h"

@interface NYMyTripsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *originNameImageView;
@property (weak, nonatomic) IBOutlet UIImageView *endNameImageView;
@property (weak, nonatomic) IBOutlet UILabel *originNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *endNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *reservationTypeLabel;

@end

@implementation NYMyTripsTableViewCell

- (void)configModel:(NYMyTripsModel *)model
{
    _originNameLabel.text = model.origin_name;
    _endNameLabel.text = model.end_name;
    
    NSInteger reservaType = [model.reserva_type integerValue];
    switch (reservaType) {
        case 1:
            _reservationTypeLabel.text = @"专车";
            break;
        case 2:
            _reservationTypeLabel.text = @"包车";
            break;
        case 3:
            _reservationTypeLabel.text = @"接机";
            break;
        case 4:
            _reservationTypeLabel.text = @"送机";
            break;
        default:
            break;
    }
    
}

@end
