//
//  MyMoney.m
//  MaShangTong
//
//  Created by q on 15/12/10.
//  Copyright © 2015年 NY. All rights reserved.
//

#import "MyMoney.h"

@implementation MyMoney


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {
        self.layer.borderColor = RGBColor(242, 242, 242, 1.f).CGColor;
        self.layer.borderWidth = 1.f;
        
        self.backgroundColor = [UIColor whiteColor];
        
        
        [self creatSubViews];
    }
    return self;
}

-(void)creatSubViews
{
    
    
    //创建我的余额的现实label，设置其显示格式
    _MyDalanceLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width-300)/2, (self.frame.size.height/5), 300, 40)];
    _MyDalanceLabel.textAlignment = 1;
    
    [self addSubview:_MyDalanceLabel];
    
    //创建“充值”btn
    UIButton *rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rechargeBtn.size = CGSizeMake( 85, 85);
    rechargeBtn.center = CGPointMake( self.center.x,  self.center.y*0.7);
    rechargeBtn.backgroundColor = RGBColor(99 , 193, 255, 1.f);
    [rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
    [rechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rechargeBtn.layer.cornerRadius = 42.5;
    [rechargeBtn addTarget:self action:@selector(recharge:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:rechargeBtn];
    
    
}
-(void)recharge:(UIButton *)sender
{
    if (self.recharge) {
        self.recharge();
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
