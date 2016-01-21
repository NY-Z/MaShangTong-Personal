//
//  wordVC.m
//  MaShangTong
//
//  Created by q on 15/12/16.
//  Copyright © 2015年 NY. All rights reserved.
//

#import "wordVC.h"

@interface wordVC ()

@end

@implementation wordVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    [_textV becomeFirstResponder];
}
-(void)viewDidLoad
{
    [self dealNavicatonItens];
    [self dealOthers];
}
-(void)dealNavicatonItens
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.text = @"给司机捎话";
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
-(void)dealOthers
{
    _btn.layer.cornerRadius = 3.0f;
    _textV.layer.borderWidth = 1.0f;

}
//返回Btn的点击事件
-(void)backBtnClick
{
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}
//确定btn的点击事件
- (IBAction)makeSure:(id)sender {
    
    if (self.sendWords) {
        self.sendWords(_textV.text);
    }
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}


@end
