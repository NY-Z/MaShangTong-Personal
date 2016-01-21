//
//  GSauthenticationVC.h
//  MaShangTong
//
//  Created by q on 15/12/24.
//  Copyright © 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSauthenticationVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *numTextFiled;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (nonatomic,strong) void(^makeAuthentication)(BOOL isSucceed);

- (IBAction)send:(id)sender;

@end
