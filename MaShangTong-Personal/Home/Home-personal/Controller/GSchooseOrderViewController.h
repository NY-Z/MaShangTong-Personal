//
//  GSchooseOrderViewController.h
//  MaShangTong-Personal
//
//  Created by q on 16/1/6.
//  Copyright © 2016年 jeaner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSchooseOrderViewController : UIViewController

@property (nonatomic,strong) void(^backTicket)(NSString *ticket_id,NSString *ticket_money);
@property (nonatomic,strong) void(^backNothing)();

@end
