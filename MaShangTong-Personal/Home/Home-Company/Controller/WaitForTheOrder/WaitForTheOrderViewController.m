//
//  WaitForTheOrderViewController.m
//  MaShangTong-Personal
//
//  Created by NY on 15/11/26.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "WaitForTheOrderViewController.h"
#import "AMapNaviKit.h"
#import "NavPointAnnotation.h"
#import <iflyMSC/iflyMSC.h>
#import "AMapSearchAPI.h"
#import "MANaviRoute.h"
#import "PayChargeViewController.h"
#import "ActualPriceModel.h"
#import "DriverInfoModel.h"
#import "DriverInfoCell.h"
#import "PassengerMessageModel.h"
#import "ValuationRuleModel.h"
#import "AirportPickupModel.h"
#import "NYCalculateSpecialCarPrice.h"
#import "NYCalculateCharteredBusPrice.h"

@interface WaitForTheOrderViewController () <MAMapViewDelegate,UITableViewDataSource,UITableViewDelegate,IFlySpeechSynthesizerDelegate,AMapSearchDelegate,AMapNaviManagerDelegate>
{
    BOOL isPullDown;
    BOOL isDriverCatch;// 司机是否已接单
    BOOL _iscalculateStart;
    NSInteger _actualDistance;
    
    UILabel *distanceLabel;
    UILabel *speedLabel;
    UILabel *priceLabel;
    
    CLLocationSpeed _speed;
    
    NSString *_totalPrice;
    
    DriverInfoModel *infoModel;
    
    NSInteger _route_status;
    
    ReservationType _reservationType;
}
@property (nonatomic,strong) MAMapView *mapView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NavPointAnnotation *navPoint;
@property (nonatomic,assign) CLLocationCoordinate2D driverCoordinate;
@property (nonatomic,strong) AMapNaviManager *naviManager;
@property (nonatomic,strong) MAPinAnnotationView *annotationView;

@property (nonatomic,strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;
@property (nonatomic,strong) AMapSearchAPI *search;
@property (nonatomic,strong) MANaviRoute * naviRoute;

@property (nonatomic,assign) NSInteger driveringTime;
@property (nonatomic,assign) BOOL calculaterWitch; // 0 到乘客的距离，1 到达目的地的距离
@property (nonatomic,assign) DriverState lastState;
@property (nonatomic,strong) UIView *chargingBgView;
@property (nonatomic,strong) ActualPriceModel *actualPriceModel;
@property (nonatomic,strong) AMapPath *driverPath;
@property (nonatomic,strong) NYCalculateSpecialCarPrice *calculateSpecialCar;
@property (nonatomic,strong) NYCalculateCharteredBusPrice *calculateCharteredBus;

@end

@implementation WaitForTheOrderViewController

- (NYCalculateSpecialCarPrice *)calculateSpecialCar
{
    if (_calculateSpecialCar == nil) {
        _calculateSpecialCar = [NYCalculateSpecialCarPrice sharedPrice];
        _calculateSpecialCar.model = _specialCarRuleModel;
    }
    return _calculateSpecialCar;
}

- (NYCalculateCharteredBusPrice *)calculateCharteredBus
{
    if (_calculateCharteredBus == nil) {
        _calculateCharteredBus = [NYCalculateCharteredBusPrice shareCharteredBusPrice];
        _calculateCharteredBus.rule = _charteredBusRule;
    }
    return _calculateCharteredBus;
}

- (void)initIFlySpeech
{
    if (self.iFlySpeechSynthesizer == nil)
    {
        _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    }
    _iFlySpeechSynthesizer.delegate = self;
}

- (void)initMapView
{
    _mapView = [[SharedMapView sharedInstance] mapView];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    [_mapView setZoomLevel:16 animated:YES];
    _mapView.rotateEnabled = NO;
    _mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    _mapView.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:_mapView];
}

- (void)configNavigationBar
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    self.navigationItem.title = @"等待接单";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UILabel *rightLabel = [[UILabel alloc] init];
    rightLabel.text = @"取消行程";
    rightLabel.textAlignment = 1;
    rightLabel.textColor = [UIColor whiteColor];
    rightLabel.font = [UIFont systemFontOfSize:13];
    rightLabel.size = CGSizeMake(60, 15);
    rightLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *rightLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightLabelTaped:)];
    [rightLabel addGestureRecognizer:rightLabelTap];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = RGBColor(84, 175, 255, 1.f);
    [_mapView setCenterCoordinate:_passengerCoordinate animated:YES];
    [_mapView setZoomLevel:16 animated:YES];
    
    NSLog(@"%@",NSStringFromCGRect(self.view.bounds));
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.mapView.showsUserLocation = NO;
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.mapView removeOverlays:self.mapView.overlays];
    
    self.mapView.delegate = nil;
    
    self.naviManager = nil;
    
    [[SharedMapView sharedInstance] popMapViewStatus];
    
    [self.mapView removeFromSuperview];
    
    self.mapView = nil;
    
    [self.iFlySpeechSynthesizer stopSpeaking];
    
    self.iFlySpeechSynthesizer.delegate = nil;
    
}

- (void)configDriverInfo {
    
    // TableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    // TableHeaderView
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 74)];
    
    UIImageView *headerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sijitouxiang"]];
    [bgView addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).with.offset(10);
        make.left.equalTo(bgView).with.offset(25);
        make.size.mas_equalTo(CGSizeMake(64, 64));
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"";
    nameLabel.tag = 100;
    nameLabel.font = [UIFont systemFontOfSize:20];
    [bgView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).with.offset(72);
        make.top.equalTo(bgView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 24));
    }];
    
    UILabel *licenseLabel = [[UILabel alloc] init];
    licenseLabel.text = @"";
    licenseLabel.tag = 200;
    licenseLabel.textColor = RGBColor(179, 179, 179, 1);
    licenseLabel.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:licenseLabel];
    [licenseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).with.offset(72);
        make.top.equalTo(nameLabel).with.offset(25);
        make.size.mas_equalTo(CGSizeMake(60, 18));
    }];
    
    UILabel *companyLabel = [[UILabel alloc] init];
    companyLabel.text = @"";
    companyLabel.tag = 300;
    companyLabel.font = [UIFont systemFontOfSize:12];
    companyLabel.textColor = RGBColor(179, 179, 179, 1);
    [bgView addSubview:companyLabel];
    [companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(licenseLabel).with.offset(65);
        make.top.equalTo(nameLabel).with.offset(25);
        make.size.mas_equalTo(CGSizeMake(60, 18));
    }];
    
    for (NSInteger i = 0; i < 5; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pingfen"]];
        [bgView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel).with.offset(10*i);
            make.top.equalTo(licenseLabel).with.offset(20);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
    }
    
    UILabel *billLabel = [[UILabel alloc] init];
    billLabel.text = @"";
    billLabel.tag = 400;
    billLabel.textColor = RGBColor(179, 179, 179, 1);
    billLabel.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:billLabel];
    [billLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(licenseLabel).offset(18);
        make.left.equalTo(nameLabel).with.offset(55);
        make.size.mas_equalTo(CGSizeMake(60, 14));
    }];
    
    UIImageView *dailImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dail"]];
    dailImageView.userInteractionEnabled = YES;
    [bgView addSubview:dailImageView];
    [dailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView).offset(-5);
        make.right.equalTo(bgView).offset(-20);
        make.size.mas_equalTo(CGSizeMake(48, 48));
    }];
    UITapGestureRecognizer *dailImageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(telImageTaped:)];
    [dailImageView addGestureRecognizer:dailImageViewTap];
    
    tableView.tableHeaderView = bgView;
    
    // TableFooterView
    UIView *footerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 26)];
    
    UILabel *pullDownLabel = [[UILabel alloc] init];
    pullDownLabel.text = @"下拉查看详细信息";
    pullDownLabel.textAlignment = 1;
    pullDownLabel.font = [UIFont systemFontOfSize:12];
    pullDownLabel.textColor = RGBColor(157, 157, 157, 1.f);
    [footerBgView addSubview:pullDownLabel];
    pullDownLabel.tag = 100;
    [pullDownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(footerBgView).insets(UIEdgeInsetsMake(0, 0, 15, 0));
    }];
    
    UIButton *pullDownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pullDownBtn setImage:[UIImage imageNamed:@"gengduo"] forState:UIControlStateNormal];
    [footerBgView addSubview:pullDownBtn];
    [pullDownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(pullDownLabel);
        make.bottom.equalTo(footerBgView).offset(0);
        make.size.mas_equalTo(CGSizeMake(20, 10));
    }];
    
    footerBgView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *pullDown = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pullDownBtnClicked:)];
    [footerBgView addGestureRecognizer:pullDown];
    
    tableView.tableFooterView = footerBgView;
    
    self.tableView.hidden = YES;
}

- (void)initTimer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    } else {
        [_timer setFireDate:[NSDate distantPast]];
    }
}

- (void)initNaviManager
{
    if (self.naviManager == nil)
    {
        _naviManager = [[AMapNaviManager alloc] init];
    }
}

- (void)initChargingBgView
{
    _chargingBgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64, SCREEN_WIDTH, 70)];
    _chargingBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_chargingBgView];
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"0 元"];
    [attri addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:24],NSForegroundColorAttributeName : RGBColor(44, 44, 44, 1.f)} range:NSMakeRange(0, 2)];
    [attri addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13],NSForegroundColorAttributeName : RGBColor(157, 157, 157, 1.f)} range:NSMakeRange(2, 1)];
    
    priceLabel = [[UILabel alloc] init];
    priceLabel.attributedText = attri;
    priceLabel.frame = CGRectMake(0, 0, 186, 40);
    priceLabel.textAlignment = NSTextAlignmentRight;
    [_chargingBgView addSubview:priceLabel];
    
    distanceLabel = [[UILabel alloc] init];
    distanceLabel.text = @"里程0公里";
    distanceLabel.textAlignment = 0;
    distanceLabel.textColor = RGBColor(131, 131, 131, 1.f);
    distanceLabel.font = [UIFont systemFontOfSize:11];
    distanceLabel.frame = CGRectMake(CGRectGetMaxX(priceLabel.frame), priceLabel.y, 200, 20);
    [_chargingBgView addSubview:distanceLabel];
    
    speedLabel = [[UILabel alloc] init];
    speedLabel.text = @"低速0分钟";
    speedLabel.textAlignment = 0;
    speedLabel.textColor = RGBColor(131, 131, 131, 1.f);
    speedLabel.font = [UIFont systemFontOfSize:11];
    speedLabel.frame = CGRectMake(CGRectGetMaxX(priceLabel.frame), CGRectGetMaxY(distanceLabel.frame), distanceLabel.width, distanceLabel.height);
    [_chargingBgView addSubview:speedLabel];
    
    _chargingBgView.hidden = YES;
}

- (void)reloadChargingBgViewWithJson:(NSDictionary *)json
{
    NSString *price = json[@"price"];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:price];
    [attri addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:24],NSForegroundColorAttributeName : RGBColor(44, 44, 44, 1.f)} range:NSMakeRange(0, price.length)];
    [attri addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13],NSForegroundColorAttributeName : RGBColor(157, 157, 157, 1.f)} range:NSMakeRange(price.length, 1)];
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.attributedText = attri;
    
    distanceLabel.text = [NSString stringWithFormat:@"里程%.2f公里",[json[@"distance"] floatValue]/1000];
    speedLabel.text = [NSString stringWithFormat:@"低速%.2f分钟",[json[@"time"] floatValue]/60];
}

#pragma mark - ViewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    _calculaterWitch = 0;
    _driveringTime = 0;
    _lastState = 0;
    _iscalculateStart = 0;
    _actualDistance = 0;
    
    [self configNavigationBar];
    [self initMapView];
    [self initIFlySpeech];
    [self configDriverInfo];
    [self initChargingBgView];
    [self initTimer];
}

#pragma mark - Timer
- (void)updateTime
{
    _driveringTime ++;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_route_id forKey:@"route_id"];
    // 10s请求一次订单状态
    if (_driveringTime % 10 == 0) {
        [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"near_cars"] params:params success:^(id json) {
            
            @try {
                if (!json) {
                    return ;
                }
                NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"result"]];
                if ([resultStr isEqualToString:@"0"]) {
                    return ;
                }
                NSString *routeStatus = [NSString stringWithFormat:@"%@",json[@"data"][@"route_status"]];
                if ([routeStatus isEqualToString:@"0"]) {
                    return;
                } else {
                    isDriverCatch = 1;
                    switch ([routeStatus integerValue]) {
                        case 1:
                        {
                            if (_lastState != DriverStateOrderReceive) {
                                _route_status = 1;
                                self.navigationItem.title = @"等待接驾";
                                [_iFlySpeechSynthesizer startSpeaking:@"司机师傅已接单，请在路边等待"];
                                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                                [param setValue:self.route_id forKey:@"route_id"];
                                [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"orderApi",@"dri_info"] params:param success:^(id json) {
                                    infoModel = [[DriverInfoModel alloc] initWithDictionary:json[@"data"] error:nil];
                                    UIView *tableHeaderView = self.tableView.tableHeaderView;
                                    UILabel *nameLabel = (UILabel *)[tableHeaderView viewWithTag:100];
                                    UILabel *licenseLabel = (UILabel *)[tableHeaderView viewWithTag:200];
                                    UILabel *companyLabel = (UILabel *)[tableHeaderView viewWithTag:300];
                                    UILabel *billLabell = (UILabel *)[tableHeaderView viewWithTag:400];
                                    nameLabel.text = infoModel.owner_name;
                                    licenseLabel.text = infoModel.license_plate;
                                    companyLabel.text = @"";
                                    billLabell.text = [NSString stringWithFormat:@"%@单",infoModel.num];
                                    self.tableView.hidden = NO;
                                } failure:^(NSError *error) {
                                    
                                }];
                                // 记录是哪种行程
                                NSString *reservaTypeStr = [NSString stringWithFormat:@"%@",json[@"data"][@"reserva_type"]];
                                if ([reservaTypeStr isEqualToString:@"1"]) {
                                    _reservationType = ReservationTypeSpecialCar;
                                } else if ([reservaTypeStr isEqualToString:@"2"]) {
                                    _reservationType = ReservationTypeCharteredBus;
                                } else if ([reservaTypeStr isEqualToString:@"3"]) {
                                    _reservationType = ReservationTypeAirportPickUp;
                                } else if ([reservaTypeStr isEqualToString:@"4"]) {
                                    _reservationType = ReservationTypeAirportDropOff;
                                }
                            }
                            _lastState = DriverStateOrderReceive;
                            break;
                        }
                        case 2:
                        {
                            if (_lastState != DriverStateReachAppointment) {
                                _route_status = 2;
                                [_iFlySpeechSynthesizer startSpeaking:@"司机师傅已到达约定地点"];
                            }
                            _lastState = DriverStateReachAppointment;
                            break;
                        }
                        case 3:
                        {
                            if (_lastState != DriverStateBeginCharge) {
                                _route_status = 3;
                                self.navigationItem.title = @"行程中";
                                [_iFlySpeechSynthesizer startSpeaking:@"司机师傅已开始计费"];
                                _chargingBgView.y = SCREEN_HEIGHT-70-34;
                                _chargingBgView.hidden = NO;
                                _calculaterWitch = 1;
                                _iscalculateStart = 1;
                            }
                            _lastState = DriverStateBeginCharge;
                            break;
                        }
                        case 4:
                        {
                            if (_lastState != DriverStateArriveDestination) {
                                _route_status = 4;
                                [_iFlySpeechSynthesizer startSpeaking:@"司机师傅正在确认价格，请稍后"];
                                _iscalculateStart = 0;
                            }
                            _lastState = DriverStateArriveDestination;
                            break;
                        }
                        case 5:
                        {
                            if (_lastState != DriverStatePayOver) {
                                _route_status = 5;
                                [_iFlySpeechSynthesizer startSpeaking:@"您已到达目的地，请付费"];
                                PayChargeViewController *pay = [[PayChargeViewController alloc] init];
                                pay.actualPriceModel = _actualPriceModel;
                                pay.passengerMessageModel = self.model;
                                pay.route_id = self.route_id;
                                pay.driverInfoModel = infoModel;
                                [self.navigationController pushViewController:pay animated:YES];
                                [_timer setFireDate:[NSDate distantFuture]];
                            }
                            _lastState = DriverStatePayOver;
                            break;
                        }
                        default:
                            break;
                    }
                    NSString *locationStr = json[@"data"][@"location"];
                    if ([locationStr isEqualToString:@""]) {
                        return;
                    }
                    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([[locationStr componentsSeparatedByString:@","][1] floatValue], [[locationStr componentsSeparatedByString:@","][0] floatValue]);
                    _driverCoordinate = location;
                    if (_navPoint) {
                        [self.mapView removeAnnotation:_navPoint];
                        _navPoint = nil;
                    }
                    _navPoint = [[NavPointAnnotation alloc] init];
                    _navPoint.coordinate = location;
                    _navPoint.title = @"司机位置";
                    [self.mapView addAnnotation:_navPoint];
                }
            }
            @catch (NSException *exception) {
                
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUD];
        }];
    }
    
    if (_iscalculateStart) {
        switch (_reservationType) {
            // 专车
            case ReservationTypeSpecialCar:
            {
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                if (_speed == -1) {
                    _speed = 0;
                }
                NSString *isLowSpeed = @"0";
                if (_speed <= 3.4) {
                    isLowSpeed = @"1";
                }
                [params setValue:[NSString stringWithFormat:@"%f",_speed] forKey:@"distance"];
                [params setValue:self.route_id forKey:@"route_id"];
                [params setValue:[NSString stringWithFormat:@"%li",(long)_route_status] forKey:@"route_status"];
                [params setValue:isLowSpeed forKey:@"time"];
                
                NSMutableDictionary *priceDic = [[self.calculateSpecialCar calculatePriceWithParams:params] mutableCopy];
                distanceLabel.text = [NSString stringWithFormat:@"里程%.2f公里",[priceDic[@"mileage"] floatValue]];
                speedLabel.text = [NSString stringWithFormat:@"低速%li分钟",[priceDic[@"low_time"] integerValue]/60];
                _totalPrice = [NSString stringWithFormat:@"%.2f元",[priceDic[@"total_price"] floatValue]];
                NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:_totalPrice];
                [attri addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:22],NSForegroundColorAttributeName : RGBColor(44, 44, 44, 1.f)} range:NSMakeRange(0, _totalPrice.length)];
                priceLabel.attributedText = attri;
                [priceDic setValue:_specialCarRuleModel.step forKey:@"start_price"];
                [priceDic setValue:_route_id forKey:@"route_id"];
                if (_driveringTime % 60) {
                    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"billing"] params:priceDic success:^(id json) {
                        
                    } failure:^(NSError *error) {
                        
                    }];
                }
                break;
            }
            // 包车
            case ReservationTypeCharteredBus:
            {
                speedLabel.hidden = YES;
                if (_speed == -1) {
                    _speed = 0;
                }
                NSArray *priceArr = [self.calculateCharteredBus calculatePriceWithSpeed:_speed];
                distanceLabel.text = [NSString stringWithFormat:@"里程%.2f公里",[priceArr[1] floatValue]];
                priceLabel.text = [NSString stringWithFormat:@"%.0f元",[priceArr[0] floatValue]];
                if (_driveringTime%60 == 0) {
                    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"billing"] params:priceDic success:^(id json) {
                        
                    } failure:^(NSError *error) {
                        
                    }];
                }
                break;
            }
            // 接机，送机
            case ReservationTypeAirportPickUp | ReservationTypeAirportDropOff:
            {
                distanceLabel.hidden = YES;
                speedLabel.hidden = YES;
                priceLabel.text = [NSString stringWithFormat:@"%.0f",_airportModel.once_price.floatValue];
                if (_driveringTime%60 == 0) {
                    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"billing"] params:priceDic success:^(id json) {
                        
                    } failure:^(NSError *error) {
                        
                    }];
                }
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark - MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        [_mapView setCenterCoordinate:userLocation.coordinate animated:YES];
        [_mapView setZoomLevel:16 animated:YES];
    });
    _passengerCoordinate = userLocation.coordinate;
    _speed = userLocation.location.speed;
    
    if (_iscalculateStart && userLocation.location.speed >= 0) {
        _actualDistance += userLocation.location.speed;
    }
    
    if (isDriverCatch) {
        [mapView setSelectedAnnotations:@[userLocation]];
        AMapDrivingRouteSearchRequest *request = [[AMapDrivingRouteSearchRequest alloc] init];
        request.origin = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
        if (!_calculaterWitch) {
            request.destination = [AMapGeoPoint locationWithLatitude:_driverCoordinate.latitude longitude:_driverCoordinate.longitude];
        } else {
            PassengerMessageModel *model = _model;
            request.destination = [AMapGeoPoint locationWithLatitude:[[model.end_coordinates componentsSeparatedByString:@","][1] floatValue] longitude:[[model.end_coordinates componentsSeparatedByString:@","][0] floatValue]];
        }
        
        request.strategy = 0;//结合交通实际情况
        request.requireExtension = YES;
        if (!_search) {
            _search = [[AMapSearchAPI alloc] init];
            _search.delegate = self;
        }
        [_search AMapDrivingRouteSearch:request];
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[NavPointAnnotation class]]) {
        if (_navPoint && _annotationView) {
            [self.mapView removeAnnotation:_navPoint];
            [_annotationView removeFromSuperview];
            _navPoint = nil;
        }
        static NSString *anIde = @"NaviAnnotation";
        _annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:anIde];
        if (!_annotationView) {
            _annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:anIde];
            _annotationView.centerOffset = CGPointMake(0, 0);
            _annotationView.canShowCallout = YES;
        }
        _annotationView.image = [UIImage imageNamed:@"sijidingwei"];
        return _annotationView;
    } else if ([annotation isKindOfClass:[MAUserLocation class]]) {
        static NSString *anIde = @"PointAnnotation";
        MAAnnotationView *view = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:anIde];
        
        if (!view) {
            view = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:anIde];
            view.image = [UIImage imageNamed:@"dingwei"];
            view.draggable = YES;
            view.canShowCallout = YES;
        }
        return view;
    }
    return nil;
}

#pragma mark - AMapSearchAPIDelegate
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if(response.route == nil)
    {
        return;
    }
    MANaviAnnotationType type = MANaviAnnotationTypeDrive;
    
    AMapPath *path = response.route.paths[0];
    self.naviRoute = [MANaviRoute naviRouteForPath:path withNaviType:type];
    _driverPath = path;
}

#pragma mark - IFlySpeechSynthesizerDelegate
- (void) onCompleted:(IFlySpeechError*) error
{
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isPullDown) {
        return 180;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isPullDown) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseId = @"DriverInfoCell";
    DriverInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DriverInfoCell" owner:nil options:nil] lastObject];
    }
    cell.originNameLabel.text = infoModel.origin_name;
    cell.endNameLabel.text = infoModel.end_name;
    cell.dateLabel.text = infoModel.create_time;
    return cell;
}

#pragma mark - Action
- (void)backBtnClicked:(UIButton *)btn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Gesture
- (void)pullDownBtnClicked:(UITapGestureRecognizer *)pullDown
{
    isPullDown = !isPullDown;
    [UIView animateWithDuration:0.3 animations:^{
        
        self.tableView.height = isPullDown ? 280 : 100;
        
    } completion:^(BOOL finished) {
        
        ((UILabel *)[_tableView.tableFooterView viewWithTag:100]).text = isPullDown ? @"上拉查看地图" : @"下拉查看详细信息";
        
    }];
    
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)rightLabelTaped:(UITapGestureRecognizer *)tap
{
    if (_lastState == DriverStateNone) {
        __weak typeof(self) weakSelf = self;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确定要取消行程吗？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [MBProgressHUD showMessage:@"正在取消订单"];
            [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"cacelorder"] params:@{@"user":[USER_DEFAULT objectForKey:@"user_id"] ,@"route_id":_route_id} success:^(id json) {
                NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"result"]];
                [MBProgressHUD hideHUD];
                if ([resultStr isEqualToString:@"1"]) {
                    [MBProgressHUD showSuccess:@"取消订单成功"];
                    [_timer setFireDate:[NSDate distantFuture]];
                    if (_timer.valid) {
                        [_timer invalidate];
                    }
                    _timer = nil;
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                } else {
                    [MBProgressHUD showError:@"取消订单失败"];
                }
            } failure:^(NSError *error) {
                
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"请求失败，请重试"];
                NYLog(@"%@",error.localizedDescription);
            }];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        __weak typeof(self) weakSelf = self;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"司机师傅已接单，是否确定取消行程？" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [MBProgressHUD showMessage:@"正在取消订单"];
            [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"cacelorder"] params:@{@"user":[USER_DEFAULT objectForKey:@"user_id"] ,@"route_id":_route_id} success:^(id json) {
                NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"result"]];
                [MBProgressHUD hideHUD];
                if ([resultStr isEqualToString:@"1"]) {
                    [MBProgressHUD showSuccess:@"取消订单成功"];
                    [_timer setFireDate:[NSDate distantFuture]];
                    if (_timer.valid) {
                        [_timer invalidate];
                    }
                    _timer = nil;
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                } else {
                    [MBProgressHUD showError:@"取消订单失败"];
                }
            } failure:^(NSError *error) {
                
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"请求失败，请重试"];
                NYLog(@"%@",error.localizedDescription);
                
            }];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - telImageTaped
- (void)telImageTaped:(UITapGestureRecognizer *)tap
{
    if (!infoModel) {
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:infoModel.mobile message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",infoModel.mobile]]];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)dealloc
{
    NYLog(@"%s",__FUNCTION__);
}

@end
