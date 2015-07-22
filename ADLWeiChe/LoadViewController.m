//
//  LoadViewController.m
//  ADLWeiChe
//
//  Created by icePhoenix on 15/6/4.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//

#import "LoadViewController.h"
#import "myLoadingView.h"
#import "TrackingViewController.h"

@interface LoadViewController ()
{
    myLoadingView *loadingView;
    BOOL isNeedLoad;
}
@end

@implementation LoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isNeedLoad = YES;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
    
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    
    [navigationItem setTitle:@"行车轨迹"];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    //把导航栏集合添加入导航栏中，设置动画关闭
    navigationItem.leftBarButtonItem = leftButton;
    navigationBar.tintColor = [UIColor colorWithRed:0.584f green:0.584f blue:0.584f alpha:1.0f];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    
    [self.view addSubview:navigationBar];
    
    // Do any additional setup after loading the view from its nib.
    
    UIView *carInfo = [[UIView alloc]initWithFrame:CGRectMake(0, 65, 320, 80)];
    carInfo.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:carInfo];
    
    UIImageView *carBrandIV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 27.5, 25, 25)];
    carBrandIV.image = [UIImage imageNamed:@"dazhong.png"];
    [carInfo addSubview:carBrandIV];
    
    UILabel *carNOLab = [[UILabel alloc]initWithFrame:CGRectMake(45, 5, 100, 30)];
    carNOLab.text = @"粤A95503";
    carNOLab.font = [UIFont systemFontOfSize:14.0f];
    carNOLab.textColor = [UIColor colorWithRed:0.0f green:0.6f blue:0.0f alpha:1.0f];
    [carInfo addSubview:carNOLab];
    
    UILabel *carOilLab = [[UILabel alloc]initWithFrame:CGRectMake(45, 35, 100, 20)];
    carOilLab.text = @"耗油量：0.4L";
    carOilLab.font = [UIFont systemFontOfSize:10.0f];
    carOilLab.textColor = [UIColor colorWithRed:192/255 green:192/255 blue:192/255 alpha:1.0f];
    [carInfo addSubview:carOilLab];
    
    UILabel *carConst = [[UILabel alloc]initWithFrame:CGRectMake(45, 55, 100, 20)];
    carConst.text = @"参考油费：2.5元";
    carConst.font = [UIFont systemFontOfSize:10.0f];
    carConst.textColor = [UIColor colorWithRed:192/255 green:192/255 blue:192/255 alpha:1.0f];
    [carInfo addSubview:carConst];
    
    UILabel *carKm = [[UILabel alloc]initWithFrame:CGRectMake(145, 35, 100, 20)];
    carKm.text = @"行驶里程：2.8km";
    carKm.font = [UIFont systemFontOfSize:10.0f];
    carKm.textColor = [UIColor colorWithRed:192/255 green:192/255 blue:192/255 alpha:1.0f];
    [carInfo addSubview:carKm];
    
    UILabel *carOilAvg = [[UILabel alloc]initWithFrame:CGRectMake(145, 55, 150, 20)];
    carOilAvg.text = @"平均耗油：14.3L/100km";
    carOilAvg.font = [UIFont systemFontOfSize:10.0f];
    carOilAvg.textColor = [UIColor colorWithRed:192/255 green:192/255 blue:192/255 alpha:1.0f];
    [carInfo addSubview:carOilAvg];
    
    
    float h = [UIScreen mainScreen].bounds.size.height;
    UIView *dateView = [[UIView alloc]initWithFrame:CGRectMake(0, h-60, 320, 60)];
    dateView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:dateView];
    
    UIButton *lastDateBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    lastDateBtn.frame = CGRectMake(15, 15, 50, 30);
    [lastDateBtn setTitle:@"上一日" forState:UIControlStateNormal];
    [lastDateBtn addTarget:self action:@selector(lastDateAction:) forControlEvents:UIControlEventTouchUpInside];
    [dateView addSubview:lastDateBtn];
    
    UIButton *nextDateBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nextDateBtn.frame = CGRectMake(255, 15, 50, 30);
    [nextDateBtn setTitle:@"下一日" forState:UIControlStateNormal];
    [nextDateBtn addTarget:self action:@selector(nextDateAction:) forControlEvents:UIControlEventTouchUpInside];
    [dateView addSubview:nextDateBtn];
    
    dateLab = [[UILabel alloc]initWithFrame:CGRectMake(110, 15, 100, 30)];
    dateLab.textAlignment = NSTextAlignmentCenter;
    [dateView addSubview:dateLab];
    [self nowDate];
    
    UIButton *dateBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    dateBtn.frame = CGRectMake(110, 15, 100, 30);
    [dateBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [dateBtn addTarget:self action:@selector(dateTimeAction:) forControlEvents:UIControlEventTouchUpInside];
    dateBtn.backgroundColor = [UIColor clearColor];
    [dateView addSubview:dateBtn];
    
    trajectTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 146, 320, 320)];
    trajectTable.delegate = self;
    trajectTable.dataSource = self;
    trajectTable.backgroundColor = [UIColor clearColor];
    trajectTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:trajectTable];
    
    loadingView = [[myLoadingView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    loadingView.hidden = NO;
    [self.view addSubview:loadingView];
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    if (isNeedLoad) {
        loadingView.hidden = NO;
        NSString *gpsUrlString = @"http://dev.adlssc.com:8080/ADLRestful/rest/ums/getGpsRecords/hexCarDeviceID=68686868&date=2015-07-09";
        NSURL *gpsUrl = [NSURL URLWithString:gpsUrlString];
        NSString *gpsJson = [NSString stringWithContentsOfURL:gpsUrl encoding:NSUTF8StringEncoding error:nil];
        [self GPSPointJson:gpsJson];
        [trajectTable reloadData];
        loadingView.hidden = YES;
        isNeedLoad = NO;
    }
   
}

-(void)dateTimeAction:(id)sender
{
    [self drawDateView];
}
-(void)lastDateAction:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSTimeInterval  interval =24*60*60*1; //1:天数
    timeDate = [timeDate dateByAddingTimeInterval:-interval];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateLab.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:timeDate]];
}
-(void)nextDateAction:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSTimeInterval  interval =24*60*60*1; //1:天数
    timeDate = [timeDate dateByAddingTimeInterval:+interval];
    NSDate *nowDate = [NSDate date];
    if ([timeDate timeIntervalSinceDate:nowDate]>0.0) {
        timeDate = [timeDate dateByAddingTimeInterval:-interval];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您选择的时间有误，请重新选择！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        dateLab.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:timeDate]];
    }
}
-(void)nowDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    timeDate = [NSDate date];
    // NSTimeInterval  interval =24*60*60*1; //1:天数
    //NSDate*date1 = [nowDate initWithTimeIntervalSinceNow:+interval];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateLab.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:timeDate]];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [sArray count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
    }
    
    for (int i=0; i<[sArray count]; i++) {
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        if (i == indexPath.row) {
            UIView *startView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 39.5)];
            startView.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:startView];
            
            UIImageView *startIV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 7.5, 20, 25)];
            startIV.image = [UIImage imageNamed:@"location_icon_start.png"];
            [startView addSubview:startIV];
            
            UILabel *startTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(45, 0, 150, 20)];
            startTimeLab.text = [sArray objectAtIndex:indexPath.row];
            startTimeLab.textColor = [UIColor colorWithRed:0.0f green:0.6f blue:0.0f alpha:1.0f];
            startTimeLab.font = [UIFont systemFontOfSize:12.0f];
            [startView addSubview:startTimeLab];
            
            UILabel *startAddressLab = [[UILabel alloc]initWithFrame:CGRectMake(45, 20, 150, 20)];
            startAddressLab.text = [startAddressArray objectAtIndex:indexPath.row];
            startAddressLab.font = [UIFont systemFontOfSize:12.0f];
            [startView addSubview:startAddressLab];
            
            UIView *endView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, 200, 39.5)];
            endView.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:endView];
            
            UIImageView *endIV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 7.5, 20, 25)];
            endIV.image = [UIImage imageNamed:@"location_icon_end.png"];
            [endView addSubview:endIV];
            
            UILabel *endTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(45, 0, 150, 20)];
            endTimeLab.text = [eArray objectAtIndex:indexPath.row];
            endTimeLab.textColor = [UIColor colorWithRed:0.0f green:0.6f blue:0.0f alpha:1.0f];
            endTimeLab.font = [UIFont systemFontOfSize:12.0f];
            [endView addSubview:endTimeLab];
            
            UILabel *endAddressLab = [[UILabel alloc]initWithFrame:CGRectMake(45, 20, 150, 20)];
            endAddressLab.text =[endAddressArray objectAtIndex:indexPath.row];
            endAddressLab.font = [UIFont systemFontOfSize:12.0f];
            [endView addSubview:endAddressLab];
            
            UIView *kmView = [[UIView alloc]initWithFrame:CGRectMake(201, 0, 119, 79.5)];
            kmView.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:kmView];
            
            UIImageView *kmIV = [[UIImageView alloc]initWithFrame:CGRectMake(40, 5, 40, 40)];
            kmIV.image = [UIImage imageNamed:@"location_length_stay.png"];
            [kmView addSubview:kmIV];
            
            UILabel *kmLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, 100, 30)];
            kmLab.textAlignment = NSTextAlignmentCenter;
            kmLab.font = [UIFont systemFontOfSize:12.0f];
            kmLab.text =[kmArray objectAtIndex:indexPath.row];
            [kmView addSubview:kmLab];
        }
        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        
        longPressGR.minimumPressDuration = 1;
        
        [self.view addGestureRecognizer:longPressGR];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrackingViewController *trackingVC = [[TrackingViewController alloc]init];
    trackingVC.gpsArray = [self doGPSPointString:[GPSPointArray objectAtIndex:indexPath.row]];
    [self presentViewController:trackingVC animated:YES completion:nil];
}
-(void)drawDateView
{
    datePickView = [[UIView alloc]initWithFrame:CGRectMake(0, 300, 320, 300)];
    datePickView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:datePickView];
    
    UIView *backViwe = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    backViwe.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [datePickView addSubview:backViwe];
    
    UIButton *cancelDate = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelDate.frame = CGRectMake(25, 0, 80, 40);
    cancelDate.tag = 2001;
    //cancelDate.backgroundColor = [UIColor whiteColor];
    [cancelDate setTitle:@"取消" forState:UIControlStateNormal];
    [cancelDate addTarget:self action:@selector(dateViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [backViwe addSubview:cancelDate];
    
    UIButton *chooseDate = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    chooseDate.frame = CGRectMake(215, 0, 80, 40);
    chooseDate.tag = 2002;
    //chooseDate.backgroundColor = [UIColor whiteColor];
    [chooseDate setTitle:@"确定" forState:UIControlStateNormal];
    [chooseDate addTarget:self action:@selector(dateViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [backViwe addSubview:chooseDate];
    
    trajectDatePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 40, 120, 80)];
    trajectDatePicker.datePickerMode = UIDatePickerModeDate;
    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    trajectDatePicker.locale = locale;
    [datePickView addSubview:trajectDatePicker];
}
-(void)dateViewAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    if (button.tag == 2001) {
        datePickView.hidden = YES;
    }
    if (button.tag == 2002) {
        NSDate *selected = [trajectDatePicker date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        NSDate *nowDate = [NSDate date];
        if ([selected timeIntervalSinceDate:nowDate]>0.0) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"您选择的时间有误，请重新选择！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        else
        {
            timeDate = selected;
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            dateLab.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:selected]];
        }
        datePickView.hidden = YES;
    }
}
- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer

{
    CGPoint tmpPointTouch = [gestureRecognizer locationInView:trajectTable];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        NSIndexPath *indexPath = [trajectTable indexPathForRowAtPoint:tmpPointTouch];
        tableRow = [indexPath row];
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除轨迹" otherButtonTitles:nil, nil];
        [sheet showInView:self.view];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [trajectArray removeObjectAtIndex:tableRow];
        [timeStartArray removeObjectAtIndex:tableRow];
        [timeEndArray removeObjectAtIndex:tableRow];
        [startAddressArray removeObjectAtIndex:tableRow];
        [endAddressArray removeObjectAtIndex:tableRow];
        [kmArray removeObjectAtIndex:tableRow];
        [trajectTable reloadData];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"删除轨迹成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    if (buttonIndex == 1) {
        
    }
}

-(void)GPSPointJson:(NSString*)gpsJsonString
{
    
    GPSPointArray = [[NSMutableArray alloc]init];
    sArray = [[NSMutableArray alloc]init];
    eArray = [[NSMutableArray alloc]init];
    gcpuntArray = [[NSMutableArray alloc]init];
    startAddressArray = [[NSMutableArray alloc]init];
    endAddressArray = [[NSMutableArray alloc]init];
    kmArray = [[NSMutableArray alloc]init];
    showKmArray = [[NSMutableArray alloc]init];
    
    NSData *gpsJsonData = [gpsJsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *gpsJsonArray = [NSJSONSerialization JSONObjectWithData:gpsJsonData options:NSJSONReadingMutableContainers error:nil];
    for (id gpsArray in gpsJsonArray) {
        NSString *s = [gpsArray objectForKey:@"beginTime"];
        [sArray addObject:s];
        
        NSString *e = [gpsArray objectForKey:@"endTime"];
        [eArray addObject:e];
        
        NSString *p = [gpsArray objectForKey:@"trail"];
        [GPSPointArray addObject:p];
    }
    /*
  P23.117356N113.427962E140000000000100000
     */
    
    for (int i = 0; i < GPSPointArray.count; i++) {
        NSString *gpsStr = [GPSPointArray objectAtIndex:i];
        NSString *startAddStr = [gpsStr substringToIndex:40];
        NSString *endADDStr = [gpsStr substringFromIndex:gpsStr.length-40];
        NSString *latStr = [startAddStr substringWithRange:NSMakeRange(1, 9)];
        if (![[startAddStr substringWithRange:NSMakeRange(10, 1)]isEqualToString:@"N"]) {
            latStr = [NSString stringWithFormat:@"-%@",latStr];
        }
        NSString *logStr = [startAddStr substringWithRange:NSMakeRange(11, 10)];
        if (![[startAddStr substringWithRange:NSMakeRange(21, 1)]isEqualToString:@"E"]) {
            logStr = [NSString stringWithFormat:@"-%@",logStr];
        }
        NSString *latStr1 = [endADDStr substringWithRange:NSMakeRange(1, 9)];
        if (![[endADDStr substringWithRange:NSMakeRange(10, 1)]isEqualToString:@"N"]) {
            latStr1 = [NSString stringWithFormat:@"-%@",latStr1];
        }
        NSString *logStr1 = [endADDStr substringWithRange:NSMakeRange(11, 10)];
        if (![[endADDStr substringWithRange:NSMakeRange(21, 1)]isEqualToString:@"E"]) {
            logStr1 = [NSString stringWithFormat:@"-%@",logStr1];
        }
        [startAddressArray addObject:[self re_Geocoding:latStr Lutitude:logStr]];
        [endAddressArray addObject:[self re_Geocoding:latStr1 Lutitude:logStr1]];
        
        NSString *kmStr = [startAddStr substringWithRange:NSMakeRange(36, 4)];
        NSString *kmStr1 = [endADDStr substringWithRange:NSMakeRange(36, 4)];
        float kmForFloat = kmStr1.floatValue - kmStr.floatValue;
        [kmArray addObject:[NSString stringWithFormat:@"%.0fkm",kmForFloat]];
    }
}

-(NSString*)re_Geocoding:(NSString*)longitude Lutitude:(NSString*)lutitude{
    
    NSString *re_GeocodingString = [NSString stringWithFormat:@"http://maps.google.cn/maps/api/geocode/json?latlng=%@,%@&language=zh-CN&sensor=false",longitude,lutitude];
    NSURL *re_GeocodingURL = [NSURL URLWithString:re_GeocodingString];
    NSString *re_GeocodingJsonString = [NSString stringWithContentsOfURL:re_GeocodingURL encoding:NSUTF8StringEncoding error:nil];
    
    NSData *re_GeocodingData = [re_GeocodingJsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *carPoint;
    NSDictionary *re_GeocodingDic = [NSJSONSerialization JSONObjectWithData:re_GeocodingData options:NSJSONReadingMutableContainers error:nil];
    
    NSArray *resultsArray = [re_GeocodingDic objectForKey:@"results"];
    if (resultsArray.count == 0) {
        carPoint = @"未知地理位置";
    }
    else{
        NSDictionary *resultsArray0 = [resultsArray objectAtIndex:0];
        NSString *formatted_address = [resultsArray0 objectForKey:@"formatted_address"];
        
        if (formatted_address == nil) {
            carPoint = @"未知地理位置";
        }
        else
        {
            carPoint = [NSString stringWithFormat:@"%@",formatted_address];
        }
    }
    NSLog(@"%@",carPoint);
    return carPoint;
}
-(NSMutableArray *)doGPSPointString:(NSString*)pointString
{
    NSMutableArray *pointArray = [[NSMutableArray alloc]init];
    while (pointString.length >= 40) {
        NSString *str = [pointString substringToIndex:40];
        NSString *latStr = [str substringWithRange:NSMakeRange(1, 9)];
        if (![[str substringWithRange:NSMakeRange(10, 1)]isEqualToString:@"N"]) {
            latStr = [NSString stringWithFormat:@"-%@",latStr];
        }
        NSString *logStr = [str substringWithRange:NSMakeRange(11, 10)];
        if (![[str substringWithRange:NSMakeRange(21, 1)]isEqualToString:@"E"]) {
            logStr = [NSString stringWithFormat:@"-%@",logStr];
        }
        [pointArray addObject:latStr];
        [pointArray addObject:logStr];
        pointString = [pointString substringFromIndex:40];
    }
    return pointArray;
}

@end
