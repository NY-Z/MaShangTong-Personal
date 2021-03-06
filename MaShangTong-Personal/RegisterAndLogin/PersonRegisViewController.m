//
//  PersonRegisViewController.m
//  MaShangTong-Personal
//
//  Created by q on 15/12/3.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "PersonRegisViewController.h"
#import "LoginViewController.h"
#import "GSpersonalAgressViewController.h"
#import <AFNetworking.h>

@interface PersonRegisViewController ()
{
    NSString *_random;
    NSTimer *_timer;
    NSInteger _timeCount;
    BOOL _isChick;//是否查看法律申明隐私
}
@property (weak, nonatomic) IBOutlet UITextField *mobileNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendVerificationCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
- (IBAction)sendVerificationCodeBtnClicked:(id)sender;
- (IBAction)confirmBtnClicked:(id)sender;


@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

- (IBAction)selectAgress:(id)sender;
- (IBAction)chickAgreement:(id)sender;

@end

@implementation PersonRegisViewController

-(void)backBtnClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)configNavigationBar
{    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.size = CGSizeMake(44, 44);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"注册个人";
    label.textAlignment = 1;
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = RGBColor(97, 190, 254, 1.f);
    self.navigationItem.titleView = label;
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"马上登陆" forState:UIControlStateNormal];
    [btn setTitleColor:RGBColor(162, 162, 162, 1) forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 66, 44);
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:@selector(loginClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)handleThwWidget
{
    _mobileNumberTextField.layer.borderColor = RGBColor(84, 175, 255, 1.f).CGColor;
    _mobileNumberTextField.layer.borderWidth = 1.f;
    _mobileNumberTextField.layer.cornerRadius = 3.f;
    _mobileNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    _verificationCodeTextField.layer.borderColor = RGBColor(84, 175, 255, 1.f).CGColor;
    _verificationCodeTextField.layer.borderWidth = 1.f;
    _verificationCodeTextField.layer.cornerRadius = 3.f;
    _verificationCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    _passwordTextField.layer.borderColor = RGBColor(84, 175, 255, 1.f).CGColor;
    _passwordTextField.layer.borderWidth = 1.f;
    _passwordTextField.layer.cornerRadius = 3.f;
    _passwordTextField.secureTextEntry = YES;
    
    _sendVerificationCodeBtn.layer.borderColor = RGBColor(84, 175, 255, 1.f).CGColor;
    _sendVerificationCodeBtn.layer.borderWidth = 1.f;
    _sendVerificationCodeBtn.layer.cornerRadius = 3.f;
    
    _confirmBtn.layer.borderColor = RGBColor(84, 175, 255, 1.f).CGColor;
    _confirmBtn.layer.borderWidth = 1.f;
    _confirmBtn.layer.cornerRadius = 3.f;
}

#pragma mark - InitTimer
- (void)initTimer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
    } else {
        [_timer setFireDate:[NSDate distantPast]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _timeCount = 60;
    //法律申明隐私默认没有查看
    _isChick = NO;
    
    [self configNavigationBar];
    [self handleThwWidget];
}

#pragma mark - BtnAction
- (IBAction)sendVerificationCodeBtnClicked:(id)sender {
    
    if (![Helper justMobile:_mobileNumberTextField.text]) {
        [MBProgressHUD showSuccess:@"请输入正确的手机号"];
        return;
    }
    
    _random = @"";
    for(int i=0; i<6; i++)
    {
        _random = [_random stringByAppendingFormat:@"%i",(arc4random() % 9)];
    }
    NYLog(@"%@",_random);
    UIButton *btn = (UIButton *)sender;
    [btn setTitle:@"验证码已发送" forState:UIControlStateNormal];
    btn.enabled = NO;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"码尚通" forKey:@"name"];
    [params setValue:@"码尚通" forKey:@"sign"];
    [params setValue:@"6C572C72EE1CA257886E65C7E5F3" forKey:@"pwd"];
    [params setValue:[NSString stringWithFormat:@"您的验证码为%@切勿泄露给他人，有效期为60秒",_random] forKey:@"content"];
    [params setValue:_mobileNumberTextField.text forKey:@"mobile"];
    [params setValue:@"pt" forKey:@"type"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:@"http://sms.1xinxi.cn/asmx/smsservice.aspx" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self initTimer];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (IBAction)confirmBtnClicked:(id)sender {
    
    if (![Helper justMobile:_mobileNumberTextField.text]) {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    
    if (![Helper justPassword:_passwordTextField.text]) {
        [MBProgressHUD showError:@"您的密码格式不正确"];
        return;
    }
    
    if (![_verificationCodeTextField.text isEqualToString:_random]) {
        [MBProgressHUD showError:@"验证码错误"];
        return;
    }
    if (!_isChick) {
        [MBProgressHUD showError:@"请同意《法律声明隐私》"];
        return;
    }
    
    [MBProgressHUD showMessage:@"注册中，请稍后"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_mobileNumberTextField.text forKey:@"mobile"];
    [params setValue:_passwordTextField.text forKey:@"user_pwd"];
    [params setValue:@"1" forKey:@"group_id"];
    
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"register"] params:params success:^(id json) {
        
        @try {
            NYLog(@"%@",json);
            NSString *resultStr = [NSString stringWithFormat:@"%@",json[@"result"]];
            [MBProgressHUD hideHUD];
            if ([resultStr isEqualToString:@"1"]) {
                [MBProgressHUD showError:@"注册成功"];
                return ;
            } else if ([resultStr isEqualToString:@"0"]) {
                [MBProgressHUD showError:@"您的网络有点问题，请重新注册"];
                return;
            } else if ([resultStr isEqualToString:@"-1"]) {
                [MBProgressHUD showSuccess:json[@"data"]];
                return;
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请求超时"];
        NYLog(@"%@",error.localizedDescription);
        
    }];
}

- (void)loginClicked:(UIButton *)btn
{
    LoginViewController *login = [[LoginViewController alloc] init];
    login.type = LoginTypePerson;
    [self.navigationController pushViewController:login animated:YES];
}

#pragma mark - TimerUpdate
- (void)timerUpdate
{
    _timeCount--;
    [_sendVerificationCodeBtn setTitle:[NSString stringWithFormat:@"%lis后重新发送",(long)_timeCount] forState:UIControlStateNormal];
    if (_timeCount == 0) {
        _timeCount = 60;
        _sendVerificationCodeBtn.enabled = YES;
        [_sendVerificationCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        [_timer setFireDate:[NSDate distantFuture]];
    }
}

#pragma mark - dealloc
- (void)dealloc
{
    [_timer setFireDate:[NSDate distantFuture]];
    if (_timer.valid) {
       [_timer invalidate];
    }
    _timer = nil;
}
- (IBAction)selectAgress:(id)sender {
    if(!_isChick){//如果没有同意的话，点击则勾选（即同意）
        [_imageView setImage:[UIImage imageNamed:@"agreeBtnSelect.png"]];
        _isChick = !_isChick;
    }
    else{//如果同意的话，点击则去掉勾选（ji不同意）
        [_imageView setImage:[UIImage imageNamed:@"agreeBtnDeselect.png"]];
        _isChick = !_isChick;
    }
}

- (IBAction)chickAgreement:(id)sender {
    
    [self.navigationController pushViewController:[[GSpersonalAgressViewController alloc]init] animated:YES];
}
@end
