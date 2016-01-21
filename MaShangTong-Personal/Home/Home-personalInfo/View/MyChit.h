//
//  MyChit.h
//  MaShangTong
//
//  Created by q on 15/12/10.
//  Copyright © 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyChit : UIView<UITableViewDataSource,UITableViewDelegate>


//展示券的表示图
@property (nonatomic,retain) UITableView *vouchersTabelV;

//存储数据的Array
@property (nonatomic,retain) NSArray *vouchersDataAry;


@end
