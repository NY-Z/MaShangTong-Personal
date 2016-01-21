//
//  GSdiscoverViewController.m
//  MaShangTong-Personal
//
//  Created by q on 16/1/12.
//  Copyright © 2016年 jeaner. All rights reserved.
//

#import "GSdiscoverViewController.h"

@interface GSdiscoverViewController ()

@end

@implementation GSdiscoverViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self  dealNavicatonItens];
}
#pragma mark - 设置NavicatonItens
-(void)dealNavicatonItens
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.text = @"发现";
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
