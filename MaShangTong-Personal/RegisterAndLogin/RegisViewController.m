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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"注册";
    label.textAlignment = 1;
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = RGBColor(97, 190, 254, 1.f);
    self.navigationItem.titleView = label;
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
    
    
    self.navigationController.navigationBar.translucent = NO;
    [self addNavTitle];
    
    // 修改控件的属性
    [self handleTheWidget];
    
    
}

#pragma mark - Action
// Btn
- (IBAction)individualBtnClick:(id)sender {
    
    PersonRegisViewController *personRegis = [[PersonRegisViewController alloc] init];
    [self.navigationController pushViewController:personRegis animated:YES];
    
}
- (IBAction)businessBtnClick:(id)sender {
    [self.navigationController pushViewController:[[RegisCompanyViewController alloc] init] animated:YES];
}

// LoginLabel
- (void)loginLabelTap:(UITapGestureRecognizer *)tap {
    LoginViewController *login = [[LoginViewController alloc] init];
    login.type = LoginTypeCompany;
     [self.navigationController pushViewController:login animated:YES];
}

- (void)personLoginLabelTap:(UITapGestureRecognizer *)tap
{
    LoginViewController *login = [[LoginViewController alloc] init];
    login.type = LoginTypePerson;
    [self.navigationController pushViewController:login animated:YES];
}

@end
