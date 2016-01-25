//
//  PersonCenterViewController.m
//  MaShangTong
//
//  Created by niliu1h  on 15/10/17.
//  Copyright (c) 2015年 NY. All rights reserved.
//  个人中心

#import "PersonCenterViewController.h"
#import "Masonry.h"
#import "MyCenterCell.h"

#import "GSPersonInfoModel.h"

#define kMyCenterImage @"image"
#define kMyCenterTitle @"title"

@interface PersonCenterViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *headerView;
    UILabel *nameLabel;
    UILabel *numberLabel;
    
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSArray *heardAry;

@end

@implementation PersonCenterViewController
// 懒加载
- (NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
       
    }
    return _dataArr;
}

//个人页面的总体是一个tableView，并设置他的headView
- (void)configTableView
{
    UIButton *alphaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    alphaBtn.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0];;
    [alphaBtn addTarget:self action:@selector(touchedForHiddenTableView:) forControlEvents:UIControlEventTouchUpInside];
    alphaBtn.frame = CGRectMake(SCREEN_WIDTH*3/4, 0, SCREEN_WIDTH/4, SCREEN_HEIGHT);
    
    [self.view addSubview:alphaBtn];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*3/4, SCREEN_HEIGHT-138) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    // TableHeaderView
    UIView *bgTableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*3/4, 107)];
    
    headerView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 35, 65, 65)];
    headerView.image = [UIImage imageWithData: _heardAry[0]];
    headerView.layer.cornerRadius = 32.5;
    [bgTableHeaderView addSubview:headerView];
    
    nameLabel = [[UILabel alloc] init];
    nameLabel.text = _heardAry[1];
    nameLabel.font = [UIFont systemFontOfSize:13];
    nameLabel.textColor = RGBColor(125, 125, 125, 1.f);
    [bgTableHeaderView addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView).with.offset(-5);
        make.size.mas_equalTo(CGSizeMake(100, 30));
        make.left.equalTo(headerView.mas_right).with.offset(18);
    }];
    
    numberLabel = [[UILabel alloc] init];
    numberLabel.text = _heardAry[5];
    numberLabel.textColor = RGBColor(125, 125, 125, 1.f);
    numberLabel.font = [UIFont systemFontOfSize:13];
    [bgTableHeaderView addSubview:numberLabel];
    
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.bottom.equalTo(headerView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
    UIImageView *indicatorImageView = [[UIImageView alloc] init];
    indicatorImageView.image = [UIImage imageNamed:@"indicator"];
    [bgTableHeaderView addSubview:indicatorImageView];
    
    [indicatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.right.equalTo(bgTableHeaderView).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 107, (SCREEN_WIDTH*3/4), 1)];
    view.backgroundColor = RGBColor(229, 229, 229, 1.f);
    [bgTableHeaderView addSubview:view];
    
    //在tableHeadView上添加一个点击的事件
    bgTableHeaderView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableHeaderViewClick:)];
    [bgTableHeaderView addGestureRecognizer:tap];
    
    _tableView.tableHeaderView = bgTableHeaderView;
}

//设置广告图片
- (void)configAD
{
    UIImageView *adImageView = [[UIImageView alloc] init];
    adImageView.backgroundColor = [UIColor whiteColor];
    [self getImageWith:adImageView];
    [self.view addSubview:adImageView];
    
    [adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-92);
        make.left.equalTo(_tableView).with.offset(0);
        make.right.equalTo(_tableView).with.offset(0);
        make.height.equalTo(@((SCREEN_WIDTH*3/16)));
    }];
    
    
    UIButton *adBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    adBtn.backgroundColor = [UIColor clearColor];

    [self.view addSubview:adBtn];
    
    [adBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-92);
        make.left.equalTo(_tableView).with.offset(0);
        make.right.equalTo(_tableView).with.offset(0);
        make.height.equalTo(@((SCREEN_WIDTH*3/16)));
    }];

    [adBtn addTarget:self action:@selector(clickADImage:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
//点击了广告图片
-(void)clickADImage:(UIButton *)sender
{
    NYLog(@"点击了广告图片");
}

//设置退出按钮所在界面，及退出按钮
- (void)configLogOutBtn
{
    UIView *btnBgView = [[UIView alloc] init];
    btnBgView.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:btnBgView];
    //设置fram
    [btnBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view.mas_left).with.offset(SCREEN_WIDTH*3/4);
        make.top.equalTo(self.view.mas_bottom).with.offset(-92);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitleColor:RGBColor(103, 103, 103, 1.f) forState:UIControlStateNormal];
    btn.layer.borderColor = RGBColor(180, 180, 180, 1.f).CGColor;
    btn.layer.borderWidth = 1.f;
    btn.layer.cornerRadius = 5.f;
    [btn addTarget:self action:@selector(personLogOut:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnBgView addSubview:btn];
    //设置fram
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-30);
        make.size.mas_equalTo(CGSizeMake(120, 32));
        make.centerX.equalTo(_tableView);
    }];

}
-(void)personLogOut:(UIButton *)sender
{
    NYLog(@"退出登录");
    if (self.logOut) {
        self.logOut();
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.superview.backgroundColor = [UIColor clearColor];
    [GSPersonInfoModel creatcreateDirectoryAtPathInDocumentWithDirectorName:@"personInfo"];
    [GSPersonInfoModel creatFileInaDirectorWithDirectorName:@"personInfo" andFileName:@"person"];
    
    [self configDataSource];
    [self configTableView];
    [self configLogOutBtn];
    [self configAD];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingString:@"/personInfo/person.plist"];
    _heardAry = [NSArray arrayWithContentsOfFile:filePath];
    if(_heardAry[0]){
    headerView.image = [UIImage imageWithData: _heardAry[0]];
    }
    else{
        headerView.image = [UIImage imageNamed:@"touxiang"];
    }
    nameLabel.text = _heardAry[1];
    numberLabel.text = _heardAry[5];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.001 animations:^{
        self.view.backgroundColor=[UIColor colorWithWhite:0.6 alpha:0.6];
    }];
}

//设置每个cell的数据（即是图片）
- (void)configDataSource
{
    _dataArr = [@[@{kMyCenterImage:@"wodexingcheng", kMyCenterTitle:@"我的行程"},
                  @{kMyCenterImage:@"wodeqianbao", kMyCenterTitle:@"我的钱包"},
                  @{kMyCenterImage:@"xiaoxizhongxin", kMyCenterTitle:@"消息中心"},
                  @{kMyCenterImage:@"tuangoushangcheng", kMyCenterTitle:@"团购商城"},
                  @{kMyCenterImage:@"tuijianyoujiang", kMyCenterTitle:@"推荐有奖"},
                  @{kMyCenterImage:@"sijizhaomu", kMyCenterTitle:@"司机招募"},
                  @{kMyCenterImage:@"faxian", kMyCenterTitle:@"发现"},
                  @{kMyCenterImage:@"shezhi", kMyCenterTitle:@"设置"}]
                mutableCopy];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 38;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"MyCenterId";
    MyCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyCenterCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.leftImageView.image = [UIImage imageNamed:_dataArr[indexPath.row][kMyCenterImage]];
    cell.nameLabel.text = _dataArr[indexPath.row][kMyCenterTitle];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableViewCellSelected) {
        self.tableViewCellSelected(indexPath.row,((MyCenterCell *)[tableView cellForRowAtIndexPath:indexPath]).nameLabel.text);
    }
}

#pragma mark - Touches
- (void)touchedForHiddenTableView:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.x = -SCREEN_WIDTH;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

#pragma mark - Gesture
- (void)tableHeaderViewClick:(UITapGestureRecognizer *)tap
{
    if (self.tableHeaderViewClicked) {
        self.tableHeaderViewClicked();
    }
}

-(void)getImageWith:(UIImageView *)imageView
{
    NSDictionary *params  = [NSDictionary dictionaryWithObject:@"1" forKey:@"adv_id"];
    
    NSString *url = [NSString stringWithFormat:URL_HEADER,@"OrderApi",@"adv"];
    
    [DownloadManager get:url params:params success:^(id json){
        @try {
            if (json) {
                NSNumber *num = json[@"data"];
                if ([num isEqualToNumber:[NSNumber numberWithInt:1]]) {
                    [imageView sd_setImageWithURL:json[@"info"] placeholderImage:[UIImage imageNamed:@"advertisementImage"] completed:^(UIImage *image,NSError *error,SDImageCacheType cacheType,NSURL *imageURL){
                    }];
                }
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }failure:^(NSError *error){
        
    }];
}
-(void)dealloc
{
    NYLog(@"%s",__func__);
}

@end
