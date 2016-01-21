//
//  pickerV.h
//  MaShangTong
//
//  Created by q on 15/12/18.
//  Copyright © 2015年 NY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pickerV : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray *dayAry;
    NSMutableArray *hourAry;
    NSMutableArray *tenMinAry;
    
}

@property (nonatomic,strong) NSString *reservation_type;
@property (nonatomic,strong) NSString *reservation_time;

@property (nonatomic,strong) void(^sendTime)(NSString *reservation_time,NSString *reservation_type,NSString *dateStr);


@end
