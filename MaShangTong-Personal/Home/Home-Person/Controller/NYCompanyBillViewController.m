//
//  NYCompanyBillViewController.m
//  MaShangTong-Personal
//
//  Created by apple on 15/12/18.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "NYCompanyBillViewController.h"
#import "NYMyTripsModel.h"
#import "NYMyTripsTableViewCell.h"

@interface NYCompanyBillViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
}
@end

@implementation NYCompanyBillViewController

- (void)configNavigationBar
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.size = CGSizeMake(44, 44);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    self.navigationItem.title = @"我的行程";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:RGBColor(73, 185, 254, 1.f)}];
}

- (void)configTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}

- (void)configDataSource
{
    _dataArr = [NSMutableArray array];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[USER_DEFAULT objectForKey:@"user_id"] forKey:@"user_id"];
    [MBProgressHUD showMessage:@"正在加载"];
    [DownloadManager post:[NSString stringWithFormat:Mast_Url,@"UserApi",@"myTrips"] params:params success:^(id json) {
        NYLog(@"%@",json);
        [MBProgressHUD hideHUD];
        @try {
            _dataArr = json[@"info"][@"detaile"];
            [_tableView reloadData];
        }
        @catch (NSException *exception) {
            [MBProgressHUD showError:@"网络错误,请重试"];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavigationBar];
    [self configTableView];
    [self configDataSource];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - UITableViewDataSorce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"NYCompanyBillTableViewCellReuseId";
    NYMyTripsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NYMyTripsTableViewCell" owner:nil options:nil] lastObject];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *dic = _dataArr[indexPath.row];
    NYMyTripsModel *model = [[NYMyTripsModel alloc] initWithDictionary:dic error:nil];
    [cell configModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _dataArr[indexPath.row];
    NYMyTripsModel *model = [[NYMyTripsModel alloc] initWithDictionary:dic error:nil];
    
}

#pragma mark - Action
- (void)leftBarButtonItemClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
