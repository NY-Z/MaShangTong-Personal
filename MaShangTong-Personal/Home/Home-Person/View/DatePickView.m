//
//  Date_pickView.m
//  MaShangTong
//
//  Created by niliu1h  on 15/10/20.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import "DatePickView.h"
#import "Masonry.h"

@interface DatePickView () <UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSArray *dateArr;
    NSArray *hourArr;
    NSArray *minArr;
}
@property (nonatomic,strong) UIPickerView *pick;

@end

@implementation DatePickView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self init_pickView];
    }
    return self;
}

- (void)init_pickView
{
    dateArr = @[@"现在用车",@"今天",[self latelyEightTime][1],[self latelyEightTime][2]];
    hourArr = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
    minArr = @[@"0",@"10",@"20",@"30",@"40",@"50"];
    
//    NSDate *senddate =[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"HH mm"];
    
//    NSString *locationString = [dateformatter stringFromDate:senddate];
    
//    NYLog(@"locationString:%@",locationString);
    
    _pick = [[UIPickerView alloc] initWithFrame:CGRectMake(-1, SCREEN_HEIGHT, SCREEN_WIDTH+2, 216)];
    _pick.backgroundColor = [UIColor whiteColor];
    _pick.showsSelectionIndicator = YES;
    _pick.dataSource = self;
    _pick.delegate = self;
    [self addSubview:_pick];
    
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.borderWidth = 1.f;
    [_pick addSubview:view];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftBtn setTitleColor:RGBColor(98, 190, 255, 1.f) forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(pickerLeftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(26);
        make.size.mas_equalTo(CGSizeMake(44, 38));
        make.top.equalTo(view);
    }];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitleColor:RGBColor(98, 190, 255, 1.f) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(pickerRightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-26);
        make.size.mas_equalTo(CGSizeMake(44, 38));
        make.top.equalTo(view);
    }];
}

#pragma mark - UIPickViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return dateArr.count;
    } else if (component == 1) {
        return hourArr.count;
    } else {
        return minArr.count;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //    if (component == 0) {
    //        NYLog(@"%@",dateArr[row]);
    //    } else if (component == 1) {
    //        NYLog(@"%@",hourArr[row]);
    //    } else {
    //        NYLog(@"%@",minArr[row]);
    //    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, 30)];
    
    if (component == 0) {
        label.text = dateArr[row];
        
    } else if (component == 1) {
        label.text = hourArr[row];
    } else {
        label.text = minArr[row];
    }
    
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    
    return label;
}

//获取最近八天时间 数组
-(NSMutableArray *)latelyEightTime{
    NSMutableArray *eightArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < 3; i ++) {
        //从现在开始的24小时
        NSTimeInterval secondsPerDay = i * 24*60*60;
        NSDate *curDate = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"M月d日"];
        NSString *dateStr = [dateFormatter stringFromDate:curDate];
        //几月几号
        NSDateFormatter *weekFormatter = [[NSDateFormatter alloc] init];
        [weekFormatter setDateFormat:@"EEEE"];
        //星期几 @"HH:mm 'on' EEEE MMMM d"];
        NSString *weekStr = [weekFormatter stringFromDate:curDate];
        //转换英文为中文
        NSString *chinaStr = [self cTransformFromE:weekStr];
        //组合时间
        NSString *strTime = [NSString stringWithFormat:@"%@ 周%@",dateStr,chinaStr];
        [eightArr addObject:strTime];
    }
    return eightArr;
}

//转换英文为中文
-(NSString *)cTransformFromE:(NSString *)theWeek{
    NSString *chinaStr;
    if(theWeek){
        if([theWeek isEqualToString:@"Monday"]){
            chinaStr = @"一";
        }else if([theWeek isEqualToString:@"Tuesday"]){
            chinaStr = @"二";
        }else if([theWeek isEqualToString:@"Wednesday"]){
            chinaStr = @"三";
        }else if([theWeek isEqualToString:@"Thursday"]){
            chinaStr = @"四";
        }else if([theWeek isEqualToString:@"Friday"]){
            chinaStr = @"五";
        }else if([theWeek isEqualToString:@"Saturday"]){
            chinaStr = @"六";
        }else if([theWeek isEqualToString:@"Sunday"]){
            chinaStr = @"七";
        }
    }
    return chinaStr;
}

- (void)pickerLeftBtnClicked:(UIButton *)btn
{
    
}

- (void)pickerRightBtnClicked:(UIButton *)btn
{
    
}

- (void)dealloc
{
    NYLog(@"%s",__FUNCTION__);
}

@end
