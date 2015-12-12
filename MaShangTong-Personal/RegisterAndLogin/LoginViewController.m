//
//  LoginViewController.m
//  MaShangTong
//
//  Created by niliu1h  on 15/10/15.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import "LoginViewController.h"
#import "CompanyHomeViewController.h"
#import "RegisCompanyViewController.h"
#import "PersonRegisViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *lostCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *regisBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginViewController
- (void)addNavTitle
{
    self.navigationItem.title = @"登录";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:RGBColor(97, 190, 254, 1.f)}];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:0 target:nil action:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    [self addNavTitle];
    // 修改控件的属性
    [self handleTheWidget];
    
    
}

- (void)handleTheWidget
{
    self.loginBtn.layer.cornerRadius = BtnRadius;
    
    self.numberTextField.layer.borderWidth = 1.3;
    self.numberTextField.layer.cornerRadius = 5.f;
    self.numberTextField.keyboardType = UIKeyboardTypePhonePad;
    [self.numberTextField becomeFirstResponder];
    
    self.codeTextField.secureTextEntry = YES;
    self.codeTextField.layer.borderWidth = 1.3;
    self.codeTextField.layer.cornerRadius = 5.f;
    
    self.numberTextField.layer.borderColor = [RGBColor(135, 204, 255, 1.f) CGColor];
    self.codeTextField.layer.borderColor = [RGBColor(135, 204, 255, 1.f) CGColor];
    
}

#pragma mark - Action
// Btn
- (IBAction)lostCodeBtnClick:(id)sender {
    
    
    
}

- (IBAction)regisBtnClick:(id)sender {
    
    if (self.type == LoginTypePerson) {
        PersonRegisViewController *regis = [[PersonRegisViewController alloc] init];
        [self.navigationController pushViewController:regis animated:YES];
    } else {
        RegisCompanyViewController *regis = [[RegisCompanyViewController alloc] init];
        [self.navigationController pushViewController:regis animated:YES];
    }
    
}

- (IBAction)loginBtnClick:(id)sender {
    [self resignResponder];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (![Helper justMobile:_numberTextField.text]) {
        [MBProgressHUD showError:@"请输入正确的电话号码"];
        return;
    }
    [params setValue:_numberTextField.text forKey:@"mobile"];
    if (![Helper justPassword:_codeTextField.text]) {
        [MBProgressHUD showError:@"密码格式不正确"];
        return;
    }
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [params setValue:_codeTextField.text forKey:@"user_pwd"];
    [MBProgressHUD showMessage:@"正在登陆"];
    [params setValue:@"2" forKey:@"group_id"];
    if (self.type == LoginTypePerson) {
        [params setValue:@"1" forKey:@"group_id"];
    } else if (self.type == LoginTypeCompany) {
        [params setValue:@"2" forKey:@"group_id"];
    }
    [DownloadManager post:@"http://112.124.115.81/m.php?m=UserApi&a=login" params:params success:^(id json) {
        NSString *isSuccessLog = json[@"data"];
        if ([isSuccessLog isEqualToString:@"1"]) {
            
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                // 耗时的操作
                delegate.valuationRuleArr = json[@"info"][@"rule"];
                
                [USER_DEFAULT setValue:json[@"user_id"] forKey:@"user_id"];
                UserModel *userModel = [[UserModel alloc] initWithDictionary:json[@"info"][@"user_info"] error:nil];
                NSData *userModelData = [NSKeyedArchiver archivedDataWithRootObject:userModel];
                [USER_DEFAULT setObject:userModelData forKey:@"user_info"];
                [USER_DEFAULT setValue:@"1" forKey:@"isLogin"];
                [USER_DEFAULT synchronize];
                UserModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:[USER_DEFAULT objectForKey:@"user_info"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.type == LoginTypeCompany) {
                        CompanyHomeViewController *companyHome = [[CompanyHomeViewController alloc] init];
                        [self.navigationController pushViewController:companyHome animated:YES];
                    } else if (self.type == LoginTypePerson) {
#warning 个人端登录
                        //                [self.navigationController pushViewController:@"" animated:@""];
                    }
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showSuccess:@"登陆成功"];
                });
            });
        } else if ([isSuccessLog isEqualToString:@"0"]) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"请输入正确的用户名和密码"];
        } else if ([isSuccessLog isEqualToString:@"-1"]) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"该账号还未注册过"];
        } else if ([isSuccessLog isEqualToString:@"2"]) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"该账号已在其他客户端注册"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请求超时"];
        NYLog(@"%@",error.localizedDescription);
        
    }];
    
    /*
     {
     "car_type_id" = 1; // 车型
     "long_mileage" = "1.5";  // 超出10公里以后每公里价格
     "low_speed" = "0.5-1.2"; // 低速单价
     mileage = "1.5"; // 10公里以内的单价
     night = 2; // 夜间行驶单价（23：00-05：00）；
     "rule_type" = 1; // 规则id
     step = 15; // 起步价
     }
     */
}

#pragma mark - Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self resignResponder];
}

#pragma mark - ResignFirstResponder
- (void)resignResponder
{
    [self.numberTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
}

@end
