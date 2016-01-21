//
//  MyOrderVC.h
//  MaShangTong
//
//  Created by q on 15/12/14.
//  Copyright © 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    All,//全部
    NotPayMent,//未付款
    NotConsumption,//未消费
    HadFinish//已完成
}OrderStatus;


@interface MyOrderVC : UIViewController<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) NSArray *dataAry;

@property (nonatomic,retain) UITableView *tableView;

@property (nonatomic,strong) UIView *blueView;

@property (nonatomic,assign) OrderStatus orderStatus;

@end
