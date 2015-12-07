//
//  PayChargeViewController.m
//  MaShangTong-Personal
//
//  Created by q on 15/12/2.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "PayChargeViewController.h"
#import "AccountBalanceViewController.h"

@interface PayChargeViewController () <UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
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
    [_scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    [contentView addSubview:headerImageView];
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(contentView).offset(30);
        make.top.equalTo(contentView).offset(8);
        make.size.mas_equalTo(CGSizeMake(55, 55));
        
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"徐师傅";
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
    propertyLabel.text = @"沪F88888    友联出租";
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
    dealCountLabel.text = @"26666单";
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
    
    UIImageView *telImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    [contentView addSubview:telImageView];
    [telImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(contentView).offset(-30);
        make.centerY.mas_equalTo(propertyLabel.centerY);
        make.size.mas_equalTo(CGSizeMake(35, 35));
        
    }];
    
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
    
    NSArray *labelTitleArr = @[@"车费合计",@"优惠合计",@"公里数",@"碳排放减少"];
    for (NSInteger i = 0; i < 4; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.text = labelTitleArr[i];
        label.textAlignment = 0;
        label.textColor = RGBColor(71, 71, 71, 1.f);
        label.font = [UIFont systemFontOfSize:12];
        [contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(contentView).offset(42);
            make.top.equalTo(barrierOneView).offset(25+28*i);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(70);
            
        }];
    }
    
    //    _detailInfoArr = @[@"14元",@"0元",@"2公里",@"0.3kg"];
    for (NSInteger i = 0; i < 4; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.text = _detailInfoArr[i];
        label.textAlignment = 2;
        label.textColor = RGBColor(71, 71, 71, 1.f);
        label.font = [UIFont systemFontOfSize:12];
        [contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(barrierOneView);
            make.top.equalTo(barrierOneView).offset(25+28*i);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(70);
            
        }];
    }
    
    UIButton *confirmPayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmPayBtn setTitle:[NSString stringWithFormat:@"确认支付%.1f元",[_detailInfoArr[0] floatValue]] forState:UIControlStateNormal];
    [confirmPayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmPayBtn setBackgroundColor:RGBColor(84, 175, 255, 1.f)];
    confirmPayBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [confirmPayBtn addTarget:self action:@selector(confirmPayBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:confirmPayBtn];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    UILabel *navTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    navTitleLabel.text = @"支付车费";
    navTitleLabel.font = [UIFont systemFontOfSize:15];
    navTitleLabel.textColor = RGBColor(78, 175, 252, 1.f);
    navTitleLabel.textAlignment = 1;
    self.navigationItem.titleView = navTitleLabel;
    
    UIButton *navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [navRightBtn setTitle:@"投诉" forState:UIControlStateNormal];
    [navRightBtn setTitleColor:RGBColor(168, 168, 168, 1.f) forState:UIControlStateNormal];
    navRightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [navRightBtn addTarget:self action:@selector(navRightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navRightBtn];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.size = CGSizeMake(44, 44);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initViews];
}

#pragma mark - NavigationBarAction
- (void)navRightBtnClicked:(UIButton *)btn
{
    
}

- (void)backBtnClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - BtnAction
- (void)confirmPayBtnClicked:(UIButton *)btn
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"] forKey:@"user_id"];
    [params setValue:_detailInfoArr[0] forKey:@"money"];
    [MBProgressHUD showMessage:@"正在支付，请稍后"];
    [DownloadManager post:@"http://112.124.115.81/m.php?m=UserApi&a=recharge" params:params success:^(id json) {
        NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"result"]];
        [MBProgressHUD hideHUD];
        if ([resultStr isEqualToString:@"1"]) {
            [MBProgressHUD showSuccess:@"支付成功"];
            return ;
        } else if ([resultStr isEqualToString:@"0"]) {
            [self confirmPayBtnClicked:btn];
            return;
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您的账户余额不足" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                AccountBalanceViewController *account = [[AccountBalanceViewController alloc] init];
                [self.navigationController pushViewController:account animated:YES];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"支付失败，请重试"];
    }];
}

@end
