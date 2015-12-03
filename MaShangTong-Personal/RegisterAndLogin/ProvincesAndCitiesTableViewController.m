//
//  ProvincesAndCitiesTableViewController.m
//  MaShangTong-Personal
//
//  Created by NY on 15/11/23.
//  Copyright © 2015年 jeaner. All rights reserved.
//

#import "ProvincesAndCitiesTableViewController.h"

@interface ProvincesAndCitiesTableViewController ()

@property (nonatomic,strong) NSMutableDictionary *addressDic;

@end

@implementation ProvincesAndCitiesTableViewController

- (void)configNavigationBar
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.size = CGSizeMake(44, 44);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigationBar];
    [self initAddressArr];
}

- (void)initAddressArr
{
    _addressDic = [NSMutableDictionary dictionary];
    NSString *pathStr = [[NSBundle mainBundle]pathForResource:@"ProvincesAndCities" ofType:@"plist"];
    NSArray *plistArray = [NSArray arrayWithContentsOfFile:pathStr];
    for (NSDictionary *subDict in plistArray) {
        NSString *provinceStr = subDict[@"State"];
        NSMutableArray  *cityArr = [NSMutableArray array];
        for (NSDictionary *cityDict in subDict[@"Cities"]) {
            [cityArr addObject:cityDict[@"city"]];
        }
        [_addressDic setValue:cityArr forKey:provinceStr];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_type == ProvinceTypeProvince) {
        return [_addressDic allKeys].count;
    }
    NSArray *cityArr = _addressDic[_province];
    return cityArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ProvinceAndCityId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (_type == ProvinceTypeProvince) {
        cell.textLabel.text = [_addressDic allKeys][indexPath.row];
    } else if (_type == ProvinceTypeCity && _province) {
        cell.textLabel.text = _addressDic[_province][indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == ProvinceTypeProvince) {

        if (self.transProvince) {
            self.transProvince(_addressDic.allKeys[indexPath.row]);
        }
        
    } else if (_type == ProvinceTypeCity && _province) {
        
        if (self.transCity) {
            self.transCity(_addressDic[_province][indexPath.row]);
        }
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Action
- (void)leftBarButtonItemClicked:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
