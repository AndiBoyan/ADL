//
//  LoginViewController.h
//  ADLWeiChe
//
//  Created by icePhoenix on 15/6/3.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>
{
    UITextField *userNameField;//用户名输入框
    UITextField *userPassField;//用户密码输入框
    NSString *userName;//用户名
    NSString *userPass;//密码
    NSString *isKeepPass;//记住密码
    //BOOL isAutoLogin;//自动登录
}
@property(nonatomic)BOOL isAutoLogin;

@end
