//
//  TaxiGuideViewController.m
//  MaShangTong-Personal
//
//  Created by apple on 15/12/23.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "NYTaxiGuideViewController.h"

@interface NYTaxiGuideViewController () <UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
}
@end

@implementation NYTaxiGuideViewController

- (void)configNavigationBar
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBarButtonItemClicked) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.size = CGSizeMake(44, 44);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    self.navigationItem.title = @"打车指南";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:RGBColor(73, 185, 254, 1.f)}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavigationBar];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _scrollView.delegate = self;
    _scrollView.scrollEnabled = YES;
    _scrollView.autoresizesSubviews = NO;
    [self.view addSubview:_scrollView];
    
    
    UIImage *image = [UIImage new];
    
    NSString *str = [USER_DEFAULT objectForKey:@"group_id"];
    if ([str isEqualToString:@"1"]) {
        image = [UIImage imageNamed:@"打车指南（个人）"];
    }
    else if ([str isEqualToString:@"2"]){
        image = [UIImage imageNamed:@"打车指南（企业）"];
    }
    
    CGSize size = image.size;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 13384/(1280/SCREEN_WIDTH));
    [_scrollView addSubview:imageView];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*size.height/SCREEN_HEIGHT);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)leftBarButtonItemClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
