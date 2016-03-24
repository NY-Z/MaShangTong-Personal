//
//  GSrechargeVC.m
//  MaShangTong
//
//  Created by q on 15/12/23.
//  Copyright © 2015年 NY. All rights reserved.
//

#import "GSrechargeVC.h"
#import "Order.h"
#import "DataSigner.h"
#import "AFNetworking.h"


#import <AlipaySDK/AlipaySDK.h>
#import <CommonCrypto/CommonDigest.h>
#import "WXApi.h"

#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "UPPaymentControl.h"

#define kModel_Developement            @"00"

typedef enum{
    Alipay,  //支付宝支付
    WeChat,  //微信支付
    Bank      //银联支付
}RechargeType;

@interface GSrechargeVC ()


{
    NSString *_wxPayMoney;
    
    NSString *_bankPayMoney;
}
//支付方式
@property (nonatomic,assign) RechargeType rechargeType;


@property (nonatomic,strong) UIButton *tempBtn;



@property (nonatomic,copy) NSString *tnModel;
@end

@implementation GSrechargeVC

-(void)viewWillAppear:(BOOL)animated
{
    _monryTextFiled.text = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _rechargeType = Alipay;
    [_alipayBtn setImage:[UIImage imageNamed:@"payBtnSelect"] forState:UIControlStateNormal];
    _tempBtn = _alipayBtn;
    
    _rechargeBtn.layer.cornerRadius = 3.f;
    
    [self dealNavicatonItens];
    
}
#pragma mark - 设置NavicatonItens
-(void)dealNavicatonItens
{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.text = @"充值";
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
    [_monryTextFiled resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
//支付宝充值
- (IBAction)doAlipay:(id)sender {
    [_tempBtn setImage:[UIImage imageNamed:@"payBtnDeselect"] forState:UIControlStateNormal];
    _rechargeType = Alipay;
    [_alipayBtn setImage:[UIImage imageNamed:@"payBtnSelect"] forState:UIControlStateNormal];
    _tempBtn = _alipayBtn;
}
//微信充值
- (IBAction)doWeChat:(id)sender {
    [_tempBtn setImage:[UIImage imageNamed:@"payBtnDeselect"] forState:UIControlStateNormal];
    _rechargeType = WeChat;
    [_weChatBtn setImage:[UIImage imageNamed:@"payBtnSelect"] forState:UIControlStateNormal];
    _tempBtn = _weChatBtn;
}

- (IBAction)daBank:(id)sender {
    [_tempBtn setImage:[UIImage imageNamed:@"payBtnDeselect"] forState:UIControlStateNormal];
    _rechargeType = Bank;
    [_bankPay setImage:[UIImage imageNamed:@"payBtnSelect"] forState:UIControlStateNormal];
    _tempBtn = _bankPay;
}

- (IBAction)doRecharge:(id)sender {
    [_monryTextFiled resignFirstResponder];
    if (_monryTextFiled.text.length < 1) {
        [MBProgressHUD showError:@"请输入金额。"];
        return;
    }
    switch (_rechargeType) {
        
        case Alipay:
            NYLog(@"支付宝支付");
            [self payAlipay];
            break;
        case WeChat:
            NYLog(@"微信支付");
            [self payWeChat];
            break;
        case Bank:
            [self payBank];
            break;
            
        default:
            break;
    }
}
#pragma mark - 支付宝充值
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
    order.amount = _monryTextFiled.text;
//    order.amount = @"0.01";
    order.notifyURL =  @"www.baidu.com"; //回调URL
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
            [params setValue:@"1" forKey:@"group_id"];
            
            [self rechargeMoneyWith:params];
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
-(void)rechargeMoneyWith:(NSDictionary *)params
{
    [MBProgressHUD hideHUD];
    [MBProgressHUD showMessage:@"正在充值,请稍后"];
    
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"recharge"] params:params success:^(id json){
        [MBProgressHUD hideHUD];
        NYLog(@"%@",json);
        if (json) {
            NSString *str = json[@"result"];
            if ([str isEqualToString:@"1"]) {
                [MBProgressHUD showSuccess:@"充值成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                [self rechargeMoneyWith:params];
            }
        }
        else{
            [self rechargeMoneyWith:params];
        }
        
    }failure:^(NSError *error){
        [MBProgressHUD hideHUD];
        [self rechargeMoneyWith:params];
    }];
}
#pragma mark - 微信充值
-(void)payWeChat
{
    [MBProgressHUD showMessage:@"正在跳转微信，请稍后"];
    _wxPayMoney = [NSString stringWithFormat:@"%.0f",[_monryTextFiled.text floatValue]*100];
//    _wxPayMoney = @"1";
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_wxPayMoney forKey:@"money"];
    [params setValue:@"码尚通余额充值" forKey:@"detail"];
    [params setValue:USER_ID forKey:@"uid"];
    [mgr POST:@"http://139.196.189.159/api/wechatPay/pay.php" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
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
        
        APP_DELEGATE.payMoney = [NSString stringWithFormat:@"%.2f",[_monryTextFiled.text floatValue]];
        APP_DELEGATE.weChatPayType = RechargePayed;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(weChatRechargeMoneyWith:) name:@"weChatRecharge" object:nil];
        
        
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

-(void)weChatRechargeMoneyWith:(NSNotification *)sender
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"weChatRecharge" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
    //    NSLog(@"succeed");
    //
//    [MBProgressHUD showMessage:@"正在充值,请稍后"];
//    NSMutableDictionary *params =(NSMutableDictionary *)sender.userInfo;
//    [params setValue:@"1" forKey:@"group_id"];
//    
//    [DownloadManager post:[NSString stringWithFormat:Mast_Url,@"UserApi",@"recharge"] params:params success:^(id json){
//        [MBProgressHUD hideHUD];
//        NYLog(@"%@",json);
//        [MBProgressHUD hideHUD];
//        if (json) {
//            NSString *str = json[@"result"];
//            if ([str isEqualToString:@"1"]) {
//                [MBProgressHUD hideHUD];
//                [MBProgressHUD showSuccess:@"充值成功"];
//                [[NSNotificationCenter defaultCenter] removeObserver:self name:@"weChatRecharge" object:nil];
//                [self.navigationController popViewControllerAnimated:YES];
//            }
//            else{
//                [self weChatRechargeMoneyWith:[NSNotification notificationWithName:@"weChatRecharge" object:sender]];
//            }
//        }
//        else{
//            [self weChatRechargeMoneyWith:[NSNotification notificationWithName:@"weChatRecharge" object:sender]];
//        }
//        
//    }failure:^(NSError *error){
//        [MBProgressHUD hideHUD];
//        [self weChatRechargeMoneyWith:[NSNotification notificationWithName:@"weChatRecharge" object:sender]];
//    }];
}

#pragma mark - 银联支付
-(void)payBank
{
    NSDictionary *parmas = @{@"money":[NSString stringWithFormat:@"%.0f",[_monryTextFiled.text floatValue]*100],@"uid":USER_ID};
    
//    NSDictionary *parmas = @{@"money":@"1",@"uid":USER_ID};
    self.tnModel = kModel_Developement;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:@"http://112.124.115.81/mst/api/cn/demo/api_05_app/Form_6_2_AppConsume.php" parameters:parmas success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *tn = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        _bankPayMoney = [NSString stringWithFormat:@"%.2f",[_monryTextFiled.text floatValue]];
        
        APP_DELEGATE.banpayType = RechargeBankPayed;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(bankBuyFare) name:@"bankRecharge" object:nil];
        
       
        
        [[UPPaymentControl defaultControl] startPay:tn fromScheme:@"MaShangTong" mode:self.tnModel viewController:self];
        
//        [[UPPaymentControl defaultControl] handlePaymentResult:[NSURL URLWithString:@"http://112.124.115.81/mst/api/cn/demo/api_05_app/BackReceive.php"] completeBlock:^(NSString *code, NSDictionary *data) {
//            NSLog(@"%@,%@",code,data);
//            NSLog(@"壮哥个大傻X");
//        }];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:@"支付失败"];
    }];
    
}
-(void)bankBuyFare
{
    NSString *userId = [USER_DEFAULT objectForKey:@"user_id"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:userId forKey:@"user_id"];
    [params setValue:_bankPayMoney forKey:@"money"];
    [params setValue:@"1" forKey:@"type"];
    [params setValue:@"1" forKey:@"group_id"];
    
    [self rechargeMoneyWith:params];
        
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
