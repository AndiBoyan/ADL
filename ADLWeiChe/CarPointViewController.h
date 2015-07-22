//
//  CarPointViewController.h
//  ADLWeiChe
//
//  Created by icePhoenix on 15/6/4.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

@interface CarPointViewController : UIViewController<MAMapViewDelegate>
{
    MAMapView *_mapView;
    NSTimer *gpsTime;
}
@property(nonatomic) float lat;
@property(nonatomic) float lon;

@end
