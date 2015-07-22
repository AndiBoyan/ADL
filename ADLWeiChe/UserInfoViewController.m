//
//  UserInfoViewController.m
//  ADLWeiChe
//
//  Created by icePhoenix on 15/6/9.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//

#import "UserInfoViewController.h"
#import "LoginViewController.h"
#import "CarInfoViewController.h"
#import "PresonerViewController.h"
#import "UserDefaults.h"
#import "AppDelegate.h"

@interface UserInfoViewController ()
{
    NSString *imagePath;
}
@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    userName = @"微途";
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65)];
    
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    
    [navigationItem setTitle:@"账户设置"];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    navigationItem.leftBarButtonItem = leftButton;
    
    navigationBar.tintColor = [UIColor colorWithRed:0.584f green:0.584f blue:0.584f alpha:1.0f];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [self.view addSubview:navigationBar];
    
    userInfoAry = [[NSArray alloc]initWithObjects:@"账户设置",@"我的爱车",@"个性化背景图片",@"推荐给朋友",@"关于我们",@"意见反馈",@"免责声明",@"退出登录", nil];
    
    userInfoTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height)];
    userInfoTable.delegate = self;
    userInfoTable.dataSource = self;
    [self.view addSubview:userInfoTable];
    [self setExtraCellLineHidden:userInfoTable];
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
    [self readImage];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [userInfoAry count]+1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        if (indexPath.row == 0) {
            self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 95, 5, 70, 70)];
            [self readImage];
            [cell.contentView addSubview:self.imageView];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, 100, 40)];
            label.text = userName;
            label.font = [UIFont systemFontOfSize:14.0f];
            [cell.contentView addSubview:label];
        }
        else
        {
            cell.textLabel.text = [userInfoAry objectAtIndex:indexPath.row-1];
            if (indexPath.row == 3) {
                UISwitch *switchButton = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 60, 5, 40, 30)];
                switchButton.on = YES;
                [switchButton addTarget:self action:@selector(switchButtonAction:) forControlEvents:UIControlEventValueChanged];
                [cell.contentView addSubview:switchButton];
            }
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 80;
    }
    else
        return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            //更换头像
            [self changeImage];
        }
            break;
        case 1:
        {
            //账户设置
            PresonerViewController *VC = [[PresonerViewController alloc]init];
            [self presentViewController:VC animated:YES completion:nil];
        }
            break;
        case 2:
        {
            //我的爱车
            CarInfoViewController *VC = [[CarInfoViewController alloc]init];
            [self presentViewController:VC animated:YES completion:nil];
        }
            break;
        case 4:
        {
            //推荐
        }
            break;
        case 5:
        {
            //关于我们
        }
            break;
        case 6:
        {
            //意见反馈
        }
            break;
        case 7:
        {
            //免责声明
            
        }
            break;
        case 8:
        {
            //退出登录
            AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
            delegate.isLoginOff = YES;
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            loginVC.isAutoLogin = NO;
            [self presentViewController:loginVC animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(void)switchButtonAction:(id)sender
{
    UISwitch *button = (UISwitch*)sender;
    if (button.on) {
        //开
    }
    else
    {
        //关
    }
}
#pragma mark 设置头像

//设置圆形头像
-(UIImage*)getEllipseImageWithImage:(UIImage*)originImage
{
    CGFloat padding = 0;//圆形图像距离图像的边距
    UIColor* epsBackColor = [UIColor clearColor];//图像的背景色
    CGSize originsize = originImage.size;
    CGRect originRect = CGRectMake(0, 0, originsize.width, originsize.height);
    UIGraphicsBeginImageContext(originsize);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //目标区域。
    CGRect desRect =  CGRectMake(padding, padding,originsize.width-(padding*2), originsize.height-(padding*2));
    //设置填充背景色。
    CGContextSetFillColorWithColor(ctx, epsBackColor.CGColor);
    //可以替换为 [epsBackColor setFill];
    UIRectFill(originRect);//真正的填充
    //设置椭圆变形区域。
    CGContextAddEllipseInRect(ctx,desRect);
    CGContextClip(ctx);//截取椭圆区域。
    [originImage drawInRect:originRect];//将图像画在目标区域。
    // 边框 //
    CGFloat borderWidth = 5;
    CGContextSetStrokeColorWithColor(ctx, [UIColor clearColor].CGColor);//设置边框颜色
    //可以替换为 [[UIColor whiteColor] setFill];
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextSetLineWidth(ctx, borderWidth);//设置边框宽度。
    CGContextAddEllipseInRect(ctx, desRect);//在这个框中画圆
    CGContextStrokePath(ctx); // 描边框。
    // 边框 //
    UIImage* desImage = UIGraphicsGetImageFromCurrentImageContext();// 获取当前图形上下文中的图像。
    UIGraphicsEndImageContext();
    return desImage;
}

-(void)readImage
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"image.png"]];   // 保存文件的名称
    UIImage *img = [UIImage imageWithContentsOfFile:filePath];
    if (img != nil) {
        self.imageView.image = [self getEllipseImageWithImage:img];
    }
    else
    {
        self.imageView.image = [self getEllipseImageWithImage:[UIImage imageNamed:@"80.png"]];
    }
}

#pragma mark actionsheetDelegate
-(void)changeImage
{
    UIActionSheet *changeImageSheet = [[UIActionSheet alloc]initWithTitle:@"选择相片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相册" otherButtonTitles:@"照相", nil];
    changeImageSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [changeImageSheet showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self selectForAlbumButtonClick];
    }else if (buttonIndex == 1) {
        [self selectForCameraButtonClick];
    }
}

//访问相册
-(void)selectForAlbumButtonClick
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"访问图片库错误"
                              message:@""
                              delegate:nil
                              cancelButtonTitle:@"OK!"
                              otherButtonTitles:nil];
        [alert show];
    }
}

//访问摄像头
-(void)selectForCameraButtonClick
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"不可使用摄像功能"
                              message:@""
                              delegate:nil
                              cancelButtonTitle:@"OK!"
                              otherButtonTitles:nil];
        [alert show];
    }
}

//图像选取器的委托方法，选完图片后回调该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    self.imageView.image = [self getEllipseImageWithImage:image]; //imageView为自己定义的UIImageView
    [self imageSavedPath];
    [picker dismissModalViewControllerAnimated:YES];
}
-(void)imageSavedPath
{
    UIImage *headerImage = self.imageView.image;
    if (headerImage != nil) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        /*写入图片*/
        imagePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"image.png"]];
        [UIImagePNGRepresentation(headerImage)writeToFile:imagePath  atomically:YES];
    }
}

@end
