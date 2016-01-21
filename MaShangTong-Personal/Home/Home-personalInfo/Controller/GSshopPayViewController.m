//
//  GSshopPayViewController.m
//  MaShangTong-Personal
//
//  Created by q on 16/1/5.
//  Copyright © 2016年 jeaner. All rights reserved.
//

#import "GSshopPayViewController.h"
#import "AFNetworking.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"

#import <WXApi.h>
#import <CommonCrypto/CommonDigest.h>

typedef enum{
    SelfMoney,//账户余额支付
    Alipay,  //支付宝支付
    WeChatPay   //微信支付
}PayType;

@interface GSshopPayViewController ()
{
    NSString *_wxPayMoney;
}
@property (nonatomic,assign) PayType payType;
@property (nonatomic,strong) UIButton *tempBtn;

@end

@implementation GSshopPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _makeSureBtn.layer.cornerRadius = 5.f;
    
    _totalPrice.text = _priceStr;
    _totalPriceLabel.text = _priceStr;
    _nameLabel.text = _goodsName;
    
    _payType = SelfMoney;
    _tempBtn = _moneyBtn;
    
    [self dealNavicatonItens];
}
#pragma mark - 设置NavicatonItens
-(void)dealNavicatonItens
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.text = @"提交订单";
    label.textAlignment = 1;
    label.font = [UIFont systemFontOfSize:19];
    label.textColor = RGBColor(99, 193, 255, 1.f);
    
    self.navigationItem.titleView = label;
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    leftBtn.size = CGSizeMake(22, 22);
    [leftBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
}
//返回Btn的点击事件
-(void)backBtnClick
{
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 余额支付
- (IBAction)moneyPay:(id)sender {
    [_tempBtn setImage:[UIImage imageNamed:@"payBtnDeselect"] forState:UIControlStateNormal];
    _payType = SelfMoney;
    [_moneyBtn setImage:[UIImage imageNamed:@"payBtnSelect"] forState:UIControlStateNormal];
    _tempBtn = _moneyBtn;
}
#pragma mark - 微信支付
- (IBAction)wechatPay:(id)sender {
    [_tempBtn setImage:[UIImage imageNamed:@"payBtnDeselect"] forState:UIControlStateNormal];
    _payType = WeChatPay;
    [_wechatBtn setImage:[UIImage imageNamed:@"payBtnSelect"] forState:UIControlStateNormal];
    _tempBtn = _wechatBtn;
}
#pragma mark - 支付宝支付
- (IBAction)alipay:(id)sender {
    [_tempBtn setImage:[UIImage imageNamed:@"payBtnDeselect"] forState:UIControlStateNormal];
    _payType = Alipay;
    [_alipayBtn setImage:[UIImage imageNamed:@"payBtnSelect"] forState:UIControlStateNormal];
    _tempBtn = _alipayBtn;
}

- (IBAction)makeSure:(id)sender {
    
    switch (_payType) {
        case SelfMoney:
            //余额支付
            [self selfMONeyPay];
            break;
        case WeChatPay:
            //微信支付
            break;
        case Alipay:
            //支付宝余额支付
            break;
            
        default:
            break;
    }
    
    
}
#pragma mark - 订单状态修改
-(void)changeRouteStatus
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[_route_id,@"1"] forKeys:@[@"array",@"status"]];
    
    [DownloadManager post:[NSString stringWithFormat:Mast_Url,@"ShcApi",@"update_status"] params:dic success:^(id json) {
        if (json) {
            NSNumber *num = json[@"data"];
            if ([num isEqualToNumber:[NSNumber numberWithInt:1]]) {
                NSInteger viewControllerNum = self.navigationController.viewControllers.count;
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:@"支付成功"];
                [self.navigationController popToViewController:self.navigationController.viewControllers[viewControllerNum - 4] animated:YES];
            }
        }
        else{
            [self changeRouteStatus];
        }
    } failure:^(NSError *error) {
        [self changeRouteStatus];
    }];
}
#pragma mark - 余额支付
-(void)selfMONeyPay
{
    [MBProgressHUD showMessage:@"正在支付"];
    NSString *userId = [USER_DEFAULT objectForKey:@"user_id"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:userId forKey:@"user_id"];
    [params setValue:[NSString stringWithFormat:@"%@",_priceStr] forKey:@"money"];
    [params setValue:@"2" forKey:@"type"];
    [params setValue:@"1" forKey:@"group_id"];
    
    NSLog(@"%@",params);
    
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"recharge"] params:params success:^(id json){
        if (json) {
//            NSString *str = [NSString stringWithFormat:@"%@",json[@"result"]];
//            if ([str isEqualToString:@"1"]) {
            
                [self changeRouteStatus];
                
//            }
//            else{
//                [MBProgressHUD hideHUD];
//                [MBProgressHUD showError:@"支付失败"];
//            }
        }
        else{
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"网络错误"];
        }
    }failure:^(NSError *error){
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请求超时"];
    }];
    
}
#pragma mark - 支付宝支付
-(void)payAlipay
{
    [MBProgressHUD showMessage:@"正在支付"];
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
    order.productDescription = @"码尚通车费";
//        order.amount = [NSString stringWithFormat:@"%.2f",_priceStr];
    order.amount = @"0.01";
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
        [MBProgressHUD hideHUD];
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            NYLog(@"reslut = %@",resultDic);
            NSString *resultStatusStr = [NSString stringWithFormat:@"%@",resultDic[@"resultStatus"]];
            if ([resultStatusStr isEqualToString:@"6001"]) {
                [MBProgressHUD showError:@"支付失败"];
                return ;
            }
            [MBProgressHUD showSuccess:@"购买成功"];
            //支付成功
            [self changeRouteStatus];
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

#pragma mark - 微信支付
-(void)payWeChat
{
    [MBProgressHUD showMessage:@"请稍候"];
    _wxPayMoney = [NSString stringWithFormat:@"%.0f",[_priceStr doubleValue]*1];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_wxPayMoney forKey:@"money"];
    [params setValue:@"192.168.0.20" forKey:@"ip"];
    [params setValue:@"码尚通个人端余额充值" forKey:@"detail"];
    [mgr POST:@"http://112.124.115.81/api/wechatPay/pay.php" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if (responseObject) {
            
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
            [MBProgressHUD hideHUD];
            
            APP_DELEGATE.paymoney = _priceStr;
            APP_DELEGATE.weChatPayType = Buyed;
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(weChatBuy) name:@"weChatBuy" object:nil];
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
-(void)weChatBuy
{
    [MBProgressHUD showSuccess:@"购买成功"];
    [self changeRouteStatus];
}

@end
