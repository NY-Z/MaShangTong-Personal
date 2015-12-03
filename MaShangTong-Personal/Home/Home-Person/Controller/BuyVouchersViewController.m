//
//  BuyVouchersViewController.m
//  MaShangTong
//
//  Created by niliu1h  on 15/10/23.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import "BuyVouchersViewController.h"
#import "BuyVouchersCell.h"
#import "Masonry.h"

#define kValue @"voucherValue"
#define kCount @"count"

@interface BuyVouchersViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArr;
}
@end

@implementation BuyVouchersViewController

- (void)configNavigationBar
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.size = CGSizeMake(44, 44);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"代金券购买";
    label.textColor = RGBColor(73, 185, 254, 1.f);
    label.size = CGSizeMake(100, 44);
    label.textAlignment = 1;
    self.navigationItem.titleView = label;
}

- (void)configDataSource
{
    _dataArr = @[@{kValue:@"10",kCount:@"X 20"},
                 @{kValue:@"15",kCount:@"X 20"},
                 @{kValue:@"20",kCount:@"X 20"},
                 @{kValue:@"30",kCount:@"X 20"},
                 @{kValue:@"50",kCount:@"X 20"}];
}

- (void)configTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    UIView *footerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    footerBgView.backgroundColor = [UIColor whiteColor];
    
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyBtn setTitle:@"购买" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyBtn setBackgroundColor:RGBColor(97, 189, 252, 1.f)];//
    buyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [footerBgView addSubview:buyBtn];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footerBgView);
        make.centerY.equalTo(footerBgView);
        make.size.mas_equalTo(CGSizeMake(125, 30));
    }];
    
    _tableView.tableFooterView = footerBgView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigationBar];
    [self configDataSource];
    [self configTableView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"BuyVouchersCell";
    BuyVouchersCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BuyVouchersCell" owner:nil options:nil ]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.valueLabel.text = _dataArr[indexPath.row][kValue];
    return cell;
}

#pragma mark - Action
- (void)leftBarButtonItemClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
