//
//  MyWalletVC.m
//  MaShangTong
//
//  Created by q on 15/12/10.
//  Copyright © 2015年 NY. All rights reserved.
//

#import "MyWalletVC.h"
#import "GSrechargeVC.h"

#import "AFNetworking.h"

#import "MyMoney.h"
#import "MyChit.h"

#import "myWalletModel.h"


@interface MyWalletVC ()


@end

@implementation MyWalletVC


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    [self dealModel];
    
    [self sendOrder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatSubViews];
}

#pragma mark - creatSubViews
-(void)creatSubViews
{
    [self dealNavicatonItens];
    
    [self creatOtherViews];
    
    [self creatOthers];


}
-(void)dealModel
{
    _myWallet.user_id = [NSString stringWithFormat:@"%@",[USER_DEFAULT objectForKey:@"user_id"]];
    _myWallet.type = [NSString stringWithFormat:@"%d",4];
    _myWallet.group_id = [NSString stringWithFormat:@"%d",1];
}
#pragma mark - dealNavicatonItens
-(void)dealNavicatonItens
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.text = @"我的账户";
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
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - creatOthers
-(void)creatOthers
{
    //上面一条灰色的线
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    view.backgroundColor = RGBColor(220, 220, 220, 1.f);
    
    [self.view addSubview:view];
    
    //下面用两个Btn完成
    NSArray *btnNameAry = @[@"我的余额",@"我的券"];
    for (NSInteger i = 0; i<2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*(self.view.frame.size.width/2), 1, (self.view.frame.size.width/2), 30);
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag = 120+i;
        btn.enabled = NO;
        [btn setTitle:btnNameAry[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitleColor:RGBColor(99, 193, 255, 1.f) forState:UIControlStateNormal];
        if (i == 1) {
            btn.backgroundColor = RGBColor(220, 220, 220, 1.f);
            [btn setTitleColor:RGBColor(192, 192, 192, 1.f) forState:UIControlStateNormal];
            btn.enabled = YES;
        }
        
        [btn addTarget:self action:@selector(cheackMyWallet:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btn];
    }
    
}
//btn的点击事件
-(void)cheackMyWallet:(UIButton *)sender
{
    UIButton *getBtn1 = [self.view viewWithTag:120];
    UIButton *getBtn2 = [self.view viewWithTag:121];
    
    //“我的钱包“被点击了
    if ( getBtn1.enabled) {
        
        [self sendOrder];
        
        getBtn1.backgroundColor = [UIColor whiteColor];
        [getBtn1 setTitleColor:RGBColor(99, 193, 255, 1.f) forState:UIControlStateNormal];
        
        getBtn2.backgroundColor = RGBColor(220, 220, 220, 1.f);
        [getBtn2 setTitleColor:RGBColor(192, 192, 192, 1.f) forState:UIControlStateNormal];
        

        getBtn1.enabled = NO;
        getBtn2.enabled = YES;

        [_chitView removeFromSuperview];
        [self.view addSubview:_moneyView];
        
        
    }
    //“我的券”被点击了
    else {
        [self postTOchickChits];
        
        getBtn2.backgroundColor = [UIColor whiteColor];
        [getBtn2 setTitleColor:RGBColor(99, 193, 255, 1.f) forState:UIControlStateNormal];
        
        getBtn1.backgroundColor = RGBColor(220, 220, 220, 1.f);
        [getBtn1 setTitleColor:RGBColor(192, 192, 192, 1.f) forState:UIControlStateNormal];
        

        getBtn2.enabled = NO;
        getBtn1.enabled = YES;
        
        [_moneyView removeFromSuperview];
        [self.view addSubview:_chitView];
    }
    
    
}

#pragma mark - 创建其他的视图
-(void)creatOtherViews
{
    _rechargeVC = [[GSrechargeVC alloc]init];
    
    _myWallet = [[myWalletModel alloc]init];
    
    //我的钱包对应的view
    _moneyView = [[MyMoney alloc]initWithFrame:CGRectMake(0, 31, self.view.frame.size.width, self.view.frame.size.height-31)];
    
    //我的券对应view
    _chitView = [[MyChit alloc]initWithFrame:CGRectMake(0, 31, self.view.frame.size.width, self.view.frame.size.height-31)];
    
    [self.view addSubview:_moneyView];

    __weak typeof (self) weakSelf = self;
    
    _moneyView.recharge = ^(){
        [weakSelf.navigationController pushViewController:weakSelf.rechargeVC animated:YES];
    };
}

#pragma mark - 网络请求，查看余额
-(void)sendOrder
{
    [MBProgressHUD showMessage:@"加载中"];
    
    NSDictionary *param = [myWalletModel getDicWith:_myWallet];
    
    NSString *url = [NSString stringWithFormat:URL_HEADER,@"UserApi",@"recharge"];
    NSDate *date = [NSDate date];
    NSLog(@"before   %@",date);
    
    [DownloadManager post:url params:param success:^(id json) {
        NSDate *date = [NSDate date];
        NSLog(@"after   %@",date);
        [MBProgressHUD hideHUD];
        
        if(json){
            NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat: @"%@ 元",json[@"money"]]];
            [attriStr setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:28]} range:NSMakeRange(0, attriStr.length-1)];
            self.moneyView.MyDalanceLabel.attributedText = attriStr;
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
#pragma mark - 网络请求，查看我的券
-(void)postTOchickChits
{
    [MBProgressHUD showMessage:@"加载中"];
    
    NSDictionary *param = @{@"user_id":[USER_DEFAULT objectForKey:@"user_id"]};
    
    NSString *url = [NSString stringWithFormat:Mast_Url,@"UserApi",@"show_ticket"];
    [DownloadManager post:url params:param success:^(id json) {
        [MBProgressHUD hideHUD];
        if (json) {
            NSString *str = [NSString stringWithFormat:@"%@",json[@"data"]];
            if ([str isEqualToString:@"0"]) {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 21)];
                label.text = @"啊哦~~您还没有优惠券~~~";
                label.textAlignment = 1;
                label.font = [UIFont systemFontOfSize:12];
                label.textColor = RGBColor(192, 192, 192, 0.9f);
                [self.chitView addSubview:label];
                
                self.chitView.vouchersTabelV.hidden = YES;
            }
            else{
                [self.chitView.vouchersTabelV reloadData];
            }
        }
        else{
            [MBProgressHUD showError:@"网络错误"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请求超时错误"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

-(void)dealloc
{
    NSLog(@"dealloc");
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
