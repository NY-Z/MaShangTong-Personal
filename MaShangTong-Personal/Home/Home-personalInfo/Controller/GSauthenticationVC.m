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
    
    if(![self IsChinese:_nameTextFiled.text]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"姓名错误" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self presentModalViewController:alert animated:YES];
        
        return;
    }
    
    
    if ([self checkIdentityCardNo:_numTextFiled.text]) {
        [self authentication];
    }
    else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"身份证号码错误" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self presentModalViewController:alert animated:YES];
        return;
    }
}
//判断用户名
-(BOOL)IsChinese:(NSString *)str {
    for(int i = 1; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}
//身份证
- (BOOL)checkIdentityCardNo:(NSString*)cardNo

{
    if (cardNo.length != 18) {
        
        return  NO;
        
    }
    
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    
    
    
    NSScanner* scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];
    
    
    
    int val;
    
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    
    if (!isNum) {
        
        return NO;
        
    }
    
    int sumValue = 0;
    
    
    
    for (int i =0; i<17; i++) {
        
        sumValue+=[[cardNo substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
        
    }
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    
    
    
    if ([strlast isEqualToString: [[cardNo substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        
        return YES;
        
    }
    
    return  NO;
    
}

#pragma mark - 网络请求，实名认证
-(void)authentication
{
    [MBProgressHUD showMessage:@"正在提交认证"];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:@[USER_ID ,@"1",_nameTextFiled.text,_numTextFiled.text ] forKeys:@[@"user_id",@"group_id",@"real_name",@"id_card_nu"]];
    
    NSString *url = [NSString stringWithFormat:Mast_Url,@"UserApi",@"certification"];
    
    [DownloadManager post:url params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        @try {
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
        } @catch (NSException *exception) {
            
        } @finally {
        
        }
    } failure:^(NSError *error) {
        NYLog(@"%@",error.description);
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
