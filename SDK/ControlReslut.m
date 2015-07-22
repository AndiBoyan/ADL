//
//  ControlReslut.m
//  ADLWeiChe
//
//  Created by icePhoenix on 15/6/15.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//

#import "ControlReslut.h"

@implementation ControlReslut

static  ControlReslut *instance = nil;

+(ControlReslut*)controlReslutInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ControlReslut alloc]init];
    });
    return instance;
}

-(id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

@end
