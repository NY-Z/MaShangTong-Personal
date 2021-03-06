//
//  AirportDropOffViewController.m
//  MaShangTong
//
//  Created by niliu1h  on 15/10/19.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import "AirportDropOffViewController.h"
#import "Masonry.h"
#import "AirportPickupModel.h"
#import "AMapLocationKit.h"
#import "AMapSearchAPI.h"
#import "PassengerMessageModel.h"
#import "UserModel.h"

@interface AirportDropOffViewController () <UIScrollViewDelegate,UITextViewDelegate,AMapLocationManagerDelegate>
{
    UIScrollView *_scrollView;
    UITextField *numberTextField;
    UITextView *remarkTextView;
    UIButton *_selectedBtn;
    NSArray *_airportPickupRuleArr;
    UILabel *priceLabel;
}
@property (nonatomic,strong) AMapLocationManager *locationManager;
@property (nonatomic,strong) NSString *airportPrice;
@end

@implementation AirportDropOffViewController

- (void)showAlertViewWithMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)configViews
{
    UserModel *userModel = [NSKeyedUnarchiver unarchiveObjectWithData:[USER_DEFAULT objectForKey:@"user_info"]];
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.backgroundColor = RGBColor(238, 238, 238, 1.f);
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
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
    
    UIButton *addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addressBtn setTitle:@"上海" forState:UIControlStateNormal];
    [addressBtn setTitleColor:RGBColor(102, 102, 102, 1.f) forState:UIControlStateNormal];
    addressBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:addressBtn];
    [addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(36);
        make.left.equalTo(bgView).offset(26);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    _sourceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sourceBtn setTitle:@"古漪庄园" forState:UIControlStateNormal];
    [_sourceBtn setTitleColor:RGBColor(98, 190, 255, 1.f) forState:UIControlStateNormal];
    _sourceBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_sourceBtn addTarget:self action:@selector(souceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_sourceBtn];
    [_sourceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(addressBtn.mas_top).offset(0);
        make.left.equalTo(addressBtn.mas_right).offset(18);
//        make.size.mas_equalTo(CGSizeMake(200, 20));
        make.height.mas_equalTo(20);
        make.right.equalTo(bgView).offset(-26);
    }];
    _sourceBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    UIImageView *sourcesImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhishijiantou"]];
    [bgView addSubview:sourcesImageView];
    [sourcesImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_sourceBtn);
        make.right.equalTo(_sourceBtn).offset(0);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    _destinationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_destinationBtn setTitle:@"请选择航班起飞机场" forState:UIControlStateNormal];
    [_destinationBtn setTitleColor:RGBColor(102, 102, 102, 1.f) forState:UIControlStateNormal];
    _destinationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _destinationBtn.titleLabel.textAlignment = 0;
    [_destinationBtn addTarget:self action:@selector(destinationBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_destinationBtn];
    [_destinationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressBtn.mas_bottom).offset(0);
        make.left.equalTo(_sourceBtn);
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
        make.top.equalTo(_sourceBtn.mas_bottom);
        make.bottom.equalTo(_destinationBtn.mas_top);
        make.right.equalTo(_sourceBtn.mas_left);
        make.width.equalTo(@20);
    }];
    switchImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    
    UIImageView *sourceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quan"]];
    [bgView addSubview:sourceImageView];
    [sourceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(switchImageView);
        make.centerY.equalTo(_sourceBtn);
        make.size.mas_equalTo(CGSizeMake(8, 8));
    }];
    
    UIImageView *destinationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quanquan"]];
    [bgView addSubview:destinationImageView];
    [destinationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(switchImageView);
        make.centerY.equalTo(_destinationBtn);
        make.size.mas_equalTo(CGSizeMake(8, 8));
    }];
    
    //
    UILabel *numberLabel = [[UILabel alloc] init];
    numberLabel.text = @"乘车人手机";
    numberLabel.textColor = RGBColor(102, 102, 102, 1.f);
    numberLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(26);
        make.top.equalTo(_destinationBtn.mas_bottom).offset(18);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    
    numberTextField = [[UITextField alloc] init];
    numberTextField.placeholder = @"请输入手机号码";
    numberTextField.text = userModel.mobile;
    numberTextField.font = [UIFont systemFontOfSize:13];
    numberTextField.textColor = RGBColor(102, 102, 102, 1.f);
    [bgView addSubview:numberTextField];
    [numberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_destinationBtn);
        make.top.equalTo(numberLabel);
//        make.size.mas_equalTo(CGSizeMake(200, 20));
        make.height.mas_equalTo(20);
        make.right.equalTo(bgView).offset(-26);
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
    
    UIButton *timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    timeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [timeBtn setTitle:@"现在用车" forState:UIControlStateNormal];
    [timeBtn setTitleColor:RGBColor(98, 190, 255, 1.f) forState:UIControlStateNormal];
    [timeBtn addTarget:self action:@selector(timeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:timeBtn];
    [timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeLabel);
        make.left.equalTo(numberTextField);
        //        make.size.mas_equalTo(CGSizeMake(200, 20));
        make.height.mas_equalTo(20);
        make.right.equalTo(bgView).offset(-26);
    }];
    timeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.timeBtn = timeBtn;
    
    UIImageView *timeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhishijiantou"]];
    [bgView addSubview:timeImageView];
    [timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeBtn);
        make.right.equalTo(timeBtn).offset(0);
        make.size.mas_equalTo(CGSizeMake(24, 24));
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
        [btn addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:selectImageArr[i]] forState:UIControlStateSelected];
        btn.tag = 200+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:11];
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
    remarkTextView.delegate = self;
    remarkTextView.text = @"请输入备注";
    remarkTextView.textColor = RGBColor(127, 127, 127, 1.f);
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
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"约     元"];
    [attri addAttributes:@{NSForegroundColorAttributeName:RGBColor(109, 193, 255, 1.f),NSFontAttributeName:[UIFont systemFontOfSize:40]} range:NSMakeRange(2, 2)];
    priceLabel.attributedText = attri;
    priceLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *priceLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(priceLabelTaped)];
    [priceLabel addGestureRecognizer:priceLabelTap];
    
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestTheRules];
    [self configViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TransportTimeChanged:) name:@"TransportTimeChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseFlight:) name:@"AirPortDropOffChooseFlight" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.locationManager == nil) {
        [self configLocation];
    }
}

#pragma mark - 计价规则
- (void)requestTheRules
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"4" forKey:@"reserva_type"];
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"order_car"] params:params success:^(id json) {
        @try {
            _airportPickupRuleArr = json[@"info"][@"rule"];
        } @catch (NSException *exception) {
            
        } @finally {
            [self requestTheRules];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
    }];
}

- (void)configLocation
{
    [AMapLocationServices sharedServices].apiKey = AMap_ApiKey;
    
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
            [self.sourceBtn setTitle:regeocode.formattedAddress forState:UIControlStateNormal];
            delegate.sourceCoordinate = location.coordinate;
        }
        
    }];
}


- (void)resignResponder
{
    [numberTextField resignFirstResponder];
    [remarkTextView resignFirstResponder];
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

- (void)scrollViewTap:(UITapGestureRecognizer *)tap
{
    [self resignResponder];
}

#pragma mark - Action
- (void)souceBtnClicked:(UIButton *)btn
{
    [self resignFirstResponder];
    if (self.sourceBtnBlock) {
        self.sourceBtnBlock();
    }
}

- (void)destinationBtnClicked:(UIButton *)btn
{
    [self resignResponder];
    if (self.destinationBlock) {
        self.destinationBlock();
    }
}

- (void)timeBtnClicked:(UIButton *)btn
{
    [self resignResponder];
    if (self.timeBtnBlock) {
        self.timeBtnBlock();
    }
}

- (void)selectBtnClicked:(UIButton *)btn
{
    [self resignResponder];
    if (btn.selected) {
        return;
    }
    btn.selected = YES;
    _selectedBtn.selected = NO;
    _selectedBtn = btn;
    if (_airportPickupRuleArr.count == 0) {
        return;
    }
    for (NSDictionary *dic in _airportPickupRuleArr) {
        AirportPickupModel *model = [[AirportPickupModel alloc] initWithDictionary:dic error:nil];
        if ([model.car_type_id isEqualToString:[NSString stringWithFormat:@"%li",(long)_selectedBtn.tag-199]] && [model.airport_name containsString:[_destinationBtn.currentTitle substringWithRange:NSMakeRange(0, 2)]] && model.airport_name.length == 4) {
            _airportPrice = model.once_price;
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"约 %@ 元",_airportPrice]];
            [attri addAttributes:@{NSForegroundColorAttributeName:RGBColor(109, 193, 255, 1.f),NSFontAttributeName:[UIFont systemFontOfSize:40]} range:NSMakeRange(2, model.once_price.length)];
            priceLabel.attributedText = attri;
        }
    }
}

- (void)confirmBtnClicked:(UIButton *)btn
{
    UserModel *userModel = [NSKeyedUnarchiver unarchiveObjectWithData:[USER_DEFAULT objectForKey:@"user_info"]];
    if ([userModel.money floatValue] <= 200) {
        [MBProgressHUD showError:@"您的余额不足200"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [params setObject:_sourceBtn.currentTitle forKey:@"origin_name"];
    [params setObject:[NSString stringWithFormat:@"%f,%f",delegate.sourceCoordinate.longitude,delegate.sourceCoordinate.latitude] forKey:@"origin_coordinates"];
    
    if ([_destinationBtn.currentTitle isEqualToString:@"您的目的地"]) {
        [self showAlertViewWithMessage:@"您的目的地"];
        return;
    }
    [params setObject:_destinationBtn.currentTitle forKey:@"end_name"];
    [params setObject:[NSString stringWithFormat:@"%f,%f",delegate.destinationCoordinate.longitude,delegate.destinationCoordinate.latitude] forKey:@"end_coordinates"];

    if (![Helper justMobile:numberTextField.text]) {
        [self showAlertViewWithMessage:@"请输入正确手机号"];
        return;
    }
    [params setObject:numberTextField.text forKey:@"mobile_phone"];

    NSString *reservation_type = @"2";
    if ([_timeBtn.currentTitle isEqualToString:@"现在用车"]) {
        reservation_type = @"1";
    }
    [params setObject:reservation_type forKey:@"reservation_type"];
    
    NSUInteger interval = [self transformToDateFormatterWithDateString:_timeBtn.currentTitle];
    [params setObject:[NSString stringWithFormat:@"%lu",(unsigned long)interval] forKey:@"reservation_time"];

    [params setObject:[NSString stringWithFormat:@"%li",(long)_selectedBtn.tag-199] forKey:@"car_type_id"];
    [params setObject:remarkTextView.text forKey:@"leave_message"];
    [params setObject:@"4" forKey:@"reserva_type"];
    [params setObject:[USER_DEFAULT objectForKey:@"user_id"] forKey:@"user_id"];
    
    [MBProgressHUD showMessage:@"正在发送订单,请稍候"];
    PassengerMessageModel *model = [[PassengerMessageModel alloc] initWithDictionary:params error:nil];
    
    AirportPickupModel *airportModel;
    for (NSDictionary *dic in _airportPickupRuleArr) {
        airportModel = [[AirportPickupModel alloc] initWithDictionary:dic error:nil];
        if ([airportModel.car_type_id isEqualToString:[NSString stringWithFormat:@"%li",(long)_selectedBtn.tag-199]] && [airportModel.airport_name containsString:[_destinationBtn.currentTitle substringWithRange:NSMakeRange(0, 2)]] && airportModel.airport_name.length == 4) {
            break;
        }
    }
    
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"usersigle"] params:params success:^(id json) {
            NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"result"]];
            [MBProgressHUD hideHUD];
        @try {
            if ([resultStr isEqualToString:@"-1"]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您有未完成的订单信息" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"进入我的订单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if (self.confirmBtnBlock) {
                        model.route_id = json[@"route_id"];
                        self.confirmBtnBlock(model,json[@"route"][@"route_id"],airportModel);
                    }
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消订单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [MBProgressHUD showMessage:@"正在取消订单"];
                    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"cacelorder"] params:@{@"user":[USER_DEFAULT objectForKey:@"user_id"] ,@"route_id":json[@"route"][@"route_id"]} success:^(id json) {
                        
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
            } else if ([resultStr isEqualToString:@"0"]) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"您的网络有问题，请重试"];
            } else if ([resultStr isEqualToString:@"1"]) {
                if (self.confirmBtnBlock) {
                    model.route_id = json[@"route_id"];
                    self.confirmBtnBlock(model,json[@"route_id"],airportModel);
                }
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"订单发送失败，请重试"];
    }];
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
    NSString *subCurrentStr = [currentStr componentsSeparatedByString:@"年"][0];
    NSString *newDateStr = [NSString stringWithFormat:@"%@年%@",subCurrentStr,subDateStr];
    
    NSTimeInterval interval = [[formatter dateFromString:newDateStr] timeIntervalSince1970];
    NYLog(@"%f",[[formatter dateFromString:newDateStr] timeIntervalSince1970]);
    return interval;
}

#pragma mark - Gesture
- (void)priceLabelTaped
{
    if (self.priceLabelBlock) {
        self.priceLabelBlock(@{@"name":_sourceBtn.currentTitle,@"price":_airportPrice,@"car_type_id":[NSString stringWithFormat:@"%li",_selectedBtn.tag-199]});
    }
}

#pragma mark - 通知
- (void)TransportTimeChanged:(NSNotification *)noti
{
    [self.timeBtn setTitle:noti.object forState:UIControlStateNormal];
}

- (void)chooseFlight:(NSNotification *)noti
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic = noti.object;
        NSString *destinationName = dic[@"titleLabel"];
        NSString *destinationCoordinate = dic[@"detailTitleLabel"];
        [self.destinationBtn setTitle:destinationName forState:UIControlStateNormal];
        APP_DELEGATE.destinationCoordinate = CLLocationCoordinate2DMake([[destinationCoordinate componentsSeparatedByString:@","][1] floatValue], [[destinationCoordinate componentsSeparatedByString:@","][0] floatValue]);
        if (_airportPickupRuleArr.count == 0) {
            return;
        }
        for (NSDictionary *dic in _airportPickupRuleArr) {
            AirportPickupModel *model = [[AirportPickupModel alloc] initWithDictionary:dic error:nil];
            if ([model.car_type_id isEqualToString:[NSString stringWithFormat:@"%li",(long)_selectedBtn.tag-199]] && [model.airport_name containsString:[_destinationBtn.currentTitle substringWithRange:NSMakeRange(0, 2)]] && model.airport_name.length == 4) {
                _airportPrice = model.once_price;
                NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"约 %@ 元",_airportPrice]];
                [attri addAttributes:@{NSForegroundColorAttributeName:RGBColor(109, 193, 255, 1.f),NSFontAttributeName:[UIFont systemFontOfSize:40]} range:NSMakeRange(2, model.once_price.length)];
                priceLabel.attributedText = attri;
            }
        }
    });
}

#pragma mark - dealloc
- (void)dealloc
{
    NYLog(@"%s",__FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
