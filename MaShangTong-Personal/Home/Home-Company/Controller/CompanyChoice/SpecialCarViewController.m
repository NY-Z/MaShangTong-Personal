//
//  SpecialCarViewController.m
//  MaShangTong
//
//  Created by niliu1h  on 15/10/19.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import "SpecialCarViewController.h"
#import "Masonry.h"
#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapNaviKit/AMapNaviKit.h>
#import "MANaviRoute.h"
#import "MAMapKit.h"

@interface SpecialCarViewController () <UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate,AMapLocationManagerDelegate,AMapSearchDelegate,AMapNaviManagerDelegate>
{
    UIScrollView *_scrollView;
    
    UIButton *_selectedBtn;
    
    UITextView *remarkTextView;
    
    UITextField *numberTextField;

    UIButton *sourceBtn;

    AMapSearchAPI *_search;
    
    UILabel *priceLabel;
}
@property (nonatomic,strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) AMapNaviManager *naviManager;

@property (nonatomic) MANaviRoute * naviRoute;

@end

@implementation SpecialCarViewController

- (void)showAlertViewWithMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)configViews
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.backgroundColor = RGBColor(238, 238, 238, 1.f);
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UITapGestureRecognizer *scrollViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTap:)];
    [_scrollView addGestureRecognizer:scrollViewTap];
    
    UIView *contentView = [[UIView alloc] init];
    [_scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(0);
        make.left.equalTo(contentView).offset(0);
        make.right.equalTo(contentView).offset(0);
        make.height.mas_equalTo(180);
    }];
    
    UILabel *numberLabel = [[UILabel alloc] init];
    numberLabel.text = @"乘车人手机";
    numberLabel.textColor = RGBColor(102, 102, 102, 1.f);
    numberLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(26);
        make.top.equalTo(bgView).offset(14);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    
    numberTextField = [[UITextField alloc] init];
    numberTextField.placeholder = @"请输入您的手机号码";
    numberTextField.text = delegate.userModel.mobile;
    numberTextField.font = [UIFont systemFontOfSize:14];
    numberTextField.delegate = self;
    numberTextField.keyboardType = UIKeyboardTypePhonePad;
    [bgView addSubview:numberTextField];
    [numberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numberLabel.mas_right).offset(18);
        make.top.equalTo(numberLabel);
//        make.size.mas_equalTo(CGSizeMake(200, 20));
        make.right.equalTo(bgView).offset(-26);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = @"用车时间";
    timeLabel.textColor = RGBColor(102, 102, 102, 1.f);
    timeLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(numberLabel.mas_bottom).offset(20);
        make.left.equalTo(numberLabel);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    
    _timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _timeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_timeBtn setTitle:@"现在用车" forState:UIControlStateNormal];
    [_timeBtn setTitleColor:RGBColor(98, 190, 255, 1.f) forState:UIControlStateNormal];
    [_timeBtn addTarget:self action:@selector(timeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_timeBtn];
    [_timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeLabel);
        make.left.equalTo(numberTextField);
        make.height.mas_equalTo(20);
        make.right.equalTo(bgView).offset(-26);
    }];
    _timeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    UIImageView *timeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhishijiantou"]];
    [bgView addSubview:timeImageView];
    [timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_timeBtn);
        make.right.equalTo(_timeBtn).offset(0);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];

    
    UIButton *addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addressBtn setTitle:@"上海" forState:UIControlStateNormal];
    [addressBtn setTitleColor:RGBColor(102, 102, 102, 1.f) forState:UIControlStateNormal];
    addressBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [addressBtn addTarget:self action:@selector(addressBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:addressBtn];
    [addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLabel.mas_bottom).offset(43);
        make.left.equalTo(timeLabel);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    sourceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sourceBtn setTitle:@"定位失败，请输入您的出发地" forState:UIControlStateNormal];
    [sourceBtn setTitleColor:RGBColor(98, 190, 255, 1.f) forState:UIControlStateNormal];
    sourceBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sourceBtn addTarget:self action:@selector(sourceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:sourceBtn];
    [sourceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(addressBtn.mas_top).offset(0);
        make.left.equalTo(_timeBtn);
//        make.size.mas_equalTo(CGSizeMake(200, 20));
        make.height.mas_equalTo(20);
        make.right.equalTo(bgView).offset(-26);
    }];
    sourceBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    UIImageView *sourcesImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhishijiantou"]];
    [bgView addSubview:sourcesImageView];
    [sourcesImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sourceBtn);
        make.right.equalTo(sourceBtn).offset(0);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    _destinationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_destinationBtn setTitle:@"你要去哪儿" forState:UIControlStateNormal];
    [_destinationBtn setTitleColor:RGBColor(102, 102, 102, 1.f) forState:UIControlStateNormal];
    _destinationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _destinationBtn.titleLabel.textAlignment = 0;
    [_destinationBtn addTarget:self action:@selector(destinationBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_destinationBtn];
    [_destinationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressBtn.mas_bottom).offset(0);
        make.left.equalTo(_timeBtn);
//        make.size.mas_equalTo(CGSizeMake(200, 20));
        make.height.mas_equalTo(20);
        make.right.equalTo(bgView).offset(-26);
    }];
    _destinationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    UIImageView *destinateImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhishijiantou"]];
    [bgView addSubview:destinateImageView];
    [destinateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_destinationBtn);
        make.right.equalTo(_destinationBtn).offset(0);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    UIImageView *switchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhuanhuan"]];
    [bgView addSubview:switchImageView];
    [switchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sourceBtn.mas_bottom);
        make.bottom.equalTo(_destinationBtn.mas_top);
        make.right.equalTo(sourceBtn.mas_left);
        make.width.mas_equalTo(20);
    }];
    
    switchImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    
    UIImageView *sourceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quan"]];
    [bgView addSubview:sourceImageView];
    [sourceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(switchImageView);
        make.centerY.equalTo(sourceBtn);
        make.size.mas_equalTo(CGSizeMake(8, 8));
    }];
    
    UIImageView *destinationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quanquan"]];
    [bgView addSubview:destinationImageView];
    [destinationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(switchImageView);
        make.centerY.equalTo(_destinationBtn);
        make.size.mas_equalTo(CGSizeMake(8, 8));
    }];
    
    UIView *switchCarView = [[UIView alloc] init];
    switchCarView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:switchCarView];
    [switchCarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_bottom).offset(16);
        make.width.equalTo(bgView);
        make.height.equalTo(@42);
        make.left.equalTo(bgView);
    }];
    
    NSArray *titleArr = @[@"舒适电动轿车",@"商务电动轿车",@"豪华电动轿车"];
    NSArray *imageArr = @[@"che1Deselect",@"che2Deselect",@"che3Deselect"];
    NSArray *selectImageArr = @[@"che1Select",@"che2Select",@"che3Select"];
    for (NSInteger i = 0; i < titleArr.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:RGBColor(138, 138, 138, 1.f) forState:UIControlStateNormal];
        [btn setTitleColor:RGBColor(103, 189, 255, 1.f) forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:selectImageArr[i]] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:11];
        [btn addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 200+i;
        if (i == 0) {
            btn.selected = YES;
            _selectedBtn = btn;
        }
        [switchCarView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(switchCarView);
            make.bottom.equalTo(switchCarView);
            make.width.mas_equalTo(SCREEN_WIDTH/3-10);
            make.left.equalTo(switchCarView).offset(SCREEN_WIDTH*i/3);
        }];
    }
    
    UIView *remarkBgView = [[UIView alloc] init];
    remarkBgView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:remarkBgView];
    [remarkBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(switchCarView.mas_bottom).offset(16);
        make.left.equalTo(switchCarView);
        make.right.equalTo(switchCarView);
        make.height.mas_equalTo(103);
    }];
    
    remarkTextView = [[UITextView alloc] init];
    remarkTextView.text = @"请输入备注";
    remarkTextView.textColor = RGBColor(127, 127, 127, 1.f);
    remarkTextView.delegate = self;
    [remarkBgView addSubview:remarkTextView];
    [remarkTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(remarkBgView).insets(UIEdgeInsetsMake(10, 20, 10, 20));
    }];
    
    priceLabel = [[UILabel alloc] init];
    priceLabel.font = [UIFont systemFontOfSize:15];
    priceLabel.textColor = RGBColor(154, 154, 154, 1.f);
    priceLabel.textAlignment = 1;
    [contentView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remarkBgView.mas_bottom).offset(0);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.mas_equalTo(60);
    }];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"约    元"];
    [attri addAttributes:@{NSForegroundColorAttributeName:RGBColor(109, 193, 255, 1.f),NSFontAttributeName:[UIFont systemFontOfSize:40]} range:NSMakeRange(2, 2)];
    priceLabel.attributedText = attri;
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setTitle:@"确认用车" forState:UIControlStateNormal];
    [confirmBtn setBackgroundColor:RGBColor(98, 190, 254, 1.f)];
    [confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceLabel.mas_bottom).offset(8);
        make.centerX.equalTo(priceLabel);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(SCREEN_WIDTH*5/6);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(confirmBtn.mas_bottom).offset(20);
    }];
}

- (void)configLocation
{
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

        if (regeocode)
        {
            if (regeocode.city) {
                delegate.currentCity = regeocode.city;
            } else {
                delegate.currentCity = regeocode.province;
            }
            NYLog(@"%@",delegate.currentCity);
            [sourceBtn setTitle:regeocode.formattedAddress forState:UIControlStateNormal];
            delegate.sourceCoordinate = location.coordinate;
        }
    }];
    /*
     @property (nonatomic, copy) NSString *formattedAddress;//!< 格式化地址
     @property (nonatomic, copy) NSString *province; //!< 省/直辖市
     @property (nonatomic, copy) NSString *city;     //!< 市
     @property (nonatomic, copy) NSString *district; //!< 区
     @property (nonatomic, copy) NSString *citycode; //!< 城市编码
     @property (nonatomic, copy) NSString *adcode;   //!< 区域编码
     */
}

- (void)initNavi
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    if (!_search) {
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    AMapDrivingRouteSearchRequest *request = [[AMapDrivingRouteSearchRequest alloc] init];
    request.origin = [AMapGeoPoint locationWithLatitude:delegate.sourceCoordinate.latitude longitude:delegate.sourceCoordinate.longitude];
    request.destination = [AMapGeoPoint locationWithLatitude:delegate.destinationCoordinate.latitude longitude:delegate.destinationCoordinate.longitude];
    request.strategy = 4;//结合交通实际情况
    request.requireExtension = YES;
    [_search AMapDrivingRouteSearch:request];
    NYLog(@"%f,%f",delegate.sourceCoordinate.latitude,delegate.sourceCoordinate.longitude);
    NYLog(@"%f,%f",delegate.destinationCoordinate.latitude,delegate.destinationCoordinate.longitude);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configViews];
    
    [self configLocation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sourceNotification:) name:@"SpecialCarViewController" object:nil];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    CGRect rect = [textView convertRect:textView.frame toView:nil];
    
    CGFloat offSet = self.view.height-(CGRectGetMaxY(rect)+216);
    if (offSet <= 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.y = offSet;
        }];
    }
    if ([textView.text isEqualToString:@"请输入备注"]) {
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.view.frame.origin.y != 0) {

        [UIView animateWithDuration:0.3 animations:^{
            self.view.y = 0;
        }];
    }
    if (textView.text.length<1) {
        textView.text = @"请输入备注";
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [remarkTextView resignFirstResponder];
    [numberTextField resignFirstResponder];
}

#pragma mark - Action
- (void)timeBtnClicked:(UIButton *)btn
{
    [numberTextField resignFirstResponder];
    if (self.timeBtnBlock) {
        self.timeBtnBlock();
    }
}

- (void)sourceBtnClicked:(UIButton *)btn
{
    [numberTextField resignFirstResponder];
    if (self.sourceBtnBlock) {
        self.sourceBtnBlock();
    }
}

- (void)destinationBtnClicked:(UIButton *)btn
{
    [numberTextField resignFirstResponder];
    if (self.destinationBtnBlock) {
        self.destinationBtnBlock();
    }
}

- (void)selectBtnClicked:(UIButton *)btn
{
    [numberTextField resignFirstResponder];
    [remarkTextView resignFirstResponder];
    if (btn.selected) {
        return;
    }
    btn.selected = YES;
    _selectedBtn.selected = NO;
    _selectedBtn = btn;
    [self initNavi];
}

- (void)addressBtnClicked:(UIButton *)btn
{
    [numberTextField resignFirstResponder];
    [remarkTextView resignFirstResponder];
    if (self.addressBtnBlock) {
        self.addressBtnBlock();
    }
}

- (void)confirmBtnClicked:(UIButton *)btn
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] forKey:@"user_id"];
    NYLog(@"%i",[Helper justMobile:numberTextField.text]);
    if (![Helper justMobile:numberTextField.text]) {
        [self showAlertViewWithMessage:@"请输入正确手机号"];
        return;
    }
    [params setObject:numberTextField.text forKey:@"mobile_phone"];
    
    NSUInteger interval = [self transformToDateFormatterWithDateString:_timeBtn.currentTitle];
    [params setObject:[NSString stringWithFormat:@"%lu",(unsigned long)interval] forKey:@"reservation_time"];

    [params setObject:sourceBtn.currentTitle forKey:@"origin_name"];
    [params setObject:[NSString stringWithFormat:@"%f,%f",delegate.sourceCoordinate.longitude,delegate.sourceCoordinate.latitude] forKey:@"origin_coordinates"];
    
    if ([_destinationBtn.currentTitle isEqualToString:@"你要去哪儿"]) {
        [self showAlertViewWithMessage:@"你要去哪儿？"];
        return;
    }
    [params setObject:_destinationBtn.currentTitle forKey:@"end_name"];
    [params setObject:[NSString stringWithFormat:@"%f,%f",delegate.destinationCoordinate.longitude,delegate.destinationCoordinate.latitude] forKey:@"end_coordinates"];
    
    NSString *reservation_type = @"2";
    if ([_timeBtn.currentTitle isEqualToString:@"现在用车"]) {
        reservation_type = @"1";
    }
    [params setObject:reservation_type forKey:@"reservation_type"];
    
    NYLog(@"%li",(long)_selectedBtn.tag-200);
    [params setObject:[NSString stringWithFormat:@"%li",(long)_selectedBtn.tag-199] forKey:@"car_type_id"];
    [params setObject:remarkTextView.text forKey:@"leave_message"];
    [params setObject:@"1" forKey:@"reserva_type"];
    
    PassengerMessageModel *model = [[PassengerMessageModel alloc] initWithDictionary:params error:nil];
    
    NSString *urlStr = @"http://112.124.115.81/m.php?m=OrderApi&a=usersigle";
    [MBProgressHUD showMessage:@"正在发送订单,请稍候。。。"];
    [DownloadManager post:urlStr params:params success:^(id json) {
        NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"result"]];
        if ([resultStr isEqualToString:@"1"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:@"订单发送成功，请等待接单。。。"];
                if (self.confirmBtnBlock) {
                    self.confirmBtnBlock(model,json[@"route_id"]);
                }
            });
        } else if ([resultStr isEqualToString:@"-1"]) {
            [MBProgressHUD hideHUD];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您有未完成的订单信息" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"进入我的订单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (self.confirmBtnBlock) {
                    self.confirmBtnBlock(model,json[@"route"][@"route_id"]);
                }
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消订单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [MBProgressHUD showMessage:@"正在取消订单"];
                [DownloadManager post:@"http://112.124.115.81/m.php?m=UserApi&a=cacelorder" params:@{@"user":[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] ,@"route_id":json[@"route"][@"route_id"]} success:^(id json) {
                    
                    NYLog(@"%@",json);
                    NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"result"]];
                    [MBProgressHUD hideHUD];
                    if ([resultStr isEqualToString:@"1"]) {
                        [MBProgressHUD showSuccess:@"取消订单成功"];
                    } else {
                        [MBProgressHUD showError:@"取消订单失败"];
                    }
                        
                    
                } failure:^(NSError *error) {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:@"请求超时"];
                    NYLog(@"%@",error.localizedDescription);
                    
                }];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        else if ([resultStr isEqualToString:@"0"]) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"您的网络有问题，请重试"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"订单发送失败，请重试。。。"];
    }];
}

/*
 route_id 行程表的自增id
 user_id  用户id
 create_time 订单的创建时间
 origin_name  起始地点
 origin_coordinates起始经纬度
 end_name  目标地点
 end_coordinates  目标经纬度
 reservation_type   预约的类型 1立即 2预定时间
 reservation_time  预约时间
 reservation_duration   预约时长
 car_type_id  车型信息
 orders_time  接单时间
 boarding_time  上车时间
 end_time  到达时间
 pay_time  支付时间
 duration_times 预约时长
 mobile_phone  联系方式
 driver_id  司机的id用户的id
 leave_message  留言   text
 reserva_type    预定用车类型  0是转车1是包车2是接机3送机
 flight_number  航班号 varchar
 route_status  行程状态 0是默认待接单
 */

- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if(response.route == nil)
    {
        return;
    }
    MANaviAnnotationType type = MANaviAnnotationTypeDrive;

    AMapPath *path = response.route.paths[0];
    self.naviRoute = [MANaviRoute naviRouteForPath:path withNaviType:type];
//    NSString *price = [NSString stringWithFormat:@"%f(元)", response.route.taxiCost];
//    NYLog(@"distance = %@",[NSString stringWithFormat:@"%ld(米)", (long)path.distance]);
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    ValuationRuleModel *model = [[ValuationRuleModel alloc] initWithDictionary:delegate.valuationRuleArr[_selectedBtn.tag-200] error:nil];
    
    NSString *price = [NSString stringWithFormat:@"%.0f",path.distance*([model.mileage floatValue])/1000+[model.step floatValue]];
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"约 %li 元", (long)[[price componentsSeparatedByString:@"."][0] integerValue]]];
    [attri addAttributes:@{NSForegroundColorAttributeName:RGBColor(109, 193, 255, 1.f),NSFontAttributeName:[UIFont systemFontOfSize:40]} range:NSMakeRange(2, [price componentsSeparatedByString:@"."][0].length)];
    priceLabel.attributedText = attri;
}

#pragma mark - Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [remarkTextView resignFirstResponder];
}

- (void)scrollViewTap:(UITapGestureRecognizer *)tap
{
    [remarkTextView resignFirstResponder];
    [numberTextField resignFirstResponder];
}

#pragma mark - Notification
- (void)sourceNotification:(NSNotification *)noti
{
    [sourceBtn setTitle:noti.object forState:UIControlStateNormal];
}

- (NSUInteger)transformToDateFormatterWithDateString:(NSString *)dateStr
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年MM月dd日 HH时mm分";
    if ([_timeBtn.currentTitle isEqualToString:@"现在用车"]) {
        NSString *timeStr = [formatter stringFromDate:date];
        NYLog(@"%f",[[formatter dateFromString:timeStr] timeIntervalSince1970]);
        return [[formatter dateFromString:timeStr] timeIntervalSince1970];
    }
    NSString *subDateStr = [NSString stringWithFormat:@"%@ %@",[dateStr componentsSeparatedByString:@" "][0],[dateStr componentsSeparatedByString:@" "][2]];
    
    NSString *currentStr = [formatter stringFromDate:date];
    NSString *subCurrnetStr = [currentStr componentsSeparatedByString:@"年"][0];
    NSString *newDateStr = [NSString stringWithFormat:@"%@年%@",subCurrnetStr,subDateStr];
    
    NSTimeInterval interval = [[formatter dateFromString:newDateStr] timeIntervalSince1970];
    NYLog(@"%f",[[formatter dateFromString:newDateStr] timeIntervalSince1970]);
    return interval;
}

#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
