//
//  MyChit.m
//  MaShangTong
//
//  Created by q on 15/12/10.
//  Copyright © 2015年 NY. All rights reserved.
//

#import "MyChit.h"

#import "AFNetworking.h"

#import "MyChitTableViewCell.h"

@implementation MyChit

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {
        self.layer.borderColor = RGBColor(242, 242, 242, 1.f).CGColor;
        self.layer.borderWidth = 1.f;
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self creatSubViews];
        
//        [self postTOchickChits];
    }
    return self;
}

-(void)creatSubViews
{    
    _vouchersDataAry = [NSArray new];
    _dataAry = [NSMutableArray new];
    
    _vouchersTabelV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 60) style:UITableViewStylePlain];
    _vouchersTabelV.delegate = self;
    _vouchersTabelV.dataSource = self;
    _vouchersTabelV.tableFooterView = [[UIView alloc]init];
    
    [self addSubview:_vouchersTabelV];
    
}

#pragma mark - UITabelViewDelegate,UITabelViewDataSourse
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_vouchersDataAry.count > 0) {
        for (int i = 0 ;i < _vouchersDataAry.count ; i++) {
            NSDictionary *dic = _vouchersDataAry[i];
            NSInteger num = [dic[@"num"] integerValue];
            for (int j = 0; j < num; j++) {
                [_dataAry addObject:dic];
            }
        }
    }
    return _dataAry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *identifier = @"chitTableViewCell";
    
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
//#pragma mark - 网络请求，查看我的券
//-(void)postTOchickChits
//{
//#warning ------加载数据中
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    
//    NSDictionary *param = @{@"user_id":@"148"};
//    
//    NSString *url = @"http://112.124.115.81/m.php?m=UserApi&a=user_show_ticket";
//    
//    [manager POST:url parameters:param success:^(AFHTTPRequestOperation *operation,id responseObject){
//        NYLog(@"============%@",responseObject);
//        
//        _vouchersDataAry = responseObject[@"info"];
//        if (_vouchersDataAry.count == 0) {
//            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 21)];
//            label.text = @"啊哦~~您还没有优惠券~~~";
//            label.textAlignment = 1;
//            label.font = [UIFont systemFontOfSize:12];
//            label.textColor = RGBColor(192, 192, 192, 0.9f);
//            [self addSubview:label];
//        }
//        else{
//            [_vouchersTabelV reloadData];
//        }
//        
//    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
//        NYLog(@"-----------------%@",error);
//    }];
//    
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
