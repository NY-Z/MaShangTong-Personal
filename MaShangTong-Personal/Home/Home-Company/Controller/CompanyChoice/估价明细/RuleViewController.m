//
//  RuleViewController.m
//  MaShangTong
//
//  Created by niliu1h  on 15/10/17.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import "RuleViewController.h"

@interface RuleViewController ()

@property (weak, nonatomic) IBOutlet UILabel *car_typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *stepPriiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *milesLabel;
@property (weak, nonatomic) IBOutlet UILabel *long_milesLabel;
@property (strong, nonatomic) IBOutlet UIView *barrierView;
@property (weak, nonatomic) IBOutlet UILabel *stepTextLabel;

@end

@implementation RuleViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationController.navigationBar.barTintColor = RGBColor(238, 238, 238, 1.f);
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    backBtn.size = CGSizeMake(22, 22);
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.text = @"计价规则";
    label.textAlignment = 1;
    label.font = [UIFont systemFontOfSize:19];
    label.textColor = RGBColor(99, 193, 255, 1.f);
    
    self.navigationItem.titleView = label;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self displayData];
}
-(void)displayData
{
    //汽车类型的展示
    int carNum = [self.car_type intValue];
    switch (carNum) {
        case 1:
            _car_typeLabel.text = @"舒适电动轿车";
            break;
            
        case 2:
            _car_typeLabel.text = @"商务电动轿车";
            break;
            
        case 3:
            _car_typeLabel.text = @"豪华电动轿车";
            break;
            
        default:
            break;
    }
    

    switch (self.type) {
        case TypeSpecialCar:
        {
            //起步价的展示
            _stepPriiceLabel.text = [NSString stringWithFormat:@"%@元",self.step];
            
            //里程价展示
            if (self.distance <= 10) {
                NYLog(@"%@",self.mileage);
                _milesLabel.text = [NSString stringWithFormat:@"%@元/km",self.mileage];
                _long_milesLabel.hidden = YES;
            }
            else{
                _long_milesLabel.hidden = NO;
                _milesLabel.text = [NSString stringWithFormat:@"%@元/km",self.mileage];
                _long_milesLabel.text = [NSString stringWithFormat:@"远途费：%@元/km",self.long_mileage];
            }
            break;
        }
        case TypeCharteredBus:
        {
            _stepPriiceLabel.text = [NSString stringWithFormat:@"%@元",self.mileage];
            _milesLabel.text = [NSString stringWithFormat:@"%@元/%gkm",self.mileage,self.distance];
            _long_milesLabel.hidden = YES;
            break;
        }
        case TypeAirportPickup:
        {
            _stepPriiceLabel.text = [NSString stringWithFormat:@"%@元",self.step];
            _milesLabel.text = [NSString stringWithFormat:@"%@元",self.step];
            _long_milesLabel.hidden = YES;
            break;
        }
        case TypeAirportDropoff:
        {
            _stepPriiceLabel.text = [NSString stringWithFormat:@"%@元",self.step];
            _milesLabel.text = [NSString stringWithFormat:@"%@元",self.step];
            _long_milesLabel.hidden = YES;
            break;
        }
        default:
            break;
    }
}
#pragma mark - Action
- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    NYLog(@"%s",__FUNCTION__);
}

@end
