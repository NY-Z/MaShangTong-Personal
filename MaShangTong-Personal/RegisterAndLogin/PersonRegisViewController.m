//
//  PersonRegisViewController.m
//  MaShangTong-Personal
//
//  Created by q on 15/12/3.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "PersonRegisViewController.h"

@interface PersonRegisViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mobileNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendVerificationCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
- (IBAction)sendVerificationCodeBtnClicked:(id)sender;
- (IBAction)confirmBtnClicked:(id)sender;

@end

@implementation PersonRegisViewController

- (void)handleThwWidget
{
    _mobileNumberTextField.layer.borderColor = RGBColor(84, 175, 255, 1.f).CGColor;
    _mobileNumberTextField.layer.borderWidth = 1.f;
    
    _verificationCodeTextField.layer.borderColor = RGBColor(84, 175, 255, 1.f).CGColor;
    _verificationCodeTextField.layer.borderWidth = 1.f;
    
    _passwordTextField.layer.borderColor = RGBColor(84, 175, 255, 1.f).CGColor;
    _passwordTextField.layer.borderWidth = 1.f;
    
    _sendVerificationCodeBtn.layer.borderColor = RGBColor(84, 175, 255, 1.f).CGColor;
    _sendVerificationCodeBtn.layer.borderWidth = 1.f;
    
    _confirmBtn.layer.borderColor = RGBColor(84, 175, 255, 1.f).CGColor;
    _confirmBtn.layer.borderWidth = 1.f;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)sendVerificationCodeBtnClicked:(id)sender {
}

- (IBAction)confirmBtnClicked:(id)sender {
}
@end
