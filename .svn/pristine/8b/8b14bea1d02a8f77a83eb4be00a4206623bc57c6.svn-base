//
//  BlueViewController.h
//  ADLWeiChe
//
//  Created by icePhoenix on 15/7/13.
//  Copyright (c) 2015年 aodelin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLEInfo.h"

@interface BlueViewController : UIViewController<CBPeripheralManagerDelegate,CBCentralManagerDelegate,CBPeripheralDelegate>


@property (nonatomic, strong) CBCentralManager *centralMgr;//蓝牙通信
@property (nonatomic, strong) CBPeripheral *discoveredPeripheral;//连接硬件蓝牙
@property (nonatomic, strong) CBService *thisService;
@property (strong, nonatomic) CBCharacteristic* writeCharacteristic;
@property (strong, nonatomic) NSData *periperalID;

@property (nonatomic, strong) NSMutableArray *arrayBLE;

// tableview sections，保存蓝牙设备里面的services字典，字典第一个为service，剩下是特性与值
@property (nonatomic, strong) NSMutableArray *arrayServices;

// 用来记录有多少特性，当全部特性保存完毕，刷新列表
@property (atomic, assign) int characteristicNum;
@property (strong, nonatomic) NSTimer *timer;

@end

