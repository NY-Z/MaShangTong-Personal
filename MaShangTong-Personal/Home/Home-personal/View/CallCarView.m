
//
//  CallCarView.m
//  MaShangTong
//
//  Created by niliu1h  on 15/10/16.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import "CallCarView.h"
//#import "Masonry.h"

@implementation CallCarView

{
    
}

//定义静态变量标记btn(车分类的btn)
static NSInteger  btnNuber;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.layer.borderColor = RGBColor(242, 242, 242, 1.f).CGColor;
        self.layer.borderWidth = 1.f;
        
        self.backgroundColor = [UIColor whiteColor];
        
        
        [self createSubView];
    }
    return self;
}

#pragma mark - 选择车执行的事件
-(void)chooseCar:(UIButton *)sender
{
    UIButton *getBtn = (UIButton *)[self viewWithTag:btnNuber];
    [getBtn setTitleColor:RGBColor(150, 150, 150, 1.f) forState:UIControlStateNormal];
    [getBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"che%ldDeselect",btnNuber-99]] forState:UIControlStateNormal];
    
    [sender setTitleColor:RGBColor(98, 190, 255, 1.f) forState:UIControlStateNormal];
    [sender setImage:[UIImage imageNamed:[NSString stringWithFormat:@"che%ldSelect",sender.tag-99]] forState:UIControlStateNormal];
    
    btnNuber = sender.tag;
    
    [self getPriceString];
    if (self.chooseCarType) {
        self.chooseCarType(btnNuber-99);
    }
    
}

-(void)goTODateV:(UIButton *)sender
{
    if (self.dateTapBlock) {
        self.dateTapBlock();
    }
}
- (void)createSubView
{
    CGFloat width = SCREEN_WIDTH-20;
    
    _goOffBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _goOffBtn.frame = CGRectMake(10, 0, width-20, 24);
    [_goOffBtn setTitle:@"出发时间" forState:UIControlStateNormal];
    [_goOffBtn setTitleColor:RGBColor(173, 173, 173, 1.f) forState:UIControlStateNormal];
    _goOffBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [_goOffBtn addTarget:self action:@selector(goTODateV:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_goOffBtn];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 24, width, 1)];
    view1.backgroundColor = RGBColor(235, 235, 235, 1.f);
    [self addSubview:view1];
    
//        [goOffLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self).with.offset(0);
//            make.centerX.equalTo(self);
//            make.size.mas_equalTo(CGSizeMake(100, 25));
//        }];
    
    NSArray *titleArr = @[@"舒适电动轿车",@"商务电动轿车",@"豪华电动轿车"];
    for (NSInteger i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(width*i/3+5, 25, width/3-10, 25);
        btn.tag = i+100;
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:10];
        [btn setTitleColor:RGBColor(150, 150, 150, 1.f) forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"che%ldDeselect",i+1]] forState:UIControlStateNormal];
        if (i == 0) {
            [btn setTitleColor:RGBColor(98, 190, 255, 1.f) forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"che1Select"] forState:UIControlStateNormal];
            btnNuber = i+100;
        }
        
        //为btn添加点击事件
        [btn addTarget:self action:@selector(chooseCar:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
        
        
        //        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.equalTo(self).with.offset(25);
        //            make.left.equalTo(self).with.offset(width/3);
        //            make.size.mas_equalTo(CGSizeMake(width/3, 25));
        //        }];
    }
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 49, width, 1)];
    view2.backgroundColor = RGBColor(235, 235, 235, 1.f);
    [self addSubview:view2];
    
    NSArray *textFieldText = @[@"请输入起点",@"  请输入终点"];
    for (NSInteger i = 0; i < 2; i++) {
        
        UIScrollView *scrollView = [self creatScrollViewForPlaceWithI:i andWidth:width];
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToSearchVC:)];
        [scrollView addGestureRecognizer:tap];
        UIView *tapView = [tap view];
        tapView.tag = 110+i;
        
        UILabel *textField = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 1.5*width, 25)];
        textField.text = textFieldText[i];
        textField.textColor = RGBColor(173, 173, 173, 1.f);
        textField.font = [UIFont systemFontOfSize:13];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quan"]];
        imageView.frame = CGRectMake(0, 7.5, 10, 10);
        
        [scrollView addSubview:imageView];
        [scrollView addSubview:textField];
        
        if (i == 1) {
            textField.textColor = RGBColor(98, 190, 255, 1.f);
            _endTextFlied = textField;
        }
        else{
            _startTextFled = textField;
        }
        
        UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(10, 25*(i+2)+24, width-20, 1)];
        view2.backgroundColor = RGBColor(235, 235, 235, 1.f);
        [self addSubview:view2];
        
        //        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.left.equalTo(self).with.offset(0);
        //            make.top.equalTo(self).with.offset(25*(i+2));
        //            make.size.mas_equalTo(CGSizeMake(width, 25));
        //        }];
    }
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, width-40, 25)];
    _textField.placeholder = @"请输入备注";
    _textField.textColor = RGBColor(173, 173, 173, 1.f);
    _textField.font = [UIFont systemFontOfSize:12];
    _textField.delegate = self;

    [self addSubview:_textField];
    
    //    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self).with.offset(100);
    //        make.left.equalTo(self).with.offset(20);
    //        make.size.mas_equalTo(CGSizeMake(width-40, 25));
    //    }];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 125, width-20, 50)];
    _priceLabel.userInteractionEnabled = YES;
    _priceLabel.textAlignment = 1;
    
    [self getPriceString];
    [self addSubview:_priceLabel];
    
    UITapGestureRecognizer *priceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(priceTapClick:)];
    [_priceLabel addGestureRecognizer:priceTap];
    //    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self).with.offset(10);
    //        make.top.equalTo(self).with.offset(125);
    //        make.size.mas_equalTo(CGSizeMake(width-20, 50));
    //    }];
    
    UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    callBtn.frame = CGRectMake(width/5, 175, width*3/5, 30);
    [callBtn setTitle:@"呼叫专车" forState:UIControlStateNormal];
    [callBtn setBackgroundColor:RGBColor(54, 171, 237, 1.f)];
    [callBtn addTarget:self action:@selector(callCarAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:callBtn];
    
    callBtn.layer.cornerRadius = 5.f;
    
    //    [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.equalTo(self);
    //        make.top.equalTo(self).with.offset(175);
    //        make.size.mas_equalTo(CGSizeMake(width/2, 25));
    //    }];
    
}
#pragma mark - UITextFiledDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (self.pushWordVC) {
        self.pushWordVC();
    }
}
#pragma mark - 手势的点击事件
-(void)goToSearchVC:(UITapGestureRecognizer *)tap
{
    if (self.pushSearchVC) {
        self.pushSearchVC([tap view].tag-110);
    }
}
#pragma mark - 呼叫专车按钮的点击事件
-(void)callCarAction:(UIButton *)sender
{
    if (self.submitOrders) {
        self.submitOrders();
    }
}

#pragma mark - 获取价钱的字符串
-(void)getPriceString
{
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat: @"约 %d 元",0]];
    [attriStr setAttributes:@{NSForegroundColorAttributeName:RGBColor(54, 171, 237, 1.f),NSFontAttributeName:[UIFont systemFontOfSize:32]} range:NSMakeRange(2, attriStr.length-4)];
    
    _priceLabel.attributedText = attriStr;
    
}

#pragma mark - 创建两个scrollView（将起始点和终点放上去）
-(UIScrollView *)creatScrollViewForPlaceWithI:(NSInteger)i andWidth:(CGFloat)width
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 25*(i+2), width-20, 25)];
    scrollView.contentSize = CGSizeMake(1.5*width, 25);
    scrollView.bounces = NO;
    scrollView.backgroundColor = [UIColor clearColor];
    
    return scrollView;
}

#pragma mark - Gesture
- (void)priceTapClick:(UITapGestureRecognizer *)tap
{
    if (self.priceTapBlock) {
        self.priceTapBlock();
    }
}

@end
