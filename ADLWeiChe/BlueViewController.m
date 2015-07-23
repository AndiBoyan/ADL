//
//  BlueViewController.m
//  ADLWeiChe
//
//  Created by icePhoenix on 15/7/13.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//

#import "BlueViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "OBShapedButton.h"
#import "TLTiltSlider.h"
#import "RESwitch.h"
#import "BLEInfo.h"


@interface BlueViewController ()<MAMapViewDelegate,AMapSearchDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDataSource,UITableViewDelegate>
{
    MAMapView *_mapView;
    AMapSearchAPI *_search;
    UIImageView *carStateIV;
    OBShapedButton *obsBleStateButton;
    OBShapedButton *obsAutoButton;
    OBShapedButton *obsOnButton;
    
    UIButton *controlBtn;
    UIButton *settingBtn;
    UIImageView *controlBtnIV;
    UIImageView *settingBtnIV;
    UILabel *controlLab;
    UILabel *settingLab;
    UILabel *startTimeLab;
    UILabel *endTimeLab;
    
    UIView *settingView;
    UIImageView *timerImage;
    UIPickerView *datePickView;
    UIView *dateView;
    
    int autoSelect;
    float RSSIValue;
    int RSSIState;//是否处于感应区
    
    NSMutableArray *hourAry;
    NSMutableArray *minAry;
    int timeValue;
    
    NSTimer *readRSSITime;
    NSTimer *tunnelTime;
    NSTimer *carStateTime;
    
    float lastlat;
    float lastlon;
    BOOL isTunnel;
    
    int bleConnectState;
    int vehicleControl;
    int bleSetDone;
}

@property UITableView *bletableView;
@property NSMutableArray *bleAry;
@property UIAlertView *bleAlertView;

@end

@implementation BlueViewController

#define SECTION_NAME @"BleInfo"
#define PI 3.1415926

- (void)viewDidLoad {
    
    lastlat = 0.0f;
    lastlon = 0.0f;
    bleSetDone = 0;
    // [self isBetweenFromHour:14 FromMinute:00 toHour:10 toMinute:00];
    [super viewDidLoad];
    [self initData];
    [self initView];
    // Do any additional setup after loading the view, typically from a nib.
    //手机定位
    [MAMapServices sharedServices].apiKey = @"d4713afc15d2a328b4242f24011dfdc8";
    _mapView = [[MAMapView alloc] init];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
    
    
    //蓝牙服务
    self.centralMgr = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    if (_discoveredPeripheral)
    {
        NSLog(@"connectPeripheral");
        [_centralMgr connectPeripheral:_discoveredPeripheral options:nil];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    tunnelTime = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(tunnel) userInfo:nil repeats:YES];
    [tunnelTime setFireDate:[NSDate distantFuture]];
    
    self.bleAry = [[NSMutableArray alloc]init];
    
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    //设置导航栏内容
    UIImage *backgroundImage = [UIImage imageNamed:@"backguound.png"];  //获取图片
    [navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    //UIImageView *titleView = [[UIImageView alloc]initWithFrame:CGRectMake(110 , 30, 100, 20)];
    //titleView.image = [UIImage imageNamed:@"navTitle.png"];
    navigationItem.title = @"蓝牙大灯";
    UIColor *color = [UIColor whiteColor];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    navigationBar.titleTextAttributes = dic;

    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    //把导航栏集合添加入导航栏中，设置动画关闭
    navigationItem.leftBarButtonItem = leftButton;
    navigationBar.tintColor = [UIColor colorWithRed:0.584f green:0.584f blue:0.584f alpha:1.0f];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    navigationBar.barTintColor = [UIColor whiteColor];
    navigationBar.tintColor = [UIColor whiteColor];
    //把导航栏添加到视图中
    [self.view insertSubview:navigationBar atIndex:1];
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)tunnel
{
    //发起搜索POI服务
    _search = [[AMapSearchAPI alloc] initWithSearchKey:@"d4713afc15d2a328b4242f24011dfdc8" Delegate:self];
    AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
    poiRequest.searchType = AMapSearchType_PlaceAround;
    //23.536678 113.311437 23.536678 113.311437
    poiRequest.location = [AMapGeoPoint locationWithLatitude:23.5390882478 longitude:113.3105027174];
    poiRequest.radius = 200;
    poiRequest.types = @[@"190310"];
    poiRequest.requireExtension = YES;
    
    //发起POI搜索
    [_search AMapPlaceSearch: poiRequest];
}
-(void)initData
{
    hourAry = [[NSMutableArray alloc]init];
    minAry = [[NSMutableArray alloc]init];
    for (int i = 0; i < 24; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        if (i < 10) {
            str = [NSString stringWithFormat:@"0%d",i];
        }
        [hourAry addObject:str];
    }
    for (int i = 0; i < 60; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        if (i < 10) {
            str = [NSString stringWithFormat:@"0%d",i];
        }
        [minAry addObject:str];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
//定位更新回调函数
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //隧道检测
        if ([self LantitudeLongitudeDist:lastlon other_Lat:lastlat self_Lon:userLocation.coordinate.longitude self_Lat:userLocation.coordinate.latitude] >= 200.0f) {
            lastlat = userLocation.coordinate.latitude;
            lastlon = userLocation.coordinate.longitude;
            [tunnelTime setFireDate:[NSDate distantPast]];
        }
    }
}

#pragma mark - calculate distance  根据2个经纬度计算距离

-(double) LantitudeLongitudeDist:(double)lon1 other_Lat:(double)lat1 self_Lon:(double)lon2 self_Lat:(double)lat2{
    double er = 6378137; // 6378700.0f;
    double radlat1 = PI*lat1/180.0f;
    double radlat2 = PI*lat2/180.0f;
    //now long.
    double radlong1 = PI*lon1/180.0f;
    double radlong2 = PI*lon2/180.0f;
    if( radlat1 < 0 ) radlat1 = PI/2 + fabs(radlat1);// south
    if( radlat1 > 0 ) radlat1 = PI/2 - fabs(radlat1);// north
    if( radlong1 < 0 ) radlong1 = PI*2 - fabs(radlong1);//west
    if( radlat2 < 0 ) radlat2 = PI/2 + fabs(radlat2);// south
    if( radlat2 > 0 ) radlat2 = PI/2 - fabs(radlat2);// north
    if( radlong2 < 0 ) radlong2 = PI*2 - fabs(radlong2);// west
    //spherical coordinates x=r*cos(ag)sin(at), y=r*sin(ag)*sin(at), z=r*cos(at)
    //zero ag is up so reverse lat
    double x1 = er * cos(radlong1) * sin(radlat1);
    double y1 = er * sin(radlong1) * sin(radlat1);
    double z1 = er * cos(radlat1);
    double x2 = er * cos(radlong2) * sin(radlat2);
    double y2 = er * sin(radlong2) * sin(radlat2);
    double z2 = er * cos(radlat2);
    double d = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
    //side, side, side, law of cosines and arccos
    double theta = acos((er*er+er*er-d*d)/(2*er*er));
    double dist  = theta*er;
    return dist;
}
//实现POI搜索对应的回调函数
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    if(response.pois.count == 0)
    {
        isTunnel = NO;
        [tunnelTime setFireDate:[NSDate distantFuture]];
        return;
    }
    
    else
    {
        //前方有隧道
        isTunnel = YES;
        
    }
    /*//通过AMapPlaceSearchResponse对象处理搜索结果
     NSString *strCount = [NSString stringWithFormat:@"count: %ld",(long)response.count];
     NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
     NSString *strPoi = @"";
     for (AMapPOI *p in response.pois) {
     strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, p.description];
     }
     NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
     NSLog(@"Place: %@", result);*/
}

#pragma mark 绘制界面
-(void)initView
{
    float h = [UIScreen mainScreen].bounds.size.height;
    NSLog(@"%f",h);
    float w = [UIScreen mainScreen].bounds.size.width;
    
    NSLog(@"%f,%f",w,h);
    UIImageView *backgroundIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, w, h)];
    NSString *imageName = [NSString stringWithFormat:@"background-%.0fh.png",h];
    backgroundIV.image = [UIImage imageNamed:imageName];
    [self.view addSubview:backgroundIV];
    
    carStateIV = [[UIImageView alloc]init];
    NSString *stateImageName = [NSString stringWithFormat:@"carlightOFF-%.0f.png",h];
    carStateIV.image = [UIImage imageNamed:stateImageName];
    [self.view addSubview:carStateIV];
    
    obsOnButton = [OBShapedButton buttonWithType:UIButtonTypeRoundedRect];
    NSString *onImageName = [NSString stringWithFormat:@"ledON1-%.0f.png",h];
    UIImage *onImage = [UIImage imageNamed:onImageName];
    UIImage *onImageBtn = [onImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [obsOnButton setBackgroundImage:onImageBtn forState:UIControlStateNormal];//定义背景图片
    obsOnButton.backgroundColor = [UIColor clearColor];
    [obsOnButton addTarget:self action:@selector(obsOnButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:obsOnButton];
    
    OBShapedButton *obsOffButton = [OBShapedButton buttonWithType:UIButtonTypeRoundedRect];
    NSString *offImageName = [NSString stringWithFormat:@"ledOFF-%.0f.png",h];
    UIImage *offImage = [UIImage imageNamed:offImageName];
    UIImage *offImageBtn = [offImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [obsOffButton setBackgroundImage:offImageBtn forState:UIControlStateNormal];//定义背景图片
    obsOffButton.backgroundColor = [UIColor clearColor];
    [obsOffButton addTarget:self action:@selector(obsOffButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:obsOffButton];
    
    obsAutoButton = [OBShapedButton buttonWithType:UIButtonTypeRoundedRect];
    NSString *autoImageName = [NSString stringWithFormat:@"autoON-%.0f.png",h];
    UIImage *aotuImage = [UIImage imageNamed:autoImageName];
    UIImage *autoImageBtn = [aotuImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [obsAutoButton setBackgroundImage:autoImageBtn forState:UIControlStateNormal];//定义背景图片
    obsAutoButton.backgroundColor = [UIColor clearColor];
    [obsAutoButton addTarget:self action:@selector(obsAutoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:obsAutoButton];
    
    obsBleStateButton = [OBShapedButton buttonWithType:UIButtonTypeCustom];
    NSString *bleStateImageName = [NSString stringWithFormat:@"ble4OFF-%.0f.png",h];
    UIImage *bleStateImage = [UIImage imageNamed:bleStateImageName];
    UIImage *bleStateImageBtn = [bleStateImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [obsBleStateButton setBackgroundImage:bleStateImageBtn forState:UIControlStateNormal];//定义背景图片
    obsBleStateButton.backgroundColor = [UIColor clearColor];
    [obsBleStateButton addTarget:self action:@selector(searchBle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:obsBleStateButton];
    
    
    controlBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    controlBtn.tag = 1000;
    controlBtnIV = [[UIImageView alloc]init];
    NSString *controlImageName = [NSString stringWithFormat:@"lightico-%.0f.png",h];
    controlBtnIV.image = [UIImage imageNamed:controlImageName];
    [controlBtn addSubview:controlBtnIV];
    [controlBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [controlBtn setBackgroundColor:[UIColor clearColor]];
    [controlBtn addTarget:self action:@selector(controlButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:controlBtn];
    controlLab = [[UILabel alloc]init];
    controlLab.text = @"控制";
    controlLab.font = [UIFont systemFontOfSize:10.0f];
    controlLab.textAlignment = NSTextAlignmentCenter;
    controlLab.textColor = [UIColor yellowColor];
    [self.view addSubview:controlLab];
    
    settingBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    settingBtn.tag = 1001;
    settingBtnIV = [[UIImageView alloc]init];
    NSString *settingImageName = [NSString stringWithFormat:@"settingico1-%.0f.png",h];
    settingBtnIV.image = [UIImage imageNamed:settingImageName];
    [settingBtn addSubview:settingBtnIV];
    [settingBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [settingBtn setBackgroundColor:[UIColor clearColor]];
    [settingBtn addTarget:self action:@selector(controlButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingBtn];
    settingLab = [[UILabel alloc]init];
    settingLab.text = @"设置";
    settingLab.font = [UIFont systemFontOfSize:10.0f];
    settingLab.textAlignment = NSTextAlignmentCenter;
    settingLab.textColor = [UIColor whiteColor];
    [self.view addSubview:settingLab];
    
    settingView = [[UIView alloc]init];
    settingView.hidden = YES;
    NSString *settingViewImageName = [NSString stringWithFormat:@"settingView-%.0f.png",h];
    UIImageView *settingViewBackground = [[UIImageView alloc]init];
    settingViewBackground.image = [UIImage imageNamed:settingViewImageName];
    [settingView addSubview:settingViewBackground];
    [self.view addSubview:settingView];
    
    UILabel *sliderLab = [[UILabel alloc]init];
    sliderLab.textColor = [UIColor whiteColor];
    sliderLab.text = @"感应距离：";
    sliderLab.textAlignment = NSTextAlignmentCenter;
    sliderLab.font = [UIFont systemFontOfSize:15.0f];
    [settingView addSubview:sliderLab];
    
    TLTiltSlider *slider = [[TLTiltSlider alloc]init];
    slider.minimumValue = 50;
    slider.maximumValue = 100;
    NSUserDefaults *periperalData = [NSUserDefaults standardUserDefaults];
    NSString *rssi = [periperalData objectForKey:@"LastRSSI"];
    slider.value = 50;
    if (rssi != nil) {
        slider.value = rssi.floatValue;
    }
    
    [slider addTarget:self action:@selector(updataValue:) forControlEvents:UIControlEventValueChanged];
    [settingView addSubview:slider];
    
    UILabel *timerLab = [[UILabel alloc]init];
    timerLab.textColor = [UIColor whiteColor];
    timerLab.text = @"时段排程：";
    timerLab.textAlignment = NSTextAlignmentCenter;
    timerLab.font = [UIFont systemFontOfSize:15.0f];
    [settingView addSubview:timerLab];
    
    RESwitch* switchView = [[RESwitch alloc]init];
    switchView.on = YES;
    [switchView addTarget:self action:@selector(timerSwtichAction:) forControlEvents:UIControlEventValueChanged];
    [settingView addSubview:switchView];
    
    timerImage = [[UIImageView alloc]init];
    NSString *timerImageName = [NSString stringWithFormat:@"timerImage-%.0f.png",h];
    timerImage.image = [UIImage imageNamed:timerImageName];
    [settingView addSubview:timerImage];
    
    UILabel *startLab = [[UILabel alloc]init];
    startLab.text = @"开始时间";
    startLab.textColor = [UIColor whiteColor];
    startLab.textAlignment = NSTextAlignmentCenter;
    startLab.font = [UIFont systemFontOfSize:13.0f];
    [timerImage addSubview:startLab];
    
    UILabel *endLab = [[UILabel alloc]init];
    endLab.text = @"结束时间";
    endLab.textColor = [UIColor whiteColor];
    endLab.textAlignment = NSTextAlignmentCenter;
    endLab.font = [UIFont systemFontOfSize:13.0f];
    [timerImage addSubview:endLab];
    
    NSString *chooseTimeImageName = [NSString stringWithFormat:@"timerImage1-%.0f.png",h];
    UIImageView *startTimeIV = [[UIImageView alloc]init];
    startTimeIV.tag = 2001;
    startTimeIV.image = [UIImage imageNamed:chooseTimeImageName];
    [timerImage addSubview:startTimeIV];
    
    
    UIImageView *endTimeIV = [[UIImageView alloc]init];
    endTimeIV.image = [UIImage imageNamed:chooseTimeImageName];
    endTimeIV.tag = 2002;
    [timerImage addSubview:endTimeIV];
    
    startTimeLab = [[UILabel alloc]init];
    startTimeLab.textAlignment = NSTextAlignmentCenter;
    startTimeLab.text = @"19:00 >";
    NSUserDefaults *startData = [NSUserDefaults standardUserDefaults];
    NSString *startTime = [startData objectForKey:@"StartTime"];
    if (startTime != nil) {
        startTimeLab.text = startTime;
    }
    
    startTimeLab.font = [UIFont systemFontOfSize:13.0f];
    startTimeLab.textColor = [UIColor whiteColor];
    [timerImage addSubview:startTimeLab];
    
    endTimeLab = [[UILabel alloc]init];
    endTimeLab.textAlignment = NSTextAlignmentCenter;
    endTimeLab.text = @"06:30 >";
    NSUserDefaults *endData = [NSUserDefaults standardUserDefaults];
    NSString *endTime = [endData objectForKey:@"EndTime"];
    if (endTime != nil) {
        endTimeLab.text = endTime;
    }
    
    endTimeLab.font = [UIFont systemFontOfSize:13.0f];
    endTimeLab.textColor = [UIColor whiteColor];
    [timerImage addSubview:endTimeLab];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.tag = 3001;
    btn.frame = CGRectMake(160, 130, 135, 22.5);
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitle:nil forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(chooseTimeAction:) forControlEvents:UIControlEventTouchUpInside];
    [settingView addSubview:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn1.tag = 3002;
    btn1.frame = CGRectMake(160, 165, 135, 22.5);
    btn1.backgroundColor = [UIColor clearColor];
    [btn1 setTitle:nil forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(chooseTimeAction:) forControlEvents:UIControlEventTouchUpInside];
    [settingView addSubview:btn1];
    
    dateView = [[UIView alloc]initWithFrame:CGRectMake(0, 30+h/2, w ,200 )];
    dateView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1 ];
    dateView.hidden = YES;
    [self.view addSubview:dateView];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.frame = CGRectMake(80, 165, 40, 30);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [dateView addSubview:cancelBtn];
    
    UIButton *doBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    doBtn.frame = CGRectMake(205, 165, 40, 30);
    [doBtn setTitle:@"确定" forState:UIControlStateNormal];
    [doBtn addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
    [dateView addSubview:doBtn];
    
    datePickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, w, 160)];
    datePickView.backgroundColor = [UIColor clearColor];
    datePickView.delegate = self;
    datePickView.dataSource = self;
    [datePickView selectRow:[hourAry count]*35 inComponent:0 animated:NO];
    [datePickView selectRow:[minAry count]*35 inComponent:1 animated:NO];
    [dateView addSubview:datePickView];
    
    //布局frame
    if (h == 480.0f) {
        carStateIV.frame = CGRectMake(0, 85, w, 160);
        
        obsOnButton.frame = CGRectMake(24, 315, 62, 62);
        obsOffButton.frame = CGRectMake(234, 315, 62, 62);
        obsAutoButton.frame = CGRectMake(113.5, 300, 95, 95);
        
        obsBleStateButton.frame = CGRectMake(20, 65, 36, 36);
        controlBtn.frame = CGRectMake(30, 440, 100, 25);
        controlBtnIV.frame = CGRectMake(37.5, 0, 23, 23);
        controlLab.frame = CGRectMake(30, 460, 100, 20);
        settingBtn.frame = CGRectMake(190, 440, 100, 25);
        settingBtnIV.frame = CGRectMake(37.5, 0, 23, 23);
        settingLab.frame = CGRectMake(190, 460, 100, 20);
        
        settingView.frame = CGRectMake(0, 255, w, 190);
        sliderLab.frame = CGRectMake(0, 20, w*1/3, 20);
        slider.frame = CGRectMake(w*1/3, 20, w*10/15, 20);
        timerLab.frame = CGRectMake(0, 60, w*1/3, 20);
        switchView.frame = CGRectMake(220, 55, 76, 28);
        timerImage.frame = CGRectMake(65, 95, 246, 71);
        startLab.frame = CGRectMake(10, 10, 80, 30);
        endLab.frame = CGRectMake(10, 40, 80, 30);
        startTimeIV.frame = CGRectMake(85, 10, 140, 22);
        endTimeIV.frame = CGRectMake(85, 40, 140, 22);
        startTimeLab.frame = CGRectMake(160, 10, 60, 20);
        endTimeLab.frame = CGRectMake(160, 42, 60, 20);
        //startTimeBtn.frame = CGRectMake(95, 10, 140, 22.5);
        btn.frame = CGRectMake(150, 108, 140, 22);
        btn1.frame = CGRectMake(150, 135, 140, 22);
        dateView.frame = CGRectMake(0, 255, w, 185);
        datePickView.frame = CGRectMake(0, 0, w, 140);
        cancelBtn.frame = CGRectMake(80, 150, 40, 30);
        doBtn.frame = CGRectMake(205, 150, 40, 30);
    }
    if (h == 568.0f) {
        carStateIV.frame = CGRectMake(0, 80, w, 226);
        obsOnButton.frame = CGRectMake(25, 380, 66, 66);
        obsOffButton.frame = CGRectMake(229, 380, 66, 66);
        obsAutoButton.frame = CGRectMake(103.5, 360, 113, 113);
        obsBleStateButton.frame = CGRectMake(25, 70, 30, 30);
        controlBtn.frame = CGRectMake(30, 520, 100, 25);
        controlBtnIV.frame = CGRectMake(37.5, 0, 25, 25);
        controlLab.frame = CGRectMake(30, 545, 100, 20);
        settingBtn.frame = CGRectMake(190, 520, 100, 25);
        settingBtnIV.frame = CGRectMake(37.5, 0, 25, 25);
        settingLab.frame = CGRectMake(190, 545, 100, 20);
        settingView.frame = CGRectMake(0, 306, w, 223);
        sliderLab.frame = CGRectMake(0, 40, w*1/3, 20);
        slider.frame = CGRectMake(w*1/3, 40, w*10/15, 20);
        timerLab.frame = CGRectMake(0, 80, w*1/3, 20);
        switchView.frame = CGRectMake(220, 75, 76, 28);
        timerImage.frame = CGRectMake(60, 120, 247.5, 72);
        startLab.frame = CGRectMake(10, 10, 80, 30);
        endLab.frame = CGRectMake(10, 35, 80, 30);
        startTimeIV.frame = CGRectMake(95, 10, 140, 22.5);
        endTimeIV.frame = CGRectMake(95, 40, 140, 22.5);
        startTimeLab.frame = CGRectMake(160, 12, 60, 20);
        endTimeLab.frame = CGRectMake(160, 42, 60, 20);
        //startTimeBtn.frame = CGRectMake(95, 10, 140, 22.5);
    }
    if (h == 667.0f) {
        carStateIV.frame = CGRectMake(0, 85, w, 265);
        obsOnButton.frame = CGRectMake(24, 470, 80, 80);
        obsOffButton.frame = CGRectMake(271, 470, 80, 80);
        obsAutoButton.frame = CGRectMake(128, 450, 119, 119);
        obsBleStateButton.frame = CGRectMake(25, 70, 37, 37);
        controlBtn.frame = CGRectMake(44, 620, 100, 25);
        controlBtnIV.frame = CGRectMake(37.5, 0, 27.5, 27.5);
        controlLab.frame = CGRectMake(44, 645, 100, 20);
        settingBtn.frame = CGRectMake(231.5, 620, 100, 25);
        settingBtnIV.frame = CGRectMake(37.5, 0, 27.5, 27.5);
        settingLab.frame = CGRectMake(232, 645, 100, 20);
        
        settingView.frame = CGRectMake(0, 360, w, 265);
        sliderLab.frame = CGRectMake(0, 40, w*1/3, 20);
        slider.frame = CGRectMake(w*1/3, 40, w*10/15, 20);
        timerLab.frame = CGRectMake(0, 80, w*1/3, 20);
        switchView.frame = CGRectMake(260, 75, 76, 28);
        timerImage.frame = CGRectMake(65, 130, 292, 85);
        startLab.frame = CGRectMake(10, 10, 80, 30);
        endLab.frame = CGRectMake(10, 40, 80, 30);
        startTimeIV.frame = CGRectMake(85, 10, 204, 26.5);
        endTimeIV.frame = CGRectMake(85, 40, 204, 26.5);
        startTimeLab.frame = CGRectMake(160, 12, 60, 20);
        endTimeLab.frame = CGRectMake(160, 42, 60, 20);
        //startTimeBtn.frame = CGRectMake(95, 10, 140, 22.5);
        btn.frame = CGRectMake(155, 140, 204, 26.5);
        btn1.frame = CGRectMake(155, 175, 204, 26.5);
        dateView.frame = CGRectMake(0, 378, w, 225);
        datePickView.frame = CGRectMake(0, 0, w, 180);
        cancelBtn.frame = CGRectMake(74, 180, 40, 30);
        doBtn.frame = CGRectMake(261.5, 180, 40, 30);
        
    }
    if (h == 736.0f) {
        carStateIV.frame = CGRectMake(0, 90, w, 293);
        obsOnButton.frame = CGRectMake(50, 500, 73, 73);
        obsOffButton.frame = CGRectMake(291, 500, 73, 73);
        obsAutoButton.frame = CGRectMake(144.5, 480, 125, 125);
        obsBleStateButton.frame = CGRectMake(35, 85, 41, 41);
        
        controlBtn.frame = CGRectMake(53.5, 680, 100, 25);
        controlBtnIV.frame = CGRectMake(37.5, 0, 25, 25);
        controlLab.frame = CGRectMake(53.5, 705, 100, 20);
        settingBtn.frame = CGRectMake(260.5, 680, 100, 25);
        settingBtnIV.frame = CGRectMake(37.5, 0, 25, 25);
        settingLab.frame = CGRectMake(260.5, 705, 100, 20);
        
        settingView.frame = CGRectMake(0, 397, w, 290);
        sliderLab.frame = CGRectMake(0, 40, w*1/3, 20);
        slider.frame = CGRectMake(w*1/3, 40, w*10/15, 20);
        timerLab.frame = CGRectMake(0, 80, w*1/3, 20);
        switchView.frame = CGRectMake(310, 75, 76, 28);
        timerImage.frame = CGRectMake(80, 140, 318, 93);
        startLab.frame = CGRectMake(10, 10, 80, 30);
        endLab.frame = CGRectMake(10, 50, 80, 30);
        startTimeIV.frame = CGRectMake(95, 10, 222, 29);
        endTimeIV.frame = CGRectMake(95, 50, 222, 29);
        startTimeLab.frame = CGRectMake(240, 15, 60, 20);
        endTimeLab.frame = CGRectMake(240, 52, 60, 20);
        //startTimeBtn.frame = CGRectMake(95, 10, 140, 22.5);
        btn.frame = CGRectMake(180, 150, 222, 29);
        btn1.frame = CGRectMake(180, 187, 222, 29);
        dateView.frame = CGRectMake(0, 397, w, 275);
        datePickView.frame = CGRectMake(0, 0, w, 216);
        cancelBtn.frame = CGRectMake(83.5, 240, 40, 30);
        doBtn.frame = CGRectMake(290.5, 240, 40, 30);
    }
    settingViewBackground.frame = CGRectMake(0, 0, settingView.frame.size.width, settingView.frame.size.height);
    carStateTime = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(readCarState) userInfo:nil repeats:YES];
    [carStateTime setFireDate:[NSDate distantFuture]];
}

#pragma mark 控制指令
//心跳
-(void)readCarState
{
    [self periperalCmd:@"F401" length:10];
}
//开灯指令
-(void)obsOnButtonAction:(id)sender
{
    if (vehicleControl == 1) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"原车控制已开启，无法控制汽车" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [self periperalCmd:@"F301" length:10];
    float h = [UIScreen mainScreen].bounds.size.height;
    NSString *autoImageName = [NSString stringWithFormat:@"ledON0-%.0f.png",h];
    UIImage *aotuImage = [UIImage imageNamed:autoImageName];
    UIImage *autoImageBtn = [aotuImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [obsOnButton setBackgroundImage:autoImageBtn forState:UIControlStateNormal];//定义背景图片
}

//关灯指令
-(void)obsOffButtonAction:(id)sender
{
    if (vehicleControl == 1) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"原车控制已开启，无法控制汽车" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [self periperalCmd:@"F300" length:10];
    float h = [UIScreen mainScreen].bounds.size.height;
    NSString *autoImageName = [NSString stringWithFormat:@"ledON1-%.0f.png",h];
    UIImage *aotuImage = [UIImage imageNamed:autoImageName];
    UIImage *autoImageBtn = [aotuImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [obsOnButton setBackgroundImage:autoImageBtn forState:UIControlStateNormal];//定义背景图片
}

//auto指令
-(void)obsAutoButtonAction:(id)sender
{
    if (vehicleControl == 1) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"原车控制已开启，无法控制汽车" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    float h = [UIScreen mainScreen].bounds.size.height;
    if (autoSelect == 0) {
        [self periperalCmd:@"F100000001" length:13];
        NSString *autoImageName = [NSString stringWithFormat:@"autoOFF-%.0f.png",h];
        UIImage *aotuImage = [UIImage imageNamed:autoImageName];
        UIImage *autoImageBtn = [aotuImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
        [obsAutoButton setBackgroundImage:autoImageBtn forState:UIControlStateNormal];//定义背景图片
        autoSelect = 1;
        [readRSSITime setFireDate:[NSDate distantFuture]];
    }
    else
    {
        autoSelect = 0;
        NSUserDefaults *startData = [NSUserDefaults standardUserDefaults];
        NSString *startTime = [startData objectForKey:@"StartTime"];
        if (startTime == nil) {
            return;
        }
        NSUserDefaults *endData = [NSUserDefaults standardUserDefaults];
        NSString *endTime = [endData objectForKey:@"EndTime"];
        if (endTime == nil) {
            return;
        }
        int fromHour = [startTime substringWithRange:NSMakeRange(0, 2)].intValue;
        int fromMin = [startTime substringWithRange:NSMakeRange(3, 2)].intValue;
        int endHour = [endTime substringWithRange:NSMakeRange(0, 2)].intValue;
        int endMin = [endTime substringWithRange:NSMakeRange(3, 2)].intValue;
        if ([self isBetweenFromHour:fromHour FromMinute:fromMin toHour:endHour toMinute:endMin]&&isTunnel) {
            [self periperalCmd:@"F101010100" length:13];
        }
        if ([self isBetweenFromHour:fromHour FromMinute:fromMin toHour:endHour toMinute:endMin]&&(isTunnel == NO)) {
            [self periperalCmd:@"F101010000" length:13];
        }
        if (([self isBetweenFromHour:fromHour FromMinute:fromMin toHour:endHour toMinute:endMin]==NO)&&isTunnel) {
            [self periperalCmd:@"F100010100" length:13];
        }
        NSString *autoImageName = [NSString stringWithFormat:@"autoON-%.0f.png",h];
        UIImage *aotuImage = [UIImage imageNamed:autoImageName];
        UIImage *autoImageBtn = [aotuImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
        [obsAutoButton setBackgroundImage:autoImageBtn forState:UIControlStateNormal];//定义背景图片
        [readRSSITime setFireDate:[NSDate distantPast]];
    }
}

//搜索蓝牙设备
-(void)searchBle:(id)sender
{
    if (bleConnectState == 1) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前设备不支持蓝牙4.0或者蓝牙未打开" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else
    {
        self.bleAlertView = [[UIAlertView alloc] initWithTitle:@"搜索蓝牙设备" message:@"蓝牙设备" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        self.bletableView = [[UITableView alloc] initWithFrame:CGRectMake(5.0, 0.0, 200.0, 150.0) style:UITableViewStylePlain];
        self.bletableView.delegate=self;
        self.bletableView.dataSource = self;
        [self.bleAlertView setValue:self.bletableView forKey:@"accessoryView"];
        [self.bleAlertView show];
    }
}

#pragma mark 控制-设置切换

-(void)controlButtonAction:(id)sender
{
    float h = [UIScreen mainScreen].bounds.size.height;
    UIButton *button = (UIButton*)sender;
    if (button.tag == 1000) {
        settingView.hidden = YES;
        dateView.hidden = YES;
        NSString *controlImageName = [NSString stringWithFormat:@"lightico-%.0f.png",h];
        controlBtnIV.image = [UIImage imageNamed:controlImageName];
        controlLab.textColor = [UIColor yellowColor];
        NSString *settingImageName = [NSString stringWithFormat:@"settingico1-%.0f.png",h];
        settingBtnIV.image = [UIImage imageNamed:settingImageName];
        settingLab.textColor = [UIColor whiteColor];
    }
    else
    {
        settingView.hidden = NO;
        NSString *controlImageName = [NSString stringWithFormat:@"lightico1-%.0f.png",h];
        controlBtnIV.image = [UIImage imageNamed:controlImageName];
        controlLab.textColor = [UIColor whiteColor];
        NSString *settingImageName = [NSString stringWithFormat:@"settingico-%.0f.png",h];
        settingBtnIV.image = [UIImage imageNamed:settingImageName];
        settingLab.textColor = [UIColor yellowColor];
    }
}

#pragma mark 其他设置

//设置感应距离
-(void)updataValue:(id)sender
{
    UISlider *slider = (UISlider*)sender;
    RSSIValue = slider.value;
    NSString *rssi = [NSString stringWithFormat:@"%f",RSSIValue];
    NSUserDefaults *defaultsData = [NSUserDefaults standardUserDefaults];
    [defaultsData setObject:rssi forKey:@"LastRSSI"];
}

//时间设置开关
-(void)timerSwtichAction:(id)sender
{
    UISwitch *Switch = (UISwitch*)sender;
    if (Switch.on) {
        timerImage.hidden = NO;
    }
    else
    {
        timerImage.hidden = YES;
    }
}

//时间设置
-(void)chooseTimeAction:(id)sender
{
    if (timerImage.hidden == NO) {
        UIButton *button = (UIButton*)sender;
        if (button.tag == 3001) {
            dateView.hidden = NO;
            timeValue = 1;
        }
        else
        {
            dateView.hidden = NO;
            timeValue = 2;
        }
    }
}

//取消
-(void)cancelAction:(id)sender
{
    dateView.hidden = YES;
}

//确定选择按钮
-(void)doAction:(id)sender
{
    NSInteger firstRow = [datePickView selectedRowInComponent:0];
    NSInteger subRow = [datePickView selectedRowInComponent:1];
    NSString *firstString = [hourAry objectAtIndex:(firstRow%[hourAry count])];
    NSString *subString = [minAry objectAtIndex:(subRow%[minAry count])];
    
    NSString *string = [NSString stringWithFormat:@"%@:%@ >",firstString,subString];
    if (timeValue == 1) {
        startTimeLab.text = string;
        NSUserDefaults *defaultsData = [NSUserDefaults standardUserDefaults];
        [defaultsData setObject:string forKey:@"StartTime"];
    }
    if (timeValue == 2) {
        endTimeLab.text = string;
        NSUserDefaults *defaultsData = [NSUserDefaults standardUserDefaults];
        [defaultsData setObject:string forKey:@"EndTime"];
    }
    dateView.hidden = YES;
}

- (BOOL)isBetweenFromHour:(NSInteger)fromHour FromMinute:(NSInteger)fromMin toHour:(NSInteger)toHour toMinute:(NSInteger)toMin
{
    BOOL isSwap = NO;
    if (fromHour > toHour) {
        NSInteger h;
        NSInteger m;
        h = fromHour;
        fromHour = toHour;
        toHour = h;
        m = fromMin;
        fromMin = toMin;
        toMin = m;
        isSwap = YES;
    }
    if (fromHour == toHour) {
        if (fromMin > toMin) {
            NSInteger m;
            m = fromMin;
            fromMin = toMin;
            toMin = m;
            isSwap = YES;
        }
    }
    NSDate *date8 = [NSDate dateWithTimeInterval:-60 sinceDate:[self getCustomDateWithHour:fromHour andMinute:fromMin]];//[self getCustomDateWithHour:fromHour andMinute:fromMin];
    NSDate *date23 = [NSDate dateWithTimeInterval:+60 sinceDate:[self getCustomDateWithHour:toHour andMinute:toMin]];//[self getCustomDateWithHour:toHour andMinute:toMin];
    NSDate *currentDate = [NSDate date];
    if ([currentDate compare:date8]==NSOrderedDescending && [currentDate compare:date23]==NSOrderedAscending)
    {
        return YES;
    }
    if ([currentDate compare:date8]!=NSOrderedDescending || [currentDate compare:date23]!=NSOrderedAscending) {
        if (isSwap == YES) {
            return YES;
        }
        
    }
    return NO;
}
- (NSDate *)getCustomDateWithHour:(NSInteger)hour andMinute:(NSInteger)minute{
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    [resultComps setMinute:minute];
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [resultCalendar dateFromComponents:resultComps];
}
#pragma mark pickerView

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return [hourAry count]*100;
    }
    else
        return [minAry count]*100;
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0){
        return [hourAry objectAtIndex:(row%[hourAry count])];
    }
    else
        return [minAry objectAtIndex:(row%[minAry count])];
    
}
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:20]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    return pickerLabel;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 45;
}

#pragma mark 蓝牙通信
//蓝牙状态delegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    
    switch (central.state)
    {
        case CBCentralManagerStatePoweredOn:
        {
            [self.centralMgr scanForPeripheralsWithServices:nil options:nil];
            NSLog(@"这在寻找设备。。。");
            bleConnectState = 0;
            
        }
            break;
        default:
        {
            float h = [UIScreen mainScreen].bounds.size.height;
            NSString *bleStateImageName = [NSString stringWithFormat:@"ble4OFF-%.0f.png",h];
            UIImage *bleStateImage = [UIImage imageNamed:bleStateImageName];
            UIImage *bleStateImageBtn = [bleStateImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
            [obsBleStateButton setBackgroundImage:bleStateImageBtn forState:UIControlStateNormal];//定义背景图片
            NSString *stateImageName = [NSString stringWithFormat:@"carlightOFF-%.0f@2x",h];
            carStateIV.image = [UIImage imageNamed:stateImageName];
            NSLog(@"蓝牙未开启或当前设备不支持蓝牙4.0");
            bleConnectState = 1;
        }
            break;
    }
}

//发现设备delegate
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    
    NSUserDefaults *periperalData = [NSUserDefaults standardUserDefaults];
    NSString *uuidString = [periperalData objectForKey:@"UUID"];
    
    BLEInfo *discoveredBLEInfo = [[BLEInfo alloc] init];
    discoveredBLEInfo.discoveredPeripheral = peripheral;
    discoveredBLEInfo.rssi = RSSI;
    
    // update tableview
    [self saveBLE:discoveredBLEInfo];
    
    if ([peripheral.name isEqualToString:@"ADL-579"]&&[peripheral.identifier.UUIDString isEqualToString:uuidString]) {
        self.centralMgr.delegate = self;
        self.discoveredPeripheral=peripheral;
        [self.centralMgr connectPeripheral:peripheral
                                   options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
                                                                       forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
    }
}
//保存设备信息
- (BOOL)saveBLE:(BLEInfo *)discoveredBLEInfo
{
    for (BLEInfo *info in self.bleAry)
    {
        if ([info.discoveredPeripheral.identifier.UUIDString isEqualToString:discoveredBLEInfo.discoveredPeripheral.identifier.UUIDString])
        {
            return NO;
        }
    }
    
    NSLog(@"\nDiscover New Devices!\n");
    NSLog(@"BLEInfo\n UUID：%@\n RSSI:%@\n\n",discoveredBLEInfo.discoveredPeripheral.identifier.UUIDString,discoveredBLEInfo.rssi);
    
    [self.bleAry addObject:discoveredBLEInfo];
    [self.bletableView reloadData];
    return YES;
}

//退出蓝牙
-(void)viewWillDisappear:(BOOL)animated{
    
    // [self.centralMgr cancelPeripheralConnection:_discoveredPeripheral];
}

//连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    float h = [UIScreen mainScreen].bounds.size.height;
    NSString *bleStateImageName = [NSString stringWithFormat:@"ble4OFF-%.0f.png",h];
    UIImage *bleStateImage = [UIImage imageNamed:bleStateImageName];
    UIImage *bleStateImageBtn = [bleStateImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [obsAutoButton setBackgroundImage:bleStateImageBtn forState:UIControlStateNormal];//定义背景图片
}

//连接成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    float h = [UIScreen mainScreen].bounds.size.height;
    NSString *bleStateImageName = [NSString stringWithFormat:@"ble4ON-%.0f.png",h];
    UIImage *bleStateImage = [UIImage imageNamed:bleStateImageName];
    UIImage *bleStateImageBtn = [bleStateImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [obsBleStateButton setBackgroundImage:bleStateImageBtn forState:UIControlStateNormal];//定义背景图片
    [_discoveredPeripheral setDelegate:self];
    [_discoveredPeripheral discoverServices:nil];
    
    readRSSITime = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(detectRSSI) userInfo:nil repeats:YES];
    [carStateTime setFireDate:[NSDate distantPast]];
    
}
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    float h = [UIScreen mainScreen].bounds.size.height;
    NSString *bleStateImageName = [NSString stringWithFormat:@"ble4OFF-%.0f.png",h];
    UIImage *bleStateImage = [UIImage imageNamed:bleStateImageName];
    UIImage *bleStateImageBtn = [bleStateImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [obsBleStateButton setBackgroundImage:bleStateImageBtn forState:UIControlStateNormal];//定义背景图片
    NSString *stateImageName = [NSString stringWithFormat:@"carlightOFF-%.0f@2x",h];
    carStateIV.image = [UIImage imageNamed:stateImageName];
    if (_discoveredPeripheral)
    {
        NSLog(@"connectPeripheral");
        [_centralMgr connectPeripheral:_discoveredPeripheral options:nil];
    }
}

#pragma mark 智能感应

//读取RSSI数据
- (void)detectRSSI {
    _discoveredPeripheral.delegate = self;
    [_discoveredPeripheral readRSSI];
}
- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"%f",fabsf([peripheral.RSSI floatValue]));
    if (fabsf([peripheral.RSSI floatValue]) < RSSIValue ) {
        //处于感应区
        if (RSSIState != 1) {
            RSSIState = 1;
            NSUserDefaults *startData = [NSUserDefaults standardUserDefaults];
            NSString *startTime = [startData objectForKey:@"StartTime"];
            NSUserDefaults *endData = [NSUserDefaults standardUserDefaults];
            NSString *endTime = [endData objectForKey:@"EndTime"];
            int fromHour = [startTime substringWithRange:NSMakeRange(0, 2)].intValue;
            int fromMin = [startTime substringWithRange:NSMakeRange(3, 2)].intValue;
            int endHour = [endTime substringWithRange:NSMakeRange(0, 2)].intValue;
            int endMin = [endTime substringWithRange:NSMakeRange(3, 2)].intValue;
            NSLog(@"当前是否处于感应时间段：(1=处于/0=不处于):%d",[self isBetweenFromHour:fromHour FromMinute:fromMin toHour:endHour toMinute:endMin]);
            if ([self isBetweenFromHour:fromHour FromMinute:fromMin toHour:endHour toMinute:endMin]&&isTunnel) {
                [self periperalCmd:@"F101010100" length:13];
            }
            if ([self isBetweenFromHour:fromHour FromMinute:fromMin toHour:endHour toMinute:endMin]&&(isTunnel == NO)) {
                [self periperalCmd:@"F101010000" length:13];
            }
            if (([self isBetweenFromHour:fromHour FromMinute:fromMin toHour:endHour toMinute:endMin]==NO)&&isTunnel) {
                [self periperalCmd:@"F100010100" length:13];
            }
        }
    }
    if (fabsf([peripheral.RSSI floatValue]) > RSSIValue+10 ) {
        //离开感应区
        if (RSSIState == 1) {
            RSSIState = 0;
            // NSLog(@"RSSS:%d",RSSIState);
            [self periperalCmd:@"F100000000" length:13];
            if (vehicleControl == 1) {
                [self notification:@"原车控制打开，离开感应区"];
            }
        }
    }
}

#pragma mark 服务UUID+特征UUID

//发现服务UUID+特征UUID
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error)
    {
        NSLog(@"didDiscoverServices : %@", [error localizedDescription]);
        return;
    }
    for (CBService *s in peripheral.services)
    {
        NSLog(@"Service found with UUID : %@", s.UUID);
        [s.peripheral discoverCharacteristics:nil forService:s];
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    [readRSSITime setFireDate:[NSDate distantPast]];
    if (error)
    {
        NSLog(@"didDiscoverCharacteristicsForService error : %@", [error localizedDescription]);
        return;
    }
    
    for (CBCharacteristic *c in service.characteristics)
    {
        //FFF1特征：发送数据控制硬件端
        if([c.UUID isEqual:[CBUUID UUIDWithString:@"FFE1"]]){
            self.writeCharacteristic = c;
            [_discoveredPeripheral setNotifyValue:YES forCharacteristic:c];
            NSUserDefaults *defaultsData = [NSUserDefaults standardUserDefaults];
            [defaultsData setObject:peripheral.identifier.UUIDString forKey:@"UUID"];
            NSUserDefaults *startData = [NSUserDefaults standardUserDefaults];
            NSString *startTime = [startData objectForKey:@"StartTime"];
            if (startTime == nil) {
                return;
            }
            NSUserDefaults *endData = [NSUserDefaults standardUserDefaults];
            NSString *endTime = [endData objectForKey:@"EndTime"];
            if (endTime == nil) {
                return;
            }
            int fromHour = [startTime substringWithRange:NSMakeRange(0, 2)].intValue;
            int fromMin = [startTime substringWithRange:NSMakeRange(3, 2)].intValue;
            int endHour = [endTime substringWithRange:NSMakeRange(0, 2)].intValue;
            int endMin = [endTime substringWithRange:NSMakeRange(3, 2)].intValue;
            if ([self isBetweenFromHour:fromHour FromMinute:fromMin toHour:endHour toMinute:endMin]&&isTunnel) {
                [self periperalCmd:@"F101010100" length:13];
            }
            if ([self isBetweenFromHour:fromHour FromMinute:fromMin toHour:endHour toMinute:endMin]&&(isTunnel == NO)) {
                [self periperalCmd:@"F101010000" length:13];
            }
            if (([self isBetweenFromHour:fromHour FromMinute:fromMin toHour:endHour toMinute:endMin]==NO)&&isTunnel) {
                [self periperalCmd:@"F100010100" length:13];
            }
        }
    }
}

#pragma mark 数据读取
//读取蓝牙数据

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        NSLog(@"Error updating value for characteristic %@ error: %@", characteristic.UUID, [error localizedDescription]);
        return;
    }
    NSLog(@"收到的数据：%@,uuid %@,",characteristic.value,characteristic.UUID);
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE1"]]) {
        if (characteristic.value.length < 6) {
            return;
        }
        //截取汽车蓝牙ID
        if ([[characteristic.value subdataWithRange:NSMakeRange(6, 1)] isEqualToData:[self stringToByte:@"F0"]]) {
            self.periperalID = [characteristic.value subdataWithRange:NSMakeRange(7, 4)];
            NSUserDefaults *defaultsData = [NSUserDefaults standardUserDefaults];
            [defaultsData setObject:self.periperalID forKey:@"periperalID"];
            [self adaptationBle];
            if (bleSetDone == 0) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"绑定设备成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                bleSetDone = 1;
            }
        }
        //车身状态数据
        //ff000002 3203f200 000129
        float h = [UIScreen mainScreen].bounds.size.height;
        if ([[characteristic.value subdataWithRange:NSMakeRange(6, 1)] isEqualToData:[self stringToByte:@"F2"]]) {
            bleSetDone = 0;
            NSData *carLightData = [characteristic.value subdataWithRange:NSMakeRange(7, 1)];
            if ([carLightData isEqualToData:[self stringToByte:@"00"]]) {
                //车灯关闭
                NSLog(@"1");
                NSString *stateImageName = [NSString stringWithFormat:@"carlightOFF-%.0f@2x",h];
                carStateIV.image = [UIImage imageNamed:stateImageName];
            }
            if ([carLightData isEqualToData:[self stringToByte:@"01"]]) {
                //车灯打开
                NSString *stateImageName = [NSString stringWithFormat:@"carlightON-%.0f@2x",h];
                carStateIV.image = [UIImage imageNamed:stateImageName];
            }
            NSData *carCmdData = [characteristic.value subdataWithRange:NSMakeRange(8, 1)];
            if ([carCmdData isEqualToData:[self stringToByte:@"00"]]) {
                //原车控制关闭
                [readRSSITime setFireDate:[NSDate distantPast]];
                
                vehicleControl = 0;
            }
            if ([carCmdData isEqualToData:[self stringToByte:@"01"]]) {
                //原车控制打开 无法控制
                float h = [UIScreen mainScreen].bounds.size.height;
                NSString *onImageName = [NSString stringWithFormat:@"ledON1-%.0f.png",h];
                UIImage *onImage = [UIImage imageNamed:onImageName];
                UIImage *onImageBtn = [onImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
                [obsOnButton setBackgroundImage:onImageBtn forState:UIControlStateNormal];//定义背景图片
                NSString *autoImageName = [NSString stringWithFormat:@"autoOFF-%.0f.png",h];
                UIImage *aotuImage = [UIImage imageNamed:autoImageName];
                UIImage *autoImageBtn = [aotuImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
                [obsAutoButton setBackgroundImage:autoImageBtn forState:UIControlStateNormal];//定义背景图片
                autoSelect = 1;
                [readRSSITime setFireDate:[NSDate distantFuture]];
                vehicleControl = 1;
            }
            /*NSData *carPowerData = [characteristic.value subdataWithRange:NSMakeRange(9, 1)];
             if ([carPowerData isEqualToData:[self stringToByte:@"00"]]) {
             //电源电量充足
             
             }
             if ([carPowerData isEqualToData:[self stringToByte:@"01"]]) {
             //电源电量低
             
             }
             if ([carPowerData isEqualToData:[self stringToByte:@"02"]]) {
             //电源电量严重不足
             
             }
             if ([carPowerData isEqualToData:[self stringToByte:@"04"]]) {
             //充电中
             
             }*/
        }
    }
}

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    
}

#pragma mark 蓝牙指令发送

//转NSData
-(NSData*)stringToByte:(NSString*)string
{
    NSString *hexString=[[string uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([hexString length]%2!=0) {
        return nil;
    }
    Byte tempbyt[1]={0};
    NSMutableData* bytes=[NSMutableData data];
    for(int i=0;i<[hexString length];i++)
    {
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            return nil;
        i++;
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            return nil;
        tempbyt[0] = int_ch1+int_ch2;  ///将转化后的数放入Byte数组里
        [bytes appendBytes:tempbyt length:1];
    }
    return bytes;
}

//指令发送
-(void)periperalCmd:(NSString*)state length:(int)length
{
    if(!_writeCharacteristic){
        NSLog(@"writeCharacteristic is nil!");
        return;
    }
    NSUserDefaults *periperalData = [NSUserDefaults standardUserDefaults];
    NSData *data = [periperalData objectForKey:@"periperalID"];
    if (data.length <= 0) {
        return;
    }
    NSData *stateData = [self stringToByte:state];
    Byte *byte = (Byte*)[data bytes];
    Byte *byte1 = (Byte*)[stateData bytes];
    Byte carByte[length];
    int checkSum = 0;
    carByte[0] = 0xff;
    for (int i = 0; i  < 4; i++) {
        checkSum += byte[i];
        carByte[i+1] = byte[i];
    }
    carByte[5] = length-8;
    checkSum += carByte[5];
    for (int i = 0; i < length-7; i++) {
        checkSum += byte1[i];
        carByte[i+6] = byte1[i];
    }
    NSString *hexCheckSum = [NSString stringWithFormat:@"%x",checkSum];
    if (hexCheckSum.length == 1) {
        hexCheckSum = [NSString stringWithFormat:@"000%@",hexCheckSum];
    }
    if (hexCheckSum.length == 2) {
        hexCheckSum = [NSString stringWithFormat:@"00%@",hexCheckSum];
    }
    if (hexCheckSum.length == 3) {
        hexCheckSum = [NSString stringWithFormat:@"0%@",hexCheckSum];
    }
    NSData *checkSumData = [self stringToByte:hexCheckSum];
    Byte *byte2 = (Byte*)[checkSumData bytes];
    carByte[length-2] = byte2[0];
    carByte[length-1] = byte2[1];
    NSData *msgdata = [NSData dataWithBytes:carByte length:length];
    NSLog(@"%@",msgdata);
    [_discoveredPeripheral writeValue:msgdata forCharacteristic:_writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

//适配蓝牙
-(void)adaptationBle{
    if(!_writeCharacteristic){
        NSLog(@"writeCharacteristic is nil!");
        return;
    }
    NSUserDefaults *periperalData = [NSUserDefaults standardUserDefaults];
    NSData *data = [periperalData objectForKey:@"periperalID"];
    if (data.length <= 0) {
        return;
    }
    int length = 13;
    Byte *byte = (Byte*)[data bytes];
    Byte carByte[length];
    int checkSum = 0;
    carByte[0] = 0xff;
    for (int i = 0; i  < 4; i++) {
        checkSum += byte[i];
        carByte[i+1] = byte[i];
    }
    carByte[5] = length-8;
    checkSum += carByte[5];
    carByte[6] = 0xF0;
    checkSum += carByte[6];
    for (int i = 0; i < 4; i++) {
        checkSum += byte[i];
        carByte[i+7] = byte[i];
    }
    NSString *hexCheckSum = [NSString stringWithFormat:@"%x",checkSum];
    if (hexCheckSum.length == 1) {
        hexCheckSum = [NSString stringWithFormat:@"000%@",hexCheckSum];
    }
    if (hexCheckSum.length == 2) {
        hexCheckSum = [NSString stringWithFormat:@"00%@",hexCheckSum];
    }
    if (hexCheckSum.length == 3) {
        hexCheckSum = [NSString stringWithFormat:@"0%@",hexCheckSum];
    }
    NSData *checkSumData = [self stringToByte:hexCheckSum];
    Byte *byte2 = (Byte*)[checkSumData bytes];
    carByte[length-2] = byte2[0];
    carByte[length-1] = byte2[1];
    NSData *msgdata = [NSData dataWithBytes:carByte length:length];
    NSLog(@"1111:%@",msgdata);
    [_discoveredPeripheral writeValue:msgdata forCharacteristic:_writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

//向peripheral中写入数据后的回调函数
- (void)peripheral:(CBPeripheral*)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    NSLog(@"写入数据成功:%@",characteristic);
}

#pragma mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bleAry.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"dequcell"];
        BLEInfo *thisBLEInfo=[self.bleAry objectAtIndex:indexPath.row];
        cell.textLabel.text=[NSString stringWithFormat:@"%@ %@",thisBLEInfo.discoveredPeripheral.name,thisBLEInfo.rssi];
        cell.detailTextLabel.text=[NSString stringWithFormat:@"UUID:%@",thisBLEInfo.discoveredPeripheral.identifier.UUIDString];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.discoveredPeripheral != nil)
    {
        NSLog(@"disConnect start");
        [self.centralMgr cancelPeripheralConnection:self.discoveredPeripheral];
    }
    [self.bleAlertView dismissWithClickedButtonIndex:0 animated:YES];//触发dismiss
    BLEInfo *thisBLEInfo=[self.bleAry objectAtIndex:indexPath.row];
    self.centralMgr.delegate = self;
    self.discoveredPeripheral=thisBLEInfo.discoveredPeripheral;
    [self.centralMgr connectPeripheral:thisBLEInfo.discoveredPeripheral
                               options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
                                                                   forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
    
}
#pragma mark 本地通知
-(void)notification:(NSString*)string
{//定义本地通知对象
    UILocalNotification *notification=[[UILocalNotification alloc]init];
    //设置调用时间
    notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:1];//通知触发的时间，10s以后
    notification.repeatInterval=2;//通知重复次数
    //notification.repeatCalendar=[NSCalendar currentCalendar];//当前日历，使用前最好设置时区等信息以便能够自动同步时间
    
    //设置通知属性
    notification.alertBody=string; //通知主体
    notification.applicationIconBadgeNumber=1;//应用程序图标右上角显示的消息数
    notification.alertAction=@"打开"; //待机界面的滑动动作提示
    //notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
    notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
    //调用通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
