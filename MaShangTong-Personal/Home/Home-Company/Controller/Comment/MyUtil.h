//
//  MyUtil.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MyUtil : NSObject

//创建标签的方法
+ (UILabel *)createLabelFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment numberOfLines:(NSInteger)numberOfLines;

+ (UILabel *)createLabelFrame:(CGRect)frame text:(NSString *)text color:(UIColor *)textColor;

//创建按钮的方法
+ (UIButton *)createBtnFrame:(CGRect)frame title:(NSString *)title bgImageName:(NSString *)bgImageName target:(id)target action:(SEL)action;

//创建图片视图的方法
+ (UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName;

@end
