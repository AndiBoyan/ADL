//
//  NewsViewController.h
//  ADLWeiChe
//
//  Created by icePhoenix on 15/6/4.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *newTable;
    NSMutableArray *timeAry;//时间
    NSMutableArray *newsAry;//新闻概要
    NSMutableArray *imageAry;//新闻图片
}
@end
