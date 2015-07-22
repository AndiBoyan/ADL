//
//  AddNewUserViewController.m
//  ADLWeiChe
//
//  Created by icePhoenix on 15/6/3.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//

#import "AddNewUserViewController.h"
#import "AddCarViewController.h"

@interface AddNewUserViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) UITextField *password1TextField;
@property (strong, nonatomic) UITextField *password2TextField;


@end

@implementation AddNewUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *backgroundIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backgroundIV.image = [UIImage imageNamed:@"loginViewControllerBG@3x.png"];
    [self.view addSubview:backgroundIV];
    self.nameTextField = [[UITextField alloc]initWithFrame:CGRectMake((self.view.frame.size.width-200)*1/2, 180, 200, 35)];
    self.nameTextField.font = [UIFont systemFontOfSize:13.0f];
    self.nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.nameTextField.placeholder = @"手机号码";
    self.nameTextField.textColor = [UIColor blackColor];
    self.nameTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.nameTextField.clearButtonMode = UITextFieldViewModeNever;
    self.nameTextField.secureTextEntry = NO;
    self.nameTextField.clearsOnBeginEditing = YES;
    self.nameTextField.textAlignment = NSTextAlignmentLeft;
    self.nameTextField.returnKeyType = UIReturnKeyNext;
    self.nameTextField.delegate = self;
    [self.view addSubview:self.nameTextField];
    
    self.password1TextField = [[UITextField alloc]initWithFrame:CGRectMake((self.view.frame.size.width-200)*1/2, 225, 200, 35)];
    self.password1TextField.borderStyle = UITextBorderStyleRoundedRect;
    self.password1TextField.font = [UIFont systemFontOfSize:13.0f];
    self.password1TextField.placeholder = @"密码";
    self.password1TextField.textColor = [UIColor blackColor];
    self.password1TextField.clearButtonMode = UITextFieldViewModeNever;
    self.password1TextField.secureTextEntry = YES;
    self.password1TextField.clearsOnBeginEditing = YES;
    self.password1TextField.textAlignment = NSTextAlignmentLeft;
    self.password1TextField.keyboardType = UIKeyboardTypeDefault;
    self.password1TextField.returnKeyType = UIReturnKeyNext;
    self.password1TextField.delegate = self;
    [self.view addSubview:self.password1TextField];
    
    self.password2TextField = [[UITextField alloc]initWithFrame:CGRectMake((self.view.frame.size.width-200)*1/2, 270, 200, 35)];
    self.password2TextField.borderStyle = UITextBorderStyleRoundedRect;
    self.password2TextField.font = [UIFont systemFontOfSize:13.0f];
    self.password2TextField.placeholder = @"确认密码";
    self.password2TextField.textColor = [UIColor blackColor];
    self.password2TextField.clearButtonMode = UITextFieldViewModeNever;
    self.password2TextField.secureTextEntry = YES;
    self.password2TextField.clearsOnBeginEditing = YES;
    self.password2TextField.textAlignment = NSTextAlignmentLeft;
    self.password2TextField.keyboardType = UIKeyboardTypeDefault;
    self.password2TextField.returnKeyType = UIReturnKeyDone;
    self.password2TextField.delegate = self;
    [self.view addSubview:self.password2TextField];
    
    CGRect frameOfNext  = CGRectMake(180, 325, 80, 35);
    UIButton *buttonOfNext = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonOfNext.frame = frameOfNext;
    //下一步按钮
    UIImage *buttonImage = [UIImage imageNamed:@"loginnextbutton@3x.png"];
    UIImage *stretchableButtonImage = [buttonImage  stretchableImageWithLeftCapWidth:12  topCapHeight:0];
    [buttonOfNext setBackgroundImage:stretchableButtonImage forState:UIControlStateNormal];
    [buttonOfNext addTarget:self action:@selector(chooseCar) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonOfNext];
    
    //返回按钮
    CGRect frameOfBack = CGRectMake(60, 325, 80, 35);
    UIButton *buttonOfBack = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonOfBack.frame = frameOfBack;
    UIImage *backImage = [UIImage imageNamed:@"loginbackbutton@3x.png"];
    UIImage *stretchableButtonImage1 = [backImage  stretchableImageWithLeftCapWidth:12  topCapHeight:0];
    [buttonOfBack setBackgroundImage:stretchableButtonImage1 forState:UIControlStateNormal];
    [buttonOfBack addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonOfBack];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)chooseCar
{
    /****************************************/
    //          用户名密码判定
    //http://202.116.48.86:8080/ADLRestful/rest/ums/isUserExist/userID=13268108673
    /*
     （1）200：用户存在
     （2）10001：用户不存在
     */

    /****************************************/
    NSString *name = self.nameTextField.text;
    NSString *pass = self.password1TextField.text;
    NSString *pass1 = self.password2TextField.text;
    if ((name.length <= 0)||(pass.length <= 0)||(pass1.length <= 0)) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您输入的用户信息不完善，请完善用户信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (![pass isEqualToString:pass1]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"两次密码不匹配，请重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        self.password1TextField.text = @"";
        self.password2TextField.text = @"";
        [alert show];
        return;
    }
    NSString *nameString = [NSString stringWithFormat:@"http://dev.adlssc.com:8080/ADLRestful/rest/ums/isUserExist/userID=%@",name];
    NSURL *nameUrl = [NSURL URLWithString:nameString];
    NSString *nameJson = [NSString stringWithContentsOfURL:nameUrl encoding:NSUTF8StringEncoding error:nil];
    NSData *nameData = [nameJson dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:nameData options:NSJSONReadingMutableContainers error:nil];
    NSString *code = [dic objectForKey:@"code"];
    if (![code isEqualToString:@"200"]) {
        AddCarViewController *VC = [[AddCarViewController alloc]init];
        VC.userName = self.nameTextField.text;
        VC.userPass = self.password1TextField.text;
        [self presentViewController:VC animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该用户名已存在，请重新输入用户名或者直接登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        self.nameTextField.text = @"";
        self.password1TextField.text = @"";
        self.password2TextField.text = @"";
        return;
    }
}
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.nameTextField resignFirstResponder]) {
        [self.password1TextField becomeFirstResponder];
    }
    else if ([self.password1TextField resignFirstResponder]) {
        [self.password2TextField becomeFirstResponder];
    }
    else if([self.password2TextField resignFirstResponder]){
        [self.password2TextField resignFirstResponder];
    }
    
    return YES;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (![self.view isExclusiveTouch]) {
        [self.nameTextField resignFirstResponder];
        [self.password1TextField resignFirstResponder];
        [self.password2TextField resignFirstResponder];
    }
}

@end
