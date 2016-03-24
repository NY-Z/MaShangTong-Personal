//
//  pickerV.m
//  MaShangTong
//
//  Created by q on 15/12/18.
//  Copyright © 2015年 NY. All rights reserved.
//

#import "pickerV.h"

@implementation pickerV
{
    NSInteger minNumber;
}

static NSInteger nowDayNum;
static NSInteger nowHourNum;
static NSInteger nowTenminNum;

static NSInteger betweenTime;

static NSInteger dayNum = 0;
static NSInteger hourNum = 0;
static NSInteger tenMinNum = 0;

static NSInteger betweenTime;
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self dealDataAry];
        [self creatTwoBtn];
        [self creatPickerViewWithFram:CGRectMake(0, 20, frame.size.width, frame.size.height-20)];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
#pragma mark - 处理pickerView的展示数据
-(void)dealDataAry
{
    [self creatDayAry];
    hourAry = [NSMutableArray new];
    tenMinAry = [NSMutableArray new];
    hourAry = [NSMutableArray arrayWithObjects:@" ", nil];
    tenMinAry = [NSMutableArray arrayWithObjects:@" ", nil];
}
-(void)creatDayAry
{
    dayAry = [NSMutableArray arrayWithObjects:@"现在用车",@"今天", nil];
    for (int i = 1; i<3; i++) {
        NSDate *date = [[NSDate alloc]initWithTimeIntervalSinceNow:i*86400];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MM月dd日 EEE"];
        NSString *str = [formatter stringFromDate:date];
        [dayAry addObject:str];
    }
}
#pragma mark - 创建pickerView
-(void)creatPickerViewWithFram:(CGRect)fram
{
    for (int i=0; i<3; i++) {
        
        UIPickerView *pickerV = [[UIPickerView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4*(i+1), 40, SCREEN_WIDTH/4, 180)];
        if (i==0) {
            pickerV.frame = CGRectMake(0, 40, SCREEN_WIDTH/2+20, 180);
        }
        pickerV.tag = 160+i;
        pickerV.showsSelectionIndicator = NO;
        pickerV.delegate = self;
        pickerV.dataSource = self;
        
        [self addSubview:pickerV];
    }

}
#pragma mark - 添加取消和确定的Btn
-(void)creatTwoBtn
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 60, 40);
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftBtn setTitleColor:RGBColor(98, 190, 255, 1.f) forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(pickerLeftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftBtn];
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(SCREEN_WIDTH - 60, 0, 60, 40);
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitleColor:RGBColor(98, 190, 255, 1.f) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(pickerRightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightBtn];

}
#pragma mark - btn的点击事件
-(void)pickerLeftBtnClicked:(UIButton *)sender
{
    [self removeFromSuperview];
}
-(void)pickerRightBtnClicked:(UIButton *)sender
{
    NSLog(@"%ld",minNumber);
    betweenTime = betweenTime + dayNum + hourNum + tenMinNum - minNumber*60;
    
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSinceNow:betweenTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM月dd日HH:mm"];
    NSString *dateStr = [formatter stringFromDate:date];
    
    
    //如果datePicker上的时间小于一个小时，则认为预约类型为立即
    if (betweenTime < 3600) {
        _reservation_type = [NSString stringWithFormat:@"%d",1];
        _reservation_time = [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];
    }
    //如果小于三天大于一小时，则认为预约类型为另定时间
    if (betweenTime >= 3600 && betweenTime <= 259200) {
        _reservation_type = [NSString stringWithFormat:@"%d",2];
        _reservation_time = [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];
    }
    //如果大于三天，则提示重新选择
    if (betweenTime > 259200) {
        NYLog(@"超出三天");
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入小于三天的时间。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        return;
    }
    NYLog(@"%@",_reservation_time);
    if (self.sendTime) {
        self.sendTime(_reservation_time,_reservation_type,dateStr);
    }
    
    betweenTime = 0;
    [self removeFromSuperview];
}

#pragma mark - UIPickerViewDelegate UIPickerDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 160) {
        return 4;
    }
    else if (pickerView.tag == 161) {
        return hourAry.count;
    }
    else{
        return tenMinAry.count;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (pickerView.tag) {
        case 160:
            return dayAry[row];
            break;
        case 161:
            return hourAry[row];
            break;
        case 162:
            return tenMinAry[row];
            break;
            
        default:
            break;
    }
    return nil;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    [self getHourNumAndTenMinNum];
    if (pickerView.tag == 160) {
        if (row == 0) {
            nowDayNum = 0;
            hourAry = [NSMutableArray arrayWithObjects:@" ", nil];
            tenMinAry = [NSMutableArray arrayWithObjects:@" ", nil];
            hourNum = 0;
            tenMinNum = 0;
        }
        else if (row == 1) {
            nowDayNum = 1;
            [self rewriteHourAry];
            [self rewriteTenMinAry];
            hourNum = 0;
            tenMinNum = 0;
        }
        else{
            [self rewriteHourArray];
            [self rewriteTenMinArray];
            hourNum = (0 - nowHourNum)*3600;
            tenMinNum = (0 - nowTenminNum)*600;
        }
        for (int i =1 ; i<3; i++) {
            UIPickerView *getPickerV = (UIPickerView *)[self viewWithTag:160+i];
            [getPickerV reloadAllComponents];
            [getPickerV selectRow:0 inComponent:0 animated:YES];
        }
        
        [self getPickerDateLaterNowTimeWith:pickerView.tag and:row];
        
    }
    else if (pickerView.tag == 161) {
        if (row == 0 && nowDayNum <= 1 ) {
            tenMinNum = 0;
        }
        else if (row == 1) {
            [self rewriteTenMinArray];
            tenMinNum = (0 - nowTenminNum)*600;
        }
        else{
            [self rewriteTenMinArray];
            tenMinNum = (0 - nowTenminNum)*600;
        }
        UIPickerView *getPickerV = (UIPickerView *)[self viewWithTag:162];
        [getPickerV reloadAllComponents];
        
        [self getPickerDateLaterNowTimeWith:pickerView.tag and:row];
    }
    else{
        [self getPickerDateLaterNowTimeWith:pickerView.tag and:row];
    }
    
    
    
    
}
-(void)getHourNumAndTenMinNum
{
    NSDate *date = [NSDate date];
    
    NSDateFormatter *fomatter = [[NSDateFormatter alloc]init];
    
    [fomatter setDateFormat:@"HHmm"];
    
    NSString *str = [fomatter stringFromDate:date];
    
    NSInteger num = [str longLongValue];
    
    nowHourNum = num/100;
    
    nowTenminNum = num%100/10+1;
    if (nowTenminNum == 6) {
        nowTenminNum = 0;
    }
    
    
    minNumber = num%100 - (nowTenminNum*10);
    
    
}
-(void)rewriteHourAry
{
    NSMutableArray *ary = [NSMutableArray new];
    for (int i=0; i<24-nowHourNum; i++) {
        [ary addObject:[NSString stringWithFormat:@"%2ld",nowHourNum+i]];
    }
    hourAry = [NSMutableArray arrayWithArray:ary];
}
-(void)rewriteHourArray
{
    NSMutableArray *ary = [NSMutableArray new];
    for (int i=0; i<24; i++) {
        [ary addObject:[NSString stringWithFormat:@"%2d",i]];
    }
    hourAry = [NSMutableArray arrayWithArray:ary];
}
-(void)rewriteTenMinAry
{
    NSMutableArray *ary = [NSMutableArray new];
    for (int i=0; i<6-nowTenminNum; i++) {
        [ary addObject:[NSString stringWithFormat:@"%2ld",(nowTenminNum+i)*10]];
    }
    tenMinAry = [NSMutableArray arrayWithArray:ary];
}
-(void)rewriteTenMinArray
{
    NSMutableArray *ary = [NSMutableArray new];
    for (int i=0; i<6; i++) {
        [ary addObject:[NSString stringWithFormat:@"%2d",i*10]];
    }
    tenMinAry = [NSMutableArray arrayWithArray:ary];
}
#pragma mark - 获取选择时间跟当前时间的的差值
-(void)getPickerDateLaterNowTimeWith:(NSInteger)tag and:(NSInteger)row
{
    if (tag == 160 ) {
        
        if (row == 0) {
            dayNum = 0;
        }
        else{
            dayNum = (row-1)*86400;
        }
    }
    else if(tag == 161){
        
        NSString *str = [hourAry objectAtIndex:row];
        NSInteger a = [str integerValue];
        hourNum = (a - nowHourNum)*3600;
    }
    else if(tag == 162){
        
        NSString *str = [tenMinAry objectAtIndex:row];
        NSInteger a = [str integerValue];
        tenMinNum = (a/10 - nowTenminNum)*600;
    }
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
