//
//  AccountBalanceViewController.m
//  MaShangTong
//
//  Created by niliu1h  on 15/10/22.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import "AccountBalanceViewController.h"
#import "Masonry.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AFNetworking.h"

@interface AccountBalanceViewController () <UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIButton *_selectPayBtn;
}

@property (nonatomic,strong) UILabel *moneyLabel;

@end

@implementation AccountBalanceViewController

- (void)configNavigationBar
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.size = CGSizeMake(44, 44);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"账户余额";
    label.textColor = RGBColor(73, 185, 254, 1.f);
    label.size = CGSizeMake(100, 44);
    label.textAlignment = 1;
    self.navigationItem.titleView = label;
}

- (void)configViews
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.backgroundColor = RGBColor(238, 238, 238, 1.f);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.userInteractionEnabled = YES;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.userInteractionEnabled = YES;
    [_scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
    
    UILabel *availableLabel = [[UILabel alloc] init];
    availableLabel.text = @"可用额度";
    availableLabel.textAlignment = 1;
    availableLabel.textColor = RGBColor(140, 140, 140, 1.f);
    availableLabel.font = [UIFont systemFontOfSize:16];
    [contentView addSubview:availableLabel];
    [availableLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(contentView).offset(31);
        make.height.mas_equalTo(28);
    }];
    
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.text = @"￥0.00";
    _moneyLabel.textAlignment = 1;
    _moneyLabel.textColor = RGBColor(60, 182, 255, 1.f);
    _moneyLabel.font = [UIFont systemFontOfSize:17];
    [contentView addSubview:_moneyLabel];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.top.equalTo(availableLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(28);
    }];
    
    UIButton *bankCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bankCardBtn setTitle:@"银行卡充值" forState:UIControlStateNormal];
    [bankCardBtn setTitleColor:RGBColor(141, 141, 141, 1.f) forState:UIControlStateNormal];
    [bankCardBtn setImage:[UIImage imageNamed:@"payBtnDeselect"] forState:UIControlStateNormal];
    [bankCardBtn setImage:[UIImage imageNamed:@"payBtnSelect"] forState:UIControlStateSelected];
    bankCardBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [bankCardBtn addTarget:self action:@selector(payBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:bankCardBtn];
    bankCardBtn.selected = YES;
    [bankCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_moneyLabel.mas_bottom).offset(24);
        make.left.equalTo(contentView).offset(0);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(44);
    }];
    _selectPayBtn = bankCardBtn;
    
    UIButton *alipayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [alipayBtn setTitle:@"支付宝充值" forState:UIControlStateNormal];
    [alipayBtn setTitleColor:RGBColor(141, 141, 141, 1.f) forState:UIControlStateNormal];
    [alipayBtn setImage:[UIImage imageNamed:@"payBtnDeselect"] forState:UIControlStateNormal];
    [alipayBtn setImage:[UIImage imageNamed:@"payBtnSelect"] forState:UIControlStateSelected];
    alipayBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [alipayBtn addTarget:self action:@selector(payBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:alipayBtn];
    [alipayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bankCardBtn.mas_bottom);
        make.left.equalTo(bankCardBtn);
        make.right.equalTo(bankCardBtn);
        make.height.equalTo(bankCardBtn);
    }];
    
    UIButton *wxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [wxBtn setTitle:@"微信充值   " forState:UIControlStateNormal];
    [wxBtn setTitleColor:RGBColor(141, 141, 141, 1.f) forState:UIControlStateNormal];
    wxBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [wxBtn setImage:[UIImage imageNamed:@"payBtnDeselect"] forState:UIControlStateNormal];
    [wxBtn setImage:[UIImage imageNamed:@"payBtnSelect"] forState:UIControlStateSelected];
    [wxBtn addTarget:self action:@selector(payBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:wxBtn];
    [wxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alipayBtn.mas_bottom);
        make.left.equalTo(alipayBtn);
        make.right.equalTo(alipayBtn);
        make.height.equalTo(alipayBtn);
    }];
    
    UIButton *rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
    [rechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rechargeBtn setBackgroundColor:RGBColor(98, 190, 254, 1.f)];
    rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    rechargeBtn.layer.cornerRadius = 3.f;
    [rechargeBtn addTarget:self action:@selector(rechargeBtnClicked1:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:rechargeBtn];
    [rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wxBtn.mas_bottom).offset(30);
        make.centerX.equalTo(contentView);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(30);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(rechargeBtn.mas_bottom).offset(20);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self showAccountBalance];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavigationBar];
    [self configViews];
    
}

- (void)showAccountBalance
{
    [MBProgressHUD showMessage:@"查询余额"];
    NSData *userModelData = [USER_DEFAULT objectForKey:@"user_info"];
    UserModel *userModel = [NSKeyedUnarchiver unarchiveObjectWithData:userModelData];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *userId = [USER_DEFAULT objectForKey:@"user_id"];
    [params setValue:userId forKey:@"user_id"];
    [params setValue:@"4" forKey:@"type"];
    [params setValue:@"2" forKey:@"group_id"];
    [DownloadManager post:@"http://112.124.115.81/m.php?m=UserApi&a=recharge" params:params success:^(id json) {
        
        NYLog(@"%@",json);
        _moneyLabel.text = [NSString stringWithFormat:@"￥%@",json[@"money"]];
        [MBProgressHUD hideHUD];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            userModel.money = json[@"money"];
            [USER_DEFAULT setObject:[NSKeyedArchiver archivedDataWithRootObject:userModel] forKey:@"user_info"];
            [USER_DEFAULT synchronize];
        });
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请求超时，请重试"];
        NYLog(@"%@",error.localizedDescription);
    }];
}

#pragma mark - Action
- (void)leftBarButtonItemClicked:(UIBarButtonItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)payBtnClicked:(UIButton *)btn
{
    if (btn.selected) {
        return;
    }
    btn.selected = YES;
    _selectPayBtn.selected = NO;
    _selectPayBtn = btn;
}

- (void)rechargeBtnClicked1:(UIButton *)btn
{
    NYLog(@"------------");
    [self payAlipay];
}

-(void)payAlipay
{
#pragma mark -
#pragma mark   ==============产生订单信息==============
    
#pragma mark -
#pragma mark   ==============产生订单信息==============
    
    
//    NSString *partner = @"2088021763249420";
//    NSString *seller = @"dw_mast@163.com";
//    NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAORTE8wVzYBhxz9t//UaG8/89s+hO6ZQgtm0vvAcGrE/IZaP/J0qZhfzzxg5cxhgfnsgr+gqr/Rm+lwKsCRlE/0co4EaldqsYHpJeeU5XQFuaAuzzBEcLjtf1wcSzQH55mVngYMp3Yn8epXZveLnYf0bXjBHYfC2bICnrKk3WCsBAgMBAAECgYBfJhvW7bMQ8C5nSYDj9HhoqYN1LTy9Z0nQTdlQGHYrLSLjKqfcGyImkyzXbIGBRB0RVKLZvohK8msc1jtnP1QfWj6MPGjejzVa9LDhKEnSneAJ1Fjn0cFSyroRn/zKk+zwnpeh4E4lyfJmJ8qafWNgDRlerLCkFFvi7hqYq2+Z0QJBAPSG0AIV3IC9/O+okMj7798s9LIcz5Dd1YPRoqDTpQY3SA6I+QQ2RtrA5cF0gfK3R75nQ6Lh2NFYfV1zeQ6ZtQUCQQDvCaZRCj46che5CQ6KBBMqSmsXvjIjJ3ybxryL3BzIkgYFcO27W4X7lS+7cbqkPky2ekcMrxqJxWdjx6+2rz7NAkEAhTRvWcN49DUK9a8Y+DOuLyA5SFHDjMIbjwyDECNbMXCp8ykQpge/P2l3f5QtOgA3t/Re9vsa9qfC20aNOrPm1QJAc1kbudWQi9GMowy8yFsJCIpavV1Zgl9GoUE4sODpvtvALhX9kkCrGek23GQYJbOufwvohzVkQAFTT/IHV8efLQJBALwKKdFnHQkl3gthQ5y6bbfvFajw+p4ApecR+KC/4TVZ4zrtlrCH6doKriOuzoxg6rbxdRXMtNELuBjTK8YOlBA=";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([alipayPID length] == 0 ||
        [alipaySeller length] == 0 ||
        [alipayRSA length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = (NSString *)alipayPID;
    order.seller = (NSString *)alipaySeller;
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.productName = @"码尚通余额充值";
    order.productDescription = @"码尚通余额充值";
    order.amount = @"500";
    order.notifyURL =  @"http://www.baidu.com"; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"MaShangTong";
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];

    NYLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner((NSString *)alipayRSA);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {

            NYLog(@"reslut = %@",resultDic);
            NSString *resultStatusStr = [NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
            if ([resultStatusStr isEqualToString:@"6001"]) {
                [MBProgressHUD showError:@"充值失败"];
                return ;
            }
            NSString *userId = [USER_DEFAULT objectForKey:@"user_id"];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:userId forKey:@"user_id"];
            [params setValue:order.amount forKey:@"money"];
            [params setValue:@"1" forKey:@"type"];
            
            AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
            [mgr POST:@"http://112.124.115.81/m.php?m=UserApi&a=recharge" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                
                NYLog(@"%@",responseObject);
                
                NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"result"]];
                
                if ([statusStr isEqualToString:@"1"]) {
                    [MBProgressHUD showSuccess:@"充值成功"];
                    [self showAccountBalance];
                } else {
                    [MBProgressHUD showError:@"充值失败"];
                }
                
            } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                
                NYLog(@"%@",error.localizedDescription);
                
            }];
            
        }];
        
        // [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }



}

- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

@end
