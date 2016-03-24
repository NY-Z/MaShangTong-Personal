//
//  GSPersonInfoModel.m
//  MaShangTong
//
//  Created by q on 15/12/20.
//  Copyright © 2015年 NY. All rights reserved.
//

#import "GSPersonInfoModel.h"

#import "AFNetworking.h"


@implementation GSPersonInfoModel


+(NSArray *)getArrayWithGSPersonInfoModel:(GSPersonInfoModel *)personInfo
{
    if (!personInfo.portraitImage) {
        personInfo.portraitImage = UIImagePNGRepresentation([UIImage imageNamed:@"touxiang"]);
    }
    if (!personInfo.nicknameStr) {
        personInfo.nicknameStr = @" ";
    }
    if (!personInfo.sexStr) {
        personInfo.sexStr = @" ";
    }
    if (!personInfo.ageStr) {
        personInfo.ageStr = @" ";
    }
    if (!personInfo.cityStr) {
        personInfo.cityStr = @" ";
    }
    if (!personInfo.mobile) {
        personInfo.mobile = [USER_DEFAULT objectForKey:@"mobile"];
    }
    
    NSArray *ary = [NSArray arrayWithObjects:personInfo.portraitImage,personInfo.nicknameStr,personInfo.sexStr,personInfo.ageStr,personInfo.cityStr,personInfo.mobile, nil] ;
    return ary;
}
#pragma mark - 在沙盒document内创建文件夹
+(void)creatcreateDirectoryAtPathInDocumentWithDirectorName:(NSString *)directorName
{
    //获取沙盒文件
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *direcutoryPath = [documentPath stringByAppendingString:[NSString stringWithFormat:@"/%@",directorName]];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:direcutoryPath]) {
        [manager createDirectoryAtPath:direcutoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
}
#pragma mark - 在沙盒document内的文件内创建文件
+(void)creatFileInaDirectorWithDirectorName:(NSString *)directorName andFileName:(NSString *)fileName
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingString:[NSString stringWithFormat:@"/%@/%@.plist",directorName,fileName]];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:filePath]) {
        BOOL fileOK = [manager createFileAtPath:filePath contents:nil attributes:nil];
        if(fileOK){
            NSArray *ary = [NSArray arrayWithObjects:UIImagePNGRepresentation([UIImage imageNamed:@"touxiang"]),@" ",@" ",@" ",@" ",@" ",nil];
            [ary writeToFile:filePath atomically:YES];
        }
    }
    NSDictionary *param = [NSDictionary dictionaryWithObject:[USER_DEFAULT objectForKey:@"user_id"] forKey:@"user_id"];
    
    NSString *url = [NSString stringWithFormat:URL_HEADER,@"UserApi",@"user_info"];
    [DownloadManager post:url params:param success:^(id json) {
        @try {
            NYLog(@"%@",json);
            if (json) {
                
                NSString *str = [NSString stringWithFormat:@"%@",json[@"result"]];
                if ([str isEqualToString:@"1"]) {
                    
                    NSURL *urlStr = [NSURL URLWithString:json[@"data"][@"head_image"]];
                    NSData *data = [NSData dataWithContentsOfURL:urlStr];
                    if (data) {
                        [self updateDateWithDirectorName:@"personInfo" andFileName:@"person" andSelectedCell:0 andContent:data];
                    }
                    else{
                        NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"touxiang"]);
                        [self updateDateWithDirectorName:@"personInfo" andFileName:@"person" andSelectedCell:0 andContent:imageData];
                    }
                    [self updateDateWithDirectorName:@"personInfo" andFileName:@"person" andSelectedCell:1 andContent:json[@"data"][@"user_name"]];
                    
                    [self updateDateWithDirectorName:@"personInfo" andFileName:@"person" andSelectedCell:2 andContent:json[@"data"][@"sex"]];
                    
                    [self updateDateWithDirectorName:@"personInfo" andFileName:@"person" andSelectedCell:3 andContent:json[@"data"][@"byear"]];
                    
                    [self updateDateWithDirectorName:@"personInfo" andFileName:@"person" andSelectedCell:4 andContent:json[@"data"][@"city"]];
                    
                    [self updateDateWithDirectorName:@"personInfo" andFileName:@"person" andSelectedCell:5 andContent:json[@"data"][@"mobile"]];
                    
                }
            }
            else
            {
                
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
    }];
    
    
}
#pragma mark - 在沙盒document内的文件夹内的文件内修改文件
+(NSArray *)updateDateWithDirectorName:(NSString *)directorName andFileName:(NSString *)fileName andSelectedCell:(NSInteger)row andContent:(id)content
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingString:[NSString stringWithFormat:@"/%@/%@.plist",directorName,fileName]];

    NSArray *ary = [NSArray arrayWithContentsOfFile: filePath];
    
    NSMutableArray *tempAry = [NSMutableArray new];
    for (int i=0; i<ary.count; i++) {
        if (i==row) {
            [tempAry addObject:content];
        }
        else{
            [tempAry addObject:ary[i]];
        }
    }
    [tempAry writeToFile:filePath atomically:YES];
    
    return tempAry;
    
}


@end
