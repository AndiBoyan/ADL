//
//  ControlViewController.h
//  WeiChe
//
//  Created by icePhoenix on 15/5/14.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncSocket.h"
#import "OBShapedButton.h"
#import <AVFoundation/AVFoundation.h>

@interface ControlViewController : UIViewController
{
    
    NSString *IPAddress;//主机IP地址以及端口
    NSString *port;
    
    //定义声音
    AVAudioPlayer *player;
    AVAudioPlayer *loginplayer;
    AVAudioPlayer *startplayer;
    AVAudioPlayer *WarmPlayer;
    
    BOOL lockSelect;//锁车按钮切换
    BOOL startSelect;//启动按钮切换
    int controlType;//控制按钮tag
    BOOL carSwap;//紧急报警图片切换
    NSTimer *swapTime;//紧急报警定时器
    NSTimer *stateTime;
    NSTimer *unlockTime;
    NSTimer *lockTime;
    BOOL stateSwqp;
    float myclockTime;
    BOOL unlockSwap;
    BOOL lockSwap;
    float clockunlock;
    float clocklock;
    float clockTime;//报警时间
    
    OBShapedButton *lockBtn;//锁定按钮
    OBShapedButton *startBtn;//启动按钮
    
    //汽车状态图层
    UIImageView *stateIV;
    UIImageView *tailBoxIV;
    UIImageView *lbIV;
    UIImageView *lfIV;
    UIImageView *lb1IV;
    UIImageView *lf1IV;
    UIImageView *rbIV;
    UIImageView *rfIV;
    UIImageView *startIV;
    UIImageView *start1IV;
    UIImageView *stopIV;
    UIImageView *tailBox2IV;
    UIImageView *tailBox3IV;
    UIImageView *lockIV;
    
    //GPS状态+通信状态
    UIImageView *GPSStateIV;
    UIImageView *scoketStateIV;
    


}
@property(strong, nonatomic)GCDAsyncSocket *scoket;//定义TCPIP通信Scoket
@property(strong, nonatomic) UIImageView *backimage;
@property(strong, nonatomic) UILabel *addressLabel;
@property(strong, nonatomic) NSString *address;
@end
