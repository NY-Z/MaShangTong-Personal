//
//  RegisViewController.m
//  MaShangTong
//
//  Created by niliu1h  on 15/10/15.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import "RegisViewController.h"
#import "LoginViewController.h"
#import "RegisCompanyViewController.h"
#import "PersonRegisViewController.h"

@interface RegisViewController ()
// 我是个人
@property (weak, nonatomic) IBOutlet UIButton *individualBtn;
// 我是企业
@property (weak, nonatomic) IBOutlet UIButton *businessBtn;
// 公司账号，登陆
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
// 个人账号，登陆
@property (weak, nonatomic) IBOutlet UILabel *personLoginLabel;



@end

@implementation RegisViewController

- (void)addNavTitle
{
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:RGBColor(97, 190, 254, 1.f)}];
    self.navigationItem.title = @"注册";
}

#pragma mark - HandleTheWidget
- (void)handleTheWidget
{
    self.individualBtn.layer.cornerRadius = BtnRadius;
    self.businessBtn.layer.cornerRadius = BtnRadius;
    
    self.loginLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *login = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginLabelTap:)];
    [self.loginLabel addGestureRecognizer:login];
    
    UITapGestureRecognizer *personLogin = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(personLoginLabelTap:)];
    [self.personLoginLabel addGestureRecognizer:personLogin];
}

#pragma mark - ViewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavTitle];
    // 修改控件的属性
    [self handleTheWidget];
}

#pragma mark - Action
// Btn
- (IBAction)individualBtnClick:(id)sender {
    
    APP_DELEGATE.group_id = @"1";
    PersonRegisViewController *personRegis = [[PersonRegisViewController alloc] init];
    [self.navigationController pushViewController:personRegis animated:YES];
    
}
- (IBAction)businessBtnClick:(id)sender {
    APP_DELEGATE.group_id = @"2";
    [self.navigationController pushViewController:[[RegisCompanyViewController alloc] init] animated:YES];
}

// LoginLabel
- (void)loginLabelTap:(UITapGestureRecognizer *)tap {
    APP_DELEGATE.group_id = @"2";
    LoginViewController *login = [[LoginViewController alloc] init];
    login.type = LoginTypeCompany;
     [self.navigationController pushViewController:login animated:YES];
}

- (void)personLoginLabelTap:(UITapGestureRecognizer *)tap
{
    APP_DELEGATE.group_id = @"1";
    LoginViewController *login = [[LoginViewController alloc] init];
    login.type = LoginTypePerson;
    [self.navigationController pushViewController:login animated:YES];
}

@end
