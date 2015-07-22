//
//  TrackViewController.h
//  ADLWeiChe
//
//  Created by icePhoenix on 15/6/11.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

{
    UITableView *trackTable;
    NSArray *array;
    UIView *addDeviceView;
}

@end
