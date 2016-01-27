//
//  GSshopViewController.h
//  MaShangTong-Personal
//
//  Created by q on 16/1/5.
//  Copyright © 2016年 jeaner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSshopViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

@property (weak, nonatomic) IBOutlet UITextView *textView;


@property (nonatomic,copy) NSString *merchantName;
@property (nonatomic,copy) NSString *goodsName;
@property (nonatomic,copy) NSString *route_id;

@property (nonatomic,copy) NSString *shc_id;
@property (nonatomic,copy) NSString *cb_id;
@property (nonatomic,copy) NSString *company_id;

- (IBAction)goShopping:(id)sender;

@end
