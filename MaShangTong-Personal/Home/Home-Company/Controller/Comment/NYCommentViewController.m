//
//  NYCommentViewController.m
//  MaShangTong-Personal
//
//  Created by NY on 15/12/31.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "NYCommentViewController.h"
#import "StarView.h"
#import "DriverInfoModel.h"
#import "CompanyHomeViewController.h"

@interface NYCommentViewController ()

@property (weak, nonatomic) IBOutlet StarView *rateStarImageView;
@property (weak, nonatomic) IBOutlet UILabel *driverNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *driverLicenseLabel;
@property (weak, nonatomic) IBOutlet StarView *driverRateStarView;
@property (weak, nonatomic) IBOutlet UILabel *driverBillCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
- (IBAction)commitBtnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation NYCommentViewController

- (void)configDriverInfo
{
    self.driverNameLabel.text = _driverInfoModel.owner_name;
    self.driverLicenseLabel.text = _driverInfoModel.license_plate;
    [self.driverRateStarView setRating:[_driverInfoModel.averagePoint floatValue]];
    self.driverBillCountLabel.text = [NSString stringWithFormat:@"%@单",_driverInfoModel.num];
}

- (void)configNavigationBar
{
    self.navigationItem.title = @"服务中";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:0 target:nil action:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configNavigationBar];
    [self configDriverInfo];
    [self handleTheWeidget];
}

- (void)handleTheWeidget
{
    [_rateStarImageView setRating:0];
    _rateStarImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *rateStarImageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rateStarImageViewTaped:)];
    [_rateStarImageView addGestureRecognizer:rateStarImageViewTap];
    
    _commitBtn.layer.cornerRadius = 35;
    
    self.contentTextView.layer.cornerRadius = 5.f;
    self.contentTextView.layer.borderWidth = 1.f;
    self.contentTextView.layer.borderColor = RGBColor(109, 187, 248, 1.f).CGColor;
}

#pragma mark - Gesture
- (void)rateStarImageViewTaped:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:_rateStarImageView];
    NYLog(@"%@",NSStringFromCGPoint(point));
    [_rateStarImageView setRating:point.x*5/(_rateStarImageView.width)];
    _rateStarImageView.rate = point.x*5/(_rateStarImageView.width);
}

- (IBAction)commitBtnClicked:(id)sender
{
    [MBProgressHUD showMessage:@"评论中"];
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"comment"] params:@{@"user_id":[USER_DEFAULT objectForKey:@"user_id"],@"driver_id":_driverInfoModel.driver_id,@"content":_contentTextView.text,@"stars":[NSString stringWithFormat:@"%.2f",_rateStarImageView.rate],@"route_id":self.route_id} success:^(id json) {
        [MBProgressHUD hideHUD];
        NSString *dataStr = [NSString stringWithFormat:@"%@",json[@"data"]];
        if ([dataStr isEqualToString:@"1"]) {
            [MBProgressHUD showSuccess:@"评论成功"];
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[CompanyHomeViewController class]]) {
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
            return ;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"评论失败，请重试"];
    }];
}
@end
