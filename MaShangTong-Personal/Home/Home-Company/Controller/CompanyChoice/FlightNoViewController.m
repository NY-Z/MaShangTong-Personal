//
//  FlightNoViewController.m
//  MaShangTong
//
//  Created by niliu1h  on 15/10/21.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import "FlightNoViewController.h"
#import "Masonry.h"

@interface FlightNoViewController () <UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView *pick;
    NSArray *dateArr;
    NSArray *hourArr;
    NSArray *minArr;
    
    UIView *_coverView;
    UIView *_pickBgView;
    UITextField *flightNoTextField;
    
    NSString *_selectedDate;
}
@end

@implementation FlightNoViewController

- (void)configViews
{
    UIView *barBgView = [[UIView alloc] init];
    barBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:barBgView];
    [barBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:RGBColor(98, 190, 255, 1.f) forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [barBgView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(barBgView).offset(15);
        make.top.equalTo(barBgView).offset(16);
        make.bottom.equalTo(barBgView).offset(-16);
        make.width.mas_equalTo(33);
    }];
    
    UILabel *flightNoLabel = [[UILabel alloc] init];
    flightNoLabel.text = @"航班号";
    flightNoLabel.textColor = [UIColor blackColor];
    [barBgView addSubview:flightNoLabel];
    [flightNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(barBgView);
        make.top.equalTo(barBgView);
        make.bottom.equalTo(barBgView);
        make.width.mas_equalTo(66);
    }];
    
    UIView *barrierView = [[UIView alloc] init];
    barrierView.backgroundColor = RGBColor(227, 227, 229, 1.f);
    [barBgView addSubview:barrierView];
    [barrierView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(barBgView);
        make.left.equalTo(barBgView);
        make.right.equalTo(barBgView);
        make.height.mas_equalTo(1);
    }];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.layer.borderColor = RGBColor(227, 227, 229, 1.f).CGColor;
    contentView.layer.borderWidth = 1.f;
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(barrierView.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(-1);
        make.right.equalTo(self.view).offset(1);
        make.height.mas_equalTo(100);
    }];

    UILabel *flightTimeLabel = [[UILabel alloc] init];
    flightTimeLabel.text = @"起飞时间";
    flightTimeLabel.textColor = RGBColor(180, 180, 180, 1.f);
    flightTimeLabel.font = [UIFont systemFontOfSize:13];
    [contentView addSubview:flightTimeLabel];
    [flightTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(15);
        make.top.equalTo(contentView).offset(5);
        make.size.mas_equalTo(CGSizeMake(120,20));
    }];
    
    UILabel *correctLabel = [[UILabel alloc] init];
    correctLabel.text = @"以当地起飞时间为准";
    correctLabel.textColor = RGBColor(180, 180, 180, 1.f);
    correctLabel.font = [UIFont systemFontOfSize:11];
    [contentView addSubview:correctLabel];
    [correctLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(flightTimeLabel);
        make.top.equalTo(flightTimeLabel.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(120, 20));
    }];
    
    _timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_timeBtn setTitle:@"10月21日 周三" forState:UIControlStateNormal];
    [_timeBtn setTitleColor:RGBColor(98, 190, 255, 1.f) forState:UIControlStateNormal];
    [_timeBtn addTarget:self action:@selector(timeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_timeBtn];
    [_timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(flightTimeLabel.mas_bottom);
        make.left.equalTo(flightTimeLabel.mas_right).offset(10);
        make.right.equalTo(contentView).offset(10);
        make.height.mas_equalTo(30);
    }];
    _timeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    UIImageView *timeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhishijiantou"]];
    [_timeBtn addSubview:timeImageView];
    [timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_timeBtn).offset(-11);
        make.top.equalTo(_timeBtn);
        make.bottom.equalTo(_timeBtn);
        make.width.mas_equalTo(30);
    }];
    
    UIView *fraiseView = [[UIView alloc] init];
    fraiseView.backgroundColor = RGBColor(227, 227, 229, 1.f);
    [contentView addSubview:fraiseView];
    [fraiseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(contentView);
        make.left.equalTo(contentView).offset(15);
        make.right.equalTo(contentView);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *flightNumLabel = [[UILabel alloc] init];
    flightNumLabel.text = @"航班号";
    flightNumLabel.textColor = [UIColor blackColor];
    flightNumLabel.font = [UIFont systemFontOfSize:13];
    [contentView addSubview:flightNumLabel];
    [flightNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(fraiseView);
        make.top.equalTo(fraiseView).offset(15);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(70);
    }];
    
    flightNoTextField = [[UITextField alloc] init];
    flightNoTextField.placeholder = @"请输入航班号";
    flightNoTextField.font = [UIFont systemFontOfSize:14];
    flightNoTextField.delegate = self;
    [contentView addSubview:flightNoTextField];
    [flightNoTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(flightNumLabel.mas_right).offset(10);
        make.top.equalTo(fraiseView).offset(10);
        make.bottom.mas_equalTo(-10);
        make.right.equalTo(contentView).offset(-11);
    }];
    
    UIButton *putBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [putBtn setTitle:@"提交" forState:UIControlStateNormal];
    [putBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    putBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [putBtn setBackgroundColor:RGBColor(98, 190, 255, 1.f)];
    putBtn.layer.cornerRadius = 5.f;
    [putBtn addTarget:self action:@selector(putBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:putBtn];
    [putBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(38);
    }];
}

- (void)configPicker
{
    _pickBgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 260)];
    _pickBgView.backgroundColor = [UIColor whiteColor];
    _pickBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _pickBgView.layer.borderWidth = 1.f;
    [self.view addSubview:_pickBgView];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [leftBtn setTitleColor:RGBColor(98, 190, 255, 1.f) forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(pickerLeftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_pickBgView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_pickBgView).offset(26);
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.top.equalTo(_pickBgView).offset(0);
    }];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitleColor:RGBColor(98, 190, 255, 1.f) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(pickerRightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_pickBgView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_pickBgView).offset(-26);
        make.size.mas_equalTo(CGSizeMake(44, 38));
        make.top.equalTo(_pickBgView);
    }];
    
    pick = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 216)];
    pick.backgroundColor = [UIColor whiteColor];
    pick.showsSelectionIndicator = YES;
    pick.dataSource = self;
    pick.delegate = self;
    [_pickBgView addSubview:pick];
    
    dateArr = [self latelyEightTime];

}

//获取最近八天时间 数组
- (NSMutableArray *)latelyEightTime{
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
- (NSString *)cTransformFromE:(NSString *)theWeek{
    NSString *chinaStr;
    if(theWeek){
        if([theWeek isEqualToString:@"Monday"] || [theWeek isEqualToString:@"星期一"]){
            chinaStr = @"一";
        }else if([theWeek isEqualToString:@"Tuesday"] || [theWeek isEqualToString:@"星期二"]){
            chinaStr = @"二";
        }else if([theWeek isEqualToString:@"Wednesday"] || [theWeek isEqualToString:@"星期三"]){
            chinaStr = @"三";
        }else if([theWeek isEqualToString:@"Thursday"] || [theWeek isEqualToString:@"星期四"]){
            chinaStr = @"四";
        }else if([theWeek isEqualToString:@"Friday"] || [theWeek isEqualToString:@"星期五"]){
            chinaStr = @"五";
        }else if([theWeek isEqualToString:@"Saturday"] || [theWeek isEqualToString:@"星期六"]){
            chinaStr = @"六";
        }else if([theWeek isEqualToString:@"Sunday"] || [theWeek isEqualToString:@"星期日"]){
            chinaStr = @"七";
        }
    }
    return chinaStr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configViews];
    _coverView = [[UIView alloc] initWithFrame:self.view.bounds];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha = 0.3;
    [self.view addSubview:_coverView];
    _coverView.hidden = YES;
    _coverView.userInteractionEnabled = YES;
    UITapGestureRecognizer *coverViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverViewTap:)];
    [_coverView addGestureRecognizer:coverViewTap];
    [self configPicker];
}

#pragma mark - UIPickViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return dateArr.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    NYLog(@"%@",dateArr[row]);
    _selectedDate = dateArr[row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    
    label.text = dateArr[row];
    
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    
    return label;
}

#pragma mark - Gesture
- (void)coverViewTap:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.3 animations:^{
        _pickBgView.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        _coverView.hidden = !_coverView.hidden;
    }];
}


#pragma mark - Action
- (void)cancelBtnClicked:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)pickerLeftBtnClicked:(UIButton *)btn
{
    [UIView animateWithDuration:0.3 animations:^{
        _pickBgView.y = SCREEN_HEIGHT;
        
    } completion:^(BOOL finished) {
        _coverView.hidden = !_coverView.hidden;
    }];
}

- (void)pickerRightBtnClicked:(UIButton *)btn
{
    [UIView animateWithDuration:0.3 animations:^{
        
        _pickBgView.y = SCREEN_HEIGHT;
        [_timeBtn setTitle:_selectedDate forState:UIControlStateNormal];
        
    } completion:^(BOOL finished) {
        
        _coverView.hidden = !_coverView.hidden;
        
    }];
}

- (void)timeBtnClicked:(UIButton *)btn
{
    _coverView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _pickBgView.y = SCREEN_HEIGHT-216;

    }];
}

- (void)putBtnClicked:(UIButton *)btn
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AirportPickupViewControllerFlightNo" object:flightNoTextField.text];
    NYLog(@"%@",flightNoTextField.text);
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
