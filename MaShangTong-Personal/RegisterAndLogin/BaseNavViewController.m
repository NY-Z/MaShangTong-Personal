//
//  BaseNavViewController.m
//  MaShangTong
//
//  Created by niliu1h  on 15/10/15.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import "BaseNavViewController.h"

@interface BaseNavViewController ()

@end

@implementation BaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)addNavTitle:(NSString *)title andTitleColor:(UIColor *)color
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.font = [UIFont systemFontOfSize:16];
    label.text = title;
    label.textAlignment = 1;
    label.textColor = color;
    self.navigationItem.titleView = label;
}

- (void)changeNavigationBarTintColorWithColor:(UIColor *)color {
    
    self.navigationController.navigationBar.barTintColor = color;
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
