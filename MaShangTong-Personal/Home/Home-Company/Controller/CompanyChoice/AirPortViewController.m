//
//  AirPortViewController.m
//  MaShangTong
//
//  Created by niliu1h  on 15/10/21.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import "AirPortViewController.h"
#import "Masonry.h"
#import "AMapSearchAPI.h"

#define kTitleLabelText @"titleLabel"
#define kDetailLabelText @"detailTitleLabel"

@interface AirPortViewController () <UITableViewDataSource,UITableViewDelegate,AMapSearchDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) AMapSearchAPI *search;

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
    
//    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
//    [confirmBtn setTitleColor:RGBColor(98, 190, 255, 1.f) forState:UIControlStateNormal];
//    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [barBgView addSubview:confirmBtn];
//    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(barBgView).offset(-15);
//        make.top.equalTo(barBgView).offset(16);
//        make.bottom.equalTo(barBgView).offset(-16);
//        make.width.mas_equalTo(33);
//    }];
    
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
//    _dataArr = @[@{kTitleLabelText:@"虹桥机场T1航站楼",kDetailLabelText:@"121.346199,31.194177"},
//                 @{kTitleLabelText:@"虹桥机场T2航站楼",kDetailLabelText:@"121.327896,31.192555"},
//                 @{kTitleLabelText:@"浦东机场T1航站楼",kDetailLabelText:@"121.803360,31.149280"},
//                 @{kTitleLabelText:@"浦东机场T2航站楼",kDetailLabelText:@"121.809733,31.151115"},
//                 @{kTitleLabelText:@"虹桥高铁",kDetailLabelText:@"121.321492,31.194196"}];
    _dataArr = [NSMutableArray array];
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        AMapPOIKeywordsSearchRequest *keywordsRequest = [[AMapPOIKeywordsSearchRequest alloc] init];
        keywordsRequest.keywords = @"飞机场";
        keywordsRequest.city = @"上海";
        keywordsRequest.sortrule = 1;
        keywordsRequest.requireExtension = 1;
        keywordsRequest.sortrule = 1;
        [_search AMapPOIKeywordsSearch:keywordsRequest];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configViews];
    [self configTableView];
    [self configDataSource];
    
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
    AMapPOI *p = _dataArr[indexPath.row];
    cell.textLabel.text = p.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMapPOI *p = _dataArr[indexPath.row];
    if (self.type == AirPortViewControllerTypePickUp) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"xuanzejichang" object:p];
    } else if (self.type == AirPortViewControllerTypeDropOff) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AirPortDropOffChooseFlight" object:p];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - AMapSearchDelegate
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if(response.pois.count == 0)
    {
        return;
    }
    [_dataArr addObjectsFromArray:response.pois];
    [_tableView reloadData];
}

#pragma mark - Action
- (void)cancelBtnClicked:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
