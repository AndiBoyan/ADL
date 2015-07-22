//
//  UserDefaults.m
//  CarApp1
//
//  Created by imac on 14-10-11.
//  Copyright (c) 2014年 com. All rights reserved.
//

#import "UserDefaults.h"

@implementation UserDefaults

//将数据保存
+(void)saveUserDefaults:(NSDictionary*) MydataDic:(NSString*)datakey{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:MydataDic forKey:datakey];
    //同步到本地
    [userDefaults synchronize];
}
//读取数据
+(NSDictionary*) readUserDefaults:(NSString*)datakey{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *myDictonary = [userDefaults dictionaryForKey:datakey];
    return myDictonary;
}

@end
