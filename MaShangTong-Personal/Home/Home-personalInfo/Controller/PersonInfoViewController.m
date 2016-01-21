//
//  PersonInfoViewController.m
//  MaShangTong
//
//  Created by niliu1h  on 15/10/17.
//  Copyright (c) 2015年 NY. All rights reserved.
//  个人信息

#import "PersonInfoViewController.h"
#import "PersonInfoCell.h"
#import "GSchangePassWordVC.h"
#import "GSPersonInfoModel.h"

#import "GSsexView.h"
#import "GSageView.h"
#import "GScityView.h"
#import "GSauthenticationVC.h"

#import "AFNetworking.h"


#define kPersonInfoTitle @"title"
#define kPersonInfoSubTitle @"subTitle"




@interface PersonInfoViewController () <UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
{
    UIImagePickerController *imagePicker;
    
    //实名认证
    NSString *_autonym;
}
@property (nonatomic,strong) GSPersonInfoModel *personInfo;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSArray *contentAry;

@end

@implementation PersonInfoViewController

static BOOL isHadAutonym = NO;

- (void)configTableView
{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/4, SCREEN_WIDTH, SCREEN_HEIGHT-SCREEN_WIDTH/4-64) style:UITableViewStylePlain];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)configAdImageView
{
    UIImageView *adImageView = [[UIImageView alloc] init];
    [self getImageWith:adImageView];
    adImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/4);
    [self.view addSubview:adImageView];
    
    UIButton *adBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    adBtn.backgroundColor = [UIColor clearColor];
    adBtn.frame = adImageView.frame;
    [adBtn addTarget:self action:@selector(clickADImage:) forControlEvents:UIControlEventTouchDragInside];
    
    [self.view addSubview:adBtn];
    
}
//点击了广告图片
-(void)clickADImage:(UIButton *)sender
{
    NSLog(@"点击了广告图片");
}
- (void)configNavigationItem
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
    titleLabel.textAlignment = 1;
    titleLabel.font = [UIFont systemFontOfSize:19];
    titleLabel.text = @"个人信息";
    titleLabel.textColor = RGBColor(99, 193, 255, 1.f);
    self.navigationItem.titleView = titleLabel;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    backBtn.size = CGSizeMake(22, 22);
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _personInfo = [[GSPersonInfoModel alloc]init];
    
    [self creatDocumentDirectorAndFile];
    [self electricForCertification];
    [self configDataArr];
    [self configNavigationItem];
    [self configAdImageView];
    [self configTableView];
}
#pragma mark - 在沙盒文件内创建文件夹和文件
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
} 
-(void)creatDocumentDirectorAndFile
{
    _authenticationVC = [[GSauthenticationVC alloc]init];
    _changePassWordVC = [[GSchangePassWordVC alloc]init];
    __weak typeof(self) weakSelf = self;
    
    _sexV = [[GSsexView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-220-64, SCREEN_WIDTH, 220)];

    _sexV.chooseSex = ^(NSString *sexStr){
        
        weakSelf.personInfo.sexStr = sexStr;
        _contentAry  = [GSPersonInfoModel updateDateWithDirectorName:@"personInfo" andFileName:@"person" andSelectedCell:2 andContent:_personInfo.sexStr];
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[USER_ID,weakSelf.personInfo.sexStr] forKeys:@[@"user_id",@"sex"]];
        [weakSelf POSTWith:dic and:@"update_personalData" and:2];
    };
    
    _ageV = [[GSageView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-220-64, SCREEN_WIDTH, 220)];
    _ageV.chooseAge = ^(NSString *ageStr){
        
        weakSelf.personInfo.ageStr = ageStr;
        _contentAry  = [GSPersonInfoModel updateDateWithDirectorName:@"personInfo" andFileName:@"person" andSelectedCell:3 andContent:_personInfo.ageStr];
        NSString *str = [weakSelf.personInfo.ageStr substringToIndex:2];
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[USER_ID,str] forKeys:@[@"user_id",@"byear"]];
        [weakSelf POSTWith:dic and:@"update_personalData"and:3];
    };
    
    _cityV = [[GScityView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-220-64, SCREEN_WIDTH, 220)];
    _cityV.chooseCity = ^(NSString *cityName){
        weakSelf.personInfo.cityStr = cityName;
        _contentAry  = [GSPersonInfoModel updateDateWithDirectorName:@"personInfo" andFileName:@"person" andSelectedCell:4 andContent:_personInfo.cityStr];
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[USER_ID,weakSelf.personInfo.cityStr] forKeys:@[@"user_id",@"city"]];
        [weakSelf POSTWith:dic and:@"update_personalData"and:4];
    };
    
    _authenticationVC.makeAuthentication = ^(BOOL isSucceed){
        _autonym = @"认证中";
        isHadAutonym = YES;
        
        [weakSelf.tableView reloadData];
    };
}
- (NSArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (void)configDataArr
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentPath stringByAppendingString:@"/personInfo/person.plist"];
    _contentAry = [NSArray arrayWithContentsOfFile:filePath];
    
    _autonym = @" ";
    _dataArr = [@[@{kPersonInfoTitle:@"头像",kPersonInfoSubTitle:@""},
                  @{kPersonInfoTitle:@"昵称",kPersonInfoSubTitle:@"张小姐"},
                  @{kPersonInfoTitle:@"性别",kPersonInfoSubTitle:@"女"},
                  @{kPersonInfoTitle:@"年龄",kPersonInfoSubTitle:@"90后"},
                  @{kPersonInfoTitle:@"所在地",kPersonInfoSubTitle:@"上海"},
                  @{kPersonInfoTitle:@"手机",kPersonInfoSubTitle:@"188****8888"},
                  @{kPersonInfoTitle:@"实名认证",kPersonInfoSubTitle:@""},
                  @{kPersonInfoTitle:@"修改密码",kPersonInfoSubTitle:@""}] mutableCopy];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 60;
    }
    return 38;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"PersonInfoCellId";
    PersonInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[PersonInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId indexPath:indexPath];
        cell.separatorInset = UIEdgeInsetsMake(0, 25, 0, 0);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 ||indexPath.row == 7) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.titleLabel.text = _dataArr[indexPath.row][kPersonInfoTitle];
    if (indexPath.row == 0) {
        [cell.headerView setImage:[UIImage imageWithData: _contentAry[indexPath.row]]];
        if(_contentAry[0]){
            [cell.headerView setImage:[UIImage imageWithData: _contentAry[0]]];
        }
        else{
            [cell.headerView setImage:[UIImage imageNamed:@"touxiang"]];
        }
    }
    else if (indexPath.row == 3){
        if (![_contentAry[indexPath.row] containsString:@"后"]) {
            cell.subTitleLabel.text = [NSString stringWithFormat:@"%@后",_contentAry[indexPath.row]];
        }
        else{
            cell.subTitleLabel.text = _contentAry[indexPath.row];
        }
    }
    else if (indexPath.row>0 && indexPath.row<6) {
        cell.subTitleLabel.text = _contentAry[indexPath.row];
        
    }
    else if (indexPath.row == 6) {
        cell.subTitleLabel.text = _autonym;
    }
    else{
        cell.subTitleLabel.text = _dataArr[indexPath.row][kPersonInfoSubTitle];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
            //设置头像
        case 0:
            [self creatActionSheet];
            
            break;
            //设置昵称
        case 1:
            [self creatAlertV];
            break;
            
        case 2:
            [self.view addSubview:_sexV];
            break;

        case 3:
            [self.view addSubview:_ageV];
            break;

        case 4:
            [self.view addSubview:_cityV];
            break;
            
        case 6:
            //实名认证
            if(!isHadAutonym){
                [self.navigationController pushViewController:_authenticationVC animated:YES];
            }
            break;
            
        case 7:
            //修改密码
            [self.navigationController pushViewController:_changePassWordVC animated:YES];
            break;
            
        default:
            break;
    }
}

-(void)creatActionSheet
{
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"打开相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        //资源类型为图片库
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        //设置选择后的图片可被编辑
        picker.allowsEditing = YES;
        [self presentModalViewController:picker animated:YES];
        
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        //判断是否有相机
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            //设置拍照后的图片可被编辑
            picker.allowsEditing = YES;
            //资源类型为照相机
            picker.sourceType = sourceType;
            [self presentModalViewController:picker animated:YES];
        }else {
            [MBProgressHUD showError:@"该设备无摄像头"];
        }
        
    }]];
    [self presentViewController:actionSheet animated:YES completion:nil];
    
    
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    UIImage *compressedImage;
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        UIImage *image = [editingInfo objectForKey:UIImagePickerControllerOriginalImage];
        NSString *mediaTyoe = [editingInfo objectForKey:UIImagePickerControllerMediaType];
        if ([mediaTyoe isEqualToString:(NSString *)kUTTypeImage]) {
            UIImage *editImage = [editingInfo objectForKey:UIImagePickerControllerEditedImage];
            UIImageWriteToSavedPhotosAlbum(editImage, self, nil, NULL);
            [MBProgressHUD showError:@"您刚刚拍摄的视频,请重试"];
        }
        CGSize imageSize = CGSizeMake(42, 42);
        //压缩图片
        compressedImage = [self imageWithImage:image scaledToSize:imageSize];
    } else if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        
        UIImage *image = editingInfo[UIImagePickerControllerOriginalImage];
        compressedImage = [self imageWithImage:image scaledToSize:CGSizeMake(42, 42)];
    }
    
    NSData *compressedImageData = UIImagePNGRepresentation(compressedImage);
    if (!compressedImageData) {
        compressedImageData = UIImageJPEGRepresentation(compressedImage, 1.f);
    }
    _personInfo.portraitImage = compressedImageData;

    NSString  *dataStr = [compressedImageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSDictionary *dic = @{@"user_id":USER_ID,@"img":dataStr};
    [self POSTWith:dic and:@"update_img" and:0];
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
// 图片压缩
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
#pragma mark - 添加alertView
-(void)creatAlertV
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"修改昵称" message:@"请输入昵称(六个字以内)。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textFiled = [alert textFieldAtIndex:0];
    textFiled.keyboardType = UIKeyboardAppearanceDefault;
    
    [alert show];
}
#pragma mark - UiAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UITextField *textFiled = [alertView textFieldAtIndex:0];
        if (textFiled.text.length > 6) {
            [MBProgressHUD showError:@"昵称格式不正确"];
            return;
        }
        else{
            _personInfo.nicknameStr = textFiled.text;
            _contentAry  = [GSPersonInfoModel updateDateWithDirectorName:@"personInfo" andFileName:@"person" andSelectedCell:1 andContent:_personInfo.nicknameStr];
            NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[USER_ID,_personInfo.nicknameStr] forKeys:@[@"user_id",@"user_name"]];
            [self POSTWith:dic and:@"update_personalData" and:1];
            
        }
    }
}

#pragma mark - 网络请求
-(void)POSTWith:(NSDictionary *)dic and:(NSString *)urlStr and:(NSInteger)row
{
    [MBProgressHUD showMessage:@"修改中"];
    NSDictionary *param = dic;
    NSString *url = [NSString stringWithFormat:Mast_Url,@"UserApi",urlStr];

    [DownloadManager post:url params:param success:^(id json) {
        [MBProgressHUD hideHUD];
        
        if (json) {
            if ([[NSString stringWithFormat:@"%@",json[@"data"]] isEqualToString:@"1" ]) {
                [MBProgressHUD showSuccess:@"修改成功"];
                if (row == 0) {
                    _contentAry  = [GSPersonInfoModel updateDateWithDirectorName:@"personInfo" andFileName:@"person" andSelectedCell:0 andContent:_personInfo.portraitImage];
                    [_tableView reloadData];
                }
                else{
                    NSArray *keyAry = @[@"user_name",@"sex",@"byear",@"city"];
                    NSString *str ;
                    if (row == 3) {
                        str = [NSString stringWithFormat:@"%@%@",dic[keyAry[row-1]],@"后"];
                        
                    }
                    else{
                        str = [NSString stringWithFormat:@"%@",dic[keyAry[row-1]]];
                    }
                    _contentAry = [GSPersonInfoModel updateDateWithDirectorName:@"personInfo" andFileName:@"person" andSelectedCell:row andContent:str];
                    [_tableView reloadData];
                    
                }
            }
            else
            {
                [MBProgressHUD showError:@"修改失败"];
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"网络错误"];
    }];
    
}

#pragma mark - Action
- (void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 网络请求图片
-(void)getImageWith:(UIImageView *)imageView
{
    NSDictionary *params  = [NSDictionary dictionaryWithObject:@"2" forKey:@"adv_id"];
    NSString *url = [NSString stringWithFormat:Mast_Url,@"OrderApi",@"adv"];
    
    [DownloadManager get:url params:params success:^(id json){
        if (json) {
            NSNumber *num = json[@"data"];
            if ([num isEqualToNumber:[NSNumber numberWithInt:1]]) {
                [imageView sd_setImageWithURL:json[@"info"] placeholderImage:[UIImage imageNamed:@"advertisementImage"] completed:^(UIImage *image,NSError *error,SDImageCacheType cacheType,NSURL *imageURL){
                    
                }];
                
                //                imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:json[@"info"]]]];
            }
        }
    }failure:^(NSError *error){
        
    }];
}

#pragma mark - 网络请求是认证的状态
-(void)electricForCertification
{
    NSDictionary *params = [NSDictionary dictionaryWithObject:USER_ID forKey:@"user_id"];
    
    NSString *url = [NSString stringWithFormat:Mast_Url,@"UserApi",@"certification"];
    [DownloadManager post:url params:params success:^(id json) {
        if (json) {
            NSString *str = [NSString stringWithFormat:@"%@",json[@"info"]];
            if ([str isEqualToString:@"-1"]) {
                _autonym = @"认证失败";
                isHadAutonym = NO;
            }
            else if ([str isEqualToString:@"0"]){
                _autonym = @"未认证";
                isHadAutonym = NO;
            }
            else if ([str isEqualToString:@"1"]){
                _autonym = @"认证中";
                isHadAutonym = YES;
            }
            else{
                _autonym = @"已认证";
                isHadAutonym = YES;
            }
            [_tableView reloadData];
            
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.description);
        [MBProgressHUD showError:@"网络错误"];
    }];

}
@end
