//
//  GSPriceRuleViewController.m
//  MaShangTong-Personal
//
//  Created by q on 16/3/12.
//  Copyright © 2016年 jeaner. All rights reserved.
//

#import "GSPriceRuleViewController.h"

@interface GSPriceRuleViewController ()
{
    UILabel *contentLabel;
    
    UIScrollView *scrollView;
}
@end

@implementation GSPriceRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"码尚通收费标准";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:RGBColor(73, 185, 254, 1.f)}];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    backBtn.size = CGSizeMake(22, 22);
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
//    NSString *contentStr = @"舒适电动车：/n  起步价：%@元；/n  里程费：%@元；/n  远途费：%@元；/n  低速费：%@元；/n  夜间费：%@元；/n/n商务电动车：/n  起步价：%@元；/n  里程费：%@元；/n  远途费：%@元；/n  低速费：%@元；/n  夜间费：%@元；/n/n豪华电动车：/n  起步价：%@元；/n  里程费：%@元；/n  远途费：%@元；/n  低速费：%@元；/n  夜间费：%@元；";
//    CGFloat height = [Helper heightOfString:contentStr font:[UIFont systemFontOfSize:15] width:SCREEN_WIDTH-60];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.view addSubview:scrollView];
    
//    contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, SCREEN_WIDTH-60, height)];
//    contentLabel.text = contentStr;
//    //    contentLabel.backgroundColor = [UIColor cyanColor];
//    contentLabel.font = [UIFont systemFontOfSize:15];
//    contentLabel.textColor = RGBColor(123, 123, 123, 1.f);
//    contentLabel.numberOfLines = 0;
//    [scrollView addSubview:contentLabel];
//    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, height+60);
//    scrollView.showsVerticalScrollIndicator = NO;
    
    [self getPriceRule];
    
}
- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 网络请求计价规则
-(void)getPriceRule{
    
    NSDictionary *param = @{@"reserva_type":@"1"};
    
    NSString *url = [NSString stringWithFormat:URL_HEADER,@"OrderApi",@"order_car"];
    
    [DownloadManager post:url params:param success:^(id json) {
        @try {
            NSString *str = json[@"data"];
            if ([str isEqualToString:@"1"]) {
                NSArray *ruleAry = [json[@"info"][@"rule"] copy];
                NSString *contentStr = [NSString stringWithFormat:@"舒适电动车：\n  起步价：%@元；\n  里程费：%@元；\n  远途费：%@元；\n  低速费：%@~%@元；\n  夜间费：%@元；\n\n商务电动车：\n  起步价：%@元；\n  里程费：%@元；\n  远途费：%@元；\n  低速费：%@~%@元；\n  夜间费：%@元；\n\n豪华电动车：\n  起步价：%@元；\n  里程费：%@元；\n  远途费：%@元；\n  低速费：%@~%@元；\n  夜间费：%@元；",ruleAry[0][@"step"],ruleAry[0][@"mileage"],ruleAry[0][@"long_mileage"],ruleAry[0][@"low_speed"],ruleAry[0][@"high_low_speed"],ruleAry[0][@"night"],         ruleAry[1][@"step"],ruleAry[1][@"mileage"],ruleAry[1][@"long_mileage"],ruleAry[1][@"low_speed"],ruleAry[1][@"high_low_speed"],ruleAry[1][@"night"] ,    ruleAry[2][@"step"],ruleAry[2][@"mileage"],ruleAry[2][@"long_mileage"],ruleAry[2][@"low_speed"],ruleAry[2][@"high_low_speed"],ruleAry[2][@"night"]];
                CGFloat height = [Helper heightOfString:contentStr font:[UIFont systemFontOfSize:15] width:SCREEN_WIDTH-60];
                
                contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, SCREEN_WIDTH-60, height)];
                contentLabel.text = contentStr;
                //    contentLabel.backgroundColor = [UIColor cyanColor];
                contentLabel.font = [UIFont systemFontOfSize:15];
                contentLabel.textColor = RGBColor(123, 123, 123, 1.f);
                contentLabel.numberOfLines = 0;
                [scrollView addSubview:contentLabel];
                scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, height+60);
                scrollView.showsVerticalScrollIndicator = NO;
                
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    } failure:^(NSError *error) {
        
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
