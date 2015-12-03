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

#define kHeader @"header"
#define kName @"name"
#define kPhone @"phoneNum"

@interface EmployeeInfoViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArr;
    
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
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"员工信息";
    label.textColor = RGBColor(73, 185, 254, 1.f);
    label.size = CGSizeMake(100, 44);
    label.textAlignment = 1;
    self.navigationItem.titleView = label;
}

- (void)configTableView
{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
//    view.backgroundColor = [UIColor cyanColor];
    
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
    [bottomBtn setTitle:@"返回首页" forState:UIControlStateNormal];
    bottomBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [bottomBtn setTitleColor:RGBColor(165, 165, 165, 1.f) forState:UIControlStateNormal];
    [self.view addSubview:bottomBtn];
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
    
    [self configNavigationBar];
    [self configBottomBar];
    [self configDataSource];
    [self configTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - DataSource
- (void)configDataSource
{
    _dataArr = @[@[@{kHeader:@"",kName:@"张可可",kPhone:@"18835625511"},@{kHeader:@"",kName:@"张可可",kPhone:@"18835625511"},@{kHeader:@"",kName:@"张可可",kPhone:@"18835625511"}],
                 @[@{kHeader:@"",kName:@"张可可",kPhone:@"18835625511"},@{kHeader:@"",kName:@"张可可",kPhone:@"18835625511"},@{kHeader:@"",kName:@"张可可",kPhone:@"18835625511"}],
                 @[@{kHeader:@"",kName:@"张可可",kPhone:@"18835625511"},@{kHeader:@"",kName:@"张可可",kPhone:@"18835625511"},@{kHeader:@"",kName:@"张可可",kPhone:@"18835625511"}]];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!sectionHide[section]) {
        return 0;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"EmployeeInfoCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
//        cell.imageView.layer.cornerRadius = 20;
//        cell.detailTextLabel.backgroundColor = [UIColor redColor];
//    }
//    cell.imageView.backgroundColor = [UIColor cyanColor];
//    cell.textLabel.text = _dataArr[indexPath.section][indexPath.row][kName];
//    cell.detailTextLabel.text = _dataArr[indexPath.section][indexPath.row][kPhone];
    EmployeeInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EmployeeInfoCell" owner:nil options:nil] lastObject];
        cell.imageView.layer.cornerRadius = 29;
    }
    cell.nameLabel.text = _dataArr[indexPath.section][indexPath.row][kName];
    cell.phoneLabel.text = _dataArr[indexPath.section][indexPath.row][kPhone];
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
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(26, 0, SCREEN_WIDTH-26, 30)];
    label.text = [NSString stringWithFormat:@"第 %ld 组",(long)section+1];
    label.textColor = RGBColor(98, 190, 255, 1.f);
    label.backgroundColor = RGBColor(238,238,238,1.f);
    label.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:label];
    
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
    
}

- (void)sectionHeaderTaped:(UITapGestureRecognizer *)tap
{
    NSInteger section = tap.view.tag-300;
    sectionHide[section] ^= 1;
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
}

@end
