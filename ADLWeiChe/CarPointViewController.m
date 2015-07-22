//
//  CarPointViewController.m
//  ADLWeiChe
//
//  Created by icePhoenix on 15/6/4.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//

#import "CarPointViewController.h"
#import "CustomAnnotation.h"
#import "GpsPoint.h"
#import "UserDefaults.h"

@interface CarPointViewController ()
{
    MAPointAnnotation *pointAnnotation;
}
@end

@implementation CarPointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //创建导航条
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    [navigationItem setTitle:@"爱车位置"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    navigationItem.leftBarButtonItem = leftButton;
    navigationBar.tintColor = [UIColor colorWithRed:0.584f green:0.584f blue:0.584f alpha:1.0f];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [self.view addSubview:navigationBar];
    
    //高德地图显示
    [MAMapServices sharedServices].apiKey = @"d4713afc15d2a328b4242f24011dfdc8";
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 65, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-65)];
    _mapView.delegate = self;
    [_mapView setZoomLevel:16.1 animated:YES];;
    [self.view addSubview:_mapView];
}

#pragma mark 经纬度数据获取
//刷新汽车的经纬度数据
-(void)viewDidAppear:(BOOL)animated
{
    gpsTime = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(gpsPoint) userInfo:nil repeats:YES];
    
}
//关闭获取汽车经纬度数据
-(void)viewDidDisappear:(BOOL)animated
{
    [gpsTime setFireDate:[NSDate distantFuture]];
}

#pragma mark 地图大头针
//添加地图大头针
-(void)gpsPoint
{
    [_mapView removeAnnotation:pointAnnotation];//移除地图所有大头针
    //传递经纬度数据
    self.lat = [GpsPoint gpsPointInstance].latitude;
    self.lon = [GpsPoint gpsPointInstance].longitude;
    pointAnnotation = [[MAPointAnnotation alloc] init];
    
    //车机没有经纬度数据传过来，就读取最后一次的数据，如果没有最后一次数据，就定位到澳鍀林
    if ((self.lat == 0) && (self.lon == 0)) {
        NSDictionary *dic = [UserDefaults readUserDefaults:@"lastGps"];
        if (dic != nil) {
            NSString *lat = [dic objectForKey:@"lat"];
            NSString *lon = [dic objectForKey:@"lon"];
            self.lat = lat.floatValue;
            self.lon = lon.floatValue;
        }
        else
        {
            self.lat = 22.554258;
            self.lon = 113.933936;
        }
    }
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(self.lat, self.lon);
    [_mapView setCenterCoordinate:pointAnnotation.coordinate animated:YES];//将汽车位置设为地图中心
    pointAnnotation.title = @"我的爱车";
    [_mapView addAnnotation:pointAnnotation];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        
        if (annotationView == nil)
        {
            
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:reuseIndetifier];
        }
        annotationView.canShowCallout = YES;
        annotationView.image = [UIImage imageNamed:@"mucar.png"];
        annotationView.draggable = YES;
        return annotationView;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
