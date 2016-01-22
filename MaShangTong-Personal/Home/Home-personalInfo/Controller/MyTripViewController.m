//
//  MyTripViewController.m
//  MaShangTong
//
//  Created by niliu1h  on 15/10/19.
//  Copyright (c) 2015年 NY. All rights reserved.
//  我的行程

#import "MyTripViewController.h"
#import "MyTripCell.h"

#import "AFNetworking.h"

#import "detailOrderVC.h"

#define kOrigin @"origin_name"
#define kDestination @"end_name"
#define kJourney @"trip_distance"
#define kCarbon @"carbon_emssion"

@interface MyTripViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArr;

@end

@implementation MyTripViewController

- (NSArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}

- (void)configTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)configNavigationItem
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
    titleLabel.textAlignment = 1;
    titleLabel.font = [UIFont systemFontOfSize:19];
    titleLabel.text = @"我的行程";
    titleLabel.textColor = RGBColor(99, 193, 255, 1.f);
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    backBtn.size = CGSizeMake(22, 22);
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setImage:[UIImage imageNamed:@"bianji"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(clickEditeBtn) forControlEvents:UIControlEventTouchUpInside];
    editBtn.size = CGSizeMake(22, 22);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
}
-(void)clickEditeBtn
{
    _tableView.editing = !_tableView.editing;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configTableView];
    [self configNavigationItem];
    
    [self sendOrder];
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    
}

#pragma mark - Action
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"MyTripCellId";
    MyTripCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyTripCell" owner:nil options:nil] lastObject];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *dic = _dataArr[indexPath.row];
    cell.originLabel.text = dic[kOrigin];
    cell.destinationLabel.text = dic[kDestination];
    if (![dic[kJourney] isEqualToString:@""]) {
        cell.journeyLabel.text = [NSString stringWithFormat:@"路程：%@km",dic[kJourney]];
    }
    else{
        cell.journeyLabel.text = [NSString stringWithFormat:@"路程：%.1fkm",0.0];
    }
    if (dic[kCarbon]) {
        cell.carbonLabel.text = [NSString stringWithFormat:@"碳排放：%@kg",dic[kCarbon]];
    }
    else{
        cell.carbonLabel.text = [NSString stringWithFormat:@"碳排放：%.1fkg",0.0];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    detailOrderVC *detailVC = [[detailOrderVC alloc]init];
    detailVC.route_id = _dataArr[indexPath.row][@"route_id"];
    
    [self.navigationController pushViewController:detailVC animated:YES];
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    NSDictionary *dic = _dataArr[indexPath.row];
    NSDictionary *parma = [NSDictionary dictionaryWithObjects:@[dic[@"route_id"]] forKeys:@[@"route_id"]];
    
    NSString *url = [NSString stringWithFormat:URL_HEADER,@"UserApi",@"order_delete"];
    [MBProgressHUD showMessage:@"删除中"];
    [DownloadManager post:url params:parma success:^(id json){
        [MBProgressHUD hideHUD];
        @try {
            if (json) {
                NSString *str = [NSString stringWithFormat:@"%@",json[@"data"]];
                if ([str isEqualToString:@"1"]) {
                    [MBProgressHUD showSuccess:@"删除成功"];
                    NSMutableArray *tempAry = [NSMutableArray arrayWithArray:_dataArr];
                    [tempAry removeObjectAtIndex:indexPath.row];
                    _dataArr = tempAry;
                    [_tableView reloadData];
                }
            }
            else{
                [MBProgressHUD showSuccess:@"删除失败"];
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }failure:^(NSError *error){
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"网络错误"];
    }];
    
   
}
#pragma mark - 网络请求，行程
-(void)sendOrder
{
    
    NSDictionary *param = [NSDictionary dictionaryWithObjects:@[[USER_DEFAULT objectForKey:@"user_id"]] forKeys:@[@"user_id"]];
    
    NSString *url = [NSString stringWithFormat:URL_HEADER,@"UserApi",@"myTrips"];

    [MBProgressHUD showMessage:@"加载中"];
    
    
    [DownloadManager post:url params:param success:^(id json) {
        @try {
            [MBProgressHUD hideHUD];
            if (json) {
                NSString *str = [NSString stringWithFormat:@"%@",json[@"data"]];
                if ([str isEqualToString:@"1"]) {
                    _dataArr = [NSArray arrayWithArray:json[@"info"][@"detaile"]];
                    [_tableView reloadData];
                }
                else{
                    [MBProgressHUD showError:@"没有行程"];
                }
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误"];
    }];
    
}

#pragma mark - Action
- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
