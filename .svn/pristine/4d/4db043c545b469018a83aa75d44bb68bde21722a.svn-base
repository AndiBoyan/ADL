//
//  Analyse.h
//  ADLWeiChe
//
//  Created by icePhoenix on 15/6/10.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Analyse : NSObject

+(NSString*) dataCategory:(NSString*)categoryString;
//控制返回
+(void) HFB:(int)intHFB;
//设置返回
+(NSString*) SFB:(NSString*)SFBString;
//温度设置
+(int) TMP:(NSString*)TMPString;
//GPS信息
+(NSString*)GPS:(NSString*)GPSString;
+(NSArray*)GPSArray:(NSString*)GPSMsg;
//汽车状态数据
+(NSArray*)carBasicInfo:(NSString*)basicString;
+(NSArray*)carState:(NSString*)stateString;

//10进制->2进制
+(NSString*)Binary:(int)TenHex;
//字符串-》Byte
+(Byte*)carID:(NSString*)carIDString;

@end