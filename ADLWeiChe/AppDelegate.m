//
//  AppDelegate.m
//  ADLWeiChe
//
//  Created by icePhoenix on 15/6/3.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//mmmmmmm

#import "AppDelegate.h"
#import <AMapSearchKit/AMapSearchAPI.h>
#import "ViewController.h"
#import "CoreNewFeatureVC.h"
#import "CALayer+Transition.h"
#import "UserDefaults.h"
#import "GCDAsyncSocket.h"
#import "CSqlite.h"
#import "GpsPoint.h"
#import "CarState.h"
#import "ControlReslut.h"
#import "address.h"

@interface AppDelegate ()<AMapSearchDelegate>
{
    GCDAsyncSocket *scoket;//定义TCPIP通信Scoket
    NSString *IPAddress;
    NSString *port;
    CSqlite *m_sqlite;
    
     AMapSearchAPI *_search;
    
    //记录上一次的经纬度数据
    float lastLat;
    float lastlon;
    
    BOOL moveState;
    int scoketCount;
    NSTimer *countTimer;
}
@end

@implementation AppDelegate
@synthesize isLogin;
@synthesize isLoginOff;
//计算大头针偏移角度
-(double)LoctionAngle:(float)startlat startLon:(float)startlon endLat:(float)endlat endLon:(float)endlon
{
    float lat = endlat - startlat;
    float lon = endlon - startlon;
    
    double cosAngle;
    //如果位置没有发生改变，就保持原来的角度不变
    if (sqrt(lat*lat+lon*lon) == 0) {
      //  cosAngle = lastAngle;
    }
    else
    {
        float angle = lon/sqrt(lat*lat+lon*lon);
        cosAngle = acos(angle);
        if (lat < 0) {
            cosAngle = cosAngle + M_PI/2;
        }
        //lastAngle = cosAngle;
    }
    return cosAngle;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *noteSetting =[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound
                                                                                   categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:noteSetting];
    }
    
    moveState = NO;
    self.isLoginOff = NO;
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
   
    //定义引导页
    BOOL isFristUserApp = NO;//判断程序是否首次使用
    NSDictionary *dic = [UserDefaults readUserDefaults:@"fristUseApp"];
    if (dic == nil) {
        isFristUserApp = YES;
    }
    if (isFristUserApp) {
        NewFeatureModel *m1 = [NewFeatureModel model:[UIImage imageNamed:@"f1.jpg"]];
        NewFeatureModel *m2 = [NewFeatureModel model:[UIImage imageNamed:@"f2.jpg"]];
        NewFeatureModel *m3 = [NewFeatureModel model:[UIImage imageNamed:@"f3.jpg"]];
        self.window.rootViewController = [CoreNewFeatureVC newFeatureVCWithModels:@[m1,m2,m3] enterBlock:^{
        [self enter];
            
        }];
    }
    else
    {
        [self enter];
    }
    [self.window makeKeyAndVisible];
    lastLat = 0.0f;
    lastlon = 0.0f;
    m_sqlite = [[CSqlite alloc]init];
    [m_sqlite openSqlite];
    [self connect];
    scoketCount = 0;
    countTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(numCount) userInfo:nil repeats:YES];
    [countTimer setFireDate:[NSDate distantFuture]];
    return YES;
}

-(void)enter
{
    ViewController *vc = [[ViewController alloc] init];
    self.window.rootViewController = vc;
    [self.window.layer transitionWithAnimType:TransitionAnimTypeRamdom subType:TransitionSubtypesFromRamdom curve:TransitionCurveRamdom duration:2.0f];
    NSDictionary *used = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"YES", nil]forKeys:[NSArray arrayWithObjects:@"used", nil]];
    [UserDefaults saveUserDefaults:used :@"fristUseApp"];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark Scoket通信

//初始化scoket
-(void)connect{
   // @"127.0.0.1";
    IPAddress = @"127.0.0.1";//@"dev.adlssc.com";
    port = @"8233";
    scoket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *err = nil;
    if(![scoket connectToHost:IPAddress onPort:[port intValue] error:&err])
    {
        
    }
    else
    {
        [scoket connectToHost:IPAddress onPort:[port intValue] error:&err];
    }
}

//连接服务器成功
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"1");
    [countTimer setFireDate:[NSDate distantFuture]];
    [scoket readDataWithTimeout:-1 tag:0];
    [self Recicer];
}

//断开服务器
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"2");
    [countTimer setFireDate:[NSDate distantPast]];
}

-(void)numCount
{
    scoketCount++;
    if (scoketCount > 10) {
        scoketCount = 0;
        [self connect];
    }
}
//发送连接指令
-(void)Recicer{
    [self carCommand:@"PL" control:nil length:18];
}

//控制指令
-(void)carCommand:(NSString*)type control:(NSString*)controlStr length:(int)length
{
    Byte byte[length];
    byte[0] = 0x54;
    byte[1] = 0x45;
    byte[2] = 0x53;
    byte[3] = 0x54;
    //5~6位为控制类型
    for (int i = 0; i < 2; i++) {
        char typeChar = [type characterAtIndex:i];
        byte[4+i] = (int)typeChar;
    }
    if (controlStr != nil) {
        NSString *controlTy = [controlStr substringToIndex:controlStr.length-2];
        NSString *controlTi = [controlStr substringFromIndex:controlStr.length-2];
        byte[6] = controlTy.intValue;
        byte[7] = controlTi.intValue;
    }
    //时间戳的生成
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    NSInteger h = [comps hour];
    NSInteger m = [comps minute];
    NSInteger s = [comps second];
    NSString *hStr;
    NSString *mStr;
    NSString *sStr;
    hStr = [NSString stringWithFormat:@"%ld",(long)h];
    mStr = [NSString stringWithFormat:@"%ld",(long)m];
    sStr = [NSString stringWithFormat:@"%ld",(long)s];
    if (h < 10) {
        hStr = [NSString stringWithFormat:@"0%ld",(long)h];
    }
    if (m < 10) {
        mStr = [NSString stringWithFormat:@"0%ld",(long)m];
    }
    if (s < 10) {
        sStr = [NSString stringWithFormat:@"0%ld",(long)s];
    }
    NSString *timeStr = [NSString stringWithFormat:@"%@%@%@000",hStr,mStr,sStr];
    for (int i = 0; i < 9; i++)
    {
        char timeType = [timeStr characterAtIndex:i];
        byte[length-12+i] = (int)timeType;
    }
    byte[length-3] = 0x55;
    byte[length-2] = 0x00;
    byte[length-1] = 0x00;
    NSData *msgdata = [NSData dataWithBytes:byte length:length];
    [self sendMsg:msgdata];
}

//发送指令
-(void)sendMsg:(NSData*)data
{
    [scoket writeData:data withTimeout:-1 tag:0];
    [scoket readDataWithTimeout:-1 tag:0];
}

//接收数据函数
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"msg=%@",message);
    [self doMsg:message];
    [scoket readDataWithTimeout:-1 tag:0];
}

//处理scoket接受到的数据
-(void)doMsg:(NSString*)message
{
    if (message != nil)
    {
        double msgTag = -1;
        NSString *tagString;
        while (message.length > 5)
        {
            NSString *tag = [message substringWithRange:NSMakeRange(5, 1)];
            if ([tag isEqualToString:@"M"])
            {
                NSString *str = [message substringWithRange:NSMakeRange(0, 25)];
                message = [message substringFromIndex:25];
                char charTag1 = [str characterAtIndex:23];
                char charTag2 = [str characterAtIndex:24];
                double tagNum;
                tagNum = (int)charTag1*1000+(int)charTag2;
                if (tagNum > msgTag) {
                    if (tagNum == 255*1000+255) {
                        tagNum = -1;
                    }
                    msgTag = tagNum;
                    tagString = str;
                }
            }
            if ([tag isEqualToString:@"G"]) {
                NSString *latInteger = [message substringWithRange:NSMakeRange(7, 2)];
                NSString *latDecimal = [message substringWithRange:NSMakeRange(9, 7)];
                NSString *latStr = [NSString stringWithFormat:@"%f",latInteger.intValue+latDecimal.floatValue/60];
                if (![[message substringWithRange:NSMakeRange(16, 1)]isEqualToString:@"N"]) {
                    latStr = [NSString stringWithFormat:@"-%@",latStr];
                }
                NSString *lonInteger = [message substringWithRange:NSMakeRange(17, 3)];
                NSString *lonDecimal = [message substringWithRange:NSMakeRange(20, 7)];
                NSString *lonStr = [NSString stringWithFormat:@"%f",lonInteger.intValue+lonDecimal.floatValue/60];
                if (![[message substringWithRange:NSMakeRange(27, 1)]isEqualToString:@"E"]) {
                    latStr = [NSString stringWithFormat:@"-%@",latStr];
                }
                if ([self LantitudeLongitudeDist:lonStr.floatValue other_Lat:latStr.floatValue self_Lon:lastlon self_Lat:lastLat] > 200) {
                    int TenLat=0;
                    int TenLog=0;
                    TenLat = (int)(latStr.floatValue*10);
                    TenLog = (int)(lonStr.floatValue*10);
                    NSString *sql = [[NSString alloc]initWithFormat:@"select offLat,offLog from gpsT where lat=%d and log = %d",TenLat,TenLog];
                    sqlite3_stmt* stmtL = [m_sqlite NSRunSql:sql];
                    int offLat=0;
                    int offLog=0;
                    while (sqlite3_step(stmtL)==SQLITE_ROW)
                    {
                        offLat = sqlite3_column_int(stmtL, 0);
                        offLog = sqlite3_column_int(stmtL, 1);
                    }
                    float latitude = latStr.floatValue+offLat*0.0001;
                    float longitude = lonStr.floatValue + offLog*0.0001;
                    GpsPoint *gpsPoint = [GpsPoint gpsPointInstance];
                    gpsPoint.longitude = longitude;
                    gpsPoint.latitude = latitude;
                    lastLat = latitude;
                    lastlon = longitude;
                    NSString *latStr = [NSString stringWithFormat:@"%f",latitude];
                    NSString *lonStr = [NSString stringWithFormat:@"%f",longitude];
                    NSDictionary *dicGps = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:latStr,lonStr, nil]forKeys:[NSArray arrayWithObjects:@"lat",@"lon", nil]];
                    [UserDefaults saveUserDefaults:dicGps :@"lastGps"];
                    NSString *moveFlag = [message substringWithRange:NSMakeRange(40, 1)];
                    if ([moveFlag isEqualToString:@"0"]&&(moveState == NO)) {
                        [self reGeocoding:latitude lon:longitude];
                        moveState = YES;
                    }
                    if ([moveFlag isEqualToString:@"1"]) {
                        moveState = NO;
                    }
                }
                message = [message substringFromIndex:49];
            }
            if ([tag isEqualToString:@"T"]) {
                message = [message substringFromIndex:11];
            }
            if ([tag isEqualToString:@"R"]) {
                ControlReslut *controlReslut = [ControlReslut controlReslutInstance];
                controlReslut.type = 1;
                message = [message substringFromIndex:20];
            }
            if ([tag isEqualToString:@"E"]) {
                //设置成功
                message = [message substringFromIndex:15];
            }
            if ([tag isEqualToString:@"L"]) {
                message = [message substringFromIndex:18];
            }
            else
            {
                break;
            }
        }
        if (tagString != nil) {
            CarState *carState = [CarState instance];
            carState.stateString = tagString;
        }
    }
}

//计算两点之间的距离
-(double) LantitudeLongitudeDist:(double)lon1 other_Lat:(double)lat1 self_Lon:(double)lon2 self_Lat:(double)lat2{
    double er = 6378137;
    double radlat1 = M_PI*lat1/180.0f;
    double radlat2 = M_PI*lat2/180.0f;
    //now long.
    double radlong1 = M_PI*lon1/180.0f;
    double radlong2 = M_PI*lon2/180.0f;
    if( radlat1 < 0 ) radlat1 = M_PI/2 + fabs(radlat1);// south
    if( radlat1 > 0 ) radlat1 = M_PI/2 - fabs(radlat1);// north
    if( radlong1 < 0 ) radlong1 = M_PI*2 - fabs(radlong1);//west
    if( radlat2 < 0 ) radlat2 = M_PI/2 + fabs(radlat2);// south
    if( radlat2 > 0 ) radlat2 = M_PI/2 - fabs(radlat2);// north
    if( radlong2 < 0 ) radlong2 = M_PI*2 - fabs(radlong2);// west
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
#pragma mark 逆地理编码
-(void)reGeocoding:(CGFloat)lat lon:(CGFloat)lon
{
    _search = [[AMapSearchAPI alloc] initWithSearchKey:@"d4713afc15d2a328b4242f24011dfdc8" Delegate:self];
    
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoRequest.searchType = AMapSearchType_ReGeocode;
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:lat longitude:lon];
    regeoRequest.radius = 10000;
    regeoRequest.requireExtension = YES;
    
    //发起逆地理编码
    [_search AMapReGoecodeSearch: regeoRequest];
}

//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    NSString *adrString;
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode];
        
        int i = 0;
        int j = 0;
        int k = 0;
        int mark = 0;
        while (mark == 0) {
            NSString *str1 = [result substringWithRange:NSMakeRange(i, 8)];
            if ([str1 isEqualToString:@"address:"]) {
                j = i + 9;
            }
            NSString *str2 = [result substringWithRange:NSMakeRange(i, 18)];
            if ([str2 isEqualToString:@", addressComponent"]) {
                k = i - 1;
                mark = 1;
            }
            i++;
        }
        adrString = [result substringWithRange:NSMakeRange(j, k-j+1)];
        address *adr = [address initAdrs];
        adr.adrs = adrString;
    }
}

@end
