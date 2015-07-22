//
//  Analyse.m
//
//
//  Created by icePhoenix on 15/5/14.
//
//

#import "Analyse.h"

@implementation Analyse
+(NSString*)dataCategory:(NSString *)categoryString
{
    NSString *cateString;
    cateString = [categoryString substringWithRange:NSMakeRange(5, 1)];
    if ([cateString isEqualToString:@"M"]) {
        //汽车状态数据
        return @"M";
    }
    if ([cateString isEqualToString:@"G"]) {
        //GPS信息
        return @"G";
    }
    if ([cateString isEqualToString:@"T"]) {
        //汽车温度数据
        return @"T";
    }
    if ([cateString isEqualToString:@"R"]) {
        //控制返回
        //8888PR1083545000M
        return @"R";
    }
    if ([cateString isEqualToString:@"S"]) {
        return @"S";
    }
    if([cateString isEqualToString:@"P"])
    {
        //汽车状态信息
        return @"P";
    }
    else
        return nil;
}
//控制返回
//8888PR4083545000U
+(void) HFB:(int)intHFB
{
    NSString *backString;
    if (intHFB == 1) {
        backString = @"控制成功";
    }
    else
    {
        backString = @"控制失败";
    }
}
//设置返回
+(NSString*) SFB:(NSString*)SFBString
{
    NSString *backString;
    if ([SFBString isEqualToString:@"0001"]) {
        backString = @"设置成功";
    }
    else
    {
        backString = @"设置失败";
    }
    return backString;
}
//温度设置
+(int) TMP:(NSString*)TMPString
{
    int sumTMP = 0;
    int j = -4;
    for (int i = 0; i <= 10; i++) {
        NSString *tmp = [TMPString substringWithRange:NSMakeRange(i, 1)];
        if ([tmp isEqualToString:@"1"]) {
            sumTMP += pow(2, j);
        }
        j++;
    }
    if ([[TMPString substringWithRange:NSMakeRange(11, 1)]isEqualToString:@"1"]) {
        sumTMP = -sumTMP;
    }
    return sumTMP;
}

//GPS信息
+(NSString*)GPS:(NSString*)GPSString
{
    int len = [GPSString length];
    NSString *string = @"";
    for (int i = 0; i<len; i++) {
        NSString *gps = [GPSString substringWithRange:NSMakeRange(i, 1)];
        if (![gps isEqualToString:@","]) {
            string = [NSString stringWithFormat:@"%@%@",string,gps];
        }
        if ([gps isEqualToString:@"E"]||[gps isEqualToString:@"W"]) {
            return string;
        }
    }
    return  nil;
}
+(NSArray*)GPSArray:(NSString*)GPSMsg
{
    int len = [GPSMsg length];
    int j = 0;
    for (int i = 0; i<len; i++) {
        NSString *string  = [GPSMsg substringWithRange:NSMakeRange(i, 1)];
        if ([string isEqualToString:@"N"]||[string isEqualToString:@"S"]) {
            j = i;
        }
    }
    NSString *lat = [GPSMsg substringWithRange:NSMakeRange(0, j)];
    if ([[GPSMsg substringWithRange:NSMakeRange(j, 1)]isEqualToString:@"S"]) {
        lat = [NSString stringWithFormat:@"-%@",lat];
    }
    NSString *lon = [GPSMsg substringWithRange:NSMakeRange(j+1, len-j-2)];
    if ([[GPSMsg substringWithRange:NSMakeRange(len-1, 1)]isEqualToString:@"W"]) {
        lon = [NSString stringWithFormat:@"-%@",lon];
    }
    NSArray *array = [[NSMutableArray alloc]initWithObjects:lat,lon, nil];
    return array;
}
//汽车状态数据
+(NSArray*)carBasicInfo:(NSString*)basicString
{
    NSString *hostState = [basicString substringWithRange:NSMakeRange(0, 1)];
    NSString *host;
    if ([hostState isEqualToString:@"0"]) {
        host = @"主机正常";
    }
    else
    {
        host = @"主机异常";
    }
    NSString *gpsState = [basicString substringWithRange:NSMakeRange(1, 1)];
    NSString *gps;
    if ([gpsState isEqualToString:@"0"]) {
        gps = @"GPS正常";
    }
    else
    {
        gps = @"GPS异常";
    }
    NSString *gprsState = [basicString substringWithRange:NSMakeRange(2, 1)];
    NSString *gprs;
    if ([gprsState isEqualToString:@"0"]) {
        gprs = @"gprs正常";
    }
    else
    {
        gprs = @"gprs正常";
    }
    NSString *bluetoothState = [basicString substringWithRange:NSMakeRange(3, 1)];
    NSString *bluetooth;
    if ([bluetoothState isEqualToString:@"0"]) {
        bluetooth = @"蓝牙正常";
    }
    else
    {
        bluetooth = @"蓝牙异常";
    }
    //.........
    NSArray *stateArray = [[NSArray alloc]initWithObjects:host,gps,gprs,bluetooth, nil];
    return stateArray;
}
+(NSArray*)carState:(NSString*)stateString
{
    NSString *engine = [stateString substringWithRange:NSMakeRange(0, 1)];
    NSString *imagengine;
    if ([engine isEqualToString:@"1"]) {
        imagengine = @"engineOpen.png";
    }
    else
    {
        imagengine = @"engineClose.png";
    }
    NSString *tailBox = [stateString substringWithRange:NSMakeRange(1, 1)];
    NSString *imagetail;
    if ([tailBox isEqualToString:@"1"]) {
        imagetail = @"tailBoxOpen.png";
    }
    else
    {
        imagetail = @"tailBoxClose.png";
    }
    NSString *rbDoor = [stateString substringWithRange:NSMakeRange(2, 1)];
    NSString *imageRB;
    if ([rbDoor isEqualToString:@"1"]) {
        imageRB = @"rbDoorOpen.png";
    }
    else
    {
        imageRB = @"rbDoorClose.png";
    }
    NSString *lbDoor = [stateString substringWithRange:NSMakeRange(3, 1)];
    NSString *imageLB;
    if ([lbDoor isEqualToString:@"1"]) {
        imageLB = @"lbDoorOpen.png";
    }
    else
    {
        imageLB = @"lbDoorClose.png";
    }
    
    NSString *rfDoor = [stateString substringWithRange:NSMakeRange(4, 1)];
    NSString *imageRF;
    if ([rfDoor isEqualToString:@"1"]) {
        imageRF = @"rfDoorOpen.png";
    }
    else
    {
        imageRF = @"rfDoorClose.png";
    }
    NSString *lfBox = [stateString substringWithRange:NSMakeRange(5, 1)];
    NSString *imageLF;
    if ([lfBox isEqualToString:@"1"]) {
        imageLF = @"lfDoorOpen.png";
    }
    else
    {
        imageLF = @"lfDoorClose.png";
    }
    NSArray *imageArray = [[NSArray alloc]initWithObjects:imagengine,imagetail,imageRB,imageLB,imageRF,imageLF, nil];
    return imageArray;
}
+(NSString*)Binary:(int)TenHex
{
    NSString *str = @"";
    while (TenHex!=0) {
        str = [NSString stringWithFormat:@"%d%@",TenHex%2,str];
        TenHex = (int)TenHex/2;
    }
    while (str.length < 8) {
        str = [NSString stringWithFormat:@"0%@",str];
    }
    return str;
}
+(Byte*)carID:(NSString*)carIDString
{
    NSData *carIDData = [carIDString dataUsingEncoding:NSUTF8StringEncoding];
    Byte *carByte = (Byte*)[carIDData bytes];
    return carByte;
}

@end
