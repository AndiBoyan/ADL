//
//  myLoadingView.m
//  WeiChe
//
//  Created by icePhoenix on 15/5/14.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//

#import "myLoadingView.h"

@implementation myLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    NSArray *myImages = [NSArray arrayWithObjects:
                         [UIImage imageNamed:@"progress_1.png"],
                         [UIImage imageNamed:@"progress_2.png"],
                         [UIImage imageNamed:@"progress_3.png"],
                         [UIImage imageNamed:@"progress_4.png"],
                         [UIImage imageNamed:@"progress_5.png"],
                         [UIImage imageNamed:@"progress_6.png"],
                         [UIImage imageNamed:@"progress_7.png"],
                         [UIImage imageNamed:@"progress_8.png"],nil];
    
    UIImageView *myAnimatedView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-26.5, self.frame.size.height/2-26.5, 53, 53)];
    myAnimatedView.animationImages = myImages; //animationImages属性返回一个存放动画图片的数组
    myAnimatedView.animationDuration = 0.5; //浏览整个图片一次所用的时间
    myAnimatedView.animationRepeatCount = 0; // 0 = loops forever 动画重复次数
    [myAnimatedView startAnimating];
    [self addSubview:myAnimatedView];
}
@end
