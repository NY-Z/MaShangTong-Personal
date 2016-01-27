 //
//  MyStoreVC.m
//  MaShangTong
//
//  Created by q on 15/12/11.
//  Copyright © 2015年 NY. All rights reserved.
//

#import "MyStoreVC.h"
#import "MyStoreCenter.h"
#import "GSshopViewController.h"

#import "MyStoreTableViewCell.h"

@interface MyStoreVC ()
{
    UITableView *_tableView;
    
    NSMutableDictionary *_ticketDic;
}
@property (nonatomic,copy) NSArray *dataAry;

@end

@implementation MyStoreVC


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    _dataAry =[NSArray new];
    
    [self dealNavicatonItens];
    [self getDataThroughtPost];
    [self creatTableView];
    
}
#pragma mark - 设置NavicatonItens
-(void)dealNavicatonItens
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.text = @"团购商城";
    label.textAlignment = 1;
    label.font = [UIFont systemFontOfSize:19];
    label.textColor = RGBColor(99, 193, 255, 1.f);
    
    self.navigationItem.titleView = label;
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    leftBtn.size = CGSizeMake(22, 22);
    [leftBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 15, 20);
    [rightBtn setImage:[UIImage imageNamed:@"团购中心1"] forState:UIControlStateNormal];
    
    [rightBtn addTarget:self action:@selector(myConsumption) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}
//返回Btn的点击事件
-(void)backBtnClick
{
    NYLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}
//点击我的消费详细
-(void)myConsumption
{
    NYLog(@"去我的消费中心");
    MyStoreCenter *vc = [[MyStoreCenter alloc]init];
    
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark - 创建Tableview
-(void)creatTableView
{
    CGRect rect = CGRectMake(0, 0, self.view.size.width, self.view.size.height-64);
    _tableView = [[UITableView alloc]initWithFrame:rect style:UITableViewStyleGrouped];
    
    _tableView .delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
}
#pragma mark - UITableViewDelegate UITableViewDasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataAry.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *ary = _dataAry[section][@"a"];
    return ary.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    view.backgroundColor = RGBColor(255, 255, 240, 1.f);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
    imageView.layer.cornerRadius = 15;
    imageView.layer.masksToBounds = YES;
    NSDictionary *dic = _dataAry[section];
    [imageView sd_setImageWithURL:dic[@"logo"]];
    
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(45, 5, 150, 30)];
    label.font = [UIFont systemFontOfSize:16];
    label.text = dic[@"name"];
    [view addSubview:label];
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MyStoreTableViewCell";
    MyStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyStoreTableViewCell" owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    NSDictionary *dic = _dataAry[indexPath.section][@"a"][indexPath.row];
    if(dic){
        [cell.imageV sd_setImageWithURL:dic[@"img"]];
        cell.nameLabel.text = dic[@"combo"];
        cell.priceLabel.text = dic[@"new_price"];
        cell.yuanjiaLabel.text = dic[@"original_price"];
        cell.zongleiLabel.text = dic[@"ticket_name"];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    GSshopViewController *vc = [[GSshopViewController alloc]init];
    NSDictionary *dic = _dataAry[indexPath.section];
    vc.shc_id = dic[@"shc_id"];
    vc.company_id = dic[@"company_id"];
    NSDictionary *subDic = dic[@"a"][indexPath.row];
    vc.cb_id = subDic[@"cb_id"];
    vc.ticket_id = subDic[@"ticket_id"];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 网络请求
-(void)getDataThroughtPost
{    
    [MBProgressHUD showMessage:@"正在加载"];
    //获取商城内详细
    [DownloadManager post:[NSString stringWithFormat:Mast_Url,@"ShcApi",@"shh"] params:nil success:^(id json){
        @try {
            [MBProgressHUD hideHUD];
            if (json) {
                NSString *str = [NSString stringWithFormat:@"%@",json[@"data"]];
                if ([str isEqualToString:@"1"]) {
                    _dataAry = json[@"info"];
                    [_tableView reloadData];
                }
                else{
                    [MBProgressHUD showSuccess:@"暂没有商家入驻"];
                }
            }
            else{
                [MBProgressHUD showError:@"网络错误"];
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        
    }failure:^(NSError *error){
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请求超时"];
    }];
    
    
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
