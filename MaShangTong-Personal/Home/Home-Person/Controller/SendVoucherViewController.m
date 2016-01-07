//
//  SendVoucherViewController.m
//  MaShangTong-Personal
//
//  Created by apple on 15/12/23.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "SendVoucherViewController.h"

@interface SendVoucherViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
- (IBAction)confirmBtnClicked:(id)sender;

@end

@implementation SendVoucherViewController

- (void)configNavigationBar
{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = YES;
    
    self.navigationItem.title = @"发放";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:RGBColor(73, 185, 254, 1.f)}];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBarButtonItemClicked) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.size = CGSizeMake(44, 44);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavigationBar];
    [self handleTheWeidget];
}

- (void)handleTheWeidget
{
    _confirmBtn.layer.borderColor = RGBColor(84, 175, 255, 1.f).CGColor;
    _confirmBtn.layer.borderWidth = 1.f;
    _confirmBtn.layer.cornerRadius = 3.f;
    
    _mobileTextField.layer.borderColor = RGBColor(84, 175, 255, 1.f).CGColor;
    _mobileTextField.layer.borderWidth = 1.f;
    _mobileTextField.layer.cornerRadius = 3.f;
    _mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
    _mobileTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (void)leftBarButtonItemClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confirmBtnClicked:(id)sender
{
    
    if (![Helper justMobile:_mobileTextField.text]) {
        [MBProgressHUD showError:@"请输入正确的电话号码"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_mobileTextField.text forKey:@"mobile"];
    [params setValue:self.voucherId forKey:@"shop_id"];
    [params setValue:[USER_DEFAULT objectForKey:@"user_id"] forKey:@"user_id"];
    [MBProgressHUD showMessage:@"请稍候"];
    [DownloadManager post:@"http://112.124.115.81/m.php?m=UserApi&a=get_ticket" params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        @try {
            NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
            if ([dataStr isEqualToString:@"1"]) {
                [MBProgressHUD showSuccess:@"发送成功"];
                [MBProgressHUD hideHUD];
                [self.navigationController popViewControllerAnimated:YES];
            } else if ([dataStr isEqualToString:@"0"]) {
                [MBProgressHUD showError:@"发放失败"];
            } else {
                [MBProgressHUD showError:@"该电话号码未注册"];
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    } failure:^(NSError *error) {
        
    }];
}
@end
