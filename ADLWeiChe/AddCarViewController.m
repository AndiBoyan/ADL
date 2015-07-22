//
//  AddCarViewController.m
//  ADLWeiChe
//
//  Created by icePhoenix on 15/6/12.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//

#import "AddCarViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"


@interface AddCarViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITextField *deviceIDTextField;
@property (strong, nonatomic) UITextField *devicePassTextField;
@property (strong, nonatomic) UITextField *modelTextField;
@property (strong, nonatomic) UITableView *catTableView;
@property (strong, nonatomic) NSMutableArray *carAry;
@property int type;
@property (strong, nonatomic) NSString *brand;
@property (strong, nonatomic) NSString *carType;
@property (strong, nonatomic) NSString *carYear;

@end

@implementation AddCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *backgroundIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backgroundIV.image = [UIImage imageNamed:@"loginViewControllerBG@3x.png"];
    [self.view addSubview:backgroundIV];
    
    self.deviceIDTextField = [[UITextField alloc]initWithFrame:CGRectMake((self.view.frame.size.width-200)*1/2, 225, 200, 35)];
    self.deviceIDTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.deviceIDTextField.placeholder =@"设备ID";
    self.deviceIDTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.deviceIDTextField.returnKeyType = UIReturnKeyNext;
    self.deviceIDTextField.font = [UIFont systemFontOfSize:13.0f];
    self.deviceIDTextField.delegate = self;
    [self.view addSubview:self.deviceIDTextField];
    
    self.devicePassTextField = [[UITextField alloc]initWithFrame:CGRectMake((self.view.frame.size.width-200)*1/2, 270, 200, 35)];
    self.devicePassTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.devicePassTextField.secureTextEntry = YES;
    self.devicePassTextField.placeholder = @"设备密码";
    self.devicePassTextField.delegate = self;
    self.devicePassTextField.returnKeyType = UIReturnKeyDone;
    self.devicePassTextField.font = [UIFont systemFontOfSize:13.0f];
    [self.view addSubview:self.devicePassTextField];
    
    
    self.modelTextField = [[UITextField alloc]initWithFrame:CGRectMake((self.view.frame.size.width-200)*1/2, 180, 200, 35)];
    self.modelTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    self.modelTextField.font = [UIFont systemFontOfSize:13.0f];
    self.modelTextField.textColor = [UIColor blackColor];
    self.modelTextField.placeholder = @"车品牌";
    self.modelTextField.clearButtonMode = UITextFieldViewModeNever;
    self.modelTextField.secureTextEntry = NO;
    self.modelTextField.clearsOnBeginEditing = YES;
    self.modelTextField.textAlignment = NSTextAlignmentLeft;
    self.modelTextField.keyboardType = UIKeyboardTypeDefault;
    self.modelTextField.delegate = self;
    [self.view addSubview:self.modelTextField];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-200)*1/2, 180, 200, 35)];
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelTouchUpInside:)];
    [view addGestureRecognizer:labelTapGestureRecognizer];
    
    CGRect frameOfNext  = CGRectMake(180, 325, 80, 35);
    UIButton *buttonOfNext = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonOfNext.frame = frameOfNext;
    //下一步按钮
    UIImage *buttonImage = [UIImage imageNamed:@"loginregisterbutton@3x.png"];
    UIImage *stretchableButtonImage = [buttonImage  stretchableImageWithLeftCapWidth:12  topCapHeight:0];
    [buttonOfNext setBackgroundImage:stretchableButtonImage forState:UIControlStateNormal];
    [buttonOfNext addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonOfNext];
    
    //返回按钮
    CGRect frameOfBack = CGRectMake(60, 325, 80, 35);
    UIButton *buttonOfBack = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonOfBack.frame = frameOfBack;
    UIImage *backImage = [UIImage imageNamed:@"loginbackbutton@3x.png"];
    UIImage *stretchableButtonImage1 = [backImage  stretchableImageWithLeftCapWidth:12  topCapHeight:0];
    [buttonOfBack setBackgroundImage:stretchableButtonImage1 forState:UIControlStateNormal];
    [buttonOfBack addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonOfBack];
    
    self.catTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.catTableView.delegate  = self;
    self.catTableView.dataSource = self;
    self.catTableView.hidden = YES;
    [self.view addSubview:self.catTableView];

}
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)done
{
    /**************************************************/
    //                  注册
    /*
    */
    /**************************************************/
    NSString *carBrand = self.modelTextField.text;
    NSString *deviceID = self.deviceIDTextField.text;
    NSString *devicePass = self.devicePassTextField.text;
    if ((carBrand.length <= 0)||(deviceID.length <= 0)||(devicePass.length <= 0)) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的用户信息不完善，请完善用户信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else
    {
        NSString *utf8Brand = [self.brand stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *utf8type = [self.carType stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString *addUserString = [NSString stringWithFormat:@"http://dev.adlssc.com:8080/ADLRestful/rest/ums/ownerRegister/hexCarDeviceID=%@&carDevicePassword=%@&userID=%@&userPassword=%@&carBrand=%@&carType=%@",deviceID,devicePass,self.userName,self.userPass,utf8Brand,utf8type];
        NSURL *addUserUrl = [NSURL URLWithString:addUserString];
        NSString *addUserJson = [NSString stringWithContentsOfURL:addUserUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *addUserData = [addUserJson dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:addUserData options:NSJSONReadingMutableContainers error:nil];
        NSString *code = [dic objectForKey:@"code"];
        if ([code isEqualToString:@"200"]) {
            ViewController *VC = [[ViewController alloc]init];
            AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
            delegate.isLogin = YES;
            [self presentViewController:VC animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"注册失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (![self.view isExclusiveTouch]) {
        [self.modelTextField resignFirstResponder];
        [self.deviceIDTextField resignFirstResponder];
        [self.devicePassTextField resignFirstResponder];
    }
}

-(void) labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
    //获取车品牌
    //http://202.116.48.86:8080/ADLRestful/rest/ums/getDistinctCarBrand/
    self.carAry = [[NSMutableArray alloc]init];
    NSString *brandString = @"http://dev.adlssc.com:8080/ADLRestful/rest/ums/getDistinctCarBrand/";
    NSURL *brandUrl = [NSURL URLWithString:brandString];
    NSString *brandJson = [NSString stringWithContentsOfURL:brandUrl encoding:NSUTF8StringEncoding error:nil];
    NSData *brandData = [brandJson dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *arrays = [NSJSONSerialization JSONObjectWithData:brandData options:NSJSONReadingMutableContainers error:nil];
    for (id array in arrays) {
        NSString *car = [array objectForKey:@"carBrand"];
        [self.carAry addObject:car];
    }
    [self.catTableView reloadData];
    self.type = 1;
    self.catTableView.hidden = NO;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.carAry.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        cell.textLabel.text = [self.carAry objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == 1) {
        self.brand = [self.carAry objectAtIndex:indexPath.row];
        self.carAry = [[NSMutableArray alloc]init];
        NSString *utf8Brand = [self.brand stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        // NSString *utf8BrandOfCar = [brandOfCar stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //http://202.116.48.86:8080/ADLRestful/rest/ums/getDistinctCarTypeByCarBrand/carBrand=%@
        self.type = 2;
        NSString *typeString = [NSString stringWithFormat:@"http://dev.adlssc.com:8080/ADLRestful/rest/ums/getDistinctCarTypeByCarBrand/carBrand=%@",utf8Brand];
        NSURL *typeUrl = [NSURL URLWithString:typeString];
        NSString *typeJson = [NSString stringWithContentsOfURL:typeUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *typeData = [typeJson dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *arrays = [NSJSONSerialization JSONObjectWithData:typeData options:NSJSONReadingMutableContainers error:nil];
        for (id array in arrays) {
            NSString *car = [array objectForKey:@"carType"];
            [self.carAry addObject:car];
        }
        
        [self.catTableView reloadData];
        return;
    }
    if (self.type == 2) {
        self.carType = [self.carAry objectAtIndex:indexPath.row];
        self.catTableView.hidden = YES;
        self.modelTextField.text = [NSString stringWithFormat:@"%@  %@",self.brand,self.carType];
        self.type = 0;
        return;
    }
}
@end
