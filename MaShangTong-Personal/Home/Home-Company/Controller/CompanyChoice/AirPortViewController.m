//
//  AirPortViewController.m
//  MaShangTong
//
//  Created by niliu1h  on 15/10/21.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import "AirPortViewController.h"
#import "Masonry.h"

#define kTitleLabelText @"titleLabel"
#define kDetailLabelText @"detailTitleLabel"

@interface AirPortViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArr;

@end

@implementation AirPortViewController

- (void)configViews
{
    UIView *barBgView = [[UIView alloc] init];
    barBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:barBgView];
    [barBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGBColor(98, 190, 255, 1.f) forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [barBgView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(barBgView).offset(15);
        make.top.equalTo(barBgView).offset(16);
        make.bottom.equalTo(barBgView).offset(-16);
        make.width.mas_equalTo(33);
    }];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:RGBColor(98, 190, 255, 1.f) forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [barBgView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(barBgView).offset(-15);
        make.top.equalTo(barBgView).offset(16);
        make.bottom.equalTo(barBgView).offset(-16);
        make.width.mas_equalTo(33);
    }];
    
    UIView *barrierView = [[UIView alloc] init];
    barrierView.backgroundColor = RGBColor(227, 227, 229, 1.f);
    [barBgView addSubview:barrierView];
    [barrierView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(barBgView);
        make.left.equalTo(barBgView);
        make.right.equalTo(barBgView);
        make.height.mas_equalTo(1);
    }];
}

- (void)configTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-90) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
}

- (void)configDataSource
{
    _dataArr = @[@{kTitleLabelText:@"首都机场T3航站楼",kDetailLabelText:@"北京市顺义区二经路"},
                 @{kTitleLabelText:@"首都机场T1航站楼",kDetailLabelText:@"北京市顺义区首都机场路"},
                 @{kTitleLabelText:@"南苑机场",kDetailLabelText:@"北京市丰台区南苑南四环警备东路"},
                 @{kTitleLabelText:@"首都机场",kDetailLabelText:@"北京市顺义区首都机场路"},
                 @{kTitleLabelText:@"首都机场T航站楼",kDetailLabelText:@"北京市顺义区首都机场路"}];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configViews];
    [self configDataSource];
    [self configTableView];
    

}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"AirPortTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = _dataArr[indexPath.row][kTitleLabelText];
    cell.detailTextLabel.text = _dataArr[indexPath.row][kDetailLabelText];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = _dataArr[indexPath.row][kTitleLabelText];
    if (self.type == AirPortViewControllerTypePickUp) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"xuanzejichang" object:title];
    } else if (self.type == AirPortViewControllerTypeDropOff) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AirPortDropOffChooseFlight" object:title];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Action
- (void)cancelBtnClicked:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)confirmBtnClicked:(UIButton *)btn
{
    
}

@end
