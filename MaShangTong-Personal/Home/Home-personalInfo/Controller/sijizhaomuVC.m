//
//  sijizhaomuVC.m
//  MaShangTong
//
//  Created by q on 15/12/12.
//  Copyright © 2015年 NY. All rights reserved.
//

#import "sijizhaomuVC.h"
#import "AFNetworking.h"
#import "DriverJoinInViewController.h"

@interface sijizhaomuVC ()

@end

@implementation sijizhaomuVC



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self dealNavicatonItens];
    
    _btn.layer.cornerRadius = 5.0f;

}
#pragma mark - 设置NavicatonItens
-(void)dealNavicatonItens
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.text = @"司机招募";
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
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}

//司机加盟按钮的点击事件
- (IBAction)jiameng:(id)sender {
    NSLog(@"司机加盟");
    
    DriverJoinInViewController *vc = [[DriverJoinInViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
