//
//  RegisCompanyViewController.m
//  MaShangTong
//
//  Created by niliu1h  on 15/10/15.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import "RegisCompanyViewController.h"
#import "Masonry.h"
#import "LoginViewController.h"
#import "ProvincesAndCitiesTableViewController.h"
#import "CompanyHomeViewController.h"
#import <AFNetworking.h>

@interface RegisCompanyViewController () <UITextFieldDelegate>
{
    NSString *random;
    NSTimer *_timer;
    NSInteger _time;
}
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *smsTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *businessTextField;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *protocalLabel;
@property (weak, nonatomic) IBOutlet UIButton *regisBtn;
@property (weak, nonatomic) IBOutlet UIButton *provinceBtn;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
- (IBAction)provinceBtnClicked:(id)sender;
- (IBAction)cityBtnClicked:(id)sender;
- (IBAction)getVerification:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *verificationBtn;
- (IBAction)selectBtnClicked:(id)sender;

@end

@implementation RegisCompanyViewController

- (void)addNavTitle
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"注册公司";
    label.textAlignment = 1;
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = RGBColor(97, 190, 254, 1.f);
    self.navigationItem.titleView = label;
}
- (void)addRightBarButtonItem
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"马上登陆" forState:UIControlStateNormal];
    [btn setTitleColor:RGBColor(162, 162, 162, 1) forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 66, 44);
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:@selector(loginClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:0 target:nil action:nil];
}

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
    
    self.view.backgroundColor = RGBColor(238, 238, 238, 1);
    self.navigationController.navigationBar.translucent = NO;
    _time = 60;
    [self addNavTitle];
    [self addRightBarButtonItem];
    // 修改控件的属性
    [self handleTheWidget];
    
}

- (void)handleTheWidget
{
    self.firstLabel.layer.cornerRadius = 11;
    self.firstLabel.clipsToBounds = YES;
    self.firstLabel.layer.borderColor = RGBColor(230, 230, 230, 1.f).CGColor;
    self.firstLabel.layer.borderWidth = 1.f;
    self.secondLabel.layer.cornerRadius = 11;
    self.secondLabel.clipsToBounds = YES;
    self.secondLabel.layer.borderColor = RGBColor(230, 230, 230, 1.f).CGColor;
    self.secondLabel.layer.borderWidth = 1.f;
    self.nameTextField.delegate = self;
    self.phoneNumberTextField.delegate = self;
    self.phoneNumberTextField.keyboardType = UIKeyboardTypePhonePad;
    self.smsTextField.delegate = self;
    self.smsTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTextField.delegate = self;
    self.codeTextField.secureTextEntry = YES;
    self.businessTextField.delegate = self;
    self.verificationBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGFloat offSet = self.view.height-(CGRectGetMaxY(textField.frame)+216);
    if (offSet <= 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.y = offSet;
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.view.frame.origin.y != 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.y = 64;
        }];
    }
}

#pragma mark - Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self resignResponder];
}

- (void)resignResponder
{
    [self.nameTextField resignFirstResponder];
    [self.phoneNumberTextField resignFirstResponder];
    [self.phoneNumberTextField resignFirstResponder];
    [self.smsTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    [self.businessTextField resignFirstResponder];
}

#pragma mark - Action
- (void)loginClicked:(UIButton *)btn
{
    [self.navigationController pushViewController:[[LoginViewController alloc] init] animated:YES];
}

- (IBAction)regisBtnClicked:(UIButton *)btn {
    if (!_selectBtn.selected) {
        [MBProgressHUD showError:@"请同意《码尚通企业服务协议》"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (!_nameTextField.text.length) {
        [MBProgressHUD showError:@"请输入正确的姓名"];
        return;
    }
    [params setValue:_nameTextField.text forKey:@"user_name"];
    
    if (![Helper justMobile:_phoneNumberTextField.text]) {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    [params setValue:_phoneNumberTextField.text forKey:@"mobile"];
    
    if (![Helper justPassword:_codeTextField.text]) {
        [MBProgressHUD showError:@"您的密码格式不正确"];
        return;
    }
    [params setValue:_codeTextField.text forKey:@"user_pwd"];
    
    if (!_businessTextField.text.length) {
        [MBProgressHUD showError:@"请输入工商注册名称"];
        return;
    }
    [params setValue:_businessTextField.text forKey:@"license"];
    
    if ([_provinceBtn.currentTitle isEqualToString:@"省份"]) {
        [MBProgressHUD showError:@"请输入您所在的省份"];
        return;
    }
    [params setValue:_provinceBtn.currentTitle forKey:@"province"];
    
    if ([_cityBtn.currentTitle isEqualToString:@"城市"]) {
        [MBProgressHUD showError:@"请输入您所在的城市"];
        return;
    }
    [params setValue:_cityBtn.currentTitle forKey:@"city"];
    
    [params setValue:@"2" forKey:@"group_id"];
    
    if (![_smsTextField.text isEqualToString:random]) {
        [MBProgressHUD showError:@"验证码错误"];
        return;
    }
    
    [MBProgressHUD showMessage:@"正在注册"];
    [DownloadManager post:@"http://112.124.115.81/m.php?m=UserApi&a=register" params:params success:^(id json) {
        
        [MBProgressHUD hideHUD];
        if ([json[@"result"] isEqualToString:@"1"]) {
            [MBProgressHUD showSuccess:@"注册成功"];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"user_id"] forKey:@"user_id"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.navigationController pushViewController:[[CompanyHomeViewController alloc] init] animated:YES];
        } else if ([json[@"result"] isEqualToString:@"-1"]){
            [MBProgressHUD showError:@"此账号已经注册过了"];
        } else if ([json isEqualToString:@"0"]){
            [MBProgressHUD showError:@"您的网络有点问题，请重新注册"];
        }
        
    } failure:^(NSError *error) {
        
        NYLog(@"%@",error.localizedDescription);
        
    }];
    
}

- (IBAction)provinceBtnClicked:(id)sender {
    ProvincesAndCitiesTableViewController *province = [[ProvincesAndCitiesTableViewController alloc] init];
    province.type  = ProvinceTypeProvince;
    province.transProvince = ^(NSString *province) {
        [_provinceBtn setTitle:province forState:UIControlStateNormal];
        [_cityBtn setTitle:@"城市" forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:province animated:YES];
}

- (IBAction)cityBtnClicked:(id)sender {
    if ([_provinceBtn.currentTitle isEqualToString:@"省份"]) {
        [MBProgressHUD showError:@"请先选择城市"];
        return;
    }
    ProvincesAndCitiesTableViewController *city = [[ProvincesAndCitiesTableViewController alloc] init];
    city.type  = ProvinceTypeCity;
    city.province = _provinceBtn.currentTitle;
    city.transCity = ^(NSString *city) {
        [_cityBtn setTitle:city forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:city animated:YES];
}

- (IBAction)getVerification:(id)sender {
    
    if (![Helper justMobile:_phoneNumberTextField.text]) {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    
    random = @"";
    for(int i=0; i<6; i++)
    {
        random = [random stringByAppendingFormat:@"%i",(arc4random() % 9)];
    }
    
    UIButton *btn = (UIButton *)sender;
    [btn setTitle:@"验证码已发送" forState:UIControlStateNormal];
    btn.enabled = NO;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"码尚通" forKey:@"name"];
    [params setValue:@"码尚通" forKey:@"sign"];
    [params setValue:@"6C572C72EE1CA257886E65C7E5F3" forKey:@"pwd"];
    [params setValue:[NSString stringWithFormat:@"您的验证码为%@切勿泄露给他人，有效期为60秒",random] forKey:@"content"];
    [params setValue:_phoneNumberTextField.text forKey:@"mobile"];
    [params setValue:@"pt" forKey:@"type"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:@"http://sms.1xinxi.cn/asmx/smsservice.aspx" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NYLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        [self initTimer];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NYLog(@"%@",error.localizedDescription);
    }];
}

#pragma mark - Timer
- (void)timerUpdate
{
    _time--;
    [_verificationBtn setTitle:[NSString stringWithFormat:@"%lis后重新发送",(long)_time] forState:UIControlStateNormal];
    _verificationBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    if (_time == 0) {
        _time = 60;
        _verificationBtn.enabled = YES;
        [_verificationBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        [_timer setFireDate:[NSDate distantFuture]];
    }
}

- (IBAction)selectBtnClicked:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
}
@end
