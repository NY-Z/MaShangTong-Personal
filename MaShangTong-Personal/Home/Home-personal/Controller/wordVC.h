//
//  wordVC.h
//  MaShangTong
//
//  Created by q on 15/12/16.
//  Copyright © 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface wordVC : UIViewController<UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UITextView *textV;


@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (nonatomic,strong) void(^sendWords)(NSString *wordsStr);

- (IBAction)makeSure:(id)sender;

@end
