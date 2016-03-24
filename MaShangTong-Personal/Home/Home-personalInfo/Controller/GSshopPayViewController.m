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

#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "UPPaymentControl.h"

#define kModel_Developement            @"00"

typedef enum{
    SelfMoney,//账户余额支付
    Alipay,  //支付宝支付
    WeChatPay,   //微信支付
    BankPay    //银联支付
}PayType;

@interface GSshopPayViewController ()
{
    NSString *_wxPayMoney;
}
@property (nonatomic,assign) PayType payType;
@property (nonatomic,strong) UIButton *tempBtn;

@property (nonatomic,copy) NSString *tnModel;

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
    NYLog(@"返回");
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

#pragma mark - 银联支付
- (IBAction)bankPay:(id)sender {
    [_tempBtn setImage:[UIImage imageNamed:@"payBtnDeselect"] forState:UIControlStateNormal];
    _payType = BankPay;
    [_bankBtn setImage:[UIImage imageNamed:@"payBtnSelect"] forState:UIControlStateNormal];
    _tempBtn = _bankBtn;
}

- (IBAction)makeSure:(id)sender {
    
    switch (_payType) {
        case SelfMoney:
            //余额支付
            [self selfMONeyPay];
            break;
        case WeChatPay:
            //微信支付
            [self payWeChat];
            break;
        case Alipay:
            //支付宝余额支付
            [self payAlipay];
            break;
        case BankPay:
            [self payBank];
            break;
            
        default:
            break;
    }
    
    
}
#pragma mark - 订单状态修改
-(void)changeRouteStatus
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[_route_id,@"1",USER_ID] forKeys:@[@"array",@"status",@"user_id"]];
    [MBProgressHUD showMessage:@"正在支付"];
    [DownloadManager post:[NSString stringWithFormat:Mast_Url,@"ShcApi",@"update_status"] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        @try {
            if (json) {
                [MBProgressHUD hideHUD];
                NSNumber *num = json[@"data"];
                if ([num isEqualToNumber:[NSNumber numberWithInt:1]]) {
                    NSInteger viewControllerNum = self.navigationController.viewControllers.count;
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showSuccess:@"支付成功"];
                    [self.navigationController popToViewController:self.navigationController.viewControllers[viewControllerNum - 4] animated:YES];
                }
            }
            else{
                [MBProgressHUD hideHUD];
                [self changeRouteStatus];
            }
        } @catch (NSException *exception) {
            [MBProgressHUD hideHUD];
        } @finally {
            [MBProgressHUD hideHUD];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
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
    [params setValue:@"6" forKey:@"type"];
    [params setValue:_company_id forKey:@"company_id"];
    [params setValue:_ticket_id forKey:@"ticket_id"];
    
    NYLog(@"%@",params);
    
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"recharge"] params:params success:^(id json){
        [MBProgressHUD hideHUD];
        @try {
            if (json) {
                NSString *str = [NSString stringWithFormat:@"%@",json[@"data"]];
                if ([str isEqualToString:@"1"]) {
                    
                    [self changeRouteStatus];
                    
                }
                else{
                    [MBProgressHUD showError:@"支付失败"];
                }
            }
            else{
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
#pragma  mark - 微信和支付宝支付
-(void)payByAliapyOrWechat
{
    [MBProgressHUD showMessage:@"正在支付"];
    NSString *userId = [USER_DEFAULT objectForKey:@"user_id"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:userId forKey:@"user_id"];
    [params setValue:[NSString stringWithFormat:@"%@",_priceStr] forKey:@"money"];
    [params setValue:@"7" forKey:@"type"];
    [params setValue:_company_id forKey:@"company_id"];
    [params setValue:_ticket_id forKey:@"ticket_id"];
    
    NYLog(@"%@",params);
    
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"recharge"] params:params success:^(id json){
        @try {
            if (json) {
                [MBProgressHUD hideHUD];
                NSString *str = [NSString stringWithFormat:@"%@",json[@"data"]];
                if ([str isEqualToString:@"1"]) {
                    [MBProgressHUD hideHUD];
                    [self changeRouteStatus];
                }
                else{
                    [MBProgressHUD hideHUD];
                    [self payByAliapyOrWechat];
                }
            }
            else{
                [MBProgressHUD hideHUD];
                [self payByAliapyOrWechat];
            }
        } @catch (NSException *exception) {
            [MBProgressHUD hideHUD];
        } @finally {
            [MBProgressHUD hideHUD];
        }
    }failure:^(NSError *error){
        [MBProgressHUD hideHUD];
        [self payByAliapyOrWechat];
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
    order.productName = @"码尚通购买商品";
    order.productDescription = @"码尚通购买商品";
    order.amount = [NSString stringWithFormat:@"%.2f",[_priceStr floatValue]];
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
            [self payByAliapyOrWechat];
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
    
    _wxPayMoney = [NSString stringWithFormat:@"%.0f",[_priceStr doubleValue]*100];
//    _wxPayMoney = @"1";
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_wxPayMoney forKey:@"money"];
    [params setValue:@"192.168.0.20" forKey:@"ip"];
    [params setValue:@"码尚通购买商品" forKey:@"detail"];
    [mgr POST:@"http://139.196.189.159/api/wechatPay/pay.php" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
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
            [signParams setObject: responseObject[@"info"][@"prepayid"] forKey:@"prepayid"];
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
            [MBProgressHUD hideHUD];
            
            APP_DELEGATE.payMoney = _priceStr;
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
    [self payByAliapyOrWechat];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"weChatBuy" object:nil];
}

#pragma mark - 银联支付
-(void)payBank
{
    NSDictionary *parmas = @{@"money":[NSString stringWithFormat:@"%.0f",[_priceStr doubleValue]*100],@"uid":USER_ID};
//    NSDictionary *parmas = @{@"money":@"1",@"uid":USER_ID};
    self.tnModel = kModel_Developement;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:@"http://139.196.189.159/mst/api/cn/demo/api_05_app/Form_6_2_AppConsume.php" parameters:parmas success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *tn = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        APP_DELEGATE.banpayType = BankBuyed;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(bankBuyFare) name:@"bankBuyed" object:nil];
        
        [[UPPaymentControl defaultControl] startPay:tn fromScheme:@"MaShangTong" mode:self.tnModel viewController:self];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:@"支付失败"];
    }];
}
-(void)bankBuyFare
{
    [self payByAliapyOrWechat];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"bankBuyed" object:nil];
}
@end
