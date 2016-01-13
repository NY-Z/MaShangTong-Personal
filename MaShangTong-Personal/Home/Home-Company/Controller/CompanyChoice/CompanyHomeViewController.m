//
//  CompanyHomeViewController.m
//  MaShangTong
//
//  Created by niliu1h  on 15/10/19.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import "CompanyHomeViewController.h"
#import "Masonry.h"
#import "SpecialCarViewController.h"
#import "CharteredBusViewController.h"
#import "AirportPickupViewController.h"
#import "AirportDropOffViewController.h"
#import "InputViewController.h"
#import "FlightNoViewController.h"
#import "AirPortViewController.h"
#import "EmployeeInfoViewController.h"
#import "AccountBalanceViewController.h"
#import "VoucherViewController.h"
#import "SettingViewController.h"
#import "PassengerMessageModel.h"
#import "WaitForTheOrderViewController.h"
#import "NYCompanyBillViewController.h"
#import "RegisViewController.h"

#define kPersonInfoTitle @"personInfoTitle"
#define kPersonInfoImageName @"personInfoImageName"
#define kPersonInfoTableViewHeight 40   // 每个cell的高度为40。

@interface CompanyHomeViewController () <UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIScrollViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIPageViewController *_pageViewController;
    NSMutableArray *_dataArr;
    
    UIButton *_selectBtn;
    UIView *_indicatorView;
    NSInteger _currentPage;
    
    UIPickerView *pick;
    NSMutableArray *dateArr;
    NSMutableArray *hourArr;
    NSMutableArray *minArr;
    
    UIView *_coverView;
    
    UIView *_pickBgView;
    
    UIView *_timePickerBgView;
    
    UIView *_cityPickBgView;
    
    UIButton *_citySelectBtn;
    
    UITableView *_personInfoTableView;
    NSArray *_personInfoDataArr;
    
    BOOL _coverIsTouching;
    
    NSString *_date;
    NSString *_hour;
    NSString *_minute;
}



@property (nonatomic,strong) UIView *navigationBar;

@end

@implementation CompanyHomeViewController

#pragma mark - ConfigViews
- (void)configNavigationBar
{
    UIView *myNavigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    myNavigationBar.backgroundColor = RGBColor(238, 238, 238, 1.f);
    [self.view addSubview:myNavigationBar];
    
    NSArray *titleArr = @[@"专车",@"包车",@"接机",@"送机"];
    CGFloat width = SCREEN_WIDTH/6;
    for (NSInteger i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(width + i*width, 20, width, 44);
        [btn setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:RGBColor(98, 190, 255, 1.f) forState:UIControlStateSelected];
        [btn setTitleColor:RGBColor(107, 107, 107, 1.f) forState:UIControlStateNormal];
        btn.titleEdgeInsets = UIEdgeInsetsMake(8, 0, 0, 0);
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        [btn addTarget:self action:@selector(navBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100+i;
        if (i == 0) {
            btn.selected = YES;
            _selectBtn = btn;
        }
        [myNavigationBar addSubview:btn];
    }
    
    _indicatorView = [[UILabel alloc] initWithFrame:CGRectMake(width, 62, width, 2)];
    _indicatorView.backgroundColor = RGBColor(98, 190, 255, 1.f);
    [myNavigationBar addSubview:_indicatorView];
    
    // LeftBarButtonItem
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"yonghu"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(SCREEN_WIDTH/12-22, 20, 44, 44);
    [leftBtn addTarget:self action:@selector(leftBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [myNavigationBar addSubview:leftBtn];
    
    /*
    // RightBarButtonItem
    UIView *rightBgView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-44, 31, 22, 22)];
    rightBgView.backgroundColor = RGBColor(160, 160, 160, 1.f);
    [myNavigationBar addSubview:rightBgView];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"qichenew"] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(SCREEN_WIDTH-38, 38, 18, 18);
    [rightBtn addTarget:self action:@selector(rightBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [myNavigationBar addSubview:rightBtn];
#warning rightBtn
    self.navigationBar = myNavigationBar;
     */
}

- (void)configPageViewController
{
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:1 navigationOrientation:0 options:nil];
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    _pageViewController.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [_pageViewController setViewControllers:@[_dataArr[0]] direction:0 animated:0 completion:^(BOOL finished) {
        _currentPage = 0;
    }];
    [self.view addSubview:_pageViewController.view];
    
//    for (UIView *view in _pageViewController.view.subviews) {
//        if ([view isKindOfClass:[UIScrollView class]]) {
//            UIScrollView *scrollView = (UIScrollView *)view;
//            scrollView.delegate = self;
//            scrollView.bounces = NO;
//            scrollView.pagingEnabled = YES;
//        }
//    }
}

- (void)configDataArr
{
    _dataArr = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    SpecialCarViewController *specialCar = [[SpecialCarViewController alloc] init];
    __weak typeof(specialCar) weakSpecialCar = specialCar;
    specialCar.timeBtnBlock = ^(){
        [UIView animateWithDuration:0.3 animations:^{
            
            _pickBgView.y = SCREEN_HEIGHT-260;
            _pickBgView.hidden = NO;
            _coverView.hidden = !_coverView.hidden;
            
        }];
    };
    specialCar.sourceBtnBlock = ^(){
        InputViewController *input = [[InputViewController alloc] init];
        input.textFieldText = @"请输入出发地";
        input.type = InputViewControllerTypeSpecialCarSource;
        [weakSelf presentViewController:input animated:YES completion:^{
            
        }];
    };
    specialCar.destinationBtnBlock = ^(){
        InputViewController *input = [[InputViewController alloc] init];
        input.textFieldText = @"请输入目的地";
        input.type = InputViewControllerTypeSpecialCarDestination;
        input.destAddress = ^(NSString *destination) {
            [weakSpecialCar.destinationBtn setTitle:destination forState:UIControlStateNormal];
            [weakSpecialCar performSelector:@selector(initNavi)];
        };
        [weakSelf presentViewController:input animated:YES completion:^{
            
        }];
    };
//    specialCar.addressBtnBlock = ^(){
//        _coverView.hidden = NO;
//        [UIView animateWithDuration:0.3 animations:^{
//            _cityPickBgView.y = SCREEN_HEIGHT-216;
//            _cityPickBgView.hidden = NO;
//        } completion:^(BOOL finished) {
//            
//        }];
//    };
    specialCar.confirmBtnBlock = ^(PassengerMessageModel *model,NSString *route_id,ValuationRuleModel *specialCarRuleModel) {
        WaitForTheOrderViewController *waitOrderVc = [[WaitForTheOrderViewController alloc] init];
        waitOrderVc.model = model;
        waitOrderVc.route_id = route_id;
        waitOrderVc.passengerCoordinate = CLLocationCoordinate2DMake(delegate.passengerCoordinate.latitude, delegate.passengerCoordinate.longitude);
        waitOrderVc.specialCarRuleModel = specialCarRuleModel;
        [weakSelf.navigationController pushViewController:waitOrderVc animated:YES];
    };
    [_dataArr addObject:specialCar];
    
    CharteredBusViewController *charteredBus = [[CharteredBusViewController alloc] init];
    charteredBus.timeBtnBlock = ^(NSArray *descArr){
        
        [weakSelf configTransportTimePicker:descArr];
        
        _coverView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _timePickerBgView.y = SCREEN_HEIGHT-216;
            _timePickerBgView.hidden = NO;
        } completion:^(BOOL finished) {
            
        }];
    };
    charteredBus.durationBtnBlock = ^(){
        _coverView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _pickBgView.y = SCREEN_HEIGHT-216;
            _pickBgView.hidden = NO;
        } completion:^(BOOL finished) {
            
        }];
    };
    charteredBus.sourceBtnBlock = ^(){
        InputViewController *input = [[InputViewController alloc] init];
        input.type = InputViewControllerTypeCharteredBusSource;
        input.textFieldText = @"请输入出发地";
        [weakSelf presentViewController:input animated:YES completion:^{
            
        }];
    };
    charteredBus.confirmBtnBlock = ^(PassengerMessageModel *model,NSString *route_id,CharteredBusRule *charteredBusRule) {
        WaitForTheOrderViewController *waitOrderVc = [[WaitForTheOrderViewController alloc] init];
        waitOrderVc.model = model;
        waitOrderVc.route_id = route_id;
        waitOrderVc.passengerCoordinate = CLLocationCoordinate2DMake(delegate.passengerCoordinate.latitude, delegate.passengerCoordinate.longitude);
        [weakSelf.navigationController pushViewController:waitOrderVc animated:YES];
    };
    [_dataArr addObject:charteredBus];
    
    AirportPickupViewController *airportPickup = [[AirportPickupViewController alloc] init];
    airportPickup.flightBtnBlock = ^(){
        FlightNoViewController *flightNo = [[FlightNoViewController alloc] init];
        [weakSelf presentViewController:flightNo animated:YES completion:^{
            
        }];
    };
    airportPickup.timeBtnBlock = ^(){
        _coverView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _pickBgView.y = SCREEN_HEIGHT-216;
            _pickBgView.hidden = NO;
        } completion:^(BOOL finished) {
            
        }];
    };
    airportPickup.sourceBtnBlock = ^(){
        AirPortViewController *airport = [[AirPortViewController alloc] init];
        airport.type = AirPortViewControllerTypePickUp;
        [weakSelf presentViewController:airport animated:YES completion:^{
            
        }];
    };
    airportPickup.destinationBtnBlock = ^(){
        InputViewController *input = [[InputViewController alloc] init];
        input.type = InputViewControllerTypeAirportPickUpDestination;
        input.textFieldText = @"请输入您的目的地";
        [weakSelf presentViewController:input animated:YES completion:^{
            
        }];
    };
    airportPickup.confirmBtnBlock = ^(PassengerMessageModel *model,NSString *route_id,AirportPickupModel *airportModel) {
        WaitForTheOrderViewController *waitOrderVc = [[WaitForTheOrderViewController alloc] init];
        waitOrderVc.model = model;
        waitOrderVc.route_id = route_id;
        waitOrderVc.airportModel = airportModel;
        waitOrderVc.passengerCoordinate = CLLocationCoordinate2DMake(delegate.passengerCoordinate.latitude, delegate.passengerCoordinate.longitude);
        [weakSelf.navigationController pushViewController:waitOrderVc animated:YES];
    };
    [_dataArr addObject:airportPickup];
    
    AirportDropOffViewController *airportDropOff = [[AirportDropOffViewController alloc] init];
    airportDropOff.sourceBtnBlock = ^(){
        InputViewController *input = [[InputViewController alloc] init];
        input.type = InputViewControllerTypeAirportDropOffSource;
        input.textFieldText = @"请输入出发地";
        [weakSelf presentViewController:input animated:YES completion:^{
            
        }];
    };
    airportDropOff.destinationBlock = ^(){
        AirPortViewController *airport = [[AirPortViewController alloc] init];
        airport.type = AirPortViewControllerTypeDropOff;
        [weakSelf presentViewController:airport animated:YES completion:^{
            
        }];
    };
    airportDropOff.timeBtnBlock = ^(){
        _coverView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _pickBgView.y = SCREEN_HEIGHT-216;
            _pickBgView.hidden = NO;
        } completion:^(BOOL finished) {
            
        }];
    };
    airportDropOff.confirmBtnBlock = ^(PassengerMessageModel *model,NSString *route_id) {
        WaitForTheOrderViewController *waitOrderVc = [[WaitForTheOrderViewController alloc] init];
        waitOrderVc.model = model;
        waitOrderVc.route_id = route_id;
        waitOrderVc.passengerCoordinate = CLLocationCoordinate2DMake(delegate.passengerCoordinate.latitude, delegate.passengerCoordinate.longitude);
        [weakSelf.navigationController pushViewController:waitOrderVc animated:YES];
    };
    [_dataArr addObject:airportDropOff];
}

- (void)configDatePicker
{
    _pickBgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 260)];
    _pickBgView.backgroundColor = [UIColor whiteColor];
    _pickBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _pickBgView.layer.borderWidth = 1.f;
    [self.view addSubview:_pickBgView];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftBtn setTitleColor:RGBColor(98, 190, 255, 1.f) forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(pickerLeftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_pickBgView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_pickBgView).offset(26);
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.top.equalTo(_pickBgView).offset(0);
    }];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitleColor:RGBColor(98, 190, 255, 1.f) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(pickerRightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_pickBgView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_pickBgView).offset(-26);
        make.size.mas_equalTo(CGSizeMake(44, 38));
        make.top.equalTo(_pickBgView);
    }];
    
    pick = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 216)];
    pick.backgroundColor = [UIColor whiteColor];
    pick.showsSelectionIndicator = YES;
    pick.dataSource = self;
    pick.delegate = self;
    
    [_pickBgView addSubview:pick];
    
    dateArr = [@[@"现在用车",@"今天",[self latelyEightTime][1],[self latelyEightTime][2]] mutableCopy];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"HH mm"];
    
    UIView *maskView = [[UIView alloc] init];
    maskView.backgroundColor = [UIColor lightGrayColor];
    [_pickBgView addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftBtn.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 0.5));
        make.left.equalTo(_pickBgView);
    }];
    
    _pickBgView.hidden = YES;
}

- (void)configTransportTimePicker:(NSArray *)descArr
{
    _timePickerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216)];
    _timePickerBgView.backgroundColor = [UIColor whiteColor];
    _timePickerBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _timePickerBgView.layer.borderWidth = 1.f;
    [self.view addSubview:_timePickerBgView];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftBtn setTitleColor:RGBColor(98, 190, 255, 1.f) forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(transportTimeLeftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_timePickerBgView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timePickerBgView).offset(26);
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.top.equalTo(_timePickerBgView).offset(0);
    }];
    
    //    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    //    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    //    [rightBtn setTitleColor:RGBColor(98, 190, 255, 1.f) forState:UIControlStateNormal];
    //    [rightBtn addTarget:self action:@selector(transportTimeRightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    [_timePickerBgView addSubview:rightBtn];
    //    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.equalTo(_timePickerBgView).offset(-26);
    //        make.size.mas_equalTo(CGSizeMake(44, 44));
    //        make.top.equalTo(_timePickerBgView);
    //    }];
    
    for (NSInteger i = 0; i < descArr.count+1; i++) {
        UIView *view = [[UILabel alloc] init];
        view.backgroundColor = RGBColor(214, 214, 214, 1.f);
        [_timePickerBgView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_timePickerBgView);
            make.right.equalTo(_timePickerBgView);
            make.height.mas_equalTo(1);
            make.top.equalTo(_timePickerBgView).offset(44+i*30);
        }];
    }
    
    for (NSInteger i = 0; i < descArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:descArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:RGBColor(178, 178, 178, 1.f) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.tag = 200+i;
        [btn addTarget:self action:@selector(timeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_timePickerBgView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_timePickerBgView).offset(44+i*30);
            make.left.equalTo(_timePickerBgView).offset(26);
            make.right.equalTo(_timePickerBgView).offset(-26);
            make.height.mas_equalTo(30);
        }];
    }
    _timePickerBgView.hidden = YES;
}

- (void)configCityPicker
{
    _cityPickBgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216)];
    _cityPickBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_cityPickBgView];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftBtn setTitleColor:RGBColor(98, 190, 255, 1.f) forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(pickerLeftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_cityPickBgView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cityPickBgView).offset(26);
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.top.equalTo(_cityPickBgView).offset(0);
    }];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitleColor:RGBColor(98, 190, 255, 1.f) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(pickerRightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_cityPickBgView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_cityPickBgView).offset(-26);
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.top.equalTo(_cityPickBgView);
    }];
    
    NSArray *charactersArr = @[@"ABCDEF",@"HIJKL",@"MNOPQRS",@"TUVWXYZ"];
    for (NSInteger i = 0; i < charactersArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:charactersArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor darkGrayColor]];
        btn.tag = 300+i;
        [btn addTarget:self action:@selector(cityBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        if (i == 0) {
            [btn setBackgroundColor:[UIColor whiteColor]];
            _citySelectBtn = btn;
        }
        [_cityPickBgView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_cityPickBgView).offset(44);
            make.left.equalTo(_cityPickBgView).offset(i*SCREEN_WIDTH/4);
            make.height.mas_equalTo(33);
            make.width.mas_equalTo(SCREEN_WIDTH/4);
        }];
    }
    
    NSArray *cityArr = @[@[@"北京",@"大连",@"成都",@"重庆",@"东莞",@"长沙",@"长春",@"福州",@"佛山",@"常州"],
                         @[@"广州",@"杭州",@"济南",@"合肥",@"哈尔滨",@"昆明",@"洛阳",@"贵阳",@"惠州"],
                         @[@"深圳",@"上海",@"沈阳",@"南京",@"青岛",@"宁波",@"石家庄",@"苏州",@"南宁",@"泉州",@"三亚"],
                         @[@"武汉",@"天津",@"郑州",@"西安",@"太原",@"烟台",@"厦门",@"威海",@"无锡",@"珠海",@"扬州"]];
    
    for (NSInteger i = 0; i < cityArr.count; i++) {
        NSArray *subArr = cityArr[i];
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.tag = 400+i;
        [_cityPickBgView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_cityPickBgView).insets(UIEdgeInsetsMake(77, 0, 0, 0));
        }];
        for (NSInteger j = 0; j < subArr.count; j++) {
            
            NSInteger col = j/4;
            NSInteger row = j%4;
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:subArr[j] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            btn.layer.borderWidth = 1.f;
            [view addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view).offset(row*SCREEN_WIDTH/4);
                make.top.equalTo(view).offset(col*48);
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/4, 44));
            }];
        }
    }
    [_cityPickBgView bringSubviewToFront:[_cityPickBgView viewWithTag:400]];
    
    _cityPickBgView.hidden = YES;
}

- (void)configPersonInfo
{
    _personInfoDataArr = @[@{kPersonInfoTitle:@"员工信息",kPersonInfoImageName:@"yuangongxinxi"},
                           @{kPersonInfoTitle:@"我的订单",kPersonInfoImageName:@"wodexingcheng"},
                           @{kPersonInfoTitle:@"账户余额",kPersonInfoImageName:@"wodeqianbao"},
                           @{kPersonInfoTitle:@"代金券管理",kPersonInfoImageName:@"daijinquan"},
                           @{kPersonInfoTitle:@"设置",kPersonInfoImageName:@"shezhi"},
                           @{kPersonInfoTitle:@"退出登录",kPersonInfoImageName:@"tuichudenglu"}];
    //    _personInfoDataArr = @[@{kPersonInfoTitle:@"账户余额",kPersonInfoImageName:@"wodeqianbao"}];
    
    _personInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kPersonInfoTableViewHeight*6) style:UITableViewStylePlain];
    _personInfoTableView.bounces = NO;
    _personInfoTableView.backgroundColor = [UIColor whiteColor];
    _personInfoTableView.tableFooterView = [UIView new];
    _personInfoTableView.delegate = self;
    _personInfoTableView.dataSource = self;
    [self.view addSubview:_personInfoTableView];
    
    _personInfoTableView.hidden = YES;
    
}

- (void)configCoverView
{
    _coverView = [[UIView alloc] initWithFrame:self.view.bounds];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha = 0.3;
    [self.view addSubview:_coverView];
    _coverView.hidden = YES;
    _coverView.userInteractionEnabled = YES;
    UITapGestureRecognizer *coverViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverViewTap:)];
    [_coverView addGestureRecognizer:coverViewTap];
}

#pragma mark - viewWillAppear
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.translucent = YES;
}

#pragma mark - ViewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _currentPage = 0;
    _date = @"现在用车";
    _hour = [[Helper stringFromDate:[NSDate date]] componentsSeparatedByString:@":"][0];
    _minute = [[Helper stringFromDate:[NSDate date]] componentsSeparatedByString:@":"][1];
    self.view.backgroundColor = RGBColor(238, 238, 238, 1.f);
    
    [self configNavigationBar];
    [self configDataArr];
    [self configPageViewController];
    
    [self configCoverView];
    
    [self configDatePicker];
//    [self configTransportTimePicker];
    [self configCityPicker];
    [self configPersonInfo];
}

//获取最近八天时间 数组
- (NSMutableArray *)latelyEightTime{
    NSMutableArray *eightArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < 3; i ++) {
        //从现在开始的24小时
        NSTimeInterval secondsPerDay = i * 24*60*60;
        NSDate *curDate = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"M月d日"];
        NSString *dateStr = [dateFormatter stringFromDate:curDate];
        //几月几号
        NSDateFormatter *weekFormatter = [[NSDateFormatter alloc] init];
        [weekFormatter setDateFormat:@"EEEE"];
        //星期几 @"HH:mm 'on' EEEE MMMM d"];
        NSString *weekStr = [weekFormatter stringFromDate:curDate];
        //转换英文为中文
        NSString *chinaStr = [self cTransformFromE:weekStr];
        //组合时间
        NSString *strTime = [NSString stringWithFormat:@"%@ 周%@",dateStr,chinaStr];
        [eightArr addObject:strTime];
    }
    return eightArr;
}

//转换英文为中文
- (NSString *)cTransformFromE:(NSString *)theWeek{
    NSString *chinaStr;
    if(theWeek){
        if([theWeek isEqualToString:@"Monday"] || [theWeek isEqualToString:@"星期一"]){
            chinaStr = @"一";
        }else if([theWeek isEqualToString:@"Tuesday"] || [theWeek isEqualToString:@"星期二"]){
            chinaStr = @"二";
        }else if([theWeek isEqualToString:@"Wednesday"] || [theWeek isEqualToString:@"星期三"]){
            chinaStr = @"三";
        }else if([theWeek isEqualToString:@"Thursday"] || [theWeek isEqualToString:@"星期四"]){
            chinaStr = @"四";
        }else if([theWeek isEqualToString:@"Friday"] || [theWeek isEqualToString:@"星期五"]){
            chinaStr = @"五";
        }else if([theWeek isEqualToString:@"Saturday"] || [theWeek isEqualToString:@"星期六"]){
            chinaStr = @"六";
        }else if([theWeek isEqualToString:@"Sunday"] || [theWeek isEqualToString:@"星期日"]){
            chinaStr = @"日";
        }
    }
    return chinaStr;
}

#pragma mark - UIPickViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return dateArr.count;
    } else if (component == 1) {
        return hourArr.count;
    } else {
        return minArr.count;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        _date = dateArr[row];
    } else if (component == 1) {
        _hour = hourArr[row];
    } else {
        _minute = minArr[row];
    }
    UILabel *label = (UILabel *)[pickerView viewForRow:row forComponent:component];
    if ([label.text isEqualToString:@"现在用车"]) {
        hourArr = [@[] mutableCopy];
        minArr = [@[] mutableCopy];
        [pick reloadAllComponents];
    } else if ([label.text isEqualToString:@"今天"]) {
        NSDate *date = [NSDate date];
        NSString *dateStr = [Helper stringFromDate:date];
        hourArr = [@[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"] mutableCopy];
        minArr = [@[@"00",@"10",@"20",@"30",@"40",@"50"] mutableCopy];
        [hourArr removeObjectsAtIndexes:[[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, [[dateStr componentsSeparatedByString:@":"][0] integerValue] + 1)]];
        [minArr removeObjectsAtIndexes:[[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, [[dateStr componentsSeparatedByString:@":"][1] integerValue]/10 + 1)]];
        if ([[dateStr componentsSeparatedByString:@":"][1] integerValue]/10 == 5) {
            [hourArr removeObjectsAtIndexes:[[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, 1)]];
            minArr = [@[@"00",@"10",@"20",@"30",@"40",@"50"] mutableCopy];
        }
        if (hourArr.count != 0) {
            _hour = hourArr[0];
        } else {
            _hour = [NSString stringWithFormat:@"%li",[[[Helper stringFromDate:[NSDate date]] componentsSeparatedByString:@":"][0] integerValue]];
        }
        if (minArr.count != 0) {
            _minute = minArr[0];
        } else {
            _minute = @"00";
        }
        
        [pick reloadAllComponents];
    } else if (![_date isEqualToString:@"今天"] && ![_date isEqualToString:@"现在用车"]){
        hourArr = [@[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"] mutableCopy];
        minArr = [@[@"00",@"10",@"20",@"30",@"40",@"50"] mutableCopy];
        _hour = hourArr[0];
        _minute = minArr[0];
        [pick reloadAllComponents];
    }
    if (component == 0) {
        _date = dateArr[row];
    } else if (component == 1) {
        _hour = hourArr[row];
    } else {
        _minute = minArr[row];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, 30)];
    
    
    if (component == 0) {
        label.text = dateArr[row];
    } else if (component == 1) {
        if (hourArr) {
            _hour = hourArr[row];
            label.text = hourArr[row];
        }
    } else {
        if (minArr) {
            _minute = minArr[row];
            label.text = minArr[row];
        }
    }
    
    
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    if (component == 0) {
//        return dateArr[row];
//    } else if (component == 1) {
//        return hourArr[row];
//    } else if (component == 2) {
//        return minArr[row];
//    }
//    return nil;
//}

#pragma mark - UIPageViewControllerDelegate
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [_dataArr indexOfObject:viewController];
    if (index == 0) {
        return nil;
    }
    return _dataArr[index-1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [_dataArr indexOfObject:viewController];
    if (index+1 == _dataArr.count) {
        return nil;
    }
    return _dataArr[index+1];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    _currentPage = [_dataArr indexOfObject:pageViewController.viewControllers[0]];
    _selectBtn.selected = NO;
    _selectBtn = (UIButton *)[_navigationBar viewWithTag:_currentPage+100];
    _selectBtn.selected = YES;
    _indicatorView.x = (_currentPage+1)*SCREEN_WIDTH/6;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _personInfoDataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"CompanyHomeViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.imageView.image = [UIImage imageNamed:_personInfoDataArr[indexPath.row][kPersonInfoImageName]];
    cell.textLabel.text = _personInfoDataArr[indexPath.row][kPersonInfoTitle];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            EmployeeInfoViewController *employeeInfo = [[EmployeeInfoViewController alloc] init];
            [self.navigationController pushViewController:employeeInfo animated:YES];
            
            break;
        }
        case 1:
        {
            NYCompanyBillViewController *companyBill = [[NYCompanyBillViewController alloc] init];
            [self.navigationController pushViewController:companyBill animated:YES];
            break;
        }
        case 2:
        {
            AccountBalanceViewController *accountBalance = [[AccountBalanceViewController alloc] init];
            [self.navigationController pushViewController:accountBalance animated:YES];
            break;
        }
        case 3:
        {
            VoucherViewController *voucher = [[VoucherViewController alloc] init];
            [self.navigationController pushViewController:voucher animated:YES];
            break;
        }
        case 4:
        {
            SettingViewController *setting = [[SettingViewController alloc] init];
            [self.navigationController pushViewController:setting animated:YES];
            break;
        }
        case 5:
        {
            [MBProgressHUD showMessage:@"正在退出"];
            if (self.navigationController.viewControllers.count == 2) {
                BOOL a = [self.navigationController.viewControllers[1] isKindOfClass:[RegisViewController class]];
                if (a) {
                    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
                }
            }
            else {
                RegisViewController *regis = [[RegisViewController alloc] init];
                [UIApplication sharedApplication].keyWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:regis];
                _pageViewController = nil;
                _dataArr = nil;
                [USER_DEFAULT setValue:@"0" forKey:@"group_id"];
                [USER_DEFAULT setValue:@"0" forKey:@"isLogin"];
                [USER_DEFAULT synchronize];
            }
            [MBProgressHUD hideHUD];
        }
        default:
            break;
    }
    _personInfoTableView.y = SCREEN_HEIGHT;
    _coverView.hidden = YES;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.3 animations:^{
        //        pick.y = SCREEN_HEIGHT;
    }];
}

#pragma mark - Gesture
- (void)coverViewTap:(UITapGestureRecognizer *)tap
{
    if (_coverIsTouching) {
        return;
    }
    _coverIsTouching = YES;
    [UIView animateWithDuration:0.3 animations:^{
        _pickBgView.y = SCREEN_HEIGHT;
        _timePickerBgView.y = SCREEN_HEIGHT;
        _cityPickBgView.y = SCREEN_HEIGHT;
        _personInfoTableView.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        _coverView.hidden = !_coverView.hidden;
        _pickBgView.hidden = YES;
        _timePickerBgView.hidden = YES;
        _cityPickBgView.hidden = YES;
        _personInfoTableView.hidden = YES;
        _coverIsTouching = NO;
    }];
}

#pragma mark - Action
- (void)navBtnClicked:(UIButton *)btn
{
    if (btn.selected == YES) {
        return;
    }
    NSInteger index = btn.tag - 100;
    btn.selected = YES;
    _selectBtn.selected = NO;
    _selectBtn = btn;
    [UIView animateWithDuration:0.3 animations:^{
        _indicatorView.x = (index+1)*SCREEN_WIDTH/6;
    } completion:^(BOOL finished) {
        
    }];
    [_pageViewController setViewControllers:@[_dataArr[btn.tag - 100]] direction:_currentPage > index animated:YES completion:^(BOOL finished) {
        _currentPage = index;
    }];
}

- (void)pickerLeftBtnClicked:(UIButton *)btn
{
    [UIView animateWithDuration:0.3 animations:^{
        _pickBgView.y = SCREEN_HEIGHT;
        _timePickerBgView.y = SCREEN_HEIGHT;
        _cityPickBgView.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        _coverView.hidden = !_coverView.hidden;
        _pickBgView.hidden = YES;
        _timePickerBgView.hidden = YES;
        _cityPickBgView.hidden = YES;
    }];
}

- (void)pickerRightBtnClicked:(UIButton *)btn
{
    
    if ([_date isEqualToString:@"今天"]) {
        _date = [self latelyEightTime][0];
    } else if ([_date isEqualToString:@"现在用车"]){
        _date = [self latelyEightTime][0];
        _hour = [[Helper stringFromDate:[NSDate date]] componentsSeparatedByString:@":"][0];
        _minute = [[Helper stringFromDate:[NSDate date]] componentsSeparatedByString:@":"][1];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TransportTimeChanged" object:@"现在用车"];
        [UIView animateWithDuration:0.3 animations:^{
            _pickBgView.y = SCREEN_HEIGHT;
            _timePickerBgView.y = SCREEN_HEIGHT;
            _cityPickBgView.y = SCREEN_HEIGHT;
            
            id viewcontroller = _dataArr[_currentPage];
            
            if ([viewcontroller isKindOfClass:[SpecialCarViewController class]]) {
                SpecialCarViewController *vc = (SpecialCarViewController *)viewcontroller;
                [vc.timeBtn setTitle:@"现在用车" forState:UIControlStateNormal];
            } else if ([viewcontroller isKindOfClass:[CharteredBusViewController class]]) {
                CharteredBusViewController *vc = (CharteredBusViewController *)viewcontroller;
                [vc.timeBtn setTitle:@"现在用车" forState:UIControlStateNormal];
            } else if ([viewcontroller isKindOfClass:[AirportPickupViewController class]]) {
                AirportPickupViewController *vc = (AirportPickupViewController *)viewcontroller;
                [vc.timeBtn setTitle:@"现在用车" forState:UIControlStateNormal];
            } else { // [AirportDropOffViewController class]
                AirportDropOffViewController *vc = (AirportDropOffViewController *)viewcontroller;
                [vc.timeBtn setTitle:@"现在用车" forState:UIControlStateNormal];
            }
        } completion:^(BOOL finished) {
            _coverView.hidden = !_coverView.hidden;
            _pickBgView.hidden = YES;
            _timePickerBgView.hidden = YES;
            _cityPickBgView.hidden = YES;
        }];
        return;
    }
    NSString *time = [NSString stringWithFormat:@"%@ %@时%@分",_date,_hour,_minute];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TransportTimeChanged" object:time];
    [UIView animateWithDuration:0.3 animations:^{
        _pickBgView.y = SCREEN_HEIGHT;
        _timePickerBgView.y = SCREEN_HEIGHT;
        _cityPickBgView.y = SCREEN_HEIGHT;
        
        id viewcontroller = _dataArr[_currentPage];
        
        if ([viewcontroller isKindOfClass:[SpecialCarViewController class]]) {
            SpecialCarViewController *vc = (SpecialCarViewController *)viewcontroller;
            [vc.timeBtn setTitle:time forState:UIControlStateNormal];
        } else if ([viewcontroller isKindOfClass:[CharteredBusViewController class]]) {
            CharteredBusViewController *vc = (CharteredBusViewController *)viewcontroller;
            [vc.timeBtn setTitle:time forState:UIControlStateNormal];
        } else if ([viewcontroller isKindOfClass:[AirportPickupViewController class]]) {
            AirportPickupViewController *vc = (AirportPickupViewController *)viewcontroller;
            [vc.timeBtn setTitle:time forState:UIControlStateNormal];
        } else { // [AirportDropOffViewController class]
            AirportDropOffViewController *vc = (AirportDropOffViewController *)viewcontroller;
            [vc.timeBtn setTitle:time forState:UIControlStateNormal];
        }
        if ([_date isEqualToString:[self latelyEightTime][0]]) {
            _date = @"今天";
        } else if ([_date isEqualToString:[self latelyEightTime][0]]){
            _date = @"现在用车";
            _hour = [[Helper stringFromDate:[NSDate date]] componentsSeparatedByString:@":"][0];
            _minute = [[Helper stringFromDate:[NSDate date]] componentsSeparatedByString:@":"][1];
        }
    } completion:^(BOOL finished) {
        _coverView.hidden = !_coverView.hidden;
        _pickBgView.hidden = YES;
        _timePickerBgView.hidden = YES;
        _cityPickBgView.hidden = YES;
    }];
}

- (void)cityBtnClicked:(UIButton *)btn
{
    if (_citySelectBtn != btn) {
        [btn setBackgroundColor:[UIColor whiteColor]];
        [_citySelectBtn setBackgroundColor:[UIColor darkGrayColor]];
        _citySelectBtn = btn;
        [_cityPickBgView bringSubviewToFront:[_cityPickBgView viewWithTag:btn.tag + 100]];
    }
}

- (void)timeBtnClicked:(UIButton *)btn
{
    [UIView animateWithDuration:0.3 animations:^{
        _pickBgView.y = SCREEN_HEIGHT;
        _timePickerBgView.y = SCREEN_HEIGHT;
        _cityPickBgView.y = SCREEN_HEIGHT;
    }];
    _coverView.hidden = YES;
    id viewcontroller = _dataArr[_currentPage];
    if (![viewcontroller isKindOfClass:[CharteredBusViewController class]]) {
        return;
    } else {
        CharteredBusViewController *vc = (CharteredBusViewController *)viewcontroller;
        [vc.durationBtn setTitle:btn.currentTitle forState:UIControlStateNormal];
        [vc changeThePrice];
    }
}

- (void)transportTimeLeftBtnClicked:(UIButton *)btn
{
    [UIView animateWithDuration:0.3 animations:^{
        _timePickerBgView.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        _coverView.hidden = YES;
        _timePickerBgView.hidden = YES;
    }];
}

//- (void)transportTimeRightBtnClicked:(UIButton *)btn
//{
//    [UIView animateWithDuration:0.3 animations:^{
//        _timePickerBgView.y = SCREEN_HEIGHT;
//    } completion:^(BOOL finished) {
//        _coverView.hidden = YES;
//        _timePickerBgView.hidden = YES;
//    }];
//}

- (void)leftBarButtonItemClicked:(UIButton *)btn
{
    _coverView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _personInfoTableView.y = SCREEN_HEIGHT-kPersonInfoTableViewHeight*6;
        _personInfoTableView.hidden = NO;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)rightBarButtonItemClicked:(UIButton *)btn
{
    
}

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

@end
