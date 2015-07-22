//
//  PresonerViewController.m
//  ADLWeiChe
//
//  Created by icePhoenix on 15/6/12.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//

#import "PresonerViewController.h"

@interface PresonerViewController ()

@end

@implementation PresonerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65)];
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    
    [navigationItem setTitle:@"用户信息"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    navigationItem.leftBarButtonItem = leftButton;
    
    navigationBar.tintColor = [UIColor colorWithRed:0.584f green:0.584f blue:0.584f alpha:1.0f];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [self.view addSubview:navigationBar];
    
    presonTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, self.view.frame.size.height)];
    presonTable.delegate = self;
    presonTable.dataSource = self;
    [self setExtraCellLineHidden:presonTable];
    [self.view addSubview:presonTable];
    presonAry = [[NSArray alloc]initWithObjects:@"用户名",@"昵称",@"邮箱",@"手机",@"生日",@"地区", nil];
    presonInfoAry = [[NSMutableArray alloc]initWithObjects:@"澳鍀林",@"aodelin",@"aodelin@aodelin.com",@"18888888888",@"2104-5-5",@"广东省广州市花都区", nil];
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [presonAry count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil ) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.textLabel.text = [presonAry objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
        cell.detailTextLabel.text = [presonInfoAry objectAtIndex:indexPath.row];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    return cell;
}
@end
