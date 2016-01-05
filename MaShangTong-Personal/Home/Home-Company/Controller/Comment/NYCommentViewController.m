//
//  NYCommentViewController.m
//  MaShangTong-Personal
//
//  Created by NY on 15/12/31.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "NYCommentViewController.h"
#import "StarView.h"

@interface NYCommentViewController ()

@property (weak, nonatomic) IBOutlet StarView *rateStarImageView;

@end

@implementation NYCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [_rateStarImageView setRating:0];
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
