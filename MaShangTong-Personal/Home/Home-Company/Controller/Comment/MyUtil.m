//
//  MyUtil.m
//

#import "MyUtil.h"

@implementation MyUtil

+(UILabel *)createLabelFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment numberOfLines:(NSInteger)numberOfLines
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textAlignment = textAlignment;
    label.textColor = textColor;
    label.numberOfLines = numberOfLines;
    
    return label;
}

+(UILabel *)createLabelFrame:(CGRect)frame text:(NSString *)text color:(UIColor *)textColor
{
    return [self createLabelFrame:frame text:text textColor:textColor textAlignment:NSTextAlignmentCenter numberOfLines:1];
}

+(UIButton *)createBtnFrame:(CGRect)frame title:(NSString *)title bgImageName:(NSString *)bgImageName target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+(UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:imageName];
    return imageView;
}

@end
