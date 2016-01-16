//
//  AddEmployeeViewController.m
//  MaShangTong-Personal
//
//  Created by apple on 15/12/13.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "AddEmployeeViewController.h"
#import "EmployeeInfoModel.h"

@interface AddEmployeeViewController () <UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArr;
    
    UIView *_coverView;
    UIPickerView *_pickerView;
    
    NSString *_currentSelectGroup;
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
    _pickerView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [NSMutableArray array];
    _currentSelectGroup = @"";
    self.view.backgroundColor = RGBColor(238, 238, 238, 1.f);
    
    [self configNavigationBar];
    [self configTableView];
    [self configPickerView];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.pickerArr.count) {
        return 1;
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickerArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    EmployeeInfoModel *model = [[EmployeeInfoModel alloc] initWithDictionary:_pickerArr[row] error:nil];
    return model.pid_name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    EmployeeInfoModel *model = [[EmployeeInfoModel alloc] initWithDictionary:_pickerArr[row] error:nil];
//    EmployeeInfoDetailModel *detailModel = model.detail[0];
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    cell.detailTextLabel.text = model.pid_name;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        static NSString *cellId = @"AddEmployeeTableViewCellValue1ReuseId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
            cell.textLabel.textColor = RGBColor(120, 120, 120, 1.f);
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = _dataArr[indexPath.row];
        return cell;
    }
    else {
        static NSString *cellId = @"AddEmployeeTableViewCellDefaultReuseId";
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
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        NYLog(@"%@",indexPath);
        _pickerView.y = SCREEN_HEIGHT-64-216;
        _pickerView.hidden = NO;
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pickerView.y = SCREEN_HEIGHT;
    _pickerView.hidden = YES;
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
    if (name.length > 0) {
        [MBProgressHUD showError:@"请输入姓名"];
        return;
    }
    [params setValue:name forKey:@"user_name"];
    NSString *account = ((UITextField *)[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].contentView viewWithTag:300]).text;
    if (![Helper justMobile:account]) {
        [MBProgressHUD showError:@"请输入正确的账号"];
        return;
    }
    [params setValue:account forKey:@"mobile"];
    NSString *password = ((UITextField *)[[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]].contentView viewWithTag:300]).text;
    if (![Helper justPassword:password]) {
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    [params setValue:password forKey:@"user_pwd"];
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    NSString *group = cell.detailTextLabel.text;
    if (!group) {
        [MBProgressHUD showError:@"请输入组名"];
        return;
    }
    [params setValue:group forKey:@"pid_name"];
    [params setValue:[USER_DEFAULT objectForKey:@"user_id"] forKey:@"pid_id"];
    NYLog(@"%@",[USER_DEFAULT valueForKey:@"user_id"]);
    NYLog(@"%@",[USER_DEFAULT objectForKey:@"user_id"]);
    [MBProgressHUD showMessage:@"正在添加"];
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"team_enter"] params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
        if ([dataStr isEqualToString:@"1"]) {
            [MBProgressHUD showSuccess:@"添加成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showError:json[@"data"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误，请重试"];
    }];
}

@end
