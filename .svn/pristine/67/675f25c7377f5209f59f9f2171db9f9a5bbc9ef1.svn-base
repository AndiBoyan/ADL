//
//  LoginViewController.m
//  ADLWeiChe
//
//  Created by icePhoenix on 15/6/3.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewController.h"
#import "OBShapedButton.h"
#import "AddNewUserViewController.h"
#import "AppDelegate.h"
#import "AddCarViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    UIImageView *backgroundIV = [[UIImageView alloc]initWithFrame:self.view.frame];
    backgroundIV.image = [UIImage imageNamed:@"loginViewControllerBG@3x.png"];
    //[self.view addSubview:backgroundIV];
    //self.isAutoLogin = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    if (self.isAutoLogin) {
        ViewController *vc= [[ViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }
    else
    {
        self.view.backgroundColor = [UIColor whiteColor];
        //添加背景图片
        UIImageView *backgroundImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        backgroundImage.image = [UIImage imageNamed:@"loginViewControllerBG@3x"];
        [self.view addSubview:backgroundImage];
        
       float w = self.view.frame.size.width;
        userNameField = [self fieldWithFrame:CGRectMake((w-200)/2, 180, 200, 35) isSecureTextEntry:NO placeholder:@"手机号码" tag:1000];
        userNameField.keyboardType = UIKeyboardTypeNumberPad;
        userPassField = [self fieldWithFrame:CGRectMake((w-200)/2, 230, 200, 35) isSecureTextEntry:YES placeholder:@"密码" tag:1001];
        [self.view addSubview:userNameField];
        [self.view addSubview:userPassField];
        
        [self checkButton:CGRectMake((w-200)/2, 280, 20, 20) isSelect:YES checkBtnTag:1002 labWithText:@"记住密码"];
        [self checkButton:CGRectMake(125+(w-200)/2, 280, 20, 20) isSelect:YES checkBtnTag:1003 labWithText:@"使用手势"];
        
        [self drawObshapedButton:CGRectMake(w/2-62.5, 320, 125, 35) tag:1005 image:@"loginViewControllerloginBtn@3x.png"];
        [self label:CGRectMake(20, 380, 100, 20) text:@"新用户注册"];
        [self label:CGRectMake(self.view.frame.size.width - 160, 380, 100, 20) text:@"忘记密码？"];
        
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.hidden = delegate.isLoginOff;
        button.frame = CGRectMake(10, 30, 50, 30);
        UIImage *buttonImage = [UIImage imageNamed:@"loginbacktomain@3x.png"];
        UIImage *stretchableButtonImage1 = [buttonImage  stretchableImageWithLeftCapWidth:12  topCapHeight:0];
        [button setBackgroundImage:stretchableButtonImage1 forState:UIControlStateNormal];
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];

    }
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 用户输入框
//用户名输入框以及密码输入框
-(UITextField*)fieldWithFrame:(CGRect)frame isSecureTextEntry:(BOOL)isSecureTextEntry placeholder:(NSString*)placeholder tag:(int)tag
{
    UITextField *field = [[UITextField alloc]initWithFrame:frame];
    field.borderStyle = UITextBorderStyleRoundedRect;
    field.delegate = self;
    field.font = [UIFont systemFontOfSize:13.0f];
    field.placeholder = placeholder;
    field.secureTextEntry = isSecureTextEntry;
    field.returnKeyType = UIReturnKeyDone;
    field.tag = tag;
    return field;
}

#pragma mark 复选框
//复选框实现记住密码+自动登录
-(void)checkButton:(CGRect)frame isSelect:(BOOL)isSelect checkBtnTag:(int)tag labWithText:(NSString*)string
{
    UIButton *checkbox=[[UIButton alloc]initWithFrame:CGRectZero];
    [self.view addSubview:checkbox];
    checkbox.frame=frame;
    [checkbox setImage:[UIImage imageNamed:@"check_off.png"]forState:UIControlStateNormal];
    //设置正常时图片为    check_off.png
    [checkbox setImage:[UIImage imageNamed:@"check_on.png"]forState:UIControlStateSelected];
    //设置点击选中状态图片为check_on.png
    [checkbox addTarget:self action:@selector(checkboxClick:)forControlEvents:UIControlEventTouchUpInside];
    checkbox.selected = isSelect;
    checkbox.tag = tag;
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x+20, frame.origin.y, 80, 20)];
    [self.view addSubview:lab];
    lab.text = string;
    lab.font = [UIFont systemFontOfSize:12.0f];
    
}

//实现checkboxClick方法
-(void)checkboxClick:(UIButton*)btn{
    btn.selected=!btn.selected;//每次点击都改变按钮的状态
    if(btn.selected){
         //在此实现打勾时的方法
        if (btn.tag == 1002) {
            NSLog(@"记住密码");
        }
        if (btn.tag == 1003) {
            NSLog(@"自动登录");
        }
        
    }else{
       //在此实现不打勾时的方法
        if (btn.tag == 1002) {
            NSLog(@"记住密码");
        }
        if (btn.tag == 1003) {
            NSLog(@"自动登录");
        }
    }
}

#pragma mark button
//绘制不规则按钮
-(void)drawObshapedButton:(CGRect)frame tag:(int)tag image:(NSString*)imageName
{
    OBShapedButton *obshapeButton = [OBShapedButton buttonWithType:UIButtonTypeRoundedRect];
    obshapeButton.frame = frame;
    UIImage *image = [UIImage imageNamed:imageName];
    UIImage *imageBtn = [image stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [obshapeButton setBackgroundImage:imageBtn forState:UIControlStateNormal];//定义背景图片
    obshapeButton.tag = tag;
    obshapeButton.backgroundColor = [UIColor clearColor];
    [obshapeButton addTarget:self action:@selector(obsapedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:obshapeButton];
}

//不规则按钮响应事件
-(void)obsapedButtonAction:(id)sender
{
    OBShapedButton *button = (OBShapedButton*)sender;
    switch (button.tag) {
        case 1005:
        {
            //登录
            [userNameField resignFirstResponder];
            [userPassField resignFirstResponder];
            userName = userNameField.text;
            userPass = userPassField.text;
            if ((userName.length <= 0)||(userPass.length <= 0)) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"您填写的用户名或者密码为空，请完善用户信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            ViewController *VC = [[ViewController alloc]init];
            AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            delegate.isLogin = YES;
            [self presentViewController:VC animated:YES completion:nil];
            //登录API
            /*********************************************************************
            //http://202.116.48.86:8080/ADLRestful/rest/ums/userLogin/userID=13268108673&userPassword=12345678
                200：登录成功
                10001： 用户ID不存在
                10003： 用户密码错误
            *********************************************************************/
           /* NSString *loginString = [NSString stringWithFormat:@"http://dev.adlssc.com:8080/ADLRestful/rest/ums/userLogin/userID=%@&userPassword=%@",userName,userPass];
            NSURL *loginUrl = [NSURL URLWithString:loginString];
            NSString *loginJson = [NSString stringWithContentsOfURL:loginUrl encoding:NSUTF8StringEncoding error:nil];
            NSData *loginData = [loginJson dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:loginData options:NSJSONReadingMutableContainers error:nil];
            NSString *code = [dic objectForKey:@"code"];
            if ([code isEqualToString:@"200"]) {
                //登录成功
                ViewController *VC = [[ViewController alloc]init];
                AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
                delegate.isLogin = YES;
                [self presentViewController:VC animated:YES completion:nil];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名或者密码错误，请检查后重新输入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                userNameField.text = @"";
                userPassField.text = @"";
                return;
            }*/
        }
            break;
        default:
            break;
    }
}

#pragma mark textFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

-(void)label:(CGRect)frame text:(NSString*)string
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentRight;
    label.text = string;
    label.font = [UIFont systemFontOfSize:13.0f];
    [self.view addSubview:label];
    
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
     [label addGestureRecognizer:labelTapGestureRecognizer];
}

-(void) labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    UILabel *label=(UILabel*)recognizer.view;
    if ([label.text isEqualToString:@"新用户注册"]) {
        //用户注册
        AddNewUserViewController *VC = [[AddNewUserViewController alloc]init];
        [self presentViewController:VC animated:YES completion:nil];
    }
    else
    {
        //忘记密码
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (![self.view isExclusiveTouch]) {
        [userNameField resignFirstResponder];
        [userPassField resignFirstResponder];
    }
}

@end
