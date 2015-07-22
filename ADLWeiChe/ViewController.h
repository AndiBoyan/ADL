//
//  ViewController.h
//  ADLWeiChe
//
//  Created by icePhoenix on 15/6/3.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TentacleView.h"
#import "GesturePasswordView.h"
#import "GCDAsyncSocket.h"

@interface ViewController : UIViewController<VerificationDelegate,ResetDelegate,GesturePasswordDelegate>
{
    UIView *toolView;
    
    //提醒设置
    BOOL typeOfTemp;
    BOOL typeOfOil;
    
    NSTimer *connectTime;
    

}

@property  GCDAsyncSocket *scoket;//定义TCPIP通信Scoket

- (void)clear;

- (BOOL)exist;

@end

