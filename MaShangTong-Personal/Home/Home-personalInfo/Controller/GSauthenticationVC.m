//
//  GSauthenticationVC.m
//  MaShangTong
//
//  Created by q on 15/12/24.
//  Copyright © 2015年 NY. All rights reserved.
//

#import "GSauthenticationVC.h"

@interface GSauthenticationVC ()

@end

@implementation GSauthenticationVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self dealNavicatonItens];
    
    _btn.layer.cornerRadius = 3.0f;
    
}
#pragma mark - 设置NavicatonItens
-(void)dealNavicatonItens
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.text = @"实名认证";
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
    [_nameTextFiled resignFirstResponder];
    [_numTextFiled resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)send:(id)sender {
    [_nameTextFiled resignFirstResponder];
    [_numTextFiled resignFirstResponder];
    
    if (_numTextFiled.text.length == 18) {
        [self authentication];
    }
    else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"身份证号码错误" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self presentModalViewController:alert animated:YES];
    }
}

#pragma mark - 网络请求，实名认证
-(void)authentication
{
    [MBProgressHUD showMessage:@"正在提交认证"];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:@[USER_ID ,@"1",_nameTextFiled.text,_numTextFiled.text ] forKeys:@[@"user_id",@"group_id",@"real_name",@"id_card_nu"]];
    
    NSString *url = [NSString stringWithFormat:Mast_Url,@"UserApi",@"certification"];
    
    [DownloadManager post:url params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        if (json) {
            NSString *str = [NSString stringWithFormat:@"%@",json[@"data"]];
            if ([str isEqualToString:@"1"]) {
                [MBProgressHUD showSuccess:@"提交成功"];
                if (self.makeAuthentication) {
                    self.makeAuthentication(YES);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                [MBProgressHUD showError:@"提交失败"];
            }
        }
        else{
            [MBProgressHUD showError:@"提交失败"];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误"];
    }];
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
