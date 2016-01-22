//
//  searchViewC.m
//  MaShangTong
//
//  Created by q on 15/12/10.
//  Copyright © 2015年 NY. All rights reserved.
//

#import "searchViewC.h"

#import "HomeViewController.h"
#import "searchTableViewCell.h"


@interface searchViewC ()

@end

@implementation searchViewC



-(void)viewWillAppear:(BOOL)animated{
    _searchBar.text = nil;
    _searchDataArray = nil;
    [_tableView reloadData];
    [_searchBar becomeFirstResponder];
}
-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _searchDataArray = [NSArray new];
    
    [self creatSubView];
    
    
}
//添加子视图
-(void)creatSubView
{
    [self creatBackBtn];
    
    [self creatSearchBar];
    
    [self creatTableViewWithFram:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    
    
}
#pragma mark - 创建返回按钮
-(void)creatBackBtn
{
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [_backBtn setFrame:CGRectMake(0, 0, 44, 44)];
    [_backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
}
//返回按钮的点击事件
-(void)back:(UIButton *)sender
{
    [_searchBar resignFirstResponder];
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 创建searchBar
-(void)creatSearchBar
{
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    _searchBar.delegate = self;
    
    self.navigationItem.titleView = _searchBar;
}
#pragma mark - UISearchBardelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (self.searchBarTextChanged && searchText) {
        self.searchBarTextChanged(searchText);
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (self.searchBarTextChanged && searchBar) {
        self.searchBarTextChanged(searchBar.text);
    }
    [_searchBar resignFirstResponder];
}
#pragma mark - 创建tableView
-(void)creatTableViewWithFram:(CGRect)fram
{
    
    _tableView = [[UITableView alloc]initWithFrame:fram style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
}
#pragma mark - UITabelViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchDataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identidfierStr = @"searchTableViewCell";
    
    searchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identidfierStr];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"searchTableViewCell" owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic = _searchDataArray[indexPath.row];
    cell.nameLabel.text = [dic valueForKey:@"name"];
    cell.districtLabel.text = [dic valueForKey:@"district"];
    
    //    NSString *str = [NSString stringWithFormat:@"%@   %@",[dic valueForKey:@"location"].latitude,[dic valueForKey:@"location"].longitude];
    //    cell.locationLabel.text = str;
    
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NYLog(@"%@",[_searchDataArray[indexPath.row] valueForKey:@"location"]);
    
    if (self.selectedCell) {
        self.selectedCell(indexPath.row,[_searchDataArray[indexPath.row] valueForKey:@"location"]);
    };
    
    [_searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)dealloc
{
    NYLog(@"销毁");
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
