//
//  EstimateViewController.m
//  MaShangTong
//
//  Created by niliu1h  on 15/10/17.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import "EstimateViewController.h"

@interface EstimateViewController ()
@property (weak, nonatomic) IBOutlet UILabel *estimatePriceLabel;

@property (weak, nonatomic) IBOutlet UIImageView *dismissImageView;
@property (weak, nonatomic) IBOutlet UILabel *ruleLabel;

@property (weak, nonatomic) IBOutlet UILabel *mileageLabel;

@property (weak, nonatomic) IBOutlet UILabel *stepPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *mileageFareLabel;

@end

@implementation EstimateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configXidView];
    
}

- (void)configXidView
{
    UITapGestureRecognizer *dismissImageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissImageViewTap:)];
    [self.dismissImageView addGestureRecognizer:dismissImageViewTap];
    
    self.ruleLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *ruleLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ruleLabelTap:)];
    [self.ruleLabel addGestureRecognizer:ruleLabelTap];
    
    switch (_type) {
        case RuleTypeSpecialCar:
        {
            NSString *price = self.estimateDic[@"estimatePrice"];
            NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"约 %@ 元",price]];
            [attriStr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:32], NSForegroundColorAttributeName : RGBColor(46, 181, 255, 1.f)} range:NSMakeRange(2, price.length)];
            self.estimatePriceLabel.attributedText = attriStr;
            
            NSString *distance = self.estimateDic[@"distance"];
            NSString *step = self.estimateDic[@"step"];
            _mileageLabel.text = [NSString stringWithFormat:@"里程费(%.2fkm)",(distance.floatValue/1000)];
            _stepPriceLabel.text = [NSString stringWithFormat:@"%@元",step];
            _mileageFareLabel.text = [NSString stringWithFormat:@"%.2f元",([price doubleValue]-[step doubleValue])];
            break;
        }
        case RuleTypeCharteredBus:
        {
            NSString *price = self.estimateDic[@"once_price"];
            NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"约 %@ 元",price]];
            [attriStr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:32], NSForegroundColorAttributeName : RGBColor(46, 181, 255, 1.f)} range:NSMakeRange(2, price.length)];
            self.estimatePriceLabel.attributedText = attriStr;
            _stepPriceLabel.text = [NSString stringWithFormat:@"%@元",self.estimateDic[@"once_price"]];
            _mileageLabel.text = [NSString stringWithFormat:@"里程费(%@km)",self.estimateDic[@"contain_mileage"]];
            _mileageFareLabel.text = [NSString stringWithFormat:@"%@元",self.estimateDic[@"once_price"]];
            break;
        }
        case RuleTypeAirportPickup:
        {
            NSString *price = self.estimateDic[@"price"];
            NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"约 %@ 元",price]];
            [attriStr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:32], NSForegroundColorAttributeName : RGBColor(46, 181, 255, 1.f)} range:NSMakeRange(2, price.length)];
            self.estimatePriceLabel.attributedText = attriStr;
            _stepPriceLabel.text = [NSString stringWithFormat:@"%@元",price];
            _mileageLabel.text = @"里程费(0km)";
            _mileageFareLabel.text = [NSString stringWithFormat:@"%@元",self.estimateDic[@"price"]];
            break;
        }
        case RuleTypeAirportDropoff:
        {
            NSString *price = self.estimateDic[@"price"];
            NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"约 %@ 元",price]];
            [attriStr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:32], NSForegroundColorAttributeName : RGBColor(46, 181, 255, 1.f)} range:NSMakeRange(2, price.length)];
            self.estimatePriceLabel.attributedText = attriStr;
            _stepPriceLabel.text = [NSString stringWithFormat:@"%@元",price];
            _mileageLabel.text = @"里程费(0km)";
            _mileageFareLabel.text = [NSString stringWithFormat:@"%@元",self.estimateDic[@"price"]];
            break;
        }
        default:
            break;
    }
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

#pragma - Gesture
- (void)dismissImageViewTap:(UITapGestureRecognizer *)tap
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)ruleLabelTap:(UITapGestureRecognizer *)tap
{
    if (self.ruleLabelClick) {
        switch (self.type) {
            case RuleTypeSpecialCar:
            {
                self.ruleLabelClick(_estimateDic[@"rule"]);
                break;
            }
            case RuleTypeCharteredBus:
            {
                self.ruleLabelClick(@[_estimateDic[@"car_type_id"],@"0",_estimateDic[@"once_price"],@"0",_estimateDic[@"contain_mileage"]]);
                break;
            }
            case RuleTypeAirportPickup:
            {
                self.ruleLabelClick(@[]);
                break;
            }
            case RuleTypeAirportDropoff:
            {
                self.ruleLabelClick(@[]);
                break;
            }
                
            default:
                break;
        }
    }
}

- (void)dealloc
{
    NYLog(@"%s",__FUNCTION__);
}

@end
