//
//  MyOrderVC.m
//  MaShangTong
//
//  Created by q on 15/12/14.
//  Copyright © 2015年 NY. All rights reserved.
//

#import "MyOrderVC.h"
#import "MyOrderTableViewCell.h"
#import "GSshopPayViewController.h"

@interface MyOrderVC ()
{
    UIButton *tempBtn;
    
    NSArray *_dataAry;
}

@end

@implementation MyOrderVC


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataAry = [NSArray new];
    
    [self dealNavicatonItens];
    
    [self chickOrders];
    
    [self dealFiveBtns];
    
    [self creatTableView];
}
#pragma mark - 设置NavicatonItens
-(void)dealNavicatonItens
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.text = @"团购订单";
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
    rightBtn.frame = CGRectMake(0, 0, 25, 25);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"bianji"] forState:UIControlStateNormal];
    
    [rightBtn addTarget:self action:@selector(editorTableView:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
}
//返回Btn的点击事件
-(void)backBtnClick
{
    NYLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}
//编辑按钮的点击事件
-(void)editorTableView:(UIButton *)sender
{
    _tableView.editing = !_tableView.editing;
}
#pragma mark - 设置上面四个按钮
-(void)dealFiveBtns
{
    
    CGSize btnSize = CGSizeMake(SCREEN_WIDTH/4-1, 35);
    CGSize viewSize = CGSizeMake(1, 12);
    CGFloat centerX = SCREEN_WIDTH/4/2;
    CGFloat centerY = 17.5;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, 1)];
    view.backgroundColor = RGBColor(204, 204, 204, 1.f);
    [self.view addSubview:view];
    _blueView = [[UIView alloc]initWithFrame:CGRectMake(0, 35, btnSize.width, 1)];
    _blueView.backgroundColor = RGBColor(93, 195, 255, 1.f);
    [self.view addSubview:_blueView];
    
    
    NSArray *nameAry = @[@"全部",@"未付款",@"未消费",@"已完成"];
    
    for (NSInteger i = 0; i<4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.size = btnSize;
        btn.center = CGPointMake(centerX*(2*i+1), centerY);
        [btn setTitle:nameAry[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = 1200+i;
        [btn setTitleColor:RGBColor(41, 36, 33, 1.f) forState:UIControlStateNormal];
        [btn addTarget: self action:@selector(moveAndReload:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(2*(i+1)*centerX, centerY-6, viewSize.width, viewSize.height)];
        view.backgroundColor = RGBColor(204, 204, 204, 1.f);
        switch (self.orderStatus) {
            case All:
                if (i == 0) {
                    tempBtn = btn;
                    [btn setTitleColor:RGBColor(93, 195, 255, 1.f) forState:UIControlStateNormal];
                    _blueView.centerX = btn.centerX;
                }
                break;
            case NotPayMent:
                if (i == 1) {
                    tempBtn = btn;
                    [btn setTitleColor:RGBColor(93, 195, 255, 1.f) forState:UIControlStateNormal];
                    _blueView.centerX = btn.centerX;
                }
                break;
            case NotConsumption:
                if (i == 2) {
                    tempBtn = btn;
                    [btn setTitleColor:RGBColor(93, 195, 255, 1.f) forState:UIControlStateNormal];
                    _blueView.centerX = btn.centerX;
                }
                break;
            case HadFinish:
                if (i == 3) {
                    tempBtn = btn;
                    [btn setTitleColor:RGBColor(93, 195, 255, 1.f) forState:UIControlStateNormal];
                    _blueView.centerX = btn.centerX;
                }
                break;
            default:
                break;
        }
        [self.view addSubview:btn];
        [self.view addSubview:view];
    }
    
    
    
}
//按钮的点击事件
-(void)moveAndReload:(UIButton *)sender
{
    [tempBtn setTitleColor:RGBColor(41, 36, 33, 1.f) forState:UIControlStateNormal];
    [sender setTitleColor:RGBColor(93, 195, 255, 1.f) forState:UIControlStateNormal];
    tempBtn = sender;
    switch (sender.tag) {
        case 1200:
            self.orderStatus = All;
            break;
        case 1201:
            self.orderStatus = NotPayMent;
            break;
        case 1202:
            self.orderStatus = NotConsumption;
            break;
        case 1203:
            self.orderStatus = HadFinish;
            break;
        default:
            break;
    }
    _dataAry = nil;
    [_tableView reloadData];
    [self chickOrders];
    
    [UIView animateWithDuration:0.3 animations:^{
        _blueView.centerX = sender.centerX;
    }];
}
#pragma mark - 查看各个分类的订单
-(void)chickOrders
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:USER_ID forKey:@"user_id"];
    switch (self.orderStatus) {
        case All:
            
            break;
        case NotPayMent:
            [params setValue:@"0" forKey:@"status"];
            break;
        case NotConsumption:
            [params setValue:@"1" forKey:@"status"];
            break;
        case HadFinish:
            [params setValue:@"2" forKey:@"status"];
            break;
        default:
            break;
    }
    [DownloadManager post:[NSString stringWithFormat:Mast_Url,@"ShcApi",@"myOrder"] params:params success:^(id json) {
        @try {
            if (json) {
                NSString *str = [NSString stringWithFormat:@"%@",json[@"data"]];
                if ([str isEqualToString:@"1"]) {
                    _dataAry = json[@"info"];
                    [_tableView reloadData];
                    [_tableView scrollsToTop];
                }
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网路错误"];
    }];
    
}
#pragma  mark - 添加TableView
-(void)creatTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 36, SCREEN_WIDTH, SCREEN_HEIGHT-100) style:UITableViewStylePlain];
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
}
#pragma mark - UITbleViewDelegate,UITbaleViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataAry.count ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MyOrderTableViewCell";
    
    MyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyOrderTableViewCell" owner:nil options:nil]lastObject];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic = _dataAry[indexPath.row];
    [cell.imageV sd_setImageWithURL:dic[@"img"]];
    cell.nameLabel.text = dic[@"name"];
    cell.priceLabel.text = [NSString stringWithFormat:@"总价：%@  数量：1",dic[@"new_price"]];
    cell.combo.text = dic[@"combo"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.orderStatus == NotPayMent) {
        NSDictionary *dic = _dataAry[indexPath.row];
        GSshopPayViewController *vc = [[GSshopPayViewController alloc]init];
        vc.goodsName = dic[@"name"];
        vc.priceStr = dic[@"new_price"];
        vc.route_id = dic[@"order_id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [NSString stringWithFormat:@"%@",_dataAry[indexPath.row][@"status"]];
    if([str isEqualToString:@"1"]){
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未消费的订单不能删除" preferredStyle:UIAlertControllerStyleAlert];
        [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        [self presentModalViewController:alter animated:YES];
    }
    else{
        [self electricDeleteOrderWith:indexPath.row];
    }
}
#pragma mark - 删除订单
-(void)electricDeleteOrderWith:(NSInteger )num
{
    [MBProgressHUD showMessage:@"删除中"];
    NSDictionary *params = [NSDictionary dictionaryWithObject:_dataAry[num][@"order_id"] forKey:@"order_id"];
    NSString *url = [NSString stringWithFormat:Mast_Url,@"ShcApi",@"del_order"];
    
    [DownloadManager post:url params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        @try {
            if(json){
                NSString *str = [NSString stringWithFormat:@"%@",json[@"data"]];
                if ( [str isEqualToString:@"1"]) {
                    [MBProgressHUD showSuccess:@"删除成功"];
                    NSMutableArray *tempAry = [NSMutableArray arrayWithArray:_dataAry];
                    [tempAry removeObjectAtIndex:num];
                    _dataAry = tempAry;
                    [_tableView reloadData];
                }
                else{
                    [MBProgressHUD showError:@"删除失败"];
                }
            }else{
                [MBProgressHUD showError:@"删除失败"];
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误"];
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
