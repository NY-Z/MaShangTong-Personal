//
//  RegisCompanyViewController.m
//  MaShangTong
//
//  Created by niliu1h  on 15/10/15.
//  Copyright (c) 2015年 NY. All rights reserved.
//

#import "RegisCompanyViewController.h"
#import "Masonry.h"
#import "LoginViewController.h"
#import "ProvincesAndCitiesTableViewController.h"
#import "CompanyHomeViewController.h"
#import "NYCompanyProtocalViewController.h"
#import "GSsoftwareMaintenanceViewController.h"
#import <AFNetworking.h>
#import "HomeViewController.h"

@interface RegisCompanyViewController () <UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
{
    NSString *random;
    NSTimer *_timer;
    NSInteger _time;
    
    NSString *_imageStr;
}
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *smsTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *businessTextField;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *protocalLabel;
@property (weak, nonatomic) IBOutlet UIButton *regisBtn;
@property (weak, nonatomic) IBOutlet UIButton *provinceBtn;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;

@property (weak, nonatomic) IBOutlet UIButton *upDataImage;
- (IBAction)upDataImage:(id)sender;

- (IBAction)provinceBtnClicked:(id)sender;
- (IBAction)cityBtnClicked:(id)sender;
- (IBAction)getVerification:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *verificationBtn;
- (IBAction)selectBtnClicked:(id)sender;
- (IBAction)softwareMaintenance:(id)sender;

@end

@implementation RegisCompanyViewController

-(void)backBtnClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)addNavTitle
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"注册公司";
    label.textAlignment = 1;
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = RGBColor(97, 190, 254, 1.f);
    self.navigationItem.titleView = label;
}
- (void)addRightBarButtonItem
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.size = CGSizeMake(44, 44);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"马上登陆" forState:UIControlStateNormal];
    [btn setTitleColor:RGBColor(162, 162, 162, 1) forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 66, 44);
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:self action:@selector(loginClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)initTimer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
    } else {
        [_timer setFireDate:[NSDate distantPast]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _upDataImage.layer.cornerRadius = 5.f;
    _upDataImage.layer.masksToBounds = YES;
    
    self.view.backgroundColor = RGBColor(238, 238, 238, 1);
    self.navigationController.navigationBar.translucent = NO;
    _time = 60;
    [self addNavTitle];
    [self addRightBarButtonItem];
    // 修改控件的属性
    [self handleTheWidget];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_timer.valid) {
        [_timer invalidate];
    }
    _timer = nil;
}

- (void)handleTheWidget
{
    self.firstLabel.layer.cornerRadius = 11;
    self.firstLabel.clipsToBounds = YES;
    self.firstLabel.layer.borderColor = RGBColor(230, 230, 230, 1.f).CGColor;
    self.firstLabel.layer.borderWidth = 1.f;
    self.secondLabel.layer.cornerRadius = 11;
    self.secondLabel.clipsToBounds = YES;
    self.secondLabel.layer.borderColor = RGBColor(230, 230, 230, 1.f).CGColor;
    self.secondLabel.layer.borderWidth = 1.f;
    self.nameTextField.delegate = self;
    self.phoneNumberTextField.delegate = self;
    self.phoneNumberTextField.keyboardType = UIKeyboardTypePhonePad;
    self.smsTextField.delegate = self;
    self.smsTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTextField.delegate = self;
    self.codeTextField.secureTextEntry = YES;
    self.businessTextField.delegate = self;
    self.verificationBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    self.protocalLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *protocalTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(protocalTaped)];
    [self.protocalLabel addGestureRecognizer:protocalTap];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGFloat offSet = self.view.height-(CGRectGetMaxY(textField.frame)+216);
    if (offSet <= 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.y = offSet;
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.view.frame.origin.y != 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.y = 64;
        }];
    }
}

#pragma mark - Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self resignResponder];
}

- (void)resignResponder
{
    [self.nameTextField resignFirstResponder];
    [self.phoneNumberTextField resignFirstResponder];
    [self.phoneNumberTextField resignFirstResponder];
    [self.smsTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    [self.businessTextField resignFirstResponder];
}

#pragma mark - Action
- (void)loginClicked:(UIButton *)btn
{
    LoginViewController *login = [[LoginViewController alloc] init];
    login.type = LoginTypeCompany;
    [self.navigationController pushViewController:login animated:YES];
}

- (IBAction)regisBtnClicked:(UIButton *)btn {
    if (!_selectBtn.selected) {
        [MBProgressHUD showError:@"请同意《码尚通企业服务协议》"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (!_nameTextField.text.length) {
        [MBProgressHUD showError:@"请输入正确的姓名"];
        return;
    }
    [params setValue:_nameTextField.text forKey:@"user_name"];
    
    if (![Helper justMobile:_phoneNumberTextField.text]) {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    [params setValue:_phoneNumberTextField.text forKey:@"mobile"];
    
    if (![Helper justPassword:_codeTextField.text]) {
        [MBProgressHUD showError:@"您的密码格式不正确"];
        return;
    }
    [params setValue:_codeTextField.text forKey:@"user_pwd"];
    
    if (!_businessTextField.text.length) {
        [MBProgressHUD showError:@"请输入工商注册名称"];
        return;
    }
    [params setValue:_businessTextField.text forKey:@"license"];
    
    if ([_provinceBtn.currentTitle isEqualToString:@"省份"]) {
        [MBProgressHUD showError:@"请输入您所在的省份"];
        return;
    }
    [params setValue:_provinceBtn.currentTitle forKey:@"province"];
    
    if ([_cityBtn.currentTitle isEqualToString:@"城市"]) {
        [MBProgressHUD showError:@"请输入您所在的城市"];
        return;
    }
    [params setValue:_cityBtn.currentTitle forKey:@"city"];
#pragma mark - 营业执照
    if (_imageStr.length <= 0) {
        [MBProgressHUD showError:@"请上传您的营业执照"];
        return;
    }
    [params setValue:_imageStr forKey:@"img"];
    
    [params setValue:@"2" forKey:@"group_id"];
    
    if (![_smsTextField.text isEqualToString:random]) {
        [MBProgressHUD showError:@"验证码错误"];
        return;
    }
    
    [MBProgressHUD showMessage:@"正在注册"];
    [DownloadManager post:[NSString stringWithFormat:URL_HEADER,@"UserApi",@"register"] params:params success:^(id json) {
        
        @try {
            [MBProgressHUD hideHUD];
            if ([json[@"result"] isEqualToString:@"1"]) {
                [MBProgressHUD showSuccess:@"注册成功,请您等工作人员认证"];
                [USER_DEFAULT setObject:json[@"user_id"] forKey:@"user_id"];
                [USER_DEFAULT synchronize];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
               
            } else if ([json[@"result"] isEqualToString:@"-1"]){
                [MBProgressHUD showError:@"此账号已经注册过了"];
            } else if ([json isEqualToString:@"0"]){
                [MBProgressHUD showError:@"您的网络有点问题，请重新注册"];
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"您的网络有点问题，请重新注册"];
        
    }];
    
}
#pragma mark - 上传头像
- (IBAction)upDataImage:(id)sender {
    
    [self creatActionSheet];
    
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
//        compressedImage = image;
    } else if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        
        UIImage *image = editingInfo[UIImagePickerControllerOriginalImage];
        compressedImage = [self imageWithImage:image scaledToSize:CGSizeMake(42, 42)];
//        compressedImage = image;
    }
    
    NSData *compressedImageData = UIImagePNGRepresentation(compressedImage);
    if (!compressedImageData) {
        compressedImageData = UIImageJPEGRepresentation(compressedImage, 1.f);
    }
    
    NSString  *dataStr = [compressedImageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    _imageStr = [NSString stringWithString:dataStr];
    [MBProgressHUD showSuccess:@"成功获取图片"];
    
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

- (IBAction)provinceBtnClicked:(id)sender {
    __weak typeof(_provinceBtn) weakProvince = _provinceBtn;
    __weak typeof(_cityBtn) weakCity = _cityBtn;
    
    ProvincesAndCitiesTableViewController *province = [[ProvincesAndCitiesTableViewController alloc] init];
    province.type  = ProvinceTypeProvince;
    province.transProvince = ^(NSString *province) {
        [weakProvince setTitle:province forState:UIControlStateNormal];
        [weakCity setTitle:@"城市" forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:province animated:YES];
}

- (IBAction)cityBtnClicked:(id)sender {
    if ([_provinceBtn.currentTitle isEqualToString:@"省份"]) {
        [MBProgressHUD showError:@"请先选择城市"];
        return;
    }
    __weak typeof(_cityBtn) weakCity = _cityBtn;
    ProvincesAndCitiesTableViewController *city = [[ProvincesAndCitiesTableViewController alloc] init];
    city.type  = ProvinceTypeCity;
    city.province = _provinceBtn.currentTitle;
    city.transCity = ^(NSString *city) {
        [weakCity setTitle:city forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:city animated:YES];
}

- (IBAction)getVerification:(id)sender {
    
    if (![Helper justMobile:_phoneNumberTextField.text]) {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    
    random = @"";
    for(int i=0; i<6; i++)
    {
        random = [random stringByAppendingFormat:@"%i",(arc4random() % 9)];
    }
    
    UIButton *btn = (UIButton *)sender;
    [btn setTitle:@"验证码已发送" forState:UIControlStateNormal];
    btn.enabled = NO;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"码尚通" forKey:@"name"];
    [params setValue:@"码尚通" forKey:@"sign"];
    [params setValue:@"6C572C72EE1CA257886E65C7E5F3" forKey:@"pwd"];
    [params setValue:[NSString stringWithFormat:@"您的验证码为%@切勿泄露给他人，有效期为60秒",random] forKey:@"content"];
    [params setValue:_phoneNumberTextField.text forKey:@"mobile"];
    [params setValue:@"pt" forKey:@"type"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:@"http://sms.1xinxi.cn/asmx/smsservice.aspx" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self initTimer];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NYLog(@"%@",error.localizedDescription);
    }];
}

#pragma mark - Timer
- (void)timerUpdate
{
    _time--;
    [_verificationBtn setTitle:[NSString stringWithFormat:@"%lis后重新发送",(long)_time] forState:UIControlStateNormal];
    _verificationBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    if (_time == 0) {
        _time = 60;
        _verificationBtn.enabled = YES;
        [_verificationBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        [_timer setFireDate:[NSDate distantFuture]];
    }
}

- (IBAction)selectBtnClicked:(id)sender {
    
    _selectBtn.selected = !_selectBtn.selected;
}

- (IBAction)softwareMaintenance:(id)sender {
    
    [self.navigationController pushViewController:[[GSsoftwareMaintenanceViewController alloc] init] animated:YES];
}

- (void)protocalTaped
{
    [self.navigationController pushViewController:[[NYCompanyProtocalViewController alloc] init] animated:YES];
}

#pragma mark - dealloc
- (void)dealloc
{
    NYLog(@"%s",__FUNCTION__);
}
@end
