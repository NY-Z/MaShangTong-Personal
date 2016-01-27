//
//  GSshopViewController.m
//  MaShangTong-Personal
//
//  Created by q on 16/1/5.
//  Copyright © 2016年 jeaner. All rights reserved.
//

#import "GSshopViewController.h"

#import "GSsendOrderViewController.h"

#import "AFNetworking.h"

@interface GSshopViewController ()
{
    NSString *_priceStr;
    NSString *_detailStr;
}

@property (nonatomic,copy) NSString *combo_name;
@property (nonatomic,copy) NSString *combo_id;
@property (nonatomic,copy) NSString *perPrice;

@end

@implementation GSshopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _buyBtn.layer.cornerRadius = 3.f;
    
    
    _priceStr = [NSString new];
    _detailStr = [NSString new];
    
    [self getDataFromNet];
    
    [self dealNavicatonItens];
}
#pragma mark - 设置NavicatonItens
-(void)dealNavicatonItens
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.text = @"团购详情";
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


- (IBAction)goShopping:(id)sender {
    GSsendOrderViewController *vc = [[GSsendOrderViewController alloc]init];
    vc.goodsName = _combo_name;
    vc.cb_id = _combo_id;
    vc.perPriceStr = _perPrice;
    vc.company_id = _company_id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 获取订餐的详细
-(void)getDataFromNet
{
    [MBProgressHUD showMessage:@"正在加载"];
    NSDictionary *parmas = [NSDictionary dictionaryWithObjects:@[_shc_id,_cb_id] forKeys:@[@"shc_id",@"cb_id"]];
    NSString *url = [NSString stringWithFormat:Mast_Url,@"ShcApi",@"combo"];
    [DownloadManager post:url params:parmas success:^(id json) {
        @try {
            [MBProgressHUD hideHUD];
            if (json) {
                NSString *str = [NSString stringWithFormat:@"%@",json[@"data"]];
                if ([str isEqualToString:@"1"]) {
                    
                    _combo_name = json[@"info"][@"combo"];
                    _combo_id = json[@"info"][@"cb_id"];
                    _perPrice = json[@"info"][@"new_price"];
                    
                    [_imageView sd_setImageWithURL:json[@"info"][@"img"]];
                    [_priceLabel setText:[NSString stringWithFormat:@"%@元",json[@"info"][@"new_price"]]];
                    
                    [_textView setText:json[@"info"][@"remark1"] ];
                    NSMutableAttributedString *addressStr = [self addressStrWith:json[@"info"]];
                    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc]initWithString:json[@"info"][@"remark1"] ];
                    [contentStr setAttributes:@{NSForegroundColorAttributeName:RGBColor(100, 100, 100, 1.f),NSFontAttributeName:[UIFont systemFontOfSize:16]} range:NSMakeRange(0, contentStr.length)];
                    [addressStr appendAttributedString:contentStr];
                    [_textView setAttributedText:addressStr];
                }
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误"];
    }];
    
}
-(NSMutableAttributedString *)addressStrWith:(NSDictionary *)dic
{
    NSString *name = dic[@"combo"];
    NSString *address = dic[@"address"];
    NSString *str = [NSString stringWithFormat: @"商家信息\n\n%@\n%@\n\n\n",name,address];
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attriStr setAttributes:@{NSForegroundColorAttributeName:RGBColor(150, 150, 150, 1.f),NSFontAttributeName:[UIFont systemFontOfSize:16]} range:NSMakeRange(0, 4)];
    [attriStr setAttributes:@{NSForegroundColorAttributeName:RGBColor(50, 50, 50, 1.f),NSFontAttributeName:[UIFont systemFontOfSize:16]} range:NSMakeRange(6, name.length)];
    [attriStr setAttributes:@{NSForegroundColorAttributeName:RGBColor(150, 150, 150, 1.f),NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(attriStr.length-address.length-3, address.length)];
    
    return attriStr;
}

@end
