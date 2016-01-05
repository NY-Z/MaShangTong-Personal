//
//  VoucherViewController.m
//  MaShangTong
//
//  Created by niliu1h  on 15/10/22.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import "VoucherViewController.h"
#import "VoucherCell.h"
#import "SendVoucherViewController.h"
#import "BuyVouchersViewController.h"

#define kValue @"voucherValue"
#define kCount @"count"

@interface VoucherViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
}
@end

@implementation VoucherViewController

- (void)configNavigationBar
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.size = CGSizeMake(44, 44);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    self.navigationItem.title = @"代金券管理";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:RGBColor(73, 185, 254, 1.f)}];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"renminbi"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.size = CGSizeMake(44, 44);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (void)configTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}

#pragma mark - ViewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigationBar];
    [self configTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self configDataSource];
}

- (void)configDataSource
{
    [MBProgressHUD showMessage:@"正在加载"];
    [DownloadManager post:@"http://112.124.115.81/m.php?m=UserApi&a=show_ticket" params:@{@"user_id":[USER_DEFAULT objectForKey:@"user_id"]} success:^(id json) {
        [MBProgressHUD hideHUD];
        NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
        if ([dataStr isEqualToString:@"1"]) {
            _dataArr = json[@"info"];
            [_tableView reloadData];
        } else {
            [MBProgressHUD showError:@"您没有代金券"];
        }
    } failure:^(NSError *error) {
        NYLog(@"%@",error.localizedDescription);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误"];
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 73;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"VoucherCellId";
    VoucherCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"VoucherCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    __weak typeof(&*self) weakSelf = self;
    
    NSDictionary *dic = _dataArr[indexPath.row];
    cell.valueLabel.text = dic[@"price"];
    cell.countLabel.text = [NSString stringWithFormat:@"X %@",dic[@"num"]];
    
    cell.sendBtnBlock = ^(){
        SendVoucherViewController *sendVoucher = [[SendVoucherViewController alloc] init];
        sendVoucher.voucherId = dic[@"shop_id"];
        [weakSelf.navigationController pushViewController:sendVoucher animated:YES];
    };
    return cell;
}

#pragma mark - Action
- (void)leftBarButtonItemClicked:(UIButton *)item
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonItemClicked:(UIButton *)btn
{
    BuyVouchersViewController *buyVouchers = [[BuyVouchersViewController alloc] init];
    [self.navigationController pushViewController:buyVouchers animated:YES];
}

@end
