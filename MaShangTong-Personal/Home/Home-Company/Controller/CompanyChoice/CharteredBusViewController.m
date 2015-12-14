//
//  CharteredBusViewController.m
//  MaShangTong
//
//  Created by niliu1h  on 15/10/19.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import "CharteredBusViewController.h"
#import "Masonry.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "MANaviRoute.h"
#import "CharteredBusRule.h"

@interface CharteredBusViewController () <UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate,AMapSearchDelegate>
{
    UIScrollView *_scrollView;
    UITextView *remarkTextView;
    UIButton *_selectedBtn;
    UITextField *numberTextField;
    UILabel *priceLabel;
    UIButton *_durationBtn;
    NSMutableArray *_charteredBusRuleArr;
    
    AMapSearchAPI *_search;
}

@property (nonatomic) MANaviRoute * naviRoute;

@end

@implementation CharteredBusViewController

- (void)showAlertViewWithMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)configViews
{
    NSData *userModelData = [USER_DEFAULT objectForKey:@"user_info"];
    UserModel *userModel = [NSKeyedUnarchiver unarchiveObjectWithData:userModelData];
    
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
    
    NSArray *titleLabel = @[@"用车时长",@"用车时间",@"出发地",@"乘车人手机"];
    for (NSInteger i = 0; i < 4; i++) {
        
        UILabel *label = [[UILabel alloc] init];
        label.text = titleLabel[i];
        label.textColor = RGBColor(64, 64, 64, 1.f);
        label.font = [UIFont systemFontOfSize:14];
        [bgView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView).offset(26);
            make.top.equalTo(bgView).offset(16+i*40);
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(20);
        }];
    }
    
    NSArray *titleBtn = @[@"4小时（包含45.0公里）",@"现在用车",@"您要从哪儿出发？"];
    for (NSInteger i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:titleBtn[i] forState:UIControlStateNormal];
        [btn setTitleColor:RGBColor(98, 190, 255, 1.f) forState:UIControlStateNormal];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(CharteredBusBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            _durationBtn = btn;
        }
        [bgView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView).offset(116);
            //            make.width.mas_equalTo(200);
            make.right.equalTo(bgView).offset(-26);
            make.top.equalTo(bgView).offset(16+i*40);
            make.height.mas_equalTo(20);
        }];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        if (i == 0) {
            self.durationBtn = btn;
        } else if (i == 1) {
            self.timeBtn = btn;
        } else if (i == 2) {
            self.sourceBtn = btn;
        }
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhishijiantou"]];
        [bgView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(btn);
            make.right.equalTo(btn).offset(0);
            make.size.mas_equalTo(CGSizeMake(24, 24));
        }];
    }
    
    numberTextField = [[UITextField alloc] init];
    numberTextField.font = [UIFont systemFontOfSize:14];
    numberTextField.placeholder = @"请输入手机号";
    numberTextField.text = userModel.mobile;
    numberTextField.delegate = self;
    [bgView addSubview:numberTextField];
    [numberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(136);
        make.left.equalTo(bgView).offset(116);
        //        make.size.mas_equalTo(CGSizeMake(200, 20));
        make.right.equalTo(bgView).offset(-26);
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
    
    NSArray *titleArr = @[@"电动轿车",@"电动中巴车",@"电动大巴车"];
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
        btn.tag = 200+i;
        [btn addTarget:self action:@selector(switchBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
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
    priceLabel.text = @"约     元";
    priceLabel.textColor = RGBColor(154, 154, 154, 1.f);
    priceLabel.textAlignment = 1;
    [contentView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remarkBgView.mas_bottom).offset(0);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.mas_equalTo(60);
    }];
    
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
    
    _charteredBusRuleArr = [NSMutableArray array];
    
    [self configViews];
    [self requestTheRules];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(haha:) name:@"CharteredBusViewControllerSourceBtn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TransportTimeChanged:) name:@"TransportTimeChanged" object:nil];
}

- (void)requestTheRules
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"2" forKey:@"reserva_type"];
    [DownloadManager post:@"http://112.124.115.81/m.php?m=OrderApi&a=order_car" params:params success:^(id json) {
        NYLog(@"%@",json);
        _charteredBusRuleArr = json[@"info"][@"rule"];
        NSString *once_price = [NSString stringWithFormat:@"约 %@ 元",json[@"info"][@"rule"][0][@"once_price"]];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:once_price];
        [attri addAttributes:@{NSForegroundColorAttributeName:RGBColor(109, 193, 255, 1.f),NSFontAttributeName:[UIFont systemFontOfSize:40]} range:NSMakeRange(2, ((NSString *)json[@"info"][@"rule"][0][@"once_price"]).length)];
        priceLabel.attributedText = attri;
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
    }];
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

- (void)scrollViewTap:(UITapGestureRecognizer *)tap
{
    [remarkTextView resignFirstResponder];
    [numberTextField resignFirstResponder];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [remarkTextView resignFirstResponder];
    [numberTextField resignFirstResponder];
}

#pragma mark - Action
- (void)CharteredBusBtnClicked:(UIButton *)btn
{
    [remarkTextView resignFirstResponder];
    [numberTextField resignFirstResponder];
    switch (btn.tag) {
        case 100:
        {
            if (self.timeBtnBlock) {
                self.timeBtnBlock();
            }
            break;
        }
        case 101:
        {
            if (self.durationBtnBlock) {
                self.durationBtnBlock();
            }
            break;
        }
        case 102:
        {
            if (self.sourceBtnBlock) {
                self.sourceBtnBlock();
            }
            break;
        }
        default:
            break;
    }
}

- (void)switchBtnClicked:(UIButton *)btn
{
    [remarkTextView resignFirstResponder];
    [numberTextField resignFirstResponder];
    if (btn.selected) {
        return;
    }
    btn.selected = YES;
    _selectedBtn.selected = NO;
    _selectedBtn = btn;
    if (_charteredBusRuleArr.count == 0) {
        [MBProgressHUD showError:@"网络延迟"];
        return;
    }
    CharteredBusRule *charteredBusRule = [[CharteredBusRule alloc] initWithDictionary:_charteredBusRuleArr[btn.tag-200] error:nil];
    NSString *oncePrice = charteredBusRule.once_price;
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"约 %@ 元",oncePrice]];
    [attri addAttributes:@{NSForegroundColorAttributeName:RGBColor(109, 193, 255, 1.f),NSFontAttributeName:[UIFont systemFontOfSize:40]} range:NSMakeRange(2, oncePrice.length)];
    [priceLabel setAttributedText:attri];
}

- (void)confirmBtnClicked:(UIButton *)btn
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[USER_DEFAULT objectForKey:@"user_id"] forKey:@"user_id"];
    NYLog(@"%i",[Helper justMobile:numberTextField.text]);
    if (![Helper justMobile:numberTextField.text]) {
        [self showAlertViewWithMessage:@"请输入正确手机号"];
        return;
    }
    [params setObject:numberTextField.text forKey:@"mobile_phone"];
    
    NSUInteger interval = [self transformToDateFormatterWithDateString:_timeBtn.currentTitle];
    [params setObject:[NSString stringWithFormat:@"%lu",(unsigned long)interval] forKey:@"reservation_time"];
    
    [params setObject:_sourceBtn.currentTitle forKey:@"origin_name"];
    [params setObject:[NSString stringWithFormat:@"%f,%f",delegate.sourceCoordinate.longitude,delegate.sourceCoordinate.latitude] forKey:@"origin_coordinates"];
    
    NSString *reservation_type = @"2";
    if ([_timeBtn.currentTitle isEqualToString:@"现在用车"]) {
        reservation_type = @"1";
    }
    [params setObject:reservation_type forKey:@"reservation_type"];
    [params setObject:_durationBtn.currentTitle forKey:@"duration_times"];
    [params setObject:[NSString stringWithFormat:@"%li",(long)_selectedBtn.tag-199] forKey:@"car_type_id"];
    [params setObject:remarkTextView.text forKey:@"leave_message"];
    [params setObject:@"2" forKey:@"reserva_type"];
    
    NSString *urlStr = @"http://112.124.115.81/m.php?m=OrderApi&a=usersigle";
    [MBProgressHUD showMessage:@"正在发送订单,请稍候。。。"];
    PassengerMessageModel *model = [[PassengerMessageModel alloc] initWithDictionary:params error:nil];
    [DownloadManager post:urlStr params:params success:^(id json) {
        NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"result"]];
        if ([resultStr isEqualToString:@"1"]) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"订单发送成功，请等待接单。。。"];
            if (self.confirmBtnBlock) {
                self.confirmBtnBlock(model,json[@"route_id"]);
            }
        } else if ([resultStr isEqualToString:@"0"]) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"您的网络有问题，请重试"];
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
                [DownloadManager post:@"http://112.124.115.81/m.php?m=UserApi&a=cacelorder" params:@{@"user":[USER_DEFAULT objectForKey:@"user_id"] ,@"route_id":json[@"route"][@"route_id"]} success:^(id json) {
                    
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
    } failure:^(NSError *error) {
        
        NYLog(@"post = %@",error);
        
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

#pragma mark - Notification
- (void)haha:(NSNotification *)noti
{
    [self.sourceBtn setTitle:noti.object forState:UIControlStateNormal];
}

- (void)TransportTimeChanged:(NSNotification *)noti
{
    [self.timeBtn setTitle:noti.object forState:UIControlStateNormal];
}

#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
