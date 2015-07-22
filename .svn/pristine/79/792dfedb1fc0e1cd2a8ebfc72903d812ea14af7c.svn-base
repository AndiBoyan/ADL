//
//  ControlViewController.m
//  WeiChe
//
//  Created by icePhoenix on 15/5/14.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//

#import "ControlViewController.h"
#import "OBShapedButton.h"
#import "myLoadingView.h"
#import "UserDefaults.h"
#import "URBAlertView.h"
#import "Analyse.h"
#import "ControlReslut.h"
#import "CarState.h"

@interface ControlViewController ()<UITextFieldDelegate>
{
    NSString *database_path;
    int showSwap;
    UIView *anmitionOneView;
    UIView *anmitionTwoView;
    UIImageView *anmitionOneIV;
    UILabel *anmitionOneLab;
    UIImageView *anmitionTwoIV;
    UILabel *anmitionTwoLab;
    NSData *carIDData;
    Byte *carIdByte;
    myLoadingView *loading;
    NSTimer *loadingTime;
    int loadingNum;
    int loadingNum1;
    UIView *addDeviceView;
    UITextField *deviceIDFiled;
    UITextField *devicePassFiled;
    NSTimer *ControlTime;
    NSTimer *carStateTime;
}
@end

@implementation ControlViewController

- (void)viewDidLoad {
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65)];
    
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"backguound.png"];
    [navigationBar setBackgroundImage:backgroundImage
                                                  forBarMetrics:UIBarMetricsDefault];
    [navigationItem setTitle:@"天炬·车联"];
    UIColor *color = [UIColor whiteColor];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:color
                                                    forKey:NSForegroundColorAttributeName];
    navigationBar.titleTextAttributes = dic;
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    //把导航栏集合添加入导航栏中，设置动画关闭
    navigationItem.leftBarButtonItem = leftButton;
    navigationBar.tintColor = [UIColor colorWithRed:0.584f green:0.584f blue:0.584f alpha:1.0f];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [self.view addSubview:navigationBar];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initViewData];
    //[self connect];
    swapTime = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(stateSwap) userInfo:nil repeats:YES];
    [swapTime setFireDate:[NSDate distantFuture]];
    
    stateTime = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(stateLight) userInfo:nil repeats:YES];
    [stateTime setFireDate:[NSDate distantFuture]];
    
    unlockTime = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(unlockLight) userInfo:nil repeats:YES];
    [unlockTime setFireDate:[NSDate distantFuture]];
    
    lockTime = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(lockLight) userInfo:nil repeats:YES];
    [lockTime setFireDate:[NSDate distantFuture]];
    
    loadingTime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(isReviceMsg) userInfo:nil repeats:YES];
    [loadingTime setFireDate:[NSDate distantFuture]];
    
    loading = [[myLoadingView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:loading];
    loading.hidden = YES;
    [self initAddDeviceView];
}
-(void)viewDidAppear:(BOOL)animated
{
    carStateTime = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(carStateAction) userInfo:nil repeats:YES];
    [carStateTime setFireDate:[NSDate distantPast]];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [carStateTime setFireDate:[NSDate distantFuture]];
}
-(void)carStateAction
{
    NSString *tagString = [CarState instance].stateString;
    if (tagString != nil) {
        NSString *carBasic = [tagString substringWithRange:NSMakeRange(6, 1)];
        char charBasic = [carBasic characterAtIndex:0];
        NSString *basic = [Analyse Binary:(int)charBasic];
        NSLog(@"basic = %@",basic);
        
        NSString *carWarm = [tagString substringWithRange:NSMakeRange(7, 1)];
        char charWarm = [carWarm characterAtIndex:0];
        NSString *warm = [Analyse Binary:(int)charWarm];
        NSLog(@"warm = %@",warm);
        NSString *lockStr = [warm substringWithRange:NSMakeRange(5, 1)];
        
        NSString *carState = [tagString substringWithRange:NSMakeRange(9, 1)];
        char charState = [carState characterAtIndex:0];
        NSString *state = [Analyse Binary:(int)charState];
        
        NSString *carWindow = [tagString substringWithRange:NSMakeRange(10, 1)];
        char charWin = [carWindow characterAtIndex:0];
        NSString *window = [Analyse Binary:(int)charWin];
        
        NSString *carStart = [tagString substringWithRange:NSMakeRange(12, 1)];
        char charStart = [carStart characterAtIndex:0];
        NSString *start = [Analyse Binary:(int)charStart];
        
        
        NSString *oilP = [tagString substringWithRange:NSMakeRange(13, 1)];
        char oilChar = [oilP characterAtIndex:0];
        int hexOil = (int)oilChar;
        //int hexOT;
        NSLog(@"oil=%d",hexOil);
        /*NSDictionary *OTDic = [UserDefaults readUserDefaults:@"OilMsg"];
        if (OTDic != nil) {
            NSString  *hexOTStr = [OTDic valueForKey:@"LT"];
            hexOT = hexOTStr.intValue;
            if ((hexOil<hexOT)&&(typeOfOil != YES)) {
                NSLog(@"油量不足");
                typeOfOil = YES;
            }
        }*/
        NSString *kmStr = [tagString substringWithRange:NSMakeRange(20, 3)];
        NSString *kmStr1 = [Analyse Binary:(int)[kmStr characterAtIndex:0]];
        NSString *kmStr2 = [Analyse Binary:(int)[kmStr characterAtIndex:1]];
        NSString *kmStr3 = [Analyse Binary:(int)[kmStr characterAtIndex:2]];
        
        NSString *hexKm = [NSString stringWithFormat:@"%@%@%@",kmStr1,kmStr2,kmStr3];
        double numKm = 0;
        for (int  i = 0; i<hexKm.length; i++) {
            NSString *tmpStr = [hexKm substringWithRange:NSMakeRange(hexKm.length-i-1, 1)];
            if ([tmpStr isEqualToString:@"1"]) {
                numKm += pow(2, i);
            }
        }
        
        NSLog(@"%.0fkm",numKm);
        
        [self ownerCarState:state start:start];
        [self alarm:warm];
        if ([lockStr isEqualToString:@"1"]&&![start isEqualToString:@"00001000"]) {
            NSString *inspectionStr = @"汽车已设防";
            NSString *boxStr = [state substringWithRange:NSMakeRange(3, 1)];
            if ([boxStr isEqualToString:@"1"]) {
                inspectionStr = [NSString stringWithFormat:@"%@,尾箱已开启",inspectionStr];
            }
            NSString *doorStr = [state substringWithRange:NSMakeRange(4, 4)];
            if (![doorStr isEqualToString:@"0000"]) {
                inspectionStr = [NSString stringWithFormat:@"%@,车门已开启",inspectionStr];
            }
            NSString *skyStr = [window substringWithRange:NSMakeRange(3, 1)];
            if ([skyStr isEqualToString:@"1"]) {
                inspectionStr = [NSString stringWithFormat:@"%@,天窗已开启",inspectionStr];
            }
            NSString *winStr = [window substringWithRange:NSMakeRange(4, 4)];
            if (![winStr isEqualToString:@"0000"]) {
                inspectionStr = [NSString stringWithFormat:@"%@,车窗已开启",inspectionStr];
            }
            NSString *gpsStr = [basic substringWithRange:NSMakeRange(6, 1)];
            if ([gpsStr isEqualToString:@"1"]) {
                inspectionStr = [NSString stringWithFormat:@"%@,GPS异常",inspectionStr];
            }
            [self carMessage:inspectionStr];
        }
    }
    CarState *carState = [CarState instance];
    carState.stateString = nil;
}
-(void)alarm:(NSString*)alarmString
{
    if ([[alarmString substringWithRange:NSMakeRange(7, 1)]isEqualToString:@"1"]) {
        [self carMessage:@"您的爱车可能由于外力碰撞，发生振动报警"];
        [swapTime setFireDate:[NSDate distantPast]];
    }
}
-(void)carMessage:(NSString*)msg
{
    NSDictionary *newMsg = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"yes", nil] forKeys:[NSArray arrayWithObjects:@"rmsg", nil]];
    [UserDefaults saveUserDefaults:newMsg :@"newMsg"];
    NSDate *time = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [df setLocale:locale];
    [self scheduleLocalNotificationWithDate:msg];
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)initData
{
    clockTime = 0.0f;
    myclockTime = 0.0f;
    showSwap = 0;
    lockSelect = YES;
    startSelect = YES;
    loadingNum = 0;
    loadingNum1 = 0;
    [self initCarStateIV];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initAddDeviceView
{
    NSDictionary *dic = [UserDefaults readUserDefaults:@"DTypeDevice"];
    if (dic == nil) {
        addDeviceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:addDeviceView];
        UIImageView *addDeviceIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, addDeviceView.frame.size.width, addDeviceView.frame.size.height)];
        addDeviceIV.image = [UIImage imageNamed:@"loginViewControllerBG@3x.png"];
        [addDeviceView addSubview:addDeviceIV];
        
        deviceIDFiled = [[UITextField alloc]initWithFrame:CGRectMake(60, 180, 200, 35)];
        deviceIDFiled.borderStyle = UITextBorderStyleRoundedRect;
        deviceIDFiled.font = [UIFont systemFontOfSize:13.0f];
        deviceIDFiled.placeholder = @"设备ID";
        deviceIDFiled.delegate = self;
        [addDeviceView addSubview:deviceIDFiled];
        
        devicePassFiled = [[UITextField alloc]initWithFrame:CGRectMake(60, 240, 200, 35)];
        devicePassFiled.borderStyle = UITextBorderStyleRoundedRect;
        devicePassFiled.font = [UIFont systemFontOfSize:13.0f];
        devicePassFiled.placeholder = @"设备密码";
        devicePassFiled.delegate = self;
        devicePassFiled.secureTextEntry = YES;
        [addDeviceView addSubview:devicePassFiled];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cancelBtn.frame = CGRectMake(60, 300, 75, 30);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [addDeviceView addSubview:cancelBtn];
        
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        doneBtn.frame = CGRectMake(185, 300, 75, 30);
        [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
        [addDeviceView addSubview:doneBtn];
    }
}

-(void)done
{
    NSString *deviceID = deviceIDFiled.text;
    NSString *devicePass = devicePassFiled.text;
    [deviceIDFiled resignFirstResponder];
    [devicePassFiled resignFirstResponder];
    
    if ((deviceID.length <= 0)||(devicePass.length <= 0)) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"输入的设备ID或者密码为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else
    {
        //查询设备ID是否存在
        /************************************
        
        
        
        ************************************/
        NSData *deviceIDData = [self hexToData:deviceID];
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:deviceIDData, nil]forKeys:[NSArray arrayWithObjects:@"DdeviceID", nil]];
        [UserDefaults saveUserDefaults:dic :@"DTypeDevice"];
        addDeviceView.hidden = YES;
    }
}

-(NSData*)hexToData:(NSString*)str
{
    int len = (int)str.length/2;
    Byte byte[len];
    for (int i = 0; i<len; i++) {
        NSString *hexStr = [str substringWithRange:NSMakeRange(0, 2)];
        byte[i] = [self myStringToData:hexStr];
        str= [str substringFromIndex:2];
    }
    return [NSData dataWithBytes:byte length:len];
}

-(Byte)myStringToData:(NSString*)str
{
    int fristNum;
    int secondNum;
    NSString *fristStr = [str substringWithRange:NSMakeRange(0, 1)];
    NSString *secondStr = [str substringWithRange:NSMakeRange(1, 1)];
    
    fristNum = fristStr.intValue;
    secondNum = secondStr.intValue;
    
    if ([fristStr isEqualToString:@"A"]||[fristStr isEqualToString:@"a"]) {
        fristNum = 10;
    }
    if ([fristStr isEqualToString:@"B"]||[fristStr isEqualToString:@"b"]) {
        fristNum = 11;
    }
    if ([fristStr isEqualToString:@"C"]||[fristStr isEqualToString:@"c"]) {
        fristNum = 12;
    }
    if ([fristStr isEqualToString:@"D"]||[fristStr isEqualToString:@"d"]) {
        fristNum = 13;
    }
    if ([fristStr isEqualToString:@"E"]||[fristStr isEqualToString:@"e"]) {
        fristNum = 14;
    }
    if ([fristStr isEqualToString:@"F"]||[fristStr isEqualToString:@"f"]) {
        fristNum = 15;
    }
    if ([secondStr isEqualToString:@"A"]||[secondStr isEqualToString:@"a"]) {
        secondNum = 10;
    }
    if ([secondStr isEqualToString:@"B"]||[secondStr isEqualToString:@"b"]) {
        secondNum = 11;
    }
    if ([secondStr isEqualToString:@"C"]||[secondStr isEqualToString:@"c"]) {
        secondNum = 12;
    }
    if ([secondStr isEqualToString:@"D"]||[secondStr isEqualToString:@"d"]) {
        secondNum = 13;
    }
    if ([secondStr isEqualToString:@"E"]||[secondStr isEqualToString:@"e"]) {
        secondNum = 14;
    }
    if ([secondStr isEqualToString:@"F"]||[secondStr isEqualToString:@"f"]) {
        secondNum = 15;
    }
    Byte buzVal= fristNum*16+secondNum;
    //return [[NSData alloc] initWithBytes:&buzVal length:1];
    return buzVal;
}

-(void)initViewData
{
    UIImageView *logoIV = [[UIImageView alloc]initWithFrame:CGRectMake(140, 70, 40, 40)];
    logoIV.image = [UIImage imageNamed:@"丰田.png"];
    [self.view addSubview:logoIV];
    
    anmitionOneView = [[UIView alloc]initWithFrame:CGRectMake(0, 75, 125, 30)];
    anmitionOneView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:anmitionOneView];
    
    anmitionOneIV = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
    anmitionOneIV.image = [UIImage imageNamed:@"温度.png"];
    [anmitionOneView addSubview:anmitionOneIV];
    anmitionOneLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 100, 30)];
    anmitionOneLab.text = @"车内温度：30°C";
    anmitionOneLab.font = [UIFont systemFontOfSize:12.0f];
    anmitionOneLab.textColor = [UIColor whiteColor];
    [anmitionOneView addSubview:anmitionOneLab];
    
    anmitionTwoView = [[UIView alloc]initWithFrame:CGRectMake(195, 75, 125, 30)];
    anmitionTwoView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:anmitionTwoView];
    
    anmitionTwoIV = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
    anmitionTwoIV.image = [UIImage imageNamed:@"加油.png"];
    [anmitionTwoView addSubview:anmitionTwoIV];
    anmitionTwoLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 100, 30)];
    anmitionTwoLab.text = @"可行驶:200km";
    anmitionTwoLab.font = [UIFont systemFontOfSize:12.0f];
    anmitionTwoLab.textColor = [UIColor whiteColor];
    [anmitionTwoView addSubview:anmitionTwoLab];
    [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(swapIV) userInfo:nil repeats:YES];
    
    
    self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-245, [UIScreen mainScreen].bounds.size.width, 25)];
    self.addressLabel.text = self.address;
    self.addressLabel.font = [UIFont systemFontOfSize:12.0f];
    self.addressLabel.textColor = [UIColor whiteColor];
    self.addressLabel.backgroundColor = [UIColor clearColor];
    self.addressLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.addressLabel];
    
    
   /* NSString *soundPath=[[NSBundle mainBundle] pathForResource:@"lock" ofType:@"wav"];
    NSURL *soundUrl=[[NSURL alloc] initFileURLWithPath:soundPath];
    player=[[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    [player prepareToPlay];
    
    NSString *soundPath1=[[NSBundle mainBundle] pathForResource:@"warm" ofType:@"wav"];
    NSURL *soundUrl1=[[NSURL alloc] initFileURLWithPath:soundPath1];
    WarmPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl1 error:nil];
    [WarmPlayer prepareToPlay];
    
    
    NSString *soundPathstart=[[NSBundle mainBundle] pathForResource:@"onStart" ofType:@"wav"];
    NSURL *soundUrlstart=[[NSURL alloc] initFileURLWithPath:soundPathstart];
    startplayer=[[AVAudioPlayer alloc] initWithContentsOfURL:soundUrlstart error:nil];
    [startplayer prepareToPlay];*/
    
    [self drawControlButton];
    self.view.backgroundColor = [UIColor clearColor];
    CGRect frame;
    frame = CGRectMake(0, 15, self.view.frame.size.width, self.view.frame.size.height);
    self.backimage = [[UIImageView alloc]initWithFrame:frame];
    self.backimage.image = [UIImage imageNamed:@"fragment_con_bg2.png"];
    [self.view insertSubview:self.backimage atIndex:0];
    
    UIImageView *tabIv = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-60, self.view.frame.size.width, 60)];
    tabIv.image = [UIImage imageNamed:@"main_bottom_bg.png"];
    [self.view addSubview:tabIv];
}

-(void)swapIV
{
    if (showSwap == 0) {
        
        [self animationToImage];
        anmitionOneIV.image = [UIImage imageNamed:@"加油.png"];
        anmitionOneLab.text = @"可行驶:200km";
        anmitionTwoIV.image = [UIImage imageNamed:@"温度.png"];
        anmitionTwoLab.text = @"车内温度：30°C";
        showSwap = 1;
    }
    else
    {
        [self animationToImage];
        showSwap = 0;
        anmitionOneIV.image = [UIImage imageNamed:@"温度.png"];
        anmitionOneLab.text = @"车内温度：30°C";
        anmitionTwoIV.image = [UIImage imageNamed:@"加油.png"];
        anmitionTwoLab.text = @"可行驶:200km";
    }
}

-(void)animationToImage
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = kCATransitionReveal;
    animation.subtype = kCATransitionFromTop;
    
    [anmitionOneView.layer addAnimation:animation forKey:@"animation"];
    [anmitionTwoView.layer addAnimation:animation forKey:@"animation"];
}



-(void)sendMsg:(NSData*)data
{
    [self.scoket writeData:data withTimeout:-1 tag:0];
    [self.scoket readDataWithTimeout:-1 tag:0];
}



- (void)scheduleLocalNotificationWithDate:(NSString*)msg
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    [localNotification setFireDate:[NSDate date]];
    [localNotification setAlertBody:msg];
    [localNotification setSoundName:@"Thunder Song.m4r"];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

-(void)sendMessageNofity{
    NSString *message = @"warm up";
    NSDictionary *nofityDic = [UserDefaults readUserDefaults:@"nofityMsgDic"];
    
    if (nofityDic != nil) {
        NSDate *nowTime = [NSDate date];
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [df setLocale:locale];
        NSString *strDate = [df stringFromDate:nowTime];
        
        NSString *nofityTime = [nofityDic valueForKey:@"MsgTime"];
        
        if ([strDate isEqualToString:nofityTime]) {
            
            [self.scoket writeData:[message dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
            [self.scoket readDataWithTimeout:-1 tag:0];
        }
    }
}

#pragma mark 按钮以及指令

-(void)drawControlButton{
    float height = self.view.frame.size.height;
    float width = self.view.frame.size.width;
    
    OBShapedButton *openBoxBtn = [OBShapedButton buttonWithType:UIButtonTypeRoundedRect];
    openBoxBtn.frame = CGRectMake((width-270)/2, height-150, 90 , 40);
    UIImage *openBoxImage = [UIImage imageNamed:@"con_openbox.png"];
    UIImage *openBoxBtnImage = [openBoxImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [openBoxBtn setBackgroundImage:openBoxBtnImage forState:UIControlStateNormal];
    openBoxBtn.backgroundColor = [UIColor clearColor];
    [openBoxBtn addTarget:self action:@selector(openBox:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view insertSubview:openBoxBtn atIndex:0];
    
    OBShapedButton *findCarBtn = [OBShapedButton buttonWithType:UIButtonTypeRoundedRect];
    findCarBtn.frame = CGRectMake((width-270)/2+180, height-145, 90 , 40);
    UIImage *findCarImage = [UIImage imageNamed:@"con_findcar.png"];
    UIImage *findCarBtnImage = [findCarImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [findCarBtn setBackgroundImage:findCarBtnImage forState:UIControlStateNormal];
    findCarBtn.backgroundColor = [UIColor clearColor];
    [findCarBtn addTarget:self action:@selector(findcar:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:findCarBtn atIndex:0];
    
    lockBtn = [OBShapedButton buttonWithType:UIButtonTypeRoundedRect];
    lockBtn.frame = CGRectMake((width-270)/2+90, height-175, 90, 50);
    UIImage *lockImage = [UIImage imageNamed:@"con_unlock.png"];
    UIImage *lockBtnImage = [lockImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [lockBtn setBackgroundImage:lockBtnImage forState:UIControlStateNormal];
    lockBtn.backgroundColor = [UIColor clearColor];
    [lockBtn addTarget:self action:@selector(lock:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lockBtn];
    
    startBtn = [OBShapedButton buttonWithType:UIButtonTypeRoundedRect];
    startBtn.frame = CGRectMake((width-270)/2+90,  height-125, 90, 50);
    UIImage *startImage = [UIImage imageNamed:@"con_onstart.png"];
    UIImage *startBtnImage = [startImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [startBtn setBackgroundImage:startBtnImage forState:UIControlStateNormal];
    startBtn.backgroundColor = [UIColor clearColor];
    [startBtn addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:startBtn atIndex:1];
}

-(void)openBox:(id)sender{
    URBAlertView *alert = [URBAlertView dialogWithTitle:@"" subtitle:@"您确定要打开后尾箱？"];
    alert.blurBackground = NO;
    [alert addButtonWithTitle:@"确定"];
    [alert addButtonWithTitle:@"取消"];
    [alert setHandlerBlock:^(NSInteger buttonIndex,URBAlertView *alert)
     {
         if (buttonIndex == 0) {
             [self sendOpenBox];
         }
         else
         {
             
         }
         [alert hideWithCompletionBlock:^{
             
         }];
     }];
    [alert showWithAnimation:URBAlertAnimationFlipHorizontal];
}

-(void)findcar:(id)sender{
    URBAlertView *alert = [URBAlertView dialogWithTitle:@"" subtitle:@"您确定要寻车？"];
    alert.blurBackground = NO;
    [alert addButtonWithTitle:@"确定"];
    [alert addButtonWithTitle:@"取消"];
    [alert setHandlerBlock:^(NSInteger buttonIndex,URBAlertView *alert)
     {
         if (buttonIndex == 0) {
             [self sendFindCar];
         }
         else
         {
         }
         [alert hideWithCompletionBlock:^{
             
         }];
         
     }];
    [alert showWithAnimation:URBAlertAnimationFlipHorizontal];
}

-(void)start:(id)sender{
    if (startSelect) {
        URBAlertView *alert = [URBAlertView dialogWithTitle:@"" subtitle:@"您确定要启动汽车？"];
        alert.blurBackground = NO;
        [alert addButtonWithTitle:@"确定"];
        [alert addButtonWithTitle:@"取消"];
        [alert setHandlerBlock:^(NSInteger buttonIndex,URBAlertView *alert)
         {
             if (buttonIndex == 0) {
                 [self sendStartCar];
             }
             else
             {
             }
             [alert hideWithCompletionBlock:^{
                 
             }];
             
         }];
        [alert showWithAnimation:URBAlertAnimationFlipHorizontal];
        
    }
    else
    {
        URBAlertView *alert = [URBAlertView dialogWithTitle:@"" subtitle:@"您确定要熄火？"];
        alert.blurBackground = NO;
        [alert addButtonWithTitle:@"确定"];
        [alert addButtonWithTitle:@"取消"];
        [alert setHandlerBlock:^(NSInteger buttonIndex,URBAlertView *alert)
         {
             if (buttonIndex == 0) {
                 [self sendStopCar];
             }
             else
             {
             }
             [alert hideWithCompletionBlock:^{
                 
             }];
             
         }];
        [alert showWithAnimation:URBAlertAnimationFlipHorizontal];
        
    }
}

-(void)lock:(id)sender{
    if (lockSelect) {
        URBAlertView *alert = [URBAlertView dialogWithTitle:@"" subtitle:@"您确定要锁定汽车？"];
        alert.blurBackground = NO;
        [alert addButtonWithTitle:@"确定"];
        [alert addButtonWithTitle:@"取消"];
        [alert setHandlerBlock:^(NSInteger buttonIndex,URBAlertView *alert)
         {
             if (buttonIndex == 0) {
                 [self sendLockCar];
             }
             else
             {
             }
             [alert hideWithCompletionBlock:^{
                 
             }];
             
         }];
        [alert showWithAnimation:URBAlertAnimationFlipHorizontal];
    }
    else
    {
        URBAlertView *alert = [URBAlertView dialogWithTitle:@"" subtitle:@"您确定要解锁汽车？"];
        alert.blurBackground = NO;
        [alert addButtonWithTitle:@"确定"];
        [alert addButtonWithTitle:@"取消"];
        [alert setHandlerBlock:^(NSInteger buttonIndex,URBAlertView *alert)
         {
             if (buttonIndex == 0) {
                 [self sendUnlockCar];
             }
             else
             {
             }
             [alert hideWithCompletionBlock:^{
                 
             }];
             
         }];
        [alert showWithAnimation:URBAlertAnimationFlipHorizontal];
    }
}

-(void)sendOpenBox
{
    loadingNum1 = 1;
    loading.hidden = NO;
    [loadingTime setFireDate:[NSDate distantPast]];
    [self carCommand:@"CA" control:@"1648" length:20];
    player.numberOfLoops=1;
    [player play];
    controlType = 5;
}

-(void)sendFindCar
{
    loadingNum1 = 1;
    loading.hidden = NO;
    [loadingTime setFireDate:[NSDate distantPast]];
    [self carCommand:@"CA" control:@"0848" length:20];
    player.numberOfLoops=1;
    [player play];
    controlType = 6;

}

-(void)sendLockCar
{
    loadingNum1 = 1;
    loading.hidden = NO;
    [loadingTime setFireDate:[NSDate distantPast]];
    [self carCommand:@"CA" control:@"6448" length:20];
    controlType = 1;

}

-(void)sendUnlockCar
{
    loadingNum1 = 1;
    loading.hidden = NO;
    [loadingTime setFireDate:[NSDate distantPast]];
    [self carCommand:@"CA" control:@"12848" length:20];
    controlType = 2;

}

-(void)sendStartCar
{
    loadingNum1 = 1;
    loading.hidden = NO;
    [loadingTime setFireDate:[NSDate distantPast]];
    [self carCommand:@"CA" control:@"3248" length:20];
    controlType = 3;
}

-(void)sendStopCar
{
    loadingNum1 = 1;
    loading.hidden = NO;
    [loadingTime setFireDate:[NSDate distantPast]];
    [self carCommand:@"CA" control:@"3248" length:20];
    controlType = 4;
}



#pragma mark 汽车状态显示

-(void)initCarStateIV
{
    CGRect frame = CGRectMake((self.view.frame.size.width-320)/2, 120, 320, 226);
    stateIV = [[UIImageView alloc]initWithFrame:frame];
    stateIV.image = [UIImage imageNamed:@"carlight1.png"];
    stateIV.hidden = YES;
    [self.view addSubview:stateIV];
    
    startIV = [[UIImageView alloc]initWithFrame:frame];
    startIV.image = [UIImage imageNamed:@"carStart.png"];
    startIV.hidden = YES;
    [self.view addSubview:startIV];
    
    stopIV = [[UIImageView alloc]initWithFrame:frame];
    stopIV.image = [UIImage imageNamed:@"carBasic.png"];
    stopIV.hidden = NO;
    [self.view addSubview:stopIV];
    
    lbIV = [[UIImageView alloc]initWithFrame:frame];
    lbIV.image = [UIImage imageNamed:@"lbDoorOpen.png"];
    lbIV.hidden = YES;
    [self.view addSubview:lbIV];
    
    lfIV = [[UIImageView alloc]initWithFrame:frame];
    lfIV.image = [UIImage imageNamed:@"lfDoorOpen.png"];
    lfIV.hidden = YES;
    [self.view addSubview:lfIV];
    
    lb1IV = [[UIImageView alloc]initWithFrame:frame];
    lb1IV.image = [UIImage imageNamed:@"lbDoorOpen1.png"];
    lb1IV.hidden = YES;
    [self.view addSubview:lb1IV];
    
    lf1IV = [[UIImageView alloc]initWithFrame:frame];
    lf1IV.image = [UIImage imageNamed:@"lfDoorOpen1.png"];
    lf1IV.hidden = YES;
    [self.view addSubview:lf1IV];
    
    rfIV = [[UIImageView alloc]initWithFrame:frame];
    rfIV.image = [UIImage imageNamed:@"rfDoorOpen.png"];
    rfIV.hidden = YES;
    [self.view addSubview:rfIV];
    
    rbIV = [[UIImageView alloc]initWithFrame:frame];
    rbIV.image = [UIImage imageNamed:@"rbDoorOpen.png"];
    rbIV.hidden = YES;
    [self.view addSubview:rbIV];
    
    tailBoxIV = [[UIImageView alloc]initWithFrame:frame];
    tailBoxIV.image = [UIImage imageNamed:@"tailBoxOpen.png"];
    tailBoxIV.hidden = YES;
    [self.view addSubview:tailBoxIV];
    
    tailBox2IV = [[UIImageView alloc]initWithFrame:frame];
    tailBox2IV.image = [UIImage imageNamed:@"tailBoxOpen2.png"];
    tailBox2IV.hidden = YES;
    [self.view addSubview:tailBox2IV];
    
    tailBox3IV = [[UIImageView alloc]initWithFrame:frame];
    tailBox3IV.image = [UIImage imageNamed:@"tailBoxOpen3.png"];
    tailBox3IV.hidden = YES;
    [self.view addSubview:tailBox3IV];
    
    lockIV = [[UIImageView alloc]initWithFrame:CGRectMake(30, 150, 40, 25)];
    lockIV.image = [UIImage imageNamed:@"carStateLock.png"];
    [self.view addSubview:lockIV];
}

-(void)ownerCarState:(NSString*)stateString start:(NSString*)isstart
{
    stateIV.hidden = YES;
    startIV.hidden = YES;
    start1IV.hidden = YES;
    lbIV.hidden = YES;
    lfIV.hidden = YES;
    rbIV.hidden = YES;
    rfIV.hidden = YES;
    tailBoxIV.hidden = YES;
    stopIV.hidden = YES;
    tailBox2IV.hidden = YES;
    tailBox3IV.hidden = YES;
    lb1IV.hidden = YES;
    lf1IV.hidden = YES;
    
    if ([[isstart substringWithRange:NSMakeRange(4, 1) ] isEqualToString:@"1"]) {
        startIV.hidden = NO;
        if ([[stateString substringWithRange:NSMakeRange(3, 1)]isEqualToString:@"1"]) {
            tailBoxIV.hidden = NO;
        }
        if ([[stateString substringWithRange:NSMakeRange(7, 1)]isEqualToString:@"1"]) {
            lf1IV.hidden = NO;
        }
        if ([[stateString substringWithRange:NSMakeRange(6, 1)]isEqualToString:@"1"]) {
            rfIV.hidden = NO;
        }
        if ([[stateString substringWithRange:NSMakeRange(5, 1)]isEqualToString:@"1"]) {
            lb1IV.hidden = NO;
        }
        if ([[stateString substringWithRange:NSMakeRange(4, 1)]isEqualToString:@"1"]) {
            rbIV.hidden = NO;
        }
    }
    else
    {
        stopIV.hidden = NO;
        [stateTime setFireDate:[NSDate distantPast]];
        if ([[stateString substringWithRange:NSMakeRange(3, 1)]isEqualToString:@"1"]) {
            tailBox2IV.hidden = NO;
        }
        if ([[stateString substringWithRange:NSMakeRange(7, 1)]isEqualToString:@"1"]) {
            lfIV.hidden = NO;
        }
        if ([[stateString substringWithRange:NSMakeRange(6, 1)]isEqualToString:@"1"]) {
            rfIV.hidden = NO;
        }
        if ([[stateString substringWithRange:NSMakeRange(5, 1)]isEqualToString:@"1"]) {
            lbIV.hidden = NO;
        }
        if ([[stateString substringWithRange:NSMakeRange(4, 1)]isEqualToString:@"1"]) {
            rbIV.hidden = NO;
        }
    }
}

-(void)stateLight
{
    if (stateSwqp) {
        stateIV.hidden = YES;
        stopIV.hidden = NO;
        stateSwqp = !stateSwqp;
    }
    else
    {
        stateIV.hidden = NO;
        stopIV.hidden = YES;
        stateSwqp = !stateSwqp;
    }
    myclockTime += 0.5f;
    if (myclockTime >= 3.0f) {
        [stateTime setFireDate:[NSDate distantFuture]];
        myclockTime = 0.0f;
        stateIV.hidden = YES;
        stopIV.hidden = NO;
    }
}

-(void)lockLight
{
    if (lockSwap) {
        stateIV.hidden = YES;
        stopIV.hidden = NO;
        lockSwap = !lockSwap;
    }
    else
    {
        stateIV.hidden = NO;
        stopIV.hidden = YES;
        lockSwap = !lockSwap;
    }
    clocklock += 0.5f;
    if (clocklock >= 3.0f) {
        [lockTime setFireDate:[NSDate distantFuture]];
        clocklock = 0.0f;
        stateIV.hidden = YES;
        stopIV.hidden = NO;
    }
}

-(void)unlockLight
{
    if (unlockSwap) {
        stateIV.hidden = YES;
        stopIV.hidden = NO;
        stateSwqp = !unlockSwap;
    }
    else
    {
        stateIV.hidden = NO;
        stopIV.hidden = YES;
        stateSwqp = !unlockSwap;
    }
    clockunlock += 0.5f;
    if (clockunlock >= 3.0f) {
        [unlockTime setFireDate:[NSDate distantFuture]];
        clockunlock = 0.0f;
        stateIV.hidden = YES;
        stopIV.hidden = NO;
    }
}



-(void)stateSwap
{
    stateIV.hidden = YES;
    startIV.hidden = YES;
    lbIV.hidden = YES;
    lfIV.hidden = YES;
    lb1IV.hidden = YES;
    lf1IV.hidden = YES;
    rbIV.hidden = YES;
    rfIV.hidden = YES;
    tailBoxIV.hidden = YES;
    stopIV.hidden = NO;
    tailBox2IV.hidden = YES;
    tailBox3IV.hidden = YES;
    [WarmPlayer play];
    if (carSwap) {
        stopIV.image = [UIImage imageNamed:@"carlight.png"];
        carSwap = NO;
    }
    else
    {
        stopIV.image = [UIImage imageNamed:@"carBasic.png"];
        carSwap = YES;
    }
    clockTime += 0.5f;
    NSLog(@"%f",clockTime);
    if (clockTime>10) {
        [swapTime setFireDate:[NSDate distantFuture]];
        clockTime = 0.0f;
        stopIV.image = [UIImage imageNamed:@"carBasic.png"];
    }
}

//控制指令
-(void)carCommand:(NSString*)type control:(NSString*)controlStr length:(int)length
{
    Byte byte[length];
    byte[0] = 0x39;
    byte[1] = 0x39;
    byte[2] = 0x39;
    byte[3] = 0x39;
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

//判断是否超时
-(void)isReviceMsg
{
    loadingNum += 1;
    int type = [ControlReslut controlReslutInstance].type;
    if (type == 1) {
        [loadingTime setFireDate:[NSDate distantFuture]];
        ControlReslut *controlReslut = [ControlReslut controlReslutInstance];
        controlReslut.type = 0;
        loadingNum = 0;
        loadingNum1 = 0;
        loading.hidden = YES;
         NSString *alertMsg;
        if (controlType == 1) {
            [unlockTime setFireDate:[NSDate distantPast]];
            player.numberOfLoops=1;
            [player play];
            lockSelect = NO;
            alertMsg = @"锁车成功";
            lockIV.image = [UIImage imageNamed:@"carStateunLock.png"];
            UIImage *lockImage = [UIImage imageNamed:@"con_lock.png"];
            UIImage *lockBtnImage = [lockImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
            [lockBtn setBackgroundImage:lockBtnImage forState:UIControlStateNormal];

        }
        if (controlType == 2) {
            [lockTime setFireDate:[NSDate distantPast]];
            player.numberOfLoops=2;
            [player play];
            lockSelect = YES;
            alertMsg = @"开锁成功";
            UIImage *lockImage = [UIImage imageNamed:@"con_unlock.png"];
            lockIV.image = [UIImage imageNamed:@"carStateLock.png"];
            UIImage *lockBtnImage = [lockImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
            [lockBtn setBackgroundImage:lockBtnImage forState:UIControlStateNormal];
        }
        if (controlType == 3) {
            [startplayer play];
            startSelect = NO;
            alertMsg = @"启动汽车成功";
            UIImage *startImage = [UIImage imageNamed:@"con_onstop.png"];
            UIImage *startBtnImage = [startImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
            [startBtn setBackgroundImage:startBtnImage forState:UIControlStateNormal];
            stopIV.hidden = YES;
            startIV.hidden = NO;
            if (lfIV.hidden == NO) {
                lfIV.hidden = YES;
                lf1IV.hidden = NO;
            }
            if (lbIV.hidden == NO) {
                lbIV.hidden = YES;
                lb1IV.hidden = NO;
            }
        }
        if (controlType == 4) {
            [startplayer play];
            startSelect = YES;
            alertMsg = @"熄火成功";
            UIImage *startImage = [UIImage imageNamed:@"con_onstart.png"];
            UIImage *startBtnImage = [startImage stretchableImageWithLeftCapWidth:12 topCapHeight:0];
            [startBtn setBackgroundImage:startBtnImage forState:UIControlStateNormal];
            stopIV.hidden = NO;
            startIV.hidden = YES;
            if (lf1IV.hidden == NO) {
                lf1IV.hidden = YES;
                lfIV.hidden = NO;
            }
            if (lb1IV.hidden == NO) {
                lb1IV.hidden = YES;
                lbIV.hidden = NO;
            }
        }
        if (controlType == 5) {
            alertMsg = @"后尾箱已开启";
            if (startIV.hidden == NO) {
                tailBoxIV.hidden = NO;
            }
            if (stopIV.hidden == NO) {
                tailBox2IV.hidden = NO;
            }
        }
        if (controlType == 6) {
             alertMsg = @"寻车指令发送成功";
        }
        if (![alertMsg isEqualToString:nil]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:alertMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    if (loadingNum >= 10) {
        [loadingTime setFireDate:[NSDate distantFuture]];
        loadingNum = 0;
        loadingNum1 = 0;
        loading.hidden = YES;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请求超时" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}
@end
