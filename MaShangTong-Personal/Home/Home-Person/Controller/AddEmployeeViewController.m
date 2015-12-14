//
//  AddEmployeeViewController.m
//  MaShangTong-Personal
//
//  Created by apple on 15/12/13.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "AddEmployeeViewController.h"

@interface AddEmployeeViewController () <UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArr;
    
    UIView *_coverView;
    UIPickerView *_pickerView;
}
@end

@implementation AddEmployeeViewController

- (void)configNavigationBar
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.size = CGSizeMake(44, 44);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.size = CGSizeMake(44, 44);
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn setTitleColor:RGBColor(120, 120, 120, 1.f) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"添加员工";
    label.textColor = RGBColor(73, 185, 254, 1.f);
    label.size = CGSizeMake(100, 44);
    label.textAlignment = 1;
    self.navigationItem.titleView = label;
}

- (void)configTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = RGBColor(238, 238, 238, 1.f);
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    _dataArr = @[@"姓名",@"Ta的码尚通账号",@"密码",@"分组"];
}

- (void)configPickerView
{
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 216)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [self.view addSubview:_pickerView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [NSMutableArray array];
    self.view.backgroundColor = RGBColor(238, 238, 238, 1.f);
    
    [self configNavigationBar];
    [self configPickerView];
    [self configTableView];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 0;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"AddEmployeeTableViewCellReuseId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.textLabel.textColor = RGBColor(120, 120, 120, 1.f);
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-190, 0, 210-45-10, 44)];
        textField.textAlignment = 2;
        textField.tag = 300;
        textField.textColor = RGBColor(120, 120, 120, 1.f);
        [cell.contentView addSubview:textField];
    }
    cell.textLabel.text = _dataArr[indexPath.row];
    UITextField *textField = (UITextField *)[cell.contentView viewWithTag:300];
    if (indexPath.row == 1) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    } else {
        textField.keyboardType = UIKeyboardTypeDefault;
    }
    if (indexPath.row == 3) {
        textField.hidden = YES;
    } else {
        textField.hidden = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        NSLog(@"%@",indexPath);
    }
}

#pragma mark - Action
- (void)leftBarButtonItemClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonItemClicked:(UIButton *)btn
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *name = ((UITextField *)[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].contentView viewWithTag:300]).text;
    if (![Helper justNickname:name]) {
        [MBProgressHUD showError:@"请输入姓名"];
        return;
    }
    NSString *account = ((UITextField *)[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].contentView viewWithTag:300]).text;
    if (![Helper justMobile:account]) {
        [MBProgressHUD showError:@"请输入账号"];
        return;
    }
    NSString *password = ((UITextField *)[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]].contentView viewWithTag:300]).text;
    if (![Helper justPassword:password]) {
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    NSString *group = ((UITextField *)[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]].contentView viewWithTag:300]).text;
    if (!group) {
        [MBProgressHUD showError:@"请输入组名"];
        return;
    }
    [DownloadManager post:@"http://112.124.115.81/m.php?m=UserApi&a=team_enter" params:params success:^(id json) {
        
    } failure:^(NSError *error) {
        
    }];
}

@end
