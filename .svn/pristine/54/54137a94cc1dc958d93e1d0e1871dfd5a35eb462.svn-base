//
//  CarInfoViewController.m
//  ADLWeiChe
//
//  Created by icePhoenix on 15/6/12.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//

#import "CarInfoViewController.h"

@interface CarInfoViewController ()

@end

@implementation CarInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65)];
    
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    
    [navigationItem setTitle:@"爱车信息"];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    navigationItem.leftBarButtonItem = leftButton;
    
    navigationBar.tintColor = [UIColor colorWithRed:0.584f green:0.584f blue:0.584f alpha:1.0f];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [self.view addSubview:navigationBar];
    carTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height)];
    carTable.delegate = self;
    carTable.dataSource =self;
    [self setExtraCellLineHidden:carTable];
    [self.view addSubview:carTable];
    
    carAry = [[NSArray alloc]initWithObjects:@"车牌号码",@"发动机号",@"车架号码",@"汽车品牌", nil];
    carInfoAry = [[NSMutableArray alloc]initWithObjects:@"粤A88888",@"888888",@"555555",@"奥迪A8", nil];
    
}
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [carAry count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.textLabel.text = [carAry objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
        cell.detailTextLabel.text = [carInfoAry objectAtIndex:indexPath.row];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        //修改车牌号码
    }
    if (indexPath.row == 1) {
        //修改发动机号
    }
    if (indexPath.row == 2) {
        //修改车架号码
    }
    if (indexPath.row == 3) {
        //修改汽车品牌
    }
}
@end
