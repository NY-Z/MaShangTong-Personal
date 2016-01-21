//
//  MyStoreCenter.h
//  MaShangTong
//
//  Created by q on 15/12/14.
//  Copyright © 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyStoreCenter : UIViewController

@property (nonatomic,copy) NSArray *array;
@property (weak, nonatomic) IBOutlet UIImageView *backImageV;

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end
