//
//  MyStoreCenter.m
//  MaShangTong
//
//  Created by q on 15/12/14.
//  Copyright © 2015年 NY. All rights reserved.
//

#import "MyStoreCenter.h"
#import "MyCouponVC.h"
#import "MyOrderVC.h"

#import "Masonry.h"

@interface MyStoreCenter ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MyStoreCenter

#pragma mark - 设置btn的大小
-(void)setBtnsSize
{
    NSArray *nameAry = @[@"未付款",@"未消费",@"已完成"];
    CGSize btnSize = CGSizeMake(SCREEN_WIDTH/3-1, 35);
    CGSize viewSize = CGSizeMake(1, 12);
    CGFloat centerX = SCREEN_WIDTH/3/2;
    CGFloat centerY = 153.5;
    
    for (NSInteger i = 0; i<3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.size = btnSize;
        btn.center = CGPointMake(centerX*(2*i+1), centerY);
        btn.tag = 150+i;
        [btn setTitle:nameAry[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:RGBColor(192, 192, 192, 1.f) forState:UIControlStateNormal];
        [btn addTarget: self action:@selector(consumption:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(2*(i+1)*centerX, 146.5, viewSize.width, viewSize.height)];
        view.backgroundColor = RGBColor(192, 192, 192, 1.f);
        if (i==3) {
            view.hidden = YES;
        }
        [self.view addSubview:btn];
        [self.view addSubview:view];
    }
    
}
-(void)consumption:(UIButton *)sender
{
    MyOrderVC *vc = [[MyOrderVC alloc]init];
    
    
    switch (sender.tag) {
        case 150:
            vc.orderStatus = NotPayMent;
            break;
        case 151:
            vc.orderStatus = NotConsumption;
            break;
        case 152:
            vc.orderStatus = HadFinish;
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _array = @[@"我的团购券",@"团购订单"];
    
    [_backImageV setImage:[UIImage imageNamed:@"1团购商城-我的_02"]];
    
    
    [self dealNavicatonItens];
    
    [self setPictureAndNickname];
    
    [self sealOthers];
    
    [self dealTableView];
    
    [self setBtnsSize];
    
    
}
#pragma mark - 设置NavicatonItens
-(void)dealNavicatonItens
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.text = @"我的";
    label.textAlignment = 1;
    label.font = [UIFont systemFontOfSize:19];
    label.textColor = RGBColor(99, 193, 255, 1.f);
    
    self.navigationItem.titleView = label;
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    leftBtn.size = CGSizeMake(22, 22);
    [leftBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
}
//返回Btn的点击事件
-(void)backBtnClick
{
    NYLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 设置头像和昵称
-(void)setPictureAndNickname
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingString:@"/personInfo/person.plist"];
    NSArray *ary = [NSArray arrayWithContentsOfFile:filePath];
        
    _image.image = [UIImage imageWithData:ary[0]];
    _nameLabel.text = ary[1];
}
#pragma mark - 处理TableView
-(void)dealTableView
{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    
}
#pragma mark - 处理Others
-(void)sealOthers
{
    _image.layer.cornerRadius = 32.5f;
    _image.layer.masksToBounds = YES;
}
#pragma mark - UITableViewDelegate,UITableViewDateSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"MyStoreCenterCCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 12, 100, 21) ];
    label.textColor = RGBColor(159, 159, 159, 1.f);
    label.font = [UIFont systemFontOfSize:14];
    label.text = _array[indexPath.row];
//    
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(cell.contentView).offset(26);
//        make.centerY.equalTo(cell.contentView);
//        make.size.mas_equalTo(CGSizeMake(130, 30));
//    }];
    
    [cell.contentView addSubview:label];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == 0) {
        MyCouponVC *vc = [[MyCouponVC alloc]init];
        [self.navigationController pushViewController:vc  animated:YES];
    }
    else
    {
        MyOrderVC *vc = [[MyOrderVC alloc]init];
        vc.orderStatus = All;
        [self.navigationController pushViewController:vc animated:YES];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end
