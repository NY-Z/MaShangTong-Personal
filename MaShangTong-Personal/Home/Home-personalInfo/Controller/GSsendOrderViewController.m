//
//  GSsendOrderViewController.m
//  MaShangTong-Personal
//
//  Created by q on 16/1/5.
//  Copyright © 2016年 jeaner. All rights reserved.
//

#import "GSsendOrderViewController.h"
#import "GSshopPayViewController.h"


@interface GSsendOrderViewController ()

{
    NSString *totalPriceStr;
}

@end

static int number = 1;
@implementation GSsendOrderViewController

-(void)viewWillAppear:(BOOL)animated
{
    number = 1;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    number = 1;
    
    _sendOrder.layer.cornerRadius = 5.f;
    _minusBtn.enabled = NO;
    
    _nameLabel.text = _goodsName;
    _perPriceLabel.text = _perPriceStr;
    _total.text = [NSString stringWithFormat:@"%.2f",[_perPriceStr floatValue]*number];
    
    [self dealNavicatonItens];
    
}
#pragma mark - 设置NavicatonItens
-(void)dealNavicatonItens
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.text = @"提交订单";
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
- (IBAction)minusAction:(id)sender {
    number --;
    _numLabel.text = [NSString stringWithFormat:@"%d",number];
    _total.text = [NSString stringWithFormat:@"%.2f",number*[_perPriceLabel.text doubleValue]];
    if (number <= 1) {
        _minusBtn.enabled = NO;
        [_minusBtn setBackgroundColor:RGBColor(211, 211, 211, 1.f)];
    }
}

- (IBAction)addAction:(id)sender {
    number ++;
    _numLabel.text = [NSString stringWithFormat:@"%d",number];
    [_minusBtn setBackgroundColor:RGBColor(99, 193, 255, 1.f)];
    _minusBtn.enabled = YES;
    _total.text = [NSString stringWithFormat:@"%.2f",number*[_perPriceLabel.text doubleValue]];
}
#pragma mark - 购买
- (IBAction)sendOrder:(id)sender {
    [self submittedOrder];
}
-(void)submittedOrder
{
    [MBProgressHUD showMessage:@"正在提交订单"];
    NSDictionary *params = [NSDictionary dictionaryWithObjects:@[_cb_id,USER_ID,@"1",[NSString stringWithFormat:@"%d",number]] forKeys:@[@"combo_id",@"user_id",@"group_id",@"num"]];
    
    [DownloadManager post:[NSString stringWithFormat:Mast_Url,@"ShcApi",@"sub_order"] params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        @try {
            if (json) {
                NSString *str = [NSString stringWithFormat:@"%@", json[@"data"]];
                if ([str isEqualToString:@"1"]) {
                    GSshopPayViewController *vc = [[GSshopPayViewController alloc]init];
                    vc.goodsName = self.goodsName;
                    vc.priceStr = _total.text;
                    vc.route_id = json[@"order_id"];
                    vc.company_id = _company_id;
                    vc.ticket_id = _ticket_id;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                }
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误，提交订单失败"];
    }];
}
@end
