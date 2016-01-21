//
//  GSPersonInfoModel.h
//  MaShangTong
//
//  Created by q on 15/12/20.
//  Copyright © 2015年 NY. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GSPersonInfoModel : NSObject

@property (nonatomic,copy) NSString *mobile;

@property (nonatomic,strong) NSData *portraitImage;
@property (nonatomic,copy) NSString *nicknameStr;
@property (nonatomic,copy) NSString *sexStr;
@property (nonatomic,copy) NSString *ageStr;
@property (nonatomic,copy) NSString *cityStr;

@property (nonatomic,strong) NSData *headImageData;

@property (nonatomic,strong) NSString *certification;



+(NSArray *)getArrayWithGSPersonInfoModel:(GSPersonInfoModel *)personInfo;
//在沙盒document内创建文件夹
+(void)creatcreateDirectoryAtPathInDocumentWithDirectorName:(NSString *)directorName;
//在沙盒document内的文件内创建文件
+(void)creatFileInaDirectorWithDirectorName:(NSString *)directorName andFileName:(NSString *)fileName;
//在沙盒document内的文件夹内的文件内修改文件
+(NSArray *)updateDateWithDirectorName:(NSString *)directorName andFileName:(NSString *)fileName andSelectedCell:(NSInteger)row andContent:(id)content;
@end
