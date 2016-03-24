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
#define kJourney @"mileage"
#define kCarbon @"carbon_emission"

@interface MyTripViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArr;

@property (nonatomic,strong) UILabel *distanceLabel;
@property (nonatomic,strong) UILabel *secondLabel;
@property (nonatomic,strong) UILabel *carbonLabel;

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
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-64-40) style:UITableViewStylePlain];
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
    [self configInformationView];
    
    [self sendOrder];
}
-(void)configInformationView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.backgroundColor = RGBColor(220 , 220, 220, 1.f);
    [self.view addSubview:view];
    
    UILabel *distance = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 50, 15)];
    distance.textAlignment = UITextAlignmentLeft;
    distance.font = [UIFont systemFontOfSize:12];
    distance.text = @"总里程";
    distance.textColor = RGBColor(50, 50, 50, 1.f);
    [view addSubview:distance];
    
    _distanceLabel  = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, 100, 15)];
    _distanceLabel.textAlignment = UITextAlignmentLeft;
    _distanceLabel.font = [UIFont systemFontOfSize:12];
    _distanceLabel.textColor = RGBColor(93, 195, 255, 1.f);
    [view addSubview:_distanceLabel];
    
    UILabel *second = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-25, 5, 50, 15)];
    second.textAlignment = UITextAlignmentCenter;
    second.font = [UIFont systemFontOfSize:12];
    second.text = @"总次数";
    second.textColor = RGBColor(50, 50, 50, 1.f);
    [view addSubview:second];
    
    _secondLabel  = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-25, 25, 50, 15)];
    _secondLabel.textAlignment = UITextAlignmentCenter;
    _secondLabel.font = [UIFont systemFontOfSize:12];
    _secondLabel.textColor = RGBColor(93, 195, 255, 1.f);
    [view addSubview:_secondLabel];
    
    UILabel *carbon = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-10-50, 5, 50, 15)];
    carbon.textAlignment = UITextAlignmentRight;
    carbon.font = [UIFont systemFontOfSize:12];
    carbon.text = @"总碳排放";
    carbon.textColor = RGBColor(50, 50, 50, 1.f);
    [view addSubview:carbon];
    
    _carbonLabel  = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-10-80, 25, 80, 15)];
    _carbonLabel.textAlignment = UITextAlignmentRight;
    _carbonLabel.font = [UIFont systemFontOfSize:12];
    _carbonLabel.textColor = RGBColor(93, 195, 255, 1.f);
    [view addSubview:_carbonLabel];
    
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
        cell.journeyLabel.text = [NSString stringWithFormat:@"路程：%.2fkm",[dic[kJourney] floatValue]];
    }
    else{
        cell.journeyLabel.text = [NSString stringWithFormat:@"路程：%.1fkm",0.0];
    }
    if (dic[kCarbon]) {
        cell.carbonLabel.text = [NSString stringWithFormat:@"碳排放：%.2fkg",[dic[kCarbon] floatValue]];
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
                    _distanceLabel.text = [NSString stringWithFormat:@"%.2fkm",[json[@"info"][@"distance"] floatValue]];
                    _secondLabel.text = [NSString stringWithFormat:@"%@次",json[@"info"][@"num1"]];
                    _carbonLabel.text = [NSString stringWithFormat:@"%.2fkg",[json[@"info"][@"carbon_emission"] floatValue]];
                    
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
