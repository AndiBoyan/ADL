//
//  ControlType.m
//  ADLWeiChe
//
//  Created by icePhoenix on 15/6/15.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//

#import "ControlType.h"

@implementation ControlType

static  ControlType *instance = nil;

+(ControlType*)controlTypeInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ControlType alloc]init];
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
