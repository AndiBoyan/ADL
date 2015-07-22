//
//  CarState.m
//  ADLWeiChe
//
//  Created by icePhoenix on 15/6/16.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//

#import "CarState.h"

@implementation CarState

static CarState *instance = nil;
+(CarState*)instance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CarState alloc]init];
    });
    return instance;
}

-(id)init
{
    if (self = [super init]) {
        
    }
    return  self;
}
@end
