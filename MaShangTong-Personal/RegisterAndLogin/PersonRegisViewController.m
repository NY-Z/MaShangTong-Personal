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
    _mobileNumberTextField.layer.cornerRadius = 3.f;
    
    _verificationCodeTextField.layer.borderColor = RGBColor(84, 175, 255, 1.f).CGColor;
    _verificationCodeTextField.layer.borderWidth = 1.f;
    _verificationCodeTextField.layer.cornerRadius = 3.f;
    
    _passwordTextField.layer.borderColor = RGBColor(84, 175, 255, 1.f).CGColor;
    _passwordTextField.layer.borderWidth = 1.f;
    _passwordTextField.layer.cornerRadius = 3.f;
    
    _sendVerificationCodeBtn.layer.borderColor = RGBColor(84, 175, 255, 1.f).CGColor;
    _sendVerificationCodeBtn.layer.borderWidth = 1.f;
    _sendVerificationCodeBtn.layer.cornerRadius = 3.f;
    
    _confirmBtn.layer.borderColor = RGBColor(84, 175, 255, 1.f).CGColor;
    _confirmBtn.layer.borderWidth = 1.f;
    _confirmBtn.layer.cornerRadius = 3.f;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self handleThwWidget];
}

- (IBAction)sendVerificationCodeBtnClicked:(id)sender {
}

- (IBAction)confirmBtnClicked:(id)sender {
}
@end
