//
//  UserInfoViewController.h
//  ADLWeiChe
//
//  Created by icePhoenix on 15/6/9.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITableView *userInfoTable;
    NSArray *userInfoAry;
    UIImageView *faceImage;
    NSString *userName;
}

@property(strong, nonatomic) UIImageView *imageView;

@end
