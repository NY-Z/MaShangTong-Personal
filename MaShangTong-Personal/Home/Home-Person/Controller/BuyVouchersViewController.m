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
#import "NYStepper.h"

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
    
    self.navigationItem.title = @"代金券购买";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:RGBColor(73, 185, 254, 1.f)}];
}

- (void)configDataSource
{
    [MBProgressHUD showMessage:@"正在加载"];
    
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"show_allTickets"] params:nil success:^(id json) {
        @try {
            NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
            if ([dataStr isEqualToString:@"1"]) {
                _dataArr = json[@"info"];
                [_tableView reloadData];
                UIView *view = [self.view viewWithTag:100];
                view.hidden = NO;
                
            } else {
                [MBProgressHUD showError:@"加载错误，请重试"];
            }
            [MBProgressHUD hideHUD];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    } failure:^(NSError *error) {
        NYLog(@"%@",error.localizedDescription);
    }];
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
    buyBtn.tag = 100;
    buyBtn.layer.cornerRadius = 3;
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyBtn setBackgroundColor:RGBColor(97, 189, 252, 1.f)];//
    buyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [buyBtn addTarget:self action:@selector(buyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [footerBgView addSubview:buyBtn];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(footerBgView);
        make.centerY.equalTo(footerBgView);
        make.size.mas_equalTo(CGSizeMake(125, 30));
    }];
    
    _tableView.tableFooterView = footerBgView;
    buyBtn.hidden = YES;
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
    NSDictionary *dic = _dataArr[indexPath.row];
    cell.valueLabel.text = dic[@"price"];
    cell.stepper.count = 0;
    return cell;
}

#pragma mark - Action
- (void)leftBarButtonItemClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buyBtnClicked:(UIButton *)btn
{
    NSInteger count = _dataArr.count;
    NSMutableArray *idMulArr = [NSMutableArray array];
    NSMutableArray *countMulArr = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i++) {
        BuyVouchersCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (cell.stepper.count == 0) {
            continue;
        }
        NSDictionary *idDic = _dataArr[i];
        [idMulArr addObject:idDic[@"shop_id"]];
        [countMulArr addObject:[NSString stringWithFormat:@"%li",cell.stepper.count]];
    }
    if (countMulArr.count == 0) {
        [MBProgressHUD showError:@"请先选择您要购买的代金券"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[USER_DEFAULT objectForKey:@"user_id"] forKey:@"user_id"];
    [params setObject:@{@"id":idMulArr,@"count":countMulArr} forKey:@"array"];
    [MBProgressHUD showMessage:@"购买中"];
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"buy_tickets"] params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
        if ([dataStr isEqualToString:@"0"]) {
            [MBProgressHUD showError:@"购买失败，请重试"];
            return ;
        } else if ([dataStr isEqualToString:@"1"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误，请重试"];
        NYLog(@"%@",error.localizedDescription);
    }];
}

@end
