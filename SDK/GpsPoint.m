//
//  GpsPoint.m
//  ADLWeiChe
//
//  Created by icePhoenix on 15/6/15.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//

#import "GpsPoint.h"

@implementation GpsPoint

static GpsPoint *instance = nil;

+(GpsPoint*)gpsPointInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GpsPoint alloc]init];
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
