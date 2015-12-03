//
//  NYStepper.m
//  MaShangTong
//
//  Created by niliu1h  on 15/10/23.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import "NYStepper.h"

@interface NYStepper ()
{
    NSInteger _count;
    UILabel *_midLabel;
}
@end

@implementation NYStepper

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.size = CGSizeMake(61, 18);
        self.layer.borderColor = RGBColor(200, 200, 200, 1.f).CGColor;
        self.layer.borderWidth = 1.f;
        self.layer.cornerRadius = 1.f;
        
        CGFloat width = self.width/3;
        CGFloat height = self.height;
        
        UIView *leftBarrierView = [[UIView alloc] initWithFrame:CGRectMake(width, 0, 0.5, height)];
        leftBarrierView.backgroundColor = RGBColor(200, 200, 200, 1.f);
        [self addSubview:leftBarrierView];
        UIView *rightBarrierView = [[UIView alloc] initWithFrame:CGRectMake(width*2, 0, 0.5, height)];
        rightBarrierView.backgroundColor = RGBColor(200, 200, 200, 1.f);
        [self addSubview:rightBarrierView];
        
        UIButton *subtractBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        subtractBtn.frame = CGRectMake(0, 0, width, height);
        [subtractBtn setTitle:@"-" forState:UIControlStateNormal];
        [subtractBtn setTitleColor:RGBColor(200, 200, 200, 1.f) forState:UIControlStateNormal];
        [subtractBtn addTarget:self action:@selector(subtractBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:subtractBtn];
        
        UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        plusBtn.frame = CGRectMake(width*2, 0, width, height);
        [plusBtn setTitle:@"+" forState:UIControlStateNormal];
        [plusBtn setTitleColor:RGBColor(200, 200, 200, 1.f) forState:UIControlStateNormal];
        [plusBtn addTarget:self action:@selector(plusBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plusBtn];
        
        _count = 20;
        _midLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width/3, 0, self.width/3, self.height)];
        _midLabel.text = @"20";
        _midLabel.textAlignment = NSTextAlignmentCenter;
        _midLabel.textColor = RGBColor(200, 200, 200, 1.f);
        _midLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_midLabel];
    }
    return self;
}

- (void)subtractBtnClicked:(UIButton *)btn
{
    if (!_count) {
        return;
    }
    _count--;
    _midLabel.text = [NSString stringWithFormat:@"%li",(long)_count];
}

- (void)plusBtnClicked:(UIButton *)btn
{
    _count++;
    _midLabel.text = [NSString stringWithFormat:@"%li",(long)_count];
    
}

@end
