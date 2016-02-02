//
//  PayChargeViewController.m
//  MaShangTong-Personal
//
//  Created by q on 15/12/2.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "PayChargeViewController.h"
#import "AccountBalanceViewController.h"
#import "NYCommentViewController.h"
#import <UIImageView+WebCache.h>
#import "NYComplaintViewController.h"

@interface PayChargeViewController () <UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    NSDictionary *_billCheck;
}
@end

@implementation PayChargeViewController

- (void)initViews
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.tag = 250;
    [_scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sijitouxiang"]];
    if (![_driverInfoModel.head_image isEqualToString:@"http://112.124.115.81/"]) {
        [headerImageView sd_setImageWithURL:[NSURL URLWithString:_driverInfoModel.head_image]];
    }
    [contentView addSubview:headerImageView];
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(30);
        make.top.equalTo(contentView).offset(8);
        make.size.mas_equalTo(CGSizeMake(55, 55));
    }];
    headerImageView.layer.cornerRadius = 55/2;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = _driverInfoModel.owner_name;
    nameLabel.textAlignment = 0;
    nameLabel.textColor = RGBColor(14, 14, 14, 1.f);
    nameLabel.font = [UIFont systemFontOfSize:19];
    [contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerImageView.mas_right).offset(8);
        make.top.equalTo(headerImageView);
        make.height.mas_equalTo(18);
        make.right.equalTo(contentView).offset(-70);
    }];
    
    UILabel *propertyLabel = [[UILabel alloc] init];
    propertyLabel.text = _driverInfoModel.license_plate;
    propertyLabel.textAlignment = 0;
    propertyLabel.textColor = RGBColor(148, 148, 148, 1.f);
    propertyLabel.font = [UIFont systemFontOfSize:12];
    [contentView addSubview:propertyLabel];
    [propertyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(nameLabel.mas_bottom).offset(5);
        make.right.equalTo(nameLabel);
        make.height.equalTo(nameLabel);
    }];
    
    UILabel *dealCountLabel = [[UILabel alloc] init];
    dealCountLabel.text = [NSString stringWithFormat:@"%@单", _driverInfoModel.num];
    dealCountLabel.textAlignment = 0;
    dealCountLabel.textColor = RGBColor(148, 148, 148, 1.f);
    dealCountLabel.font = [UIFont systemFontOfSize:12];
    [contentView addSubview:dealCountLabel];
    [dealCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(propertyLabel.mas_bottom).offset(5);
        make.left.equalTo(propertyLabel);
        make.right.equalTo(propertyLabel);
        make.height.equalTo(propertyLabel);
    }];
    
    UIImageView *telImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dail"]];
    [contentView addSubview:telImageView];
    [telImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).offset(-30);
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.bottom.equalTo(headerImageView);
    }];
    telImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *telTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(telTaped)];
    [telImageView addGestureRecognizer:telTap];
    
    UIView *barrierOneView = [[UIView alloc] init];
    barrierOneView.backgroundColor = RGBColor(207, 207, 207, 1.f);
    [contentView addSubview:barrierOneView];
    [barrierOneView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(headerImageView.mas_bottom).offset(28);
        make.left.equalTo(contentView).offset(30);
        make.right.equalTo(contentView).offset(-30);
        make.height.equalTo(@1);
        
    }];
    
    UILabel *detailPriceLabel = [[UILabel alloc] init];
    detailPriceLabel.text = @"车费详情";
    detailPriceLabel.textAlignment = 1;
    detailPriceLabel.backgroundColor = [UIColor whiteColor];
    detailPriceLabel.textColor = RGBColor(183, 183, 183, 1.f);
    detailPriceLabel.font = [UIFont systemFontOfSize:11];
    [contentView addSubview:detailPriceLabel];
    [detailPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(barrierOneView.mas_top).offset(-8);
        make.centerX.mas_equalTo(contentView.centerX);
        make.size.mas_equalTo(CGSizeMake(70, 18));
    }];
    
    NSArray *labelTitleArr = @[@"车费合计",@"公里数",@"碳排放减少"];
    for (NSInteger i = 0; i < labelTitleArr.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.text = labelTitleArr[i];
        label.textAlignment = 0;
        label.textColor = RGBColor(71, 71, 71, 1.f);
        label.font = [UIFont systemFontOfSize:12];
        label.tag = 250+i;
        [contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(contentView).offset(42);
            make.top.equalTo(barrierOneView).offset(25+28*i);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(70);
            
        }];
    }
    
    NSArray *detailInfoArr = @[@"0元",@"0km",@"0.0kg"];
    for (NSInteger i = 0; i < detailInfoArr.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.text = detailInfoArr[i];
        label.textAlignment = 2;
        label.textColor = RGBColor(71, 71, 71, 1.f);
        label.font = [UIFont systemFontOfSize:12];
        label.tag = 600+i;
        [contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(barrierOneView);
            make.top.equalTo(barrierOneView).offset(25+28*i);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(70);
        }];
    }
    
    UIButton *confirmPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmPayBtn setTitle:[NSString stringWithFormat:@"确认支付%.0f元",[detailInfoArr[0] floatValue]] forState:UIControlStateNormal];
    [confirmPayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmPayBtn setBackgroundColor:RGBColor(84, 175, 255, 1.f)];
    confirmPayBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [confirmPayBtn addTarget:self action:@selector(confirmPayBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:confirmPayBtn];
    confirmPayBtn.tag = 900;
    confirmPayBtn.layer.cornerRadius = 3.f;
    [confirmPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view).offset(-40);
        make.left.equalTo(contentView).offset(55);
        make.right.equalTo(contentView).offset(-55);
        make.height.mas_equalTo(35);
        
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(confirmPayBtn.mas_bottom).offset(20);
    }];
}

- (void)configNavigationBar
{
//    self.navigationItem.title = @"支付车费";
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UILabel *navTitleLabel = [[UILabel alloc] init];
    navTitleLabel.size = CGSizeMake(200, 22);
    navTitleLabel.font = [UIFont systemFontOfSize:21];
    navTitleLabel.textColor = RGBColor(73, 185, 254, 1.f);
    navTitleLabel.textAlignment = 1;
    navTitleLabel.text = @"支付车费";
    self.navigationItem.titleView = navTitleLabel;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UILabel *rightLabel = [[UILabel alloc] init];
    rightLabel.text = @"投诉";
    rightLabel.textAlignment = NSTextAlignmentCenter;
    rightLabel.textColor = RGBColor(73, 185, 254, 1.f);
    rightLabel.font = [UIFont systemFontOfSize:13];
    rightLabel.size = CGSizeMake(60, 15);
    rightLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *rightLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightLabelTaped)];
    [rightLabel addGestureRecognizer:rightLabelTap];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBar];
    [self initViews];
    [self configData];
}

- (void)configData
{
    [MBProgressHUD showMessage:@"请稍候"];
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"check_bill"] params:@{@"route_id":_passengerMessageModel.route_id} success:^(id json) {
        [MBProgressHUD hideHUD];
        @try {
            NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
            if ([dataStr isEqualToString:@"1"]) {
                _billCheck = json;
                
                UIView *contentView = (UIView *)[_scrollView viewWithTag:250];
                
                UIButton *btn = (UIButton *)[contentView viewWithTag:900];
                [btn setTitle:[NSString stringWithFormat:@"确认支付%.0f元",[json[@"info"][@"total_price"] floatValue]] forState:UIControlStateNormal];
                
                NSArray *detailInfoArr = @[[NSString stringWithFormat:@"%.0f元",[json[@"info"][@"total_price"] floatValue]],[NSString stringWithFormat:@"%.2fkm",[json[@"info"][@"mileage"] floatValue]],[NSString stringWithFormat:@"%.2fkg",[json[@"info"][@"carbon_emission"] floatValue]]];
                for (NSInteger i = 0; i < detailInfoArr.count; i++) {
                    UILabel *label = (UILabel *)[contentView viewWithTag:600+i];
                    label.text = detailInfoArr[i];
                }
            } else {
                [self configData];
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误"];
        NYLog(@"%@",error.localizedDescription);
    }];
}

#pragma mark - BtnAction
- (void)confirmPayBtnClicked:(UIButton *)btn
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[USER_DEFAULT objectForKey:@"user_id"] forKey:@"user_id"];
    [params setValue:[NSString stringWithFormat:@"%.2f",[_billCheck[@"info"][@"total_price"] floatValue]] forKey:@"money"];
    [params setValue:@"2" forKey:@"type"];
    [params setValue:@"2" forKey:@"group_id"];
    [params setValue:_passengerMessageModel.route_id forKey:@"route_id"];
    [MBProgressHUD showMessage:@"正在支付，请稍候"];
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"recharge"] params:params success:^(id json) {
        NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"result"]];
        [MBProgressHUD hideHUD];
        @try {
            if ([resultStr isEqualToString:@"1"]) {
                [MBProgressHUD showSuccess:@"支付成功"];
                NYLog(@"%@",_passengerMessageModel.route_id);
                [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"boarding"] params:@{@"route_id":_passengerMessageModel.route_id,@"route_status":@"6"} success:^(id json) {
                    NYLog(@"%@",json);
                } failure:^(NSError *error) {
                    
                }];
                NYCommentViewController *comment = [[NYCommentViewController alloc] init];
                comment.driverInfoModel = self.driverInfoModel;
                comment.route_id = self.route_id;
                [self.navigationController pushViewController:comment animated:YES];
                return ;
            } else if ([resultStr isEqualToString:@"0"]) {
                [MBProgressHUD showError:@"支付失败，请重试"];
                return;
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"支付失败，请重试"];
    }];
}

#pragma mark - Gesture
- (void)telTaped
{
    if (!_driverInfoModel) {
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:_driverInfoModel.mobile message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_driverInfoModel.mobile]]];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)rightLabelTaped
{
    NYComplaintViewController *complaint = [[NYComplaintViewController alloc] init];
    complaint.driverId = self.driverInfoModel.driver_id;
    [self.navigationController pushViewController:complaint animated:YES];
}

@end
