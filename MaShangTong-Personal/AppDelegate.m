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

#import "WaitForTheOrderViewController.h"
#import "PayChargeViewController.h"
#import "CompanyHomeViewController.h"

@interface AppDelegate () <WXApiDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 微信支付
    [WXApi registerApp:WxAppId withDescription:@"demo 2.0"];
    
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
        CompanyHomeViewController *companyHome = [[CompanyHomeViewController alloc] init];
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:companyHome];
    } else {
        RegisViewController *regis = [[RegisViewController alloc] init];
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:regis];
    }
    [self.window makeKeyAndVisible];

    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NYLog(@"result = %@",resultDic);
    }];
    [WXApi handleOpenURL:url delegate:self];
    
    return YES;
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSLog(@"%@",[NSNumber numberWithInt:resp.errCode]);
    }
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
