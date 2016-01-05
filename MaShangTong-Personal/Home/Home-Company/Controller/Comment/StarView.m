//
//  StarView.m
//  LimitFree_1513
//
//  Created by gaokunpeng on 15/9/14.
//  Copyright (c) 2015年 gaokunpeng. All rights reserved.
//

#import "StarView.h"
#import "MyUtil.h"

@implementation StarView
{
    //前景图片
    UIImageView *_fgImageView;
    
    CGFloat width;
    CGFloat height;
}

//代码初始化时调用
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        width = frame.size.width;
        height = frame.size.height;
        [self createImageView];
    }
    return self;
}

//xib初始化
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self createImageView];
    }
    return self;
}

//创建图片视图
- (void)createImageView
{
    self.backgroundColor = [UIColor blackColor];
    
    width = self.width;
    height = self.height;
    //背景图片
    UIImageView *bgImageView = [MyUtil createImageViewFrame:CGRectMake(0, 0, width, height) imageName:@"StarsBackground"];
    [self addSubview:bgImageView];
    
    //前景图片
    _fgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"StarsForeground"]];
    _fgImageView.size = CGSizeMake(width, height);
    //设置停靠模式
    NSLog(@"%@",NSStringFromCGRect(_fgImageView.frame));
    _fgImageView.contentMode = UIViewContentModeLeft;
    _fgImageView.clipsToBounds = YES;
    [self addSubview:_fgImageView];
    [_fgImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgImageView);
        make.top.equalTo(bgImageView);
        make.size.mas_equalTo(CGSizeMake(width, height));
    }];
    NSLog(@"%@",NSStringFromCGRect(_fgImageView.frame));
}

-(void)setRating:(float)rating
{
    _fgImageView.frame = CGRectMake(0, 0, width*rating/5.0f, height);
    _fgImageView.size = CGSizeMake(width*rating/5.0f, height);
    NSLog(@"%@",NSStringFromCGRect(_fgImageView.frame));
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
