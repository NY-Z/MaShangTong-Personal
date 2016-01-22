//
//  MyCouponVC.m
//  MaShangTong
//
//  Created by q on 15/12/14.
//  Copyright © 2015年 NY. All rights reserved.
//

#import "MyCouponVC.h"
#import "MyCouponTableViewCell.h"

@interface MyCouponVC ()

{
    NSArray *_dataAry;
}
@end

@implementation MyCouponVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataAry = [NSArray new];

    [self chickMyorders];
    [self dealNavicatonItens];
}
#pragma mark - 设置NavicatonItens
-(void)dealNavicatonItens
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.text = @"我的团购券";
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
#pragma mark - 出去看我的团购券
-(void)chickMyorders
{
    NSDictionary *params = [NSDictionary dictionaryWithObject:USER_ID forKey:@"user_id"];
    
    [DownloadManager post:[NSString stringWithFormat:Mast_Url,@"ShcApi",@"myStamps"] params:params success:^(id json) {
        @try {
            if (json) {
                NSString *str = [NSString stringWithFormat:@"%@",json[@"data"]];
                if ([str isEqualToString:@"1"]) {
                    _dataAry = json[@"info"];
                    [_tableView reloadData];
                }
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
    }];
}

#pragma mark - UITableViewDataSource,UITableDelegte
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataAry.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MyCouponTableViewCell";
    
    MyCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyCouponTableViewCell" owner:nil options:nil]lastObject];
        
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    }
    NSDictionary *dic = _dataAry[indexPath.row];
    cell.nameLabel.text = dic[@"name"];
    cell.timeLabel.text = dic[@"end_time"];
    cell.numberLabel.text = dic[@"yzm"];
    NSDictionary *subDic = dic[@"ticket"];
    cell.presenterOrder.text = [NSString stringWithFormat:@"赠送：%@%@元",subDic[@"name"],subDic[@"price"]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
