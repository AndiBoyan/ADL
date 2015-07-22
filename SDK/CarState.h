//
//  CarState.h
//  ADLWeiChe
//
//  Created by icePhoenix on 15/6/16.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarState : NSObject

@property(strong, nonatomic) NSString* stateString;

+(CarState*)instance;

@end
