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
#import "WXApi.h"
#import "GDataXMLNode.h"

#import <CommonCrypto/CommonDigest.h>

#include <ifaddrs.h>
#include <arpa/inet.h>

@interface AccountBalanceViewController () <UIScrollViewDelegate,WXApiDelegate>
{
    UIScrollView *_scrollView;
    UIButton *_selectPayBtn;
    UITextField *_payChargeTextField;
    
    NSString *_wxPayMoney;
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
    
    self.navigationItem.title = @"账户余额";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:RGBColor(73, 185, 254, 1.f)}];
}

- (void)configViews
{
    NSData *userModelData = [USER_DEFAULT valueForKey:@"user_info"];
    UserModel *userModel = [NSKeyedUnarchiver unarchiveObjectWithData:userModelData];
    
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
    _moneyLabel.text = [NSString stringWithFormat:@"￥ %@",userModel.money];
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
    bankCardBtn.tag = 1000;
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
    alipayBtn.tag = 2000;
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
    wxBtn.tag = 3000;
    [contentView addSubview:wxBtn];
    [wxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alipayBtn.mas_bottom);
        make.left.equalTo(alipayBtn);
        make.right.equalTo(alipayBtn);
        make.height.equalTo(alipayBtn);
    }];
    
    _payChargeTextField = [[UITextField alloc] init];
    _payChargeTextField.borderStyle = UITextBorderStyleRoundedRect;
    _payChargeTextField.keyboardType = UIKeyboardTypeNumberPad;
    _payChargeTextField.layer.borderColor = RGBColor(98, 190, 254, 1.f).CGColor;
    _payChargeTextField.layer.borderWidth = 1.f;
    _payChargeTextField.layer.cornerRadius = 3.f;
    _payChargeTextField.placeholder = @"充值价格";
    [contentView addSubview:_payChargeTextField];
    [_payChargeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wxBtn.mas_bottom).offset(12);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(33);
        make.centerX.equalTo(contentView);
    }];
    
    UIButton *rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
    [rechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rechargeBtn setBackgroundColor:RGBColor(98, 190, 254, 1.f)];
    rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    rechargeBtn.layer.cornerRadius = 3.f;
    [rechargeBtn addTarget:self action:@selector(rechargeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:rechargeBtn];
    [rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_payChargeTextField.mas_bottom).offset(30);
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
    _wxPayMoney = @"";
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
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"recharge"] params:params success:^(id json) {
        
        NYLog(@"%@",json);
        _moneyLabel.text = [NSString stringWithFormat:@"￥ %@",json[@"money"]];
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

- (void)rechargeBtnClicked:(UIButton *)btn
{
    NYLog(@"%@",_selectPayBtn.currentTitle);
    if (![_payChargeTextField.text floatValue]) {
        [MBProgressHUD showError:@"请输入您要充值的余额"];
        return;
    }
    switch (_selectPayBtn.tag) {
        case 1000:
        {
            
            break;
        }
        case 2000:
        {
            [self payAlipay];
            break;
        }
        case 3000:
        {
            [self bizPay];
            break;
        }
        default:
            break;
    }
}

- (void)bizPay
{
    
    [MBProgressHUD showMessage:@"请稍候"];
    _wxPayMoney = [NSString stringWithFormat:@"%.0f",[_payChargeTextField.text floatValue]*100];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_wxPayMoney forKey:@"money"];
    [params setValue:@"192.168.0.20" forKey:@"ip"];
    [params setValue:@"码尚通企业端余额充值" forKey:@"detail"];
    [mgr POST:@"http://112.124.115.81/api/wechatPay/pay.php" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSLog(@"%@",responseObject);
        //获取到prepayid后进行第二次签名
        NSString    *package, *time_stamp, *nonce_str;
        //设置支付参数
        time_t now;
        time(&now);
        time_stamp  = [NSString stringWithFormat:@"%ld", now];
        nonce_str = [self md5HexDigest:time_stamp];
        //重新按提交格式组包，微信客户端暂只支持package=Sign=WXPay格式，须考虑升级后支持携带package具体参数的情况
        package         = @"Sign=WXPay";
        //第二次签名参数列表
        NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
        [signParams setObject: @"wx3760bac068655ead"  forKey:@"appid"];
        [signParams setObject: @"1294532301"  forKey:@"partnerid"];
        [signParams setObject: nonce_str    forKey:@"noncestr"];
        [signParams setObject: @"Sign=WXPay"      forKey:@"package"];
        [signParams setObject: time_stamp   forKey:@"timestamp"];
        [signParams setObject: responseObject[@"info"][@"prepay_id"] forKey:@"prepayid"];
        [signParams setObject:@"F36DA743251B99E9D7779D2209F6E3F6" forKey:@"key"];
        NSString *sign  = [self createMd5Sign:signParams];
        [signParams setObject: sign forKey:@"sign"];
        NSMutableString *stamp  = [signParams objectForKey:@"timestamp"];
        NSLog(@"%@",signParams);
        PayReq *req = [[PayReq alloc] init];
        req.openID  = [NSString stringWithFormat:@"%@",[signParams objectForKey:@"appid"]];
        req.partnerId = [NSString stringWithFormat:@"%@",[signParams objectForKey:@"partnerid"]];
        req.prepayId  = [NSString stringWithFormat:@"%@",[signParams objectForKey:@"prepayid"]];
        req.nonceStr  = [NSString stringWithFormat:@"%@",[signParams objectForKey:@"noncestr"]];
        req.timeStamp  = (UInt32)stamp.intValue;
        req.package = [NSString stringWithFormat:@"%@",[signParams objectForKey:@"package"]];
        req.sign = [NSString stringWithFormat:@"%@",[signParams objectForKey:@"sign"]];
        [WXApi sendReq:req];
        APP_DELEGATE.payMoney = [NSString stringWithFormat:@"%.0f",[_payChargeTextField.text floatValue]];
        [MBProgressHUD hideHUD];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误"];
    }];
}

-(NSString*) createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", @"F36DA743251B99E9D7779D2209F6E3F6"];
    //得到MD5 sign签名
    NSString *md5Sign =[self md5HexDigest:contentString];
    
    //输出Debug Info
    
    return md5Sign;
}

- (NSString *)md5HexDigest:(NSString *)input{
    
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];
    
    return output;
}

-(void)payAlipay
{
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
    order.amount = _payChargeTextField.text;
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
            
            [self informTheServerWithParams:params];
        }];
    }
}

- (void)informTheServerWithParams:(NSDictionary *)params
{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    [mgr POST:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"recharge"] parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NYLog(@"%@",responseObject);
        
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"result"]];
        
        if ([statusStr isEqualToString:@"1"]) {
            [MBProgressHUD showSuccess:@"充值成功"];
        } else {
            [self informTheServerWithParams:params];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        NYLog(@"%@",error.localizedDescription);
    }];
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
