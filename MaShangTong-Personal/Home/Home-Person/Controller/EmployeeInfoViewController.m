//
//  EmployeeInfoViewController.m
//  MaShangTong
//
//  Created by niliu1h  on 15/10/22.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import "EmployeeInfoViewController.h"
#import "Masonry.h"
#import "EmployeeInfoCell.h"
#import "AddEmployeeViewController.h"
#import "EmployeeInfoModel.h"

#define kHeader @"header"
#define kName @"name"
#define kPhone @"phoneNum"

@interface EmployeeInfoViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
    
    int sectionHide[3];
}
@end

@implementation EmployeeInfoViewController
- (void)configNavigationBar
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.size = CGSizeMake(44, 44);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"tianjiayuangong"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.size = CGSizeMake(44, 44);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.navigationItem.title = @"员工信息";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:RGBColor(73, 185, 254, 1.f)}];
}

- (void)configTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-94) style:UITableViewStylePlain];
    _tableView.tableFooterView = [UIView new];
    _tableView.showsVerticalScrollIndicator = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)configBottomBar
{
    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomBtn setTitle:@"添加分组" forState:UIControlStateNormal];
    bottomBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [bottomBtn setTitleColor:RGBColor(165, 165, 165, 1.f) forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(addGroup:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:bottomBtn];
#warning 添加分组
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(30);
    }];
}

#pragma mark - ViewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [NSMutableArray array];
    
    [self configNavigationBar];
    [self configBottomBar];
    [self configTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self configDataSource];
}

#pragma mark - DataSource
- (void)configDataSource
{
//    _dataArr = @[@[@{kHeader:@"",kName:@"张可可",kPhone:@"18835625511"},@{kHeader:@"",kName:@"张可可",kPhone:@"18835625511"},@{kHeader:@"",kName:@"张可可",kPhone:@"18835625511"}],
//                 @[@{kHeader:@"",kName:@"张可可",kPhone:@"18835625511"},@{kHeader:@"",kName:@"张可可",kPhone:@"18835625511"},@{kHeader:@"",kName:@"张可可",kPhone:@"18835625511"}],
//                 @[@{kHeader:@"",kName:@"张可可",kPhone:@"18835625511"},@{kHeader:@"",kName:@"张可可",kPhone:@"18835625511"},@{kHeader:@"",kName:@"张可可",kPhone:@"18835625511"}]];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[USER_DEFAULT objectForKey:@"user_id"] forKey:@"pid_id"];
    [DownloadManager post:@"http://112.124.115.81/m.php?m=UserApi&a=emInfo" params:params success:^(id json) {
        NYLog(@"%@",json);
        _dataArr = json[@"info"];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (sectionHide[section]) {
        return 0;
    }
    EmployeeInfoModel *employeeInfoModel = [[EmployeeInfoModel alloc] initWithDictionary:_dataArr[section] error:nil];
    return employeeInfoModel.detail.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"EmployeeInfoCell";
    EmployeeInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EmployeeInfoCell" owner:nil options:nil] lastObject];
        cell.imageView.layer.cornerRadius = 29;
    }
    EmployeeInfoModel *employeeInfoModel = [[EmployeeInfoModel alloc] initWithDictionary:_dataArr[indexPath.section] error:nil];
    EmployeeInfoDetailModel *employeeInfoDetailModel = employeeInfoModel.detail[indexPath.row];
    cell.nameLabel.text = employeeInfoDetailModel.user_name;
    cell.phoneLabel.text = employeeInfoDetailModel.mobile;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    bgView.backgroundColor = RGBColor(238,238,238,1.f);
    bgView.userInteractionEnabled = YES;
    bgView.tag = 300+section;
    UITapGestureRecognizer *sectionHeaderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTaped:)];
    [bgView addGestureRecognizer:sectionHeaderTap];
    
    EmployeeInfoModel *model = [[EmployeeInfoModel alloc] initWithDictionary:_dataArr[section] error:nil];
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(26, 0, SCREEN_WIDTH/2-26, 30)];
//    textField.text = [NSString stringWithFormat:@"第 %ld 组",(long)section+1];
    textField.text = model.pid_name;
    textField.textColor = RGBColor(98, 190, 255, 1.f);
    textField.backgroundColor = RGBColor(238,238,238,1.f);
    textField.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:textField];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhishijiantou"]];
    [bgView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView).offset(-13);
        make.centerY.equalTo(bgView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    return bgView;
}

#pragma mark - Action
- (void)leftBarButtonItemClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonItemClicked:(UIButton *)btn
{
    AddEmployeeViewController *addEmployee = [[AddEmployeeViewController alloc] init];
    addEmployee.pickerArr = _dataArr;
    [self.navigationController pushViewController:addEmployee animated:YES];
}

- (void)sectionHeaderTaped:(UITapGestureRecognizer *)tap
{
    NSInteger section = tap.view.tag-300;
    sectionHide[section] ^= 1;
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)addGroup:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
