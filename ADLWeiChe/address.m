//
//  address.m
//  ADLWeiChe
//
//  Created by icePhoenix on 15/7/10.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//

#import "address.h"

@implementation address

static address *instance = nil;

+(address*)initAdrs
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[address alloc]init];
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
