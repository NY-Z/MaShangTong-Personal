//
//  HomeViewController.m
//  MaShangTong
//
//  Created by niliu1h  on 15/10/15.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import "HomeViewController.h"
#import <AMapNaviKit/AMapNaviKit.h>
#import "Masonry.h"
#import "AFNetworking.h"

#import "EstimateViewController.h"
#import "RuleViewController.h"
#import "searchViewC.h"
#import "wordVC.h"

#import "PersonCenterViewController.h"
#import "PersonInfoViewController.h"
#import "MyTripViewController.h"
#import "MyWalletVC.h"
#import "MyNewsCenterVC.h"
#import "MyStoreVC.h"
#import "recommendedVC.h"
#import "GSdiscoverViewController.h"
#import "sijizhaomuVC.h"
#import "settingVC.h"

#import "CallCarView.h"
#import "pickerV.h"

#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

#import "personOrderModel.h"
#import "GSPriceRuleModel.h"
#import "PassengerMessageModel.h"

#import "WaitForTheOrderViewController.h"
#import "RegisViewController.h"
#import "ValuationRuleModel.h"

#import "UserModel.h"

@interface HomeViewController () <MAMapViewDelegate,AMapSearchDelegate,UIAlertViewDelegate>
{
    MAMapView *_mapView;
    BOOL isPullDown;
    BOOL isShowPersonCenter;
    
    NSString *_nameStr;
    NSArray *_nearCarsAry;
    
    NSInteger getNearCarsNum;
}
//计价规则
@property (nonatomic,copy) NSArray *ruleAry;

@property (nonatomic,assign) CGFloat distance ;
@property (nonatomic,assign) NSInteger priceNum;
@property (nonatomic,strong) PersonCenterViewController *personCenter;


@end

@implementation HomeViewController

//判断用户是否是自己选择位置（NO为否）
static BOOL isHadSearched = NO;
//判断用户自己选择预约时间没有
static bool isChooseDate = NO;
//判断是哪个label点击的（起点是0和终点是1）
static NSInteger whichLabel;
//判断计价规则是否请求成功
static BOOL isGetRule = NO;
//判断视图是否消失，从而要不要求情附近的车
static BOOL isApper = YES;

- (void)configNavigationBar
{
    self.navigationController.navigationBar.translucent = NO;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"gerenzhongxin"] forState:UIControlStateNormal];
    [leftBtn setFrame:CGRectMake(0, 0, 44, 44)];
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"xiaoxi"] forState:UIControlStateNormal];
    [rightBtn setFrame:CGRectMake(0, 0, 44, 44)];
    [rightBtn addTarget:self action:@selector(chickNews:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    UIImageView *titleImageView = [[UIImageView alloc] init];
    titleImageView.image = [UIImage imageNamed:@"LOGO"];
    titleImageView.frame = CGRectMake(0, 0, 150, 44);
    titleImageView.contentMode = UIViewContentModeCenter;
    self.navigationItem.titleView = titleImageView;
}
-(void)chickNews:(UIButton *)sender
{
    MyNewsCenterVC *vc3 = [[MyNewsCenterVC alloc]init];
    [self.navigationController pushViewController:vc3 animated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    isApper = YES;
    
    [_mapView removeAnnotations:_mapView.annotations];
    
    self.navigationController.navigationBar.barTintColor = RGBColor(99, 190, 255, 1.f);
    _callCarView.startTextFled.enabled = YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    isApper = NO;
    
    [_mapView removeAnnotations:_mapView.annotations];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeSureModel];
    
    isPullDown = NO;
    _nameStr = [NSString string];
    
    [self configNavigationBar];
    [self configMaMapView];
    
    [self chickIsHadRoute];
    [self callcarView];
    [self configLeftViewController];
    
    
}
#pragma mark - 为model设置信息
-(void)makeSureModel
{
    _personModel = [[personOrderModel alloc]init];
    _priceRuleModel = [[GSPriceRuleModel alloc]init];
    
    //获取用车的类型，为专车
    _personModel.reserva_type = [NSString stringWithFormat:@"%d",1];
    //获取车型，为舒适电动轿车
    _personModel.car_type_id = [NSString stringWithFormat:@"%d",1];
    
    
    //用户的id和电话号码（先写死，到时候从本地持久化文件里面取出来）
    _personModel.user_id = [NSString stringWithFormat:@"%@",[USER_DEFAULT objectForKey:@"user_id"]];
    UserModel *userModel = [NSKeyedUnarchiver unarchiveObjectWithData:[USER_DEFAULT objectForKey:@"user_info"]];
    _personModel.mobile_phone = userModel.mobile;
    
//    NSLog(@"------%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]);
    _personModel.leave_message = @"请输入备注";
}

- (void)callcarView
{
    
    // 呼叫专车
    CGRect frame = CGRectMake(10, 0.6*SCREEN_HEIGHT-64, SCREEN_WIDTH-20, 0.4*SCREEN_HEIGHT);
    _callCarView = [[CallCarView alloc] initWithFrame:frame];
    [self.view addSubview:_callCarView];
    _searchVC = [[searchViewC alloc]init];
    
    __weak typeof(self) weakSelf = self;
    
    _callCarView.pushSearchVC = ^(NSInteger whichOne){
        //判断是哪个label点击的
        whichLabel = whichOne;
        //判断用户是否是自己选择位置
        isHadSearched = YES;
        
        weakSelf.searchVC.searchBarTextChanged = ^(NSString *searchStr){
            //设置收索的详细信息（city选填，address是必填）
            weakSelf.request.keywords = searchStr;
            weakSelf.request.city = @"上海";
            
            //发起收索
            [weakSelf.search AMapInputTipsSearch:weakSelf.request];
        };
        weakSelf.searchVC.selectedCell = ^(NSInteger num,AMapGeoPoint *point){
            NSDictionary *dic = weakSelf.searchVC.searchDataArray[num];
            
            if(whichLabel == 0){
                //获取到出发地的中文名字和location
                weakSelf.callCarView.startTextFled.text = [dic valueForKey:@"name"];
                weakSelf.personModel.origin_name = [dic valueForKey:@"name"];
                weakSelf.personModel.origin_coordinates = [NSString stringWithFormat:@"%@,%@",[point valueForKey:@"longitude"],[point valueForKey:@"latitude"]];
                
                weakSelf.driveSearch.origin = point;
                [weakSelf.search AMapDrivingRouteSearch:weakSelf.driveSearch];
            }
            else if(whichLabel == 1){
                //获取到目的地的中文名字和location
                weakSelf.callCarView.endTextFlied.text = [dic valueForKey:@"name"];
                weakSelf.personModel.end_name = [dic valueForKey:@"name"];
                weakSelf.personModel.end_coordinates = [NSString stringWithFormat:@"%@,%@",[point valueForKey:@"longitude"],[point valueForKey:@"latitude"]];
                
                weakSelf.driveSearch.destination = point;
                [weakSelf.search AMapDrivingRouteSearch:weakSelf.driveSearch];
            }
        };
        //跳转到收索VC
        [weakSelf.navigationController pushViewController:weakSelf.searchVC animated:NO];
    };
    
    _callCarView.chooseCarType = ^(NSInteger carType){
        //获取到车型
        weakSelf.personModel.car_type_id = [NSString stringWithFormat:@"%ld",carType];
        if (weakSelf.personModel.end_name.length > 0) {
            weakSelf.priceNum = [weakSelf calculateThFeareWithCarType:weakSelf.personModel.car_type_id and:weakSelf.distance];
            weakSelf.priceRuleModel.price = [NSString stringWithFormat:@"%ld",weakSelf.priceNum];
            NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat: @"约 %ld 元",weakSelf.priceNum]];
            [attriStr setAttributes:@{NSForegroundColorAttributeName:RGBColor(54, 171, 237, 1.f),NSFontAttributeName:[UIFont systemFontOfSize:32]} range:NSMakeRange(2, attriStr.length-4)];
            
            weakSelf.callCarView.priceLabel.attributedText = attriStr;
        }
    };
    
    _callCarView.priceTapBlock = ^() {
        if (weakSelf.priceRuleModel.price && weakSelf.priceNum > 0) {
            
            NYLog(@"预估价格");
            
            EstimateViewController *estimate = [[EstimateViewController alloc] init];
            estimate.estimateDic = @{@"rule":(NSDictionary *)weakSelf.ruleAry[[weakSelf.personModel.car_type_id integerValue]-1],@"estimatePrice":weakSelf.priceRuleModel.price,@"step":weakSelf.priceRuleModel.step,@"distance":[NSString stringWithFormat:@"%.2f",weakSelf.priceRuleModel.distance]};
            estimate.type = RuleTypeSpecialCar;
            //            estimate.estimatePrice = weakSelf.priceRuleModel.price ;
            //            estimate.step = weakSelf.priceRuleModel.step;
            //            estimate.mileage = weakSelf.priceRuleModel.mileage;
            //            estimate.long_mileage = weakSelf.priceRuleModel.long_mileage;
            //            estimate.distnce = weakSelf.priceRuleModel.distance;
            
            estimate.view.backgroundColor=[UIColor colorWithWhite:1 alpha:0.85];
            estimate.modalPresentationStyle = UIModalPresentationOverFullScreen;
            __weak typeof(estimate) weakSetimate = estimate;
            estimate.ruleLabelClick = ^(NSArray *ruleAry){
                RuleViewController *rule = [[RuleViewController alloc] init];
                rule.car_type = weakSelf.personModel.car_type_id;
                rule.step = weakSelf.priceRuleModel.step;
                rule.mileage = weakSelf.priceRuleModel.mileage;
                rule.long_mileage = weakSelf.priceRuleModel.long_mileage;
                rule.distance = weakSelf.priceRuleModel.distance;
                rule.type = TypeSpecialCar;
                
                [weakSetimate dismissViewControllerAnimated:YES completion:nil];
                [weakSelf.navigationController pushViewController:rule animated:NO];
            };
            [weakSelf presentViewController:estimate animated:YES completion:^{
                estimate.view.superview.backgroundColor = [UIColor clearColor];
            }];
        }
    };
    
    
    
    _callCarView.dateTapBlock = ^(){
        pickerV *dataV = [[pickerV alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-220-64, SCREEN_WIDTH, 220)];
        dataV.sendTime = ^(NSString *reservation_time,NSString *reservation_type,NSString *dateStr){
            //获取到预约事件类型和预约时间
            weakSelf.personModel.reservation_time = reservation_time;
            weakSelf.personModel.reservation_type = reservation_type;
            isChooseDate = YES;
            [weakSelf.callCarView.goOffBtn setTitle:[NSString stringWithFormat:@"出发时间  %@",dateStr] forState:UIControlStateNormal];
        };
        [weakSelf.view addSubview:dataV];
    };
    
    
    _callCarView.pushWordVC = ^(){
        wordVC *wordViewController = [[wordVC alloc] init];
        wordViewController.sendWords = ^(NSString *wordsStr){
            
            //获取到用户的留言（给司机捎话）
            weakSelf.callCarView.textField.text = wordsStr;
            weakSelf.personModel.leave_message = wordsStr;
        };
        [weakSelf.navigationController pushViewController:wordViewController animated:NO];
    };
    
    //发单
    _callCarView.submitOrders = ^(){
        
        if (!weakSelf.personModel.end_name) {
            UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择目的地。" delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alter show];
        }
        else {
            if (!isChooseDate) {
                //获取出发时间和预约类型
                weakSelf.personModel.reservation_type = [NSString stringWithFormat:@"%d",1];
                NSDate *date = [NSDate date];
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"HH mm"];
                
                weakSelf.personModel.reservation_time = [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];
            }
            NSDictionary *param = [personOrderModel getDictionaryWith:weakSelf.personModel];
            [weakSelf sendOrderWith:param];
            
            
        }
    };
}

#pragma mark - 个人中心跳转到各个属性视图
- (void)configLeftViewController
{
    _personCenter = [[PersonCenterViewController alloc] init];
    _personCenter.view.frame = CGRectMake(-SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _personCenter.view.hidden = YES;
    
    __weak typeof(self) weakSelf = self;
    
    _personCenter.tableViewCellSelected = ^(NSInteger cellId, NSString *title){
        
        switch (cellId) {
            case 0:
            {
                MyTripViewController *vc1 = [[MyTripViewController alloc] init];
                [weakSelf.navigationController pushViewController:vc1 animated:NO];
                break;
            }
                
            case 1:
            {
                MyWalletVC *vc2 = [[MyWalletVC alloc]init];
                [weakSelf.navigationController pushViewController:vc2 animated:NO];
                break;
            }
                
            case 2:
            {
                MyNewsCenterVC *vc3 = [[MyNewsCenterVC alloc]init];
                [weakSelf.navigationController pushViewController:vc3 animated:NO];
                break;
            }
                
            case 3:
            {
                MyStoreVC *vc4 = [[MyStoreVC alloc]init];
                [weakSelf.navigationController pushViewController:vc4 animated:NO];
                break;
            }
                
            case 4:
            {
                recommendedVC *vc5 = [[recommendedVC alloc]init];
                [weakSelf.navigationController pushViewController:vc5 animated:NO];
                break;
            }
                
            case 5:
            {
                sijizhaomuVC *vc6 = [[sijizhaomuVC alloc]init];
                [weakSelf.navigationController pushViewController:vc6
                                                         animated:NO];
                break;
            }
                
            case 6:
            {
                GSdiscoverViewController *vc7 = [[GSdiscoverViewController alloc]init];
                [weakSelf.navigationController pushViewController:vc7 animated:NO];
            }
                break;
            case 7:
            {
                settingVC *vc8 = [[settingVC alloc]init];
                [weakSelf.navigationController pushViewController:vc8 animated:NO];
                break;
            }
            default:
                break;
        }
        
        [weakSelf hidePersonCenter];
        
    };
    
    _personCenter.tableHeaderViewClicked = ^{
        
        PersonInfoViewController *vc = [[PersonInfoViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
        [weakSelf hidePersonCenter];
        
    };
    
    _personCenter.logOut = ^{
        NYLog(@"退出登录");
        
        [MBProgressHUD showMessage:@"正在退出"];
        if (self.navigationController.viewControllers.count == 2) {
            BOOL a = [weakSelf.navigationController.viewControllers[1] isKindOfClass:[RegisViewController class]];
            if (a) {
                [weakSelf.navigationController popToViewController:weakSelf.navigationController.viewControllers[1] animated:YES];
            }
        }
        else {
            RegisViewController *regis = [[RegisViewController alloc] init];
            [UIApplication sharedApplication].keyWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:regis];
            [USER_DEFAULT setValue:@"0" forKey:@"isLogin"];
            [USER_DEFAULT setValue:@"0" forKey:@"group_id"];
        }
        [MBProgressHUD hideHUD];
        
        
    };
}
- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    
    _mapView.showsUserLocation = YES;
    
}

- (void)configMaMapView
{
    _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    _mapView.showsCompass = YES;
    _mapView.showsScale = YES;
    _mapView.userTrackingMode = 1;
    _mapView.showsUserLocation = YES;
    [_mapView setZoomLevel:16 animated:YES];
    
    _geocoder = [[CLGeocoder alloc]init];
    
    /**
     *收索详细的地理位置信息，获取经纬度
     **/
    [AMapSearchServices sharedServices].apiKey = AMap_ApiKey;
    //初始化收索对象，设置代理
    _search = [[AMapSearchAPI alloc]init];
    _search.delegate = self;
    
    //实例化request对象
    _request = [[AMapInputTipsSearchRequest alloc]init];
    
    //实例化一个路线规划的对象
    _driveSearch = [[AMapDrivingRouteSearchRequest alloc]init];
    _driveSearch.strategy = 2;
    _driveSearch.requireExtension = YES;
    
}

#pragma mark - AMapSearchDelegate
-(void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    NSMutableArray *tempArray = [NSMutableArray new];
    if (response.tips.count == 0) {
        NYLog(@"没有请求到数据");
        return;
    }
    //对请求到的数据进行处理
    for (AMapTip  *p in response.tips) {
        //将查到的数据存到数组
        [tempArray addObject:p];
        
    }
    _searchVC.searchDataArray = [NSArray arrayWithArray:tempArray];
    
    [_searchVC.tableView reloadData];
    
    [tempArray removeAllObjects];
    
}

-(void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    _distance = 0;
    if (response.route == nil) {
        [MBProgressHUD showError:@"路线规划失败"];
        return;
    }
    for (AMapPath *path in response.route.paths) {
        for (AMapStep *step in path.steps) {
            _distance = _distance+step.distance;
        }
    }
    NYLog(@"%g",_distance);
    _priceNum = [self calculateThFeareWithCarType:_personModel.car_type_id and:_distance];
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat: @"约 %ld 元",_priceNum]];
    _priceRuleModel.price = [NSString stringWithFormat:@"%ld",_priceNum];
    [attriStr setAttributes:@{NSForegroundColorAttributeName:RGBColor(54, 171, 237, 1.f),NSFontAttributeName:[UIFont systemFontOfSize:32]} range:NSMakeRange(2, attriStr.length-4)];
    
    _callCarView.priceLabel.attributedText = attriStr;
}


#pragma mark - MAMapViewDelegate
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation) {
        /**
         *反地理编码获取定位的信息字典
         **/
        
        //获取定位位置的经纬度
        _location = [[CLLocation alloc]initWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
        //获取附近的车de位置
        getNearCarsNum ++;
        if (isApper && getNearCarsNum%10 == 0) {
            [self getNearCarsWithLocation:_location];
        }
        
        //获取计价规则
        if(!isGetRule){
            [self sendToGetRuleAry];
        }
        //开始反码，获取定位的信息字典
        [_geocoder reverseGeocodeLocation:_location completionHandler:^(NSArray *placeMark,NSError *error){
            if (error||placeMark == 0) {
                
            }else{
                CLPlacemark *firstPlaceMark = [placeMark firstObject];
                //将定位到的信息展示出来
                if (![_callCarView.startTextFled.text isEqualToString:[self componentString:firstPlaceMark.name] ] && !isHadSearched) {
                    
                    _nameStr = [self componentString:firstPlaceMark.name];
                    NYLog(@"%@",_nameStr);
                    _callCarView.startTextFled.text = _nameStr;
                    _personModel.origin_name = _nameStr;
                    
                    _personModel.origin_coordinates = [NSString stringWithFormat:@"%f,%f",firstPlaceMark.location.coordinate.longitude,firstPlaceMark.location.coordinate.latitude];
                    _driveSearch.origin = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
                    
                }
            }
        }];
        
    }
}
//大头针和附近的车
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    
    if([annotation isKindOfClass:[MAUserLocation class]]){
        
        static NSString *anIde = @"userAnnotation";
        MAAnnotationView *view = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:anIde];
        if (!view) {
            view = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:anIde];
        }
        view.image = [UIImage imageNamed:@"dingwei"];
        view.selected = YES;
        view.draggable = YES;        //设置标注可以拖动，默认为NO
        view.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        view.centerOffset = CGPointMake(0, -10);
        
        return view;
    }
    
    else   if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        
        static NSString *anIde = @"pointAnnotation";
        MAPointAnnotation *annotation = (MAPointAnnotation *)[mapView dequeueReusableAnnotationViewWithIdentifier:anIde];
        MAAnnotationView *annitationView;
        if (!annotation) {
            annotation = [[MAPointAnnotation alloc]init];
            annitationView = [[MAAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:anIde];
            annitationView.image = [UIImage imageNamed:@"sijidingwei"];
            annitationView.centerOffset = CGPointMake(0, -10);
        }
        return annitationView;
    }
    return nil;
}
#pragma mark - 查看是否有未完成的行程
-(void)chickIsHadRoute
{
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"user_backLoge"] params:@{@"user_id":[USER_DEFAULT objectForKey:@"user_id"]} success:^(id json) {
        @try {
            NYLog(@"%@",json);
            NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
            if ([dataStr isEqualToString:@"1"]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您有未完成的行程" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"进入我的订单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    WaitForTheOrderViewController *waitOrderVc = [[WaitForTheOrderViewController alloc] init];
                    waitOrderVc.route_id = json[@"info"][@"route_id"];
                    waitOrderVc.model = [[PassengerMessageModel alloc] initWithDictionary:json[@"info"] error:nil];
                    waitOrderVc.passengerCoordinate = CLLocationCoordinate2DMake(self.driveSearch.origin.latitude, self.driveSearch.origin.longitude);
                    waitOrderVc.specialCarRuleModel = [[ValuationRuleModel alloc] initWithDictionary:json[@"rule"] error:nil];
                    waitOrderVc.type = ReservationTypeSpecialCar;
                    waitOrderVc.HaveOrder = YES;
                    waitOrderVc.gonePrice = [NSString stringWithFormat:@"%f" ,[json[@"info"][@"total_price"] floatValue] - [json[@"info"][@"start_price"] floatValue]];
                    waitOrderVc.isHadExit = HadExit;
                    waitOrderVc.low_time = json[@"info"][@"low_time"];
                    waitOrderVc.mileage = json[@"info"][@"mileage"];
                    [self.navigationController pushViewController:waitOrderVc animated:YES];
                }]];
                NSString *str = [NSString stringWithFormat:@"%@",json[@"info"][@"route_status"]];
                if([str intValue] < 3){
                    [alert addAction:[UIAlertAction actionWithTitle:@"取消订单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self cancelOrderWithRouteId:json[@"info"][@"route_id"]];
                    }]];
                }
                [self presentViewController:alert animated:YES completion:nil];
            } else {
                
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)cancelOrderWithRouteId:(NSString *)routeId{
    [MBProgressHUD showMessage:@"正在取消订单"];
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"cacelorder"] params:@{@"user":[USER_DEFAULT objectForKey:@"user_id"] ,@"route_id":routeId} success:^(id json) {
        @try {
            NYLog(@"%@",json);
            NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"result"]];
            [MBProgressHUD hideHUD];
            if ([resultStr isEqualToString:@"1"]) {
                [MBProgressHUD showSuccess:@"取消订单成功"];
            } else {
                [MBProgressHUD showError:@"取消订单失败"];
                
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请求超时"];
       
    }];
}
#pragma mark - 网络请求，发单
-(void)sendOrderWith:(NSDictionary *)param
{
    [MBProgressHUD showMessage:@"正在发单"];
    
    NSString *url = [NSString stringWithFormat:URL_HEADER,@"OrderApi",@"usersigle"];
    
    [DownloadManager post:url params:param success:^(id json) {
        @try {
            NYLog(@"发单，发单%@",json);
            [MBProgressHUD hideHUD];
            if (json) {
                NSString *str = [NSString stringWithFormat:@"%@",json[@"result"]];
                if ([str isEqualToString:@"1"]) {
                    [MBProgressHUD showSuccess:@"发单成功"];
                    WaitForTheOrderViewController *vc = [[WaitForTheOrderViewController alloc]init];
                    PassengerMessageModel *passengerModel = [[PassengerMessageModel alloc] initWithDictionary:param error:nil];
                    passengerModel.route_id = json[@"route_id"];
                    vc.model = passengerModel;
                    vc.route_id = json[@"route_id"];
                    vc.passengerCoordinate = CLLocationCoordinate2DMake(self.driveSearch.origin.latitude, self.driveSearch.origin.longitude);
                    vc.specialCarRuleModel = [[ValuationRuleModel alloc]initWithDictionary:(NSDictionary *)self.ruleAry[[self.personModel.car_type_id integerValue]-1] error:nil];
                    vc.type = ReservationTypeSpecialCar;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                //            else if([str isEqualToString:@"-1"]){
                //                [MBProgressHUD hideHUD];
                //                NSString *route_id = json[@"route"][@"route_id"];
                //                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您有未完成的订单" preferredStyle:UIAlertControllerStyleAlert];
                //                [alert addAction:[UIAlertAction actionWithTitle:@"取消订单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //
                //                    [MBProgressHUD showMessage:@"正在取消订单"];
                //
                //                    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"cacelorder"] params:@{@"user":[USER_DEFAULT objectForKey:@"user_id"] ,@"route_id":route_id} success:^(id jsons) {
                //                        NSString *resultStr = [NSString stringWithFormat:@"%@",jsons[@"result"]];
                //                        [MBProgressHUD hideHUD];
                //                        if ([resultStr isEqualToString:@"1"]) {
                //                            [MBProgressHUD showSuccess:@"取消订单成功"];
                //
                //                            [self.navigationController popViewControllerAnimated:YES];
                //                        } else {
                //                            [MBProgressHUD showError:@"取消订单失败"];
                //                        }
                //                    } failure:^(NSError *error) {
                //
                //                        [MBProgressHUD hideHUD];
                //                        [MBProgressHUD showError:@"请求失败，请重试"];
                //                        NYLog(@"%@",error.localizedDescription);
                //
                //                    }];
                //                }]];
                //                [alert addAction:[UIAlertAction actionWithTitle:@"前往订单" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
                //
                //                    WaitForTheOrderViewController *vc = [[WaitForTheOrderViewController alloc]init];
                //                    //                    PassengerMessageModel *passengerModel = [[PassengerMessageModel alloc]initWithDictionary:param andRouteId:json[@"route_id"]];
                //                    PassengerMessageModel *passengerModel = [[PassengerMessageModel alloc] initWithDictionary:param error:nil];
                //                    passengerModel.route_id = json[@"route_id"];
                //                    vc.model = passengerModel;
                //                    vc.route_id = route_id;
                //                    [self.navigationController pushViewController:vc animated:YES];
                //                }]];
                //                [self presentViewController:alert animated:YES completion:nil];
                //            }
            }
            else{
                [MBProgressHUD showError:@"网络错误"];
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误"];
    }];
}

#pragma mark - 网络请求请求,获取计价规则
-(void)sendToGetRuleAry
{
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *param = @{@"reserva_type":@"1"};
    
    NSString *url = [NSString stringWithFormat:URL_HEADER,@"OrderApi",@"order_car"];
    
    [DownloadManager post:url params:param success:^(id json) {
        @try {
            NSString *str = json[@"data"];
            if ([str isEqualToString:@"1"]) {
                isGetRule = YES;
                weakSelf.ruleAry = [NSArray arrayWithArray: json[@"info"][@"rule"]];
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark - 网络请求，附近的车
-(void)getNearCarsWithLocation:(CLLocation *)location
{
    
    NSDictionary *param = @{@"person_place":[NSString stringWithFormat:@"%f,%f",location.coordinate.longitude,location.coordinate.latitude]};
    
    NSString *url = [NSString stringWithFormat:URL_HEADER,@"OrderApi",@"near_cars"];
    [DownloadManager post:url params:param success:^(id json) {
        @try {
            if(json){
                NSString *str = [NSString stringWithFormat:@"%@", json[@"data"]];
                if ([str isEqualToString:@"1"]) {
                    
                    for (MAPointAnnotation *point in _mapView.annotations) {
                        if (![point isKindOfClass:[MAUserLocation class]]) {
                            [_mapView removeAnnotation:point];
                        }
                    }
                    _nearCarsAry = [NSArray arrayWithArray: json[@"info"]];
                    NSMutableArray *annotationAry = [NSMutableArray new];
                    for (int i=0; i < _nearCarsAry.count; i++) {
                        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc]init];
                        NSString *str = _nearCarsAry[i];
                        NSArray *ary = [str componentsSeparatedByString:@","];
                        pointAnnotation.coordinate = [[CLLocation alloc]initWithLatitude:[ary[1] doubleValue] longitude:[ary[0] doubleValue]].coordinate;
                        
                        [annotationAry addObject:pointAnnotation];
                    }
                    [_mapView addAnnotations:annotationAry];
                    for (MAPointAnnotation *point in _mapView.annotations) {
                        if ([point isKindOfClass:[MAUserLocation class]]) {
                            if (_nearCarsAry.count == 0) {
                                point.title = [NSString stringWithFormat:@"附近没有车"];
                            }
                            else{
                                point.title = [NSString stringWithFormat:@"附近%ld辆车",_nearCarsAry.count];
                            }
                        }
                    }
                }
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    } failure:^(NSError *error) {
        
    }];
    
    
    
}
#pragma mark - 计算预估车费
-(NSInteger)calculateThFeareWithCarType:(NSString *)carType and:(CGFloat)distance
{
    _priceRuleModel.distance = distance/1000;
    
    NSInteger KM  = distance/1000;
    CGFloat stemp1,stemp2,stemp3;
    CGFloat price1,price2,price3;
    CGFloat priceNum1,priceNum2,priceNum3;
    
    stemp1 = [_ruleAry[0][@"step"] intValue];
    price1 = [_ruleAry[0][@"mileage"] doubleValue];
    priceNum1 = [_ruleAry[0][@"long_mileage"] doubleValue];
    
    stemp2 = [_ruleAry[1][@"step"] intValue];
    price2 = [_ruleAry[1][@"mileage"] doubleValue];
    priceNum2 = [_ruleAry[1][@"long_mileage"] doubleValue];
    
    stemp3 = [_ruleAry[2][@"step"] intValue];
    price3 = [_ruleAry[2][@"mileage"] doubleValue];
    priceNum3 = [_ruleAry[2][@"long_mileage"] doubleValue];
    
    if (((long)distance%1000)>0) {
        KM +=1;
    }
    
    if ([carType isEqualToString:@"1"]) {
        _priceRuleModel.step = [NSString stringWithFormat:@"%g",stemp1];
        _priceRuleModel.mileage = [NSString stringWithFormat:@"%g",price1];
        _priceRuleModel.long_mileage = [NSString stringWithFormat:@"%g",priceNum1];
        
        if (KM <= 10) {
            NSInteger fareNum = (long)(KM*price1+stemp1);
            return fareNum;
        }
        else{
            NSInteger fareNum  = (long)(stemp1+KM*price1+(KM-10)*priceNum1);
            return fareNum;
        }
        
        
    }
    else if ([carType isEqualToString:@"2"]){
        _priceRuleModel.step = [NSString stringWithFormat:@"%g",stemp2];
        _priceRuleModel.mileage = [NSString stringWithFormat:@"%g",price2];
        _priceRuleModel.long_mileage = [NSString stringWithFormat:@"%g",priceNum2];
        
        if (KM <= 10) {
            NSInteger fareNum = (long)(KM*price2+stemp2);
            return fareNum;
        }
        else{
            NSInteger fareNum  = (long)(stemp2+KM*price2+(KM-10)*priceNum2);
            return fareNum;
        }
    }
    else{
        _priceRuleModel.step = [NSString stringWithFormat:@"%g",stemp3];
        _priceRuleModel.mileage = [NSString stringWithFormat:@"%g",price3];
        _priceRuleModel.long_mileage = [NSString stringWithFormat:@"%g",priceNum3];
        
        if (KM <= 10) {
            NSInteger fareNum = (long)(stemp3+KM*price3);
            return fareNum;
        }
        else{
            NSInteger fareNum  = (long)(stemp3+KM*price3+(KM-10)*priceNum3);
            return fareNum;
        }
    }
}
- (void)leftBtnClick:(UIButton *)btn
{
    
    [[UIApplication sharedApplication].keyWindow addSubview:_personCenter.view];
    [self showPersonCenter];
}

- (void)showPersonCenter
{
    _personCenter.view.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _personCenter.view.x = 0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hidePersonCenter
{
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        weakSelf.personCenter.view.x = -SCREEN_WIDTH;
        
    } completion:^(BOOL finished) {
        
        [weakSelf.personCenter.view removeFromSuperview];
        
    }];
}
//截取地址
-(NSString *)componentString:(NSString *)str
{
    NSMutableString *tempStr1 = [NSMutableString stringWithString:str];
    NSString *string = [tempStr1 substringWithRange:NSMakeRange(0, 2)];
    if ([string isEqualToString:@"中国"]) {
        NSMutableString *tempStr2 = [NSMutableString stringWithString:str];
        [tempStr2 deleteCharactersInRange:NSMakeRange(0, 2)];
        NSString *getStr = [NSString stringWithString:tempStr2];
        return getStr;
    }
    else{
        return str;
    }
    
}
-(void)dealloc
{
    NYLog(@"释放%@",_mapView);
}
@end
