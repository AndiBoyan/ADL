//
//  UserDefaults.h
//  CarApp1
//
//  Created by imac on 14-10-11.
//  Copyright (c) 2014年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaults : NSObject

+(void)saveUserDefaults:(NSDictionary*) MydataDic:(NSString*)datakey;

+(NSDictionary*) readUserDefaults:(NSString*)datakey;

@end