//
//  GSpayVC.m
//  MaShangTong
//
//  Created by q on 15/12/25.
//  Copyright © 2015年 NY. All rights reserved.
//

#import "GSpayVC.h"

#import "Order.h"
#import "DataSigner.h"
#import "AFNetworking.h"

#import "GSPayModel.h"
#import "ActualPriceModel.h"
#import "DriverInfoModel.h"

#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import <CommonCrypto/CommonDigest.h>

#import "GSchooseOrderViewController.h"
#import "NYCommentViewController.h"

typedef enum{
    SelfMoney,//账户余额支付
    Alipay,  //支付宝支付
    WeChat   //微信支付
}PayType;

@interface GSpayVC ()

{
    CGFloat _total_price;
    
    CGFloat _ture_price;
    
    NSDictionary *_dataDic;
    
    NSString *_wxPayMoney;
}
@property (nonatomic,assign) PayType payType;

@property (nonatomic,strong) UIButton *tempBtn;


@end

@implementation GSpayVC

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataDic = [NSDictionary new];
    
   
    _makeSureBtn.layer.cornerRadius = 5.f;
    _makeSureBtn.layer.masksToBounds = YES;
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.backgroundColor = [UIColor clearColor];
    clearBtn.size = CGSizeMake(300, 21);
    clearBtn.center = _youhuiLabel.center;
    [clearBtn addTarget:self action:@selector(chooseOrder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearBtn];
    

    _payType = SelfMoney;
    [_selfMoneyBtn setImage:[UIImage imageNamed:@"payBtnSelect"] forState:UIControlStateNormal];
    _tempBtn = _selfMoneyBtn;
    
    _orderPayType = DisUseOrderPay;
    
    [self getDriverInfo];
    [self dealNaviction];
    [self getPriceAndOthers];
    
    
}
#pragma mark - 选择优惠券
-(void)chooseOrder {
    
    __weak typeof (self) weakSelf = self;
    
    GSchooseOrderViewController *vc = [[GSchooseOrderViewController alloc]init];
    //回调
    vc.backTicket = ^(NSString *ticket_id,NSString *ticket_money){
        weakSelf.ticket_id = ticket_id;
        weakSelf.ticket_money = ticket_money;
        NYLog(@"%@,%@",ticket_id,ticket_money);
        weakSelf.orderPayType = UseOrderPay;
        
        _ture_price = _total_price - [ticket_money  doubleValue];
        if (_ture_price < 0) {
            _ture_price = 0;
            weakSelf.youhuiLabel.text = [NSString stringWithFormat:@"-%.2f元>",_total_price];
        }
        else{
            weakSelf.youhuiLabel.text = [NSString stringWithFormat:@"-%@元>",  ticket_money];
        }
        NSString *title =[NSString stringWithFormat:@"确认支付：%.2f",_ture_price];
        [weakSelf.makeSureBtn setTitle:title forState:UIControlStateNormal];
    };
    
    vc.backNothing = ^(){
        weakSelf.orderPayType = DisUseOrderPay;
        weakSelf.youhuiLabel.text = @"0元>";
        _ture_price = _total_price ;
        
        NSString *title =[NSString stringWithFormat:@"确认支付：%.2f",_ture_price ];
        [weakSelf.makeSureBtn setTitle:title forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)dealNaviction
{
    [self.navigationItem setHidesBackButton:YES];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.text = @"支付车费";
    label.textAlignment = 1;
    label.font = [UIFont systemFontOfSize:19];
    label.textColor = RGBColor(99, 193, 255, 1.f);
    
    self.navigationItem.titleView = label;
    
}

#pragma mark - 填充数据
-(void)displayData
{
    [_touxiangImage sd_setImageWithURL:[NSURL URLWithString:self.driverModel.head_image]];
    _sijiName.text = _driverModel.owner_name;
    _numberLabel.text = _driverModel.license_plate;
    _compareName.text = @"友联出租";
    [self setStarsWith:[self.driverModel.averagePoint floatValue]];
    _danLabel.text = [NSString stringWithFormat:@"%@单",_driverModel.num];
    
}

#pragma mark - 设置评分的星星
-(void)setStarsWith:(CGFloat)num
{
    
    UIImageView *bottomIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bluHui"]];
    bottomIV.frame = CGRectMake(0, 0, 57, 11);
    [_starBottomView addSubview:bottomIV];
    
    
    _starView = [[UIView alloc]initWithFrame:CGRectMake(_starBottomView.frame.origin.x, _starBottomView.frame.origin.y, (57/5)*num, 11)];
    _starView.clipsToBounds = YES;
    [self.view addSubview:_starView];
    
    UIImageView *lightIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blueLiang"]];
    lightIV.frame = CGRectMake(0, 0, 57, 11);
    
    [_starView addSubview:lightIV];

}

- (IBAction)chooseOrder:(id)sender {
//
//    NSLog(@"点击事件");
//    __weak typeof (self) weakSelf = self;
//    GSchooseOrderViewController *vc = [[GSchooseOrderViewController alloc]init];
//    vc.backTicket = ^(NSString *ticket_id,NSString *ticket_money){
//        weakSelf.ticket_id = ticket_id;
//        weakSelf.ticket_money = ticket_money;
//        
//        weakSelf.orderPayType = UseOrderPay;
//        
//        weakSelf.youhuiLabel.text = [NSString stringWithFormat:@"-%@元",  ticket_money];
//        NSString *title =[NSString stringWithFormat:@"确认支付：%.2f",(_total_price - [ticket_money  doubleValue])];
//        [weakSelf.makeSureBtn setTitle:title forState:UIControlStateNormal];
//    };
//    [self.navigationController pushViewController:vc animated:YES];
}
//打电话
- (IBAction)call:(id)sender {
    NYLog(@"call");
    
    if (!_driverModel) {
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:_driverModel.mobile message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_driverModel.mobile]]];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
//账户余额支付
- (IBAction)selfMoneyAction:(id)sender {
    NYLog(@"余额支付");
    [_tempBtn setImage:[UIImage imageNamed:@"payBtnDeselect"] forState:UIControlStateNormal];
    _payType = SelfMoney;
    [_selfMoneyBtn setImage:[UIImage imageNamed:@"payBtnSelect"] forState:UIControlStateNormal];
    _tempBtn = _selfMoneyBtn;
}

//支付宝支付
- (IBAction)aliPayAction:(id)sender {
    [_tempBtn setImage:[UIImage imageNamed:@"payBtnDeselect"] forState:UIControlStateNormal];
    _payType = Alipay;
    [_alipayBtn setImage:[UIImage imageNamed:@"payBtnSelect"] forState:UIControlStateNormal];
    _tempBtn = _alipayBtn;
}
//微信支付
- (IBAction)weChatPayAction:(id)sender {
    [_tempBtn setImage:[UIImage imageNamed:@"payBtnDeselect"] forState:UIControlStateNormal];
    _payType = WeChat;
    [_weChatBtn setImage:[UIImage imageNamed:@"payBtnSelect"] forState:UIControlStateNormal];
    _tempBtn = _weChatBtn;
}

- (IBAction)makeSureAction:(id)sender {
    switch (_payType) {
        case SelfMoney:
            NYLog(@"账户余额支付");
            [self selfMONeyPay];
            break;
        case Alipay:
            NYLog(@"支付宝支付");
            [self payAlipay];
            break;
        case WeChat:
            NYLog(@"微信支付");
            [self payWeChat];
            break;
            
        default:
            break;
    }
}
#pragma mark - 余额支付
-(void)selfMONeyPay
{
    [MBProgressHUD showMessage:@"正在支付"];
    NSString *userId = [USER_DEFAULT objectForKey:@"user_id"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:userId forKey:@"user_id"];
    [params setValue:[NSString stringWithFormat:@"%.2f",_total_price] forKey:@"money"];
    if (_orderPayType == DisUseOrderPay) {
        [params setValue:@"2" forKey:@"type"];
    }
    else if (_orderPayType == UseOrderPay){
        [params setValue:@"3" forKey:@"type"];
        [params setValue:_ticket_id forKey:@"ticket_id"];
    }
    
    [params setValue:@"1" forKey:@"group_id"];
    [params setValue:_route_id forKey:@"route_id"];
    NYLog(@"%@",params);
    
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"recharge"] params:params success:^(id json){
        NYLog(@"%@",json);
        @try {
            if (json) {
                if ([json[@"result" ] isEqualToString:@"1" ]) {
                    
                    [self rebackOrderState];
                    
                }
                else{
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:@"支付失败"];
                }
            }
            else{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"网络错误"];
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }failure:^(NSError *error){
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请求超时"];
    }];

}

#pragma mark - 支付宝支付
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
    order.productName = @"码尚通车费支付";
    order.productDescription = @"码尚通车费支付";
    order.amount = [NSString stringWithFormat:@"%.2f",_ture_price];
//    order.amount = @"0.01";
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
                [MBProgressHUD showError:@"支付失败"];
                return ;
            }
            
            NSString *userId = [USER_DEFAULT objectForKey:@"user_id"];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:userId forKey:@"user_id"];
            
            if (_orderPayType == DisUseOrderPay) {
                [params setValue:@"2" forKey:@"type"];
                [params setValue:_route_id forKey:@"route_id"];
                [params setValue:[NSString stringWithFormat:@"%f",_total_price] forKey:@"money"];
                [params setValue:@"1" forKey:@"group_id"];
            }
            else if (_orderPayType == UseOrderPay){
                [params setValue:@"5" forKey:@"type"];
                [params setValue:_ticket_id forKey:@"ticket_id"];
                [params setValue:[NSString stringWithFormat:@"%f",_total_price] forKey:@"last_money"];
                [params setValue:self.driverModel.driver_id forKey:@"driver_id"];
            }
            
            
            [self payPriceWith:params];
            
        }];

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
-(void)payPriceWith:(NSMutableDictionary *)params
{
    [MBProgressHUD hideHUD];
    [MBProgressHUD showMessage:@"正在支付"];
    NYLog(@"%@",params);
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"recharge"] params:params success:^(id json){
        @try {
            if (json) {
                NSString *str = [NSString stringWithFormat:@"%@",json[@"result"]];
                if ([str isEqualToString:@"1"]) {
                    [MBProgressHUD hideHUD];
                    [self rebackOrderState];
                }
                else{
                    [self payPriceWith:params];
                }
            }
            else{
                [self payPriceWith:params];
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }failure:^(NSError *error){
        [self payPriceWith:params];
    }];

}
#pragma mark - 微信支付
-(void)payWeChat
{
    _wxPayMoney = [NSString stringWithFormat:@"%.0f",_ture_price*100];
//    _wxPayMoney = @"1";
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_wxPayMoney forKey:@"money"];
    [params setValue:@"192.168.0.20" forKey:@"ip"];
    [params setValue:@"码尚通车费支付" forKey:@"detail"];
    [mgr POST:@"http://112.124.115.81/api/wechatPay/pay.php" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (responseObject) {
            
            NYLog(@"%@",responseObject);
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
            NYLog(@"%@",signParams);
            //发起请求
            PayReq *req = [[PayReq alloc] init];
            
            req.openID  = [NSString stringWithFormat:@"%@",[signParams objectForKey:@"appid"]];
            req.partnerId = [NSString stringWithFormat:@"%@",[signParams objectForKey:@"partnerid"]];
            req.prepayId  = [NSString stringWithFormat:@"%@",[signParams objectForKey:@"prepayid"]];
            req.nonceStr  = [NSString stringWithFormat:@"%@",[signParams objectForKey:@"noncestr"]];
            req.timeStamp  = (UInt32)stamp.intValue;
            req.package = [NSString stringWithFormat:@"%@",[signParams objectForKey:@"package"]];
            req.sign = [NSString stringWithFormat:@"%@",[signParams objectForKey:@"sign"]];
            
            [WXApi sendReq:req];
            
            APP_DELEGATE.paymoney = [NSString stringWithFormat:@"%.2f",_ture_price];
            APP_DELEGATE.weChatPayType = Payed;
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(weChatPayMoneyWith:) name:@"weChatPay" object:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误"];
    }];
    
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
#pragma mark - 微信支付
-(void)weChatPayMoneyWith:(NSNotification *)sender
{
    [MBProgressHUD showMessage:@"正在支付,请稍后"];
    NSMutableDictionary *params = (NSMutableDictionary *)sender.userInfo;
    
    if (_orderPayType == DisUseOrderPay) {
        [params setValue:[NSString stringWithFormat:@"%.2f",_ture_price] forKey:@"money"];
        [params setValue:_route_id forKey:@"route_id"];
        [params setValue:@"1" forKey:@"group_id"];
    }
    else if (_orderPayType == UseOrderPay){
        [params setValue:[NSString stringWithFormat:@"%.2f",_ture_price] forKey:@"last_money"];
        [params setValue:@"5" forKey:@"type"];
        [params setValue:_ticket_id forKey:@"ticket_id"];
        [params setValue:self.driverModel.driver_id forKey:@"driver_id"];
    }
    
    [DownloadManager post:[NSString stringWithFormat:Mast_Url,@"UserApi",@"recharge"] params:params success:^(id json){
        
        @try {
            if (json) {
                NSString *str = json[@"result"];
                if ([str isEqualToString:@"1"]) {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showSuccess:@"支付成功"];
                    [self rebackOrderState];
                }
                else{
                    [self weChatPayMoneyWith:[NSNotification notificationWithName:@"weChatPay" object:nil]];
                }
            }
            else{
                [self weChatPayMoneyWith:[NSNotification notificationWithName:@"weChatPay" object:nil]];
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }failure:^(NSError *error){
        [self weChatPayMoneyWith:[NSNotification notificationWithName:@"weChatPay" object:nil]];
    }];
}

#pragma mrak - 返回订单状态
-(void)rebackOrderState
{
    [MBProgressHUD hideHUD];
    [MBProgressHUD showMessage:@"正在支付"];
    NYLog(@"%@",@{@"route_id":_route_id,@"route_status":@"6"});
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"OrderApi",@"boarding"] params:@{@"route_id":_route_id,@"route_status":@"6"} success:^(id json) {
        
        @try {
            if (json) {
                NSString *str = [NSString stringWithFormat:@"%@",json[@"result"]];
                if ([str isEqualToString:@"1"]) {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showSuccess:@"支付成功"];
                    NYCommentViewController *comment = [[NYCommentViewController alloc] init];
                    comment.driverInfoModel = self.driverModel;
                    comment.route_id = self.route_id;
                    [self.navigationController pushViewController:comment animated:YES];
                }
                else
                {
                    [self rebackOrderState];
                }
            }
            else{
                [self rebackOrderState];
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    } failure:^(NSError *error) {
        [self rebackOrderState];
    }];
}
#pragma mark - 获取价钱
-(void)getPriceAndOthers
{
    [MBProgressHUD showMessage:@"加载中"];
    NSDictionary *param = [NSDictionary dictionaryWithObject:_route_id forKey:@"route_id"];
    
    
    NSString *url = [NSString stringWithFormat:URL_HEADER,@"OrderApi",@"check_bill"];
    
    [DownloadManager post:url params:param success:^(id json) {
        [MBProgressHUD hideHUD];
        @try {
            if (json) {
                NSNumber *num  = json[@"data"];
                if ([num isEqualToNumber:[NSNumber numberWithInt:1]]) {
                    _dataDic = json[@"info"];
                    
                    _total_price = [_dataDic[@"total_price"] doubleValue];
                    _ture_price = [_dataDic[@"total_price"] doubleValue];
                    
                    _fareLabel.text = [NSString stringWithFormat:@"%@元",  _dataDic[@"total_price"]];
                    _distanceLabel.text = [NSString stringWithFormat:@"%.2fkm",[_dataDic[@"mileage"] floatValue]];
                    _carbonLabel.text = [NSString stringWithFormat:@"%.2fkg",[_dataDic[@"carbon_emission"] floatValue]];
                    
                    NSString *title =[NSString stringWithFormat:@"确认支付：%.2f",_total_price];
                    [_makeSureBtn setTitle:title forState:UIControlStateNormal];
                    
                }
                else{
                    [self getPriceAndOthers];
                }
            }
            else{
                [self getPriceAndOthers];
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [self getPriceAndOthers];
    }];

}
#pragma mark - 请求司机信息
-(void)getDriverInfo
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.route_id forKey:@"route_id"];
    
    [DownloadManager post:[NSString stringWithFormat:Mast_Url,@"orderApi",@"dri_info"] params:param success:^(id json) {
        @try {
            if (json) {
                
                self.driverModel = [[DriverInfoModel alloc] initWithDictionary:json[@"data"] error:nil];
                [self displayData];
                
            }
            else{
                [self getDriverInfo];
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    } failure:^(NSError *error) {
        [self getDriverInfo];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end
