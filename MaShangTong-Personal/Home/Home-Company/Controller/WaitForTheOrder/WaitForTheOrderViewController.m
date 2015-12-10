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

@interface WaitForTheOrderViewController () <MAMapViewDelegate,UITableViewDataSource,UITableViewDelegate,IFlySpeechSynthesizerDelegate,AMapSearchDelegate>
{
    BOOL isPullDown;
    BOOL isDriverCatch;// 司机是否已接单
    BOOL _iscalculateStart;
    NSInteger _actualDistance;
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

@end

@implementation WaitForTheOrderViewController

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
    _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];
}

- (void)configNavigationBar
{
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
    backBtn.size = CGSizeMake(44, 44);
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    label.text = @"等待接单";
    label.textAlignment = 1;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = label;
    
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
    [_mapView setZoomLevel:14 animated:YES];
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
    nameLabel.text = @"徐师傅";
    nameLabel.font = [UIFont systemFontOfSize:20];
    [bgView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).with.offset(72);
        make.top.equalTo(bgView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 24));
    }];
    
    UILabel *licenseLabel = [[UILabel alloc] init];
    licenseLabel.text = @"沪F88888";
    licenseLabel.textColor = RGBColor(179, 179, 179, 1);
    licenseLabel.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:licenseLabel];
    [licenseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).with.offset(72);
        make.top.equalTo(nameLabel).with.offset(25);
        make.size.mas_equalTo(CGSizeMake(60, 18));
    }];
    
    UILabel *companyLabel = [[UILabel alloc] init];
    companyLabel.text = @"友联出租";
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
    billLabel.text = @"26666单";
    billLabel.textColor = RGBColor(179, 179, 179, 1);
    billLabel.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:billLabel];
    [billLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(licenseLabel).offset(18);
        make.left.equalTo(nameLabel).with.offset(55);
        make.size.mas_equalTo(CGSizeMake(60, 14));
    }];
    
    UIImageView *dailImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dail"]];
    [bgView addSubview:dailImageView];
    [dailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView).offset(-5);
        make.right.equalTo(bgView).offset(-20);
        make.size.mas_equalTo(CGSizeMake(48, 48));
    }];
    
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
    
    //    self.naviManager.delegate = self;
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
    [self initTimer];
}

#pragma mark - Timer
- (void)updateTime
{
    _driveringTime ++;
    UILabel *navTitleLabel = (UILabel *)self.navigationItem.titleView;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_route_id forKey:@"route_id"];
    [DownloadManager post:@"http://112.124.115.81/m.php?m=OrderApi&a=near_cars" params:params success:^(id json) {
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
                        navTitleLabel.text = @"等待接驾";
                        self.tableView.hidden = NO;
                        [_iFlySpeechSynthesizer startSpeaking:@"司机师傅已接单，请在路边等待"];
                    }
                    _lastState = DriverStateOrderReceive;
                    break;
                }
                case 2:
                {
                    if (_lastState != DriverStateReachAppointment) {
                        [_iFlySpeechSynthesizer startSpeaking:@"司机师傅已到达约定地点"];
                    }
                    _lastState = DriverStateReachAppointment;
                    break;
                }
                case 3:
                {
                    if (_lastState != DriverStateBeginCharge) {
                        navTitleLabel.text = @"行程中";
                        [_iFlySpeechSynthesizer startSpeaking:@"司机师傅已开始计费"];
                        _calculaterWitch = 1;
                        _iscalculateStart = 1;
                    }
                    _lastState = DriverStateBeginCharge;
                    break;
                }
                case 4:
                {
                    if (_lastState != DriverStateArriveDestination) {
                        [_iFlySpeechSynthesizer startSpeaking:@"您已到达目的地，请付费"];
                        _iscalculateStart = 0;
                        PayChargeViewController *pay = [[PayChargeViewController alloc] init];
#warning 价格
                        pay.detailInfoArr = @[[NSString stringWithFormat:@"%li元",(long)_actualDistance*1+14],@"0元",[NSString stringWithFormat:@"%li公里",(long)_actualDistance],@"0.0kg"];
                        [self.navigationController pushViewController:pay animated:YES];
                    }
                    _lastState = DriverStateArriveDestination;
                    break;
                }
                case 5:
                {
                    if (_lastState != DriverStatePayOver) {
                        [_iFlySpeechSynthesizer startSpeaking:@"支付已完成，欢迎本次乘车"];
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
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请求超时"];
        NYLog(@"%@",error.localizedDescription);
    }];
}

#pragma mark - MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        [_mapView setCenterCoordinate:userLocation.coordinate animated:YES];
        [_mapView setZoomLevel:14 animated:YES];
    });
    _passengerCoordinate = userLocation.coordinate;
    
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
    
    for (id ann in self.mapView.annotations) {
        if ([ann isKindOfClass:[MAUserLocation class]]) {
            MAUserLocation *userLocation = (MAUserLocation *)ann;
            NSString *annTitle = [NSString stringWithFormat:@"剩余%.2f公里 已行驶%ld:%ld",((float)path.distance)/1000,(long)_driveringTime/60,(long)_driveringTime%60];
            userLocation.title = annTitle;
        }
    }
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
    static NSString *cellId = @"DriverInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DriverInfoCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
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
    //    [_tableView reloadData];
}

- (void)rightLabelTaped:(UITapGestureRecognizer *)tap
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确定要取消行程吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [MBProgressHUD showMessage:@"正在取消订单"];
        [DownloadManager post:@"http://112.124.115.81/m.php?m=UserApi&a=cacelorder" params:@{@"user":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] ,@"route_id":_route_id} success:^(id json) {
            
            NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"result"]];
            [MBProgressHUD hideHUD];
            if ([resultStr isEqualToString:@"1"]) {
                [MBProgressHUD showSuccess:@"取消订单成功"];
                [self.navigationController popViewControllerAnimated:YES];
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

- (void)dealloc
{
    NYLog(@"%s",__FUNCTION__);
    if (_timer.valid) {
        [_timer invalidate];
    }
    _timer = nil;
}

@end
