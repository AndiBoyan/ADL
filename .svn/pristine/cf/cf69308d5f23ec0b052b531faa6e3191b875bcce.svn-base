//
//  TrackingViewController.m
//  ADLWeiChe
//
//  Created by icePhoenix on 15/6/11.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//

#import "TrackingViewController.h"
#import "CustomAnnotation.h"

@interface TrackingViewController ()

@end

@implementation TrackingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //添加导航条
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    [navigationItem setTitle:@"我的足迹"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    navigationItem.leftBarButtonItem = leftButton;
    navigationBar.tintColor = [UIColor colorWithRed:0.584f green:0.584f blue:0.584f alpha:1.0f];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [self.view addSubview:navigationBar];
    
    //添加地图
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 65, 320, 510)];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    //地图划线
    [self drawTestLine];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark 地图大头针

//设置起点和终点
-(MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    MKAnnotationView *newAnnotation=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation"];
    if ([[annotation title] isEqualToString:@"起点"]) {
        newAnnotation.image = [UIImage imageNamed:@"location_icon_start.png"];
    }
    if ([[annotation title] isEqualToString:@"终点"]) {
        newAnnotation.image = [UIImage imageNamed:@"location_icon_end.png"];
        
    }
    newAnnotation.canShowCallout=YES;
    return newAnnotation;
}

#pragma mark - MKMapViewDelegate

//解析一段路程的经纬度数组数据
- (void)drawTestLine
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.gpsArray.count/2; i++) {
        NSString *latStr = [self.gpsArray objectAtIndex:2*i];
        NSString *logStr = [self.gpsArray objectAtIndex:2*i+1];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:latStr.floatValue longitude:logStr.floatValue];
        [array addObject:location];
    }
    [self drawLineWithLocationArray:array];
    int gpsCount = (int)self.gpsArray.count;
    NSString *latStr1 = [self.gpsArray objectAtIndex:0];
    NSString *logStr1 = [self.gpsArray objectAtIndex:1];
    NSString *latStr2 = [self.gpsArray objectAtIndex:gpsCount-2];
    NSString *logStr2 = [self.gpsArray objectAtIndex:gpsCount-1];
    CLLocationCoordinate2D coords1 = CLLocationCoordinate2DMake(latStr1.floatValue,logStr1.floatValue);
    CLLocationCoordinate2D coords2 = CLLocationCoordinate2DMake(latStr2.floatValue,logStr2.floatValue);
    
    CustomAnnotation *annotation = [[CustomAnnotation alloc] initWithCoordinate:
                                    coords1];
    annotation.title = @"起点";
    [self.mapView addAnnotation:annotation];
    CustomAnnotation *annotation1 = [[CustomAnnotation alloc] initWithCoordinate:
                                     coords2];
    annotation1.title = @"终点";
    [self.mapView addAnnotation:annotation1];
}

//根据获取的GPS点进行连线
- (void)drawLineWithLocationArray:(NSArray *)locationArray
{
    int pointCount = (int)[locationArray count];
    CLLocationCoordinate2D *coordinateArray = (CLLocationCoordinate2D *)malloc(pointCount * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < pointCount; ++i) {
        CLLocation *location = [locationArray objectAtIndex:i];
        coordinateArray[i] = [location coordinate];
    }
    
    self.routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:pointCount];
    [self.mapView setVisibleMapRect:[self.routeLine boundingMapRect]];
    [self.mapView addOverlay:self.routeLine];
    
    free(coordinateArray);
    coordinateArray = NULL;
}

//设置地图划线的属性
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    if(overlay == self.routeLine) {
        if(nil == self.routeLineView) {
            self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
            self.routeLineView.fillColor = [UIColor redColor];
            self.routeLineView.strokeColor = [UIColor redColor];
            self.routeLineView.lineWidth = 5;
        }
        return self.routeLineView;
    }
    return nil;
}

@end
