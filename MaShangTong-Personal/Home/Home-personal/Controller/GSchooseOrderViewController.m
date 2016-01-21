//
//  GSchooseOrderViewController.m
//  MaShangTong-Personal
//
//  Created by q on 16/1/6.
//  Copyright © 2016年 jeaner. All rights reserved.
//

#import "GSchooseOrderViewController.h"

#import "MyChitTableViewCell.h"

@interface GSchooseOrderViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,copy) NSArray *dataAry;

@end

@implementation GSchooseOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataAry = [NSArray new];
    [self dealNaviction];
    [self getdataFromNet];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
}
-(void)dealNaviction
{
    [self.navigationItem setHidesBackButton:YES];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.text = @"选择优惠券";
    label.textAlignment = 1;
    label.font = [UIFont systemFontOfSize:19];
    label.textColor = RGBColor(99, 193, 255, 1.f);
    
    self.navigationItem.titleView = label;
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 60, 30);
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightBtn setTitle:@"取消" forState:UIControlStateNormal];
    [rightBtn setTitleColor:RGBColor(192, 192, 192, 1.f) forState:UIControlStateNormal];
    
    [rightBtn addTarget:self action:@selector(myConsumption) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
}
//点击我的消费详细
-(void)myConsumption
{
    if (self.backNothing) {
        self.backNothing();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITabelViewDelegate,UITabelViewDataSourse
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataAry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"orderTableViewCell";
    
    MyChitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyChitTableViewCell" owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.image.image = [UIImage imageNamed:@"wodeyouhuiquan@2x"];
    NSDictionary *dic = _dataAry[indexPath.row];
    cell.moneyLabel.text = dic[@"price"];
    cell.nameLabel.text = dic[@"name"];
    cell.timeLabel.text = [NSString stringWithFormat:@"有效至%@",dic[@"end_time"]];;
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _dataAry[indexPath.row];
    if (self.backTicket) {
        self.backTicket(dic[@"ticket_id"],dic[@"price"]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)getdataFromNet
{
    [MBProgressHUD showMessage:@"加载中"];
    
    NSDictionary *param = @{@"user_id":[USER_DEFAULT objectForKey:@"user_id"]};
    
    NSString *url = [NSString stringWithFormat:URL_HEADER,@"UserApi",@"show_ticket"];
    [DownloadManager post:url params:param success:^(id json) {
        [MBProgressHUD hideHUD];
        if (json) {
            NSString *str = [NSString stringWithFormat:@"%@",json[@"data"]];
            if ([str isEqualToString:@"1"]) {
                _dataAry = json[@"info"];
                [_tableView reloadData];
            }
            else{
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 21)];
                label.text = @"啊哦~~您还没有优惠券~~~";
                label.textAlignment = 1;
                label.font = [UIFont systemFontOfSize:12];
                label.textColor = RGBColor(192, 192, 192, 0.9f);
                [self.view addSubview:label];
                _tableView.hidden = YES;
            }
        }
        else{
            [MBProgressHUD showError:@"网络错误"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

@end
