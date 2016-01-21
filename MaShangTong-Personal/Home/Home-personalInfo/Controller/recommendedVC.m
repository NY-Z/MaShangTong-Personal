//
//  recommendedVC.m
//  MaShangTong
//
//  Created by q on 15/12/11.
//  Copyright © 2015年 NY. All rights reserved.
//

#import "recommendedVC.h"

#import "AFNetworking.h"

#import <WXApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <WeiboSDK.h>

#import "UMSocial.h"
#import "UMSocialDataService.h"

@interface recommendedVC ()<UMSocialUIDelegate>


@end

@implementation recommendedVC

#define SIZE_Y self.view.center.y*0.8
#define SIZE_X self.view.center.x

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _moneyStr = [NSString stringWithFormat:@"%d",30];
    
    [self dealNavicatonItens];
    
    [self setTopViews];
    
    [self setMidVews];
    
    [self setBottomViews];
}
#pragma mark - 设置NavicatonItens
-(void)dealNavicatonItens
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.text = @"推荐有奖";
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
#pragma mark - 上面的推荐好友
-(void)setTopViews
{
    
    UIImageView *chitIV = [[UIImageView alloc]init];
    chitIV.size = CGSizeMake(128, 128);
    chitIV.center = CGPointMake(SIZE_X, SIZE_Y/3);
    chitIV.image = [UIImage imageNamed:@"wodeyouhuiquan@3x"];
    
    [self.view addSubview:chitIV];
    
    
    UILabel *moneyLabel = [[UILabel alloc]init];
    moneyLabel.text = _moneyStr;
    moneyLabel.textAlignment = 1;
    moneyLabel.font = [UIFont systemFontOfSize:30];
    moneyLabel.textColor = RGBColor(99, 193, 255, 1.f);
    CGRect txtLabelFram = moneyLabel.frame;
    CGSize size = [moneyLabel.text boundingRectWithSize:txtLabelFram.size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:moneyLabel.font,NSFontAttributeName, nil] context:nil].size;
    moneyLabel.size = size;
    moneyLabel.centerX = chitIV.centerX+25;
    moneyLabel.centerY = SIZE_Y/3;
    
    [self.view addSubview:moneyLabel];
    
    
    UILabel *recommendLabel = [[UILabel alloc]init];
    recommendLabel.textAlignment = 1;
    recommendLabel.font = [UIFont systemFontOfSize:14];
    recommendLabel.textColor = RGBColor(128, 138, 135, 1.f);
    
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat: @"推荐新朋友，可得%@元优惠券",_moneyStr]];
    [attriStr setAttributes:@{NSForegroundColorAttributeName:RGBColor(54, 171, 237, 1.f)} range:NSMakeRange(8, attriStr.length-12)];
    recommendLabel.attributedText = attriStr;
    
    CGRect recommendLabelFram = recommendLabel.frame;
    CGSize recommendLabelSize = [recommendLabel.text boundingRectWithSize:recommendLabelFram.size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:recommendLabel.font,NSFontAttributeName, nil] context:nil].size;
    recommendLabel.size = recommendLabelSize;
    recommendLabel.centerX = SIZE_X;
    recommendLabel.centerY = SIZE_Y*7/12;
    
    [self.view addSubview:recommendLabel];
    
    
    UIButton *recommendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    recommendBtn.size = CGSizeMake(128 , 22);
    recommendBtn.layer.cornerRadius = 5.0f;
    recommendBtn.backgroundColor = RGBColor(99, 193, 255, 1.f);
    [recommendBtn setTitle:@"推荐好友" forState:UIControlStateNormal];
    [recommendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    recommendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    recommendBtn.centerX = SIZE_X;
    recommendBtn.centerY = SIZE_Y*0.75;
    
    [recommendBtn addTarget:self action:@selector(clickRecommendFriends:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:recommendBtn];
    
}
//按钮的点击事件
-(void)clickRecommendFriends:(UIButton *)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"推荐好友" message:@"请输入好友手机号。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textFiled = [alert textFieldAtIndex:0];
    textFiled.keyboardType = UIKeyboardTypeNumberPad;
    
    [alert show];
    
}
#pragma mark - UiAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UITextField *textFiled = [alertView textFieldAtIndex:0];
        if (![Helper justMobile:textFiled.text]) {
            [MBProgressHUD showSuccess:@"请输入正确的手机号"];
            return;
        }
        [self recommendedFriend:textFiled.text];
    }
}
#pragma maark - 网络请求，推荐好友
-(void)recommendedFriend:(NSString *)phoneNumber
{
    [MBProgressHUD showMessage:@"校验中"];
    NSLog(@"%@",phoneNumber);
    NSDictionary *param = [NSDictionary dictionaryWithObjects:@[@"1",phoneNumber] forKeys:@[@"group_id",@"mobile"]];
    
    NSString *url = [NSString stringWithFormat:URL_HEADER,@"UserApi",@"user_recomment"];
    
    [DownloadManager post:url params:param success:^(id json) {
        [MBProgressHUD hideHUD];
        NYLog(@"%@",json);
        if(json){
            if([json[@"data"] isEqualToString:@"1"]){
                [self sendMessages:phoneNumber];
            }
            else{
                [MBProgressHUD showSuccess:json[@"info"]];
            }
        }
        else{
            [MBProgressHUD showError:@"网络错误"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误"];
    }];
}
#pragma mark - 发送短信验证码
-(void)sendMessages:(NSString *)mobile
{
    [MBProgressHUD hideHUD];
    [MBProgressHUD showMessage:@"短信发送中"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"码尚通" forKey:@"name"];
    [params setValue:@"码尚通" forKey:@"sign"];
    [params setValue:@"6C572C72EE1CA257886E65C7E5F3" forKey:@"pwd"];
    [params setValue:@"您的联系人好友向您推荐码尚通。" forKey:@"content"];
    [params setValue:mobile forKey:@"mobile"];
    [params setValue:@"pt" forKey:@"type"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:@"http://sms.1xinxi.cn/asmx/smsservice.aspx" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"推荐成功"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 中间de社交分享
-(void)setMidVews
{
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, SIZE_Y, SIZE_X*2-36, 1)];
    lineLabel.backgroundColor = RGBColor(192, 192, 192, 1.f);
    
    [self.view addSubview:lineLabel];
    
    
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.text = @"社交分享";
    tipLabel.backgroundColor = [UIColor whiteColor];
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.textAlignment = 1;
    CGRect txtLabelFram = tipLabel.frame;
    CGSize size = [tipLabel.text boundingRectWithSize:txtLabelFram.size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:tipLabel.font,NSFontAttributeName, nil] context:nil].size;
    tipLabel.size = size;
    tipLabel.center = lineLabel.center;
    
    [self.view addSubview:tipLabel];
    
    
    UILabel *promptLabel = [[UILabel alloc]init];
    promptLabel.text = @"点击以下按钮，分享给朋友";
    promptLabel.font = [UIFont systemFontOfSize:10];
    promptLabel.textAlignment = 1;
    promptLabel.textColor = RGBColor(128, 138, 135, 1.f);
    
    CGRect promptFram = promptLabel.frame;
    
    CGSize promptSize = [promptLabel.text boundingRectWithSize:promptFram.size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:promptLabel.font,NSFontAttributeName, nil]  context:nil].size;
    
    promptLabel.size = promptSize;
    promptLabel.center = lineLabel.center;
    promptLabel.centerY = SIZE_Y+30;
    
    [self.view addSubview:promptLabel];
    
    
}

#pragma mark - 下面de分享按钮
-(void)setBottomViews
{
    //for循环创建四个按钮，完成分享
    for (NSInteger i = 0 ; i<9; i++) {
        
        UIButton *fenxiangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        fenxiangBtn.size = CGSizeMake(SIZE_X/3, SIZE_X/3);
        fenxiangBtn.layer.cornerRadius = SIZE_X/6;
        fenxiangBtn.tag = 140+i;
        switch (i) {
            case 0:
                [fenxiangBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-weixin1"] forState:UIControlStateNormal] ;
                fenxiangBtn.centerX = SIZE_X-50;
                fenxiangBtn.centerY = SIZE_Y/8*11;
                //判断是否安装微信
                if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]){
                    fenxiangBtn.hidden = NO;
                }
                else{
                    fenxiangBtn.hidden = YES;
                }
                break;
                
            case 1:
                [fenxiangBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-iconfontfriend1"] forState:UIControlStateNormal] ;
                fenxiangBtn.centerX = SIZE_X+50;
                fenxiangBtn.centerY = SIZE_Y/8*11;
                //判断是否安装微信
                if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]){
                    fenxiangBtn.hidden = NO;
                }
                else{
                    fenxiangBtn.hidden = YES;
                }
                break;
                
            case 2:
                [fenxiangBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-qq01 (1)1"] forState:UIControlStateNormal];
                fenxiangBtn.centerX = SIZE_X-50;
                fenxiangBtn.centerY = SIZE_Y/8*14;
                //判断是否安装QQ
                if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]){
                    fenxiangBtn.hidden = NO;
                }
                else{
                    fenxiangBtn.hidden = YES;
                }
                break;
                
            case 3:
                [fenxiangBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-weibo1"] forState:UIControlStateNormal] ;
                fenxiangBtn.centerX = SIZE_X+50;
                fenxiangBtn.centerY = SIZE_Y/8*14;
                break;
                
            default:
                break;
        }
        
        [fenxiangBtn addTarget:self action:@selector(fenXiang:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:fenxiangBtn];
        
        
    
    
    }
}
//分享按钮的点击事件
-(void)fenXiang:(UIButton *)sender
{
    switch (sender.tag) {
        case 140:
            //微信分享
            [[UMSocialDataService defaultDataService]postSNSWithTypes:@[UMShareToWechatSession] content:@"码尚通" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    [MBProgressHUD showSuccess:@"分享到微信好友成功"];
                    NSLog(@"分享微信好友成功");
                }
            }];
            break;
            
        case 141:
            //朋友圈分享
            [[UMSocialDataService defaultDataService]postSNSWithTypes:@[UMShareToWechatTimeline] content:@"码尚通" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    [MBProgressHUD showSuccess:@"分享到微信朋友圈成功"];
                    NSLog(@"分享微信朋友圈成功");
                }
            }];
            break;
            
        case 142:
            //QQ分享
            [[UMSocialDataService defaultDataService]postSNSWithTypes:@[UMShareToQQ] content:@"码尚通" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    [MBProgressHUD showSuccess:@"分享到QQ成功"];
                    NSLog(@"分享QQ成功");
                }
            }];
            break;
            
        case 143:
            //微博分享
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:@"分享内嵌文字，www.baidu.com" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NYLog(@"分享成功！");
                    
                    [MBProgressHUD showSuccess:@"分享成功！"];
                }
            }];
            
            
            break;
            
        default:
            break;
    }
}
#pragma mark - 友盟分享的代理
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if (response.responseCode == UMSResponseCodeSuccess) {
        
    }
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
