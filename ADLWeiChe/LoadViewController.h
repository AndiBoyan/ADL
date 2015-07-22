//
//  LoadViewController.h
//  ADLWeiChe
//
//  Created by icePhoenix on 15/6/4.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    UIDatePicker *trajectDatePicker;
    UITableView *trajectTable;
    NSMutableArray *trajectArray;
    NSMutableArray *timeStartArray;
    NSMutableArray *timeEndArray;
    NSMutableArray *startAddressArray;
    NSMutableArray *endAddressArray;
    NSMutableArray *kmArray;
    NSMutableArray *showKmArray;
    UILabel *dateLab;
    NSDate *timeDate;
    UIView *datePickView;
    NSInteger tableRow;
    NSMutableArray *GPSPointArray;
    NSMutableArray *sArray;
    NSMutableArray *eArray;
    NSMutableArray *gcpuntArray;
}

@end
