//
//  searchViewC.h
//  MaShangTong
//
//  Created by q on 15/12/10.
//  Copyright © 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AMapGeoPoint;


@interface searchViewC : UIViewController<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIButton *backBtn;

@property (nonatomic,retain) UISearchBar *searchBar;

@property (nonatomic,retain) UITableView *tableView;

//查询到的数据的array
@property (nonatomic,copy) NSArray *searchDataArray;

//block回调，将终点输入的内容传给地理编码
@property (nonatomic,strong) void(^searchBarTextChanged)(NSString *searchTextStr);

@property (nonatomic,strong) void(^selectedCell)(NSInteger num,AMapGeoPoint *tip);

@end
