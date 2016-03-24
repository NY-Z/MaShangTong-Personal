//
//  AppDelegate.m
//  MaShangTong-Personal
//
//  Created by jeaner on 15/11/10.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "AppDelegate.h"
#import "MAMapKit.h"
#import "AMapSearchKit.h"
#import "RegisViewController.h"
#import "AlipaySDK.h"
#import "AMapLocationKit.h"
#import "AMapNaviKit.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlySetting.h"
#import "IQKeyboardManager.h"
#import "WXApi.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialSinaHandler.h"

#import "WaitForTheOrderViewController.h"
#import "PayChargeViewController.h"
#import "CompanyHomeViewController.h"
#import "NYCommentViewController.h"
#import "PayChargeViewController.h"
#import "HomeViewController.h"

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "UPPaymentControl.h"
#import "USA.h"
#import <CommonCrypto/CommonDigest.h>

//新增代码
#if defined (__unix) || (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
#ifndef __ENABLE_COMPATIBILITY_WITH_UNIX_2003__
#define __ENABLE_COMPATIBILITY_WITH_UNIX_2003__
#include <stdio.h>
#include <dirent.h>
FILE *fopen$UNIX2003( const char *filename, const char *mode )
{
    return fopen(filename, mode);
}
size_t fwrite$UNIX2003( const void *a, size_t b, size_t c, FILE *d )
{
    return fwrite(a, b, c, d);
}
char *strerror$UNIX2003( int errnum )
{

    return strerror(errnum);
}

DIR *opendir$INODE64(const char * a)
{
    return opendir(a);
}

struct dirent *readdir$INODE64(DIR *dir)
{
    return readdir(dir);
}

int fputs$UNIX2003 ( const char *filename, FILE *mode )
{
    return fputs(filename, mode);
}

#endif
#endif
//结束

@interface AppDelegate () <WXApiDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 友盟分享
    [UMSocialData setAppKey:(NSString *)UMSocialAppKey];
    [UMSocialQQHandler setQQWithAppId:@"1105007699" appKey:@"bCDtAHTxJBP80oUA" url:@"http://www.51mast.com"];
    [UMSocialQQHandler setSupportWebView:YES];
    [UMSocialWechatHandler setWXAppId:@"wx3760bac068655ead" appSecret:@"d4624c36b6795d1d99dcf0547af5443d" url:@"http://www.51mast.com"];

    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://www.51mast.com"];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"147809891" RedirectURL:@"http://www.51mast.com"];

    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0
                                                            diskCapacity:0
                                                                diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];

    // 微信支付
    [WXApi registerApp:(NSString *)WxAppId withDescription:@"demo 2.0"];

    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;

    [MAMapServices sharedServices].apiKey = AMap_ApiKey;
    [AMapSearchServices sharedServices].apiKey = AMap_ApiKey;
    [AMapLocationServices sharedServices].apiKey = AMap_ApiKey;
    [AMapNaviServices sharedServices].apiKey = AMap_ApiKey;


    [IFlySpeechUtility createUtility:[NSString stringWithFormat:@"appid=%@,timeout=%@",@"5565399b",@"20000"]];
    [IFlySetting setLogFile:LVL_NONE];
    [IFlySetting showLogcat:NO];

    // 设置语音合成的参数
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"50" forKey:[IFlySpeechConstant SPEED]];//合成的语速,取值范围 0~100
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"50" forKey:[IFlySpeechConstant VOLUME]];//合成的音量;取值范围 0~100

    // 发音人,默认为”xiaoyan”;可以设置的参数列表可参考个 性化发音人列表;
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"xiaoyan" forKey:[IFlySpeechConstant VOICE_NAME]];

    // 音频采样率,目前支持的采样率有 16000 和 8000;
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"8000" forKey:[IFlySpeechConstant SAMPLE_RATE]];

    // 当你再不需要保存音频时，请在必要的地方加上这行。
    [[IFlySpeechSynthesizer sharedInstance] setParameter:nil forKey:[IFlySpeechConstant TTS_AUDIO_PATH]];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    NSString *str = [USER_DEFAULT objectForKey:@"isLogin"];
    if ([str isEqualToString:@"1"]) {
        NSString *str = [USER_DEFAULT objectForKey:@"group_id"];
        if ([str isEqualToString:@"1"]) {
            HomeViewController *personalHome = [[HomeViewController alloc]init];
            self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:personalHome];
        }
        else{
            CompanyHomeViewController *companyHome = [[CompanyHomeViewController alloc] init];
            self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:companyHome];
        }
    } else {
        RegisViewController *regis = [[RegisViewController alloc] init];
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:regis];
    }

    [self.window makeKeyAndVisible];
    return YES;
}
-(BOOL)veritfy:(NSString *)resulStr{

    //从NSString转化为NSDictonary
    NSData *resultData = [resulStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:resultData options:0 error:nil];

    NSString *sign = data[@"sign"];
    NSString *signElements = data[@"data"];

    //转换服务器签名数据
    NSData *nsdataFromBase64String = [[NSData alloc]initWithBase64EncodedString:sign options:0];

    //获取生成本地签名数据，并生成摘要
    NSData *dataOrgial = [[self sha1:signElements] dataUsingEncoding:NSUTF8StringEncoding];

    //验证签名
    //TODO：此处如果是正式环境需要换成public_product.key
    NSString *pubKey = [self readPublicKey:@"mast.pfx"];
    OSStatus result = [USA verifyData:dataOrgial sig:nsdataFromBase64String publicKey:pubKey];

    //签名验证成功，商户app做后续处理
    if (result == 0) {
        //支付成功且验签成功，展示支付成功提示

        NSLog(@"成功");
        if(self.banpayType == BankPayed){//车费支付
            [[NSNotificationCenter defaultCenter]postNotificationName:@"bankPayed" object:nil userInfo:nil];
        }
        if (self.banpayType == BankBuyed) {//商城消费
            [[NSNotificationCenter defaultCenter]postNotificationName:@"bankBuyed" object:nil userInfo:nil];
        }
        if (self.banpayType == RechargeBankPayed) {//余额充值
            [[NSNotificationCenter defaultCenter]postNotificationName:@"bankRecharge" object:nil userInfo:nil];
        }
        return  YES;
    }
    else{
        //验证失败，交易结果数据被篡改，商户app后台查询交易结果
        return NO;
    }

    return NO;
}
- (NSString *) readPublicKey:(NSString *) keyName
{
    if (keyName == nil || [keyName isEqualToString:@""]) return nil;

    NSMutableArray *filenameChunks = [[keyName componentsSeparatedByString:@"."] mutableCopy];
    NSString *extension = filenameChunks[[filenameChunks count] - 1];
    [filenameChunks removeLastObject]; // remove the extension
    NSString *filename = [filenameChunks componentsJoinedByString:@"."]; // reconstruct the filename with no extension

    NSString *keyPath = [[NSBundle mainBundle] pathForResource:filename ofType:extension];

    NSString *keyStr = [NSString stringWithContentsOfFile:keyPath encoding:NSUTF8StringEncoding error:nil];

    return keyStr;
}
- (NSString*)sha1:(NSString *)string
{
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1_CTX context;
    NSString *description;

    CC_SHA1_Init(&context);

    memset(digest, 0, sizeof(digest));

    description = @"";


    if (string == nil)
    {
        return nil;
    }

    // Convert the given 'NSString *' to 'const char *'.
    const char *str = [string cStringUsingEncoding:NSUTF8StringEncoding];

    // Check if the conversion has succeeded.
    if (str == NULL)
    {
        return nil;
    }

    // Get the length of the C-string.
    int len = (int)strlen(str);

    if (len == 0)
    {
        return nil;
    }


    if (str == NULL)
    {
        return nil;
    }

    CC_SHA1_Update(&context, str, len);

    CC_SHA1_Final(digest, &context);

    description = [NSString stringWithFormat:
                   @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[ 0], digest[ 1], digest[ 2], digest[ 3],
                   digest[ 4], digest[ 5], digest[ 6], digest[ 7],
                   digest[ 8], digest[ 9], digest[10], digest[11],
                   digest[12], digest[13], digest[14], digest[15],
                   digest[16], digest[17], digest[18], digest[19]];

    return description;
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

    //跳转银联进行支付.
    [[UPPaymentControl defaultControl]handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {

        //结果code为成功时，先校验签名，校验成功后做后续处理
        if ([code isEqualToString:@"success"]) {

            //结果code为成功时，先校验签名，校验成功后做后续处理
            if(data == nil){
                //如果没有签名数据，建议商户app后台查询交易结果
                return ;
            }

            //数据从NSDictionary转换为NSString
            NSData *signData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];

            NSString *sign = [[NSString alloc]initWithData:signData encoding:NSUTF8StringEncoding];

            //验签证书同后台验签证书
            //此处的verify，商户送去商户后台做验签
            if([self veritfy:sign]){
                //支付成功且验签成功，展示支付成功提示

            }
            else{
                //验签失败，交易结果数据被篡改，商户后台查询建议结果
            }


            if([[USER_DEFAULT objectForKey:@"group_id"] isEqualToString:@"1"]){
                if(self.banpayType == BankPayed){//车费支付
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"bankPayed" object:nil userInfo:nil];
                }
                else if (self.banpayType == BankBuyed) {//商城消费
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"bankBuyed" object:nil userInfo:nil];
                }
                else if (self.banpayType == RechargeBankPayed) {//余额充值
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"bankRecharge" object:nil userInfo:nil];
                }
            }
            else{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"companyRecharge" object:nil userInfo:nil];
            }
        }
        else if([code isEqualToString:@"fail"]){
            //交易失败
        }

        else if ([code isEqualToString:@"cancel"]){
            //交易取消
        }
    }];

    //跳转支付宝钱包进行支付，处理支付结果c
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NYLog(@"result = %@",resultDic);
    }];

    //跳转微信进行支付。
    [WXApi handleOpenURL:url delegate:self];

    //友盟社交化分享
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {


    }
    return result;

    return YES;
}

-(void) onResp:(BaseResp*)resp
{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
            {
                NYLog(@"支付成功");
                NSString *userId = [USER_DEFAULT objectForKey:@"user_id"];
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                [params setValue:userId forKey:@"user_id"];

                if([[USER_DEFAULT objectForKey:@"group_id"] isEqualToString:@"1"]){
                    if(self.weChatPayType == RechargePayed){
                        [params setValue:APP_DELEGATE.payMoney forKey:@"money"];
                        [params setValue:@"1" forKey:@"type"];

                        [[NSNotificationCenter defaultCenter]postNotificationName:@"weChatRecharge" object:nil userInfo:params];
                    }
                    else if (self.weChatPayType == Payed){
                        [params setValue:APP_DELEGATE.payMoney forKey:@"money"];
                        [params setValue:@"2" forKey:@"type"];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"weChatPay" object:nil userInfo:params];
                    }
                    else if (self.weChatPayType == Buyed){
                        [params setValue:APP_DELEGATE.payMoney forKey:@"money"];
                        [params setValue:@"2" forKey:@"type"];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"weChatBuy" object:nil userInfo:params];
                    }

                    self.weChatPayType = NonePayed;
                } else {
                    [params setValue:APP_DELEGATE.payMoney forKey:@"money"];
                    [params setValue:@"1" forKey:@"type"];
                    [params setValue:@"2" forKey:@"group_id"];
                    [self informTheServerWithParams:params];
                }
            }
                break;
            default:
                NYLog(@"支付失败，retcode=%d",resp.errCode);
                break;
        }
    }
}

- (void)informTheServerWithParams:(NSDictionary *)params
{
    //    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    //    [mgr POST:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"recharge"] parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
    //
    //        NYLog(@"%@",responseObject);
    //
    //        NSString *statusStr = [NSString stringWithFormat:@"%@",responseObject[@"result"]];
    //
    //        if ([statusStr isEqualToString:@"1"]) {
    [MBProgressHUD showSuccess:@"充值成功"];
    //        } else {
    //            [self informTheServerWithParams:params];
    //        }
    //    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
    //        NYLog(@"%@",error.localizedDescription);
    //    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

@end
