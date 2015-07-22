//
//  TrackViewController.m
//  ADLWeiChe
//
//  Created by icePhoenix on 15/6/11.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//

#import "TrackViewController.h"
#import "CarPointViewController.h"
#import "LoadViewController.h"
#import "UserDefaults.h"

@interface TrackViewController ()<UITextFieldDelegate>
{
    UITextField *deviceIDFiled;
    UITextField *devicePassFiled;
}
@end

@implementation TrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建导航栏
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    [navigationItem setTitle:@"行车轨迹"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    navigationItem.leftBarButtonItem = leftButton;
    navigationBar.tintColor = [UIColor colorWithRed:0.584f green:0.584f blue:0.584f alpha:1.0f];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [self.view addSubview:navigationBar];

    //创建列表
    trackTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 65, 320, self.view.frame.size.height-65)];
    trackTable.delegate = self;
    trackTable.dataSource = self;
    [self.view addSubview:trackTable];
    [self setExtraCellLineHidden:trackTable];
    array = [[NSArray alloc]initWithObjects:@"爱车位置",@"行车轨迹", nil];
    
    //添加设备数据
    [self initAddDeviceView];
}

//返回
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark tableDelegate

//去除tableView多余的横线
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [array count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.textLabel.text = [array objectAtIndex:indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        CarPointViewController *vc = [[CarPointViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }
    if (indexPath.row == 1) {
        LoadViewController *vc= [[LoadViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

-(void)initAddDeviceView
{
    NSDictionary *dic = [UserDefaults readUserDefaults:@"ATypeDevice"];
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

//添加设备ID
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
        /************************************/
        
        /************************************/
        
        NSData *deviceIDData = [self hexToData:deviceID];
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:deviceIDData, nil]forKeys:[NSArray arrayWithObjects:@"AdeviceID", nil]];
        [UserDefaults saveUserDefaults:dic :@"ATypeDevice"];
        addDeviceView.hidden = YES;
    }
}

#pragma mark 设备ID处理
//将设备ID转换成NSData
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
    return buzVal;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
