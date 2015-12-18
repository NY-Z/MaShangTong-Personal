//
//  SendVoucherViewController.m
//  MaShangTong
//
//  Created by niliu1h  on 15/10/22.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import "SendVoucherViewController.h"
#import "SendVoucherCell.h"
#import "Masonry.h"

#define kHeader @"header"
#define kName @"name"
#define kPhone @"phoneNum"

@interface SendVoucherViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArr;
    bool sectionHide[3];
    int cellIsSelect[3][3];
}
@end

@implementation SendVoucherViewController

- (void)configNavigationBar
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.size = CGSizeMake(44, 44);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    self.navigationItem.title = @"发放";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:RGBColor(73, 185, 254, 1.f)}];
}

- (void)configDataSource
{
    _dataArr = @[@[@{kHeader:@"",kName:@"张可可",kPhone:@"18835625511"},@{kHeader:@"",kName:@"张可可",kPhone:@"18835625511"},@{kHeader:@"",kName:@"张可可",kPhone:@"18835625511"}],
                 @[@{kHeader:@"",kName:@"张可可",kPhone:@"18835625511"},@{kHeader:@"",kName:@"张可可",kPhone:@"18835625511"},@{kHeader:@"",kName:@"张可可",kPhone:@"18835625511"}],
                 @[@{kHeader:@"",kName:@"张可可",kPhone:@"18835625511"},@{kHeader:@"",kName:@"张可可",kPhone:@"18835625511"},@{kHeader:@"",kName:@"张可可",kPhone:@"18835625511"}]];
}

- (void)configTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104) style:UITableViewStylePlain];
    _tableView.tableFooterView = [UIView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigationBar];
    [self configDataSource];
    [self configTableView];
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
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
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
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(26, 0, SCREEN_WIDTH-26, 25)];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"SendVoucherCell";
    SendVoucherCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SendVoucherCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.nameLabel.text = _dataArr[indexPath.section][indexPath.row][kName];
    cell.phoneLabel.text = _dataArr[indexPath.section][indexPath.row][kPhone];
    cell.cellIsSelected = ^(BOOL isSelected){
        cellIsSelect[indexPath.section][indexPath.row] = isSelected;
    };
    cell.selectBtn.selected = cellIsSelect[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SendVoucherCell *cell = (SendVoucherCell *)[tableView cellForRowAtIndexPath:indexPath];
    BOOL selected = !cell.selectBtn.selected;
    cell.selectBtn.selected = selected;
    cellIsSelect[indexPath.section][indexPath.row] = selected;
}

#pragma mark - Action
- (void)leftBarButtonItemClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sectionHeaderTaped:(UITapGestureRecognizer *)tap
{
    NSInteger section = tap.view.tag-300;
    sectionHide[section] ^= 1;
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
}

@end
