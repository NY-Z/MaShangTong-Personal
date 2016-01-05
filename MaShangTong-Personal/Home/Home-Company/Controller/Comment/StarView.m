//
//  StarView.m
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
//    _fgImageView = [MyUtil createImageViewFrame:CGRectMake(0, 0, width, height) imageName:@"StarsForeground"];
    _fgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    _fgImageView.image = [self imageToImage];
    //设置停靠模式
    _fgImageView.contentMode = UIViewContentModeLeft;
    _fgImageView.clipsToBounds = YES;
    [self addSubview:_fgImageView];
}

-(void)setRating:(float)rating
{
//    _fgImageView.frame = CGRectMake(0, 0, width*rating/5.0f, height);
//    _fgImageView.size = CGSizeMake(width*rating/5.0f, height);

    NSLog(@"%@",NSStringFromCGRect(_fgImageView.frame));
    NSLog(@"%@",NSStringFromCGSize(_fgImageView.image.size));
}

- (UIImage *)imageToImage
{
    UIImage *image = [UIImage imageNamed:@"StarsForeground"];
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [image drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
