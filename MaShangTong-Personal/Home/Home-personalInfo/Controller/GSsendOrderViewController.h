//
//  GSsendOrderViewController.h
//  MaShangTong-Personal
//
//  Created by q on 16/1/5.
//  Copyright © 2016年 jeaner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSsendOrderViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *perPriceLabel;

@property (weak, nonatomic) IBOutlet UIButton *minusBtn;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UILabel *total;

@property (weak, nonatomic) IBOutlet UIButton *sendOrder;


@property (nonatomic,copy) NSString *goodsName;
@property (nonatomic,copy) NSString *cb_id;
@property (nonatomic,copy) NSString *company_id;
@property (nonatomic,copy) NSString *ticket_id;

@property (nonatomic,copy) NSString *perPriceStr;


- (IBAction)minusAction:(id)sender;

- (IBAction)addAction:(id)sender;

- (IBAction)sendOrder:(id)sender;


@end
