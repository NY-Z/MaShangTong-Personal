//
//  NYComplaintViewController.m
//  MaShangTong-Personal
//
//  Created by NY on 16/1/21.
//  Copyright © 2016年 jeaner. All rights reserved.
//

#import "NYComplaintViewController.h"

@interface NYComplaintViewController ()
@property (weak, nonatomic) IBOutlet UITextView *complaintTextView;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
- (IBAction)confirmBtnClicked:(id)sender;

@end

@implementation NYComplaintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigationBar];
    [self handleTheWeidget];
}

- (void)handleTheWeidget
{
    self.confirmBtn.layer.cornerRadius = 40;
}

- (void)configNavigationBar
{
    UILabel *navTitleLabel = [[UILabel alloc] init];
    navTitleLabel.size = CGSizeMake(200, 22);
    navTitleLabel.font = [UIFont systemFontOfSize:21];
    navTitleLabel.textColor = RGBColor(73, 185, 254, 1.f);
    navTitleLabel.textAlignment = 1;
    navTitleLabel.text = @"投诉";
    self.navigationItem.titleView = navTitleLabel;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBarButtonItemClicked) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.size = CGSizeMake(44, 44);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}

- (void)leftBarButtonItemClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confirmBtnClicked:(id)sender {
    if (self.complaintTextView.text.length <= 3) {
        [MBProgressHUD showError:@"投诉内容过短"];
        return;
    }
    [MBProgressHUD showMessage:@"投诉中"];
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"complaint"] params:@{@"driver_id":self.driverId,@"user_id":[USER_DEFAULT objectForKey:@"user_id"],@"content":self.complaintTextView.text} success:^(id json) {
        [MBProgressHUD hideHUD];
        NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
        if ([dataStr isEqualToString:@"1"]) {
            [MBProgressHUD showSuccess:@"投诉成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showError:@"投诉失败，请重试"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"投诉失败，请重试"];
    }];
}
@end
