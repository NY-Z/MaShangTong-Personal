//
//  StarView.h
//

#import <UIKit/UIKit.h>

@interface StarView : UIView

//设置星级
- (void)setRating:(float)rating;
@property (nonatomic,assign) float rate;

@end
