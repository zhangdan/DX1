//
//  UPDDeviceHelper.h
//  UPDFoundation
//
//  Created by zhangdan on 13-7-24.
//  Copyright (c) 2013年 sogou-inc.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>

typedef enum
{
	NS_NA	= 0,
	WIFI	= 1,
	WWAN	= 2,
}NetworkState;

@interface UPDDeviceHelper : NSObject
{
    @package
    SCNetworkReachabilityRef	reachabilityRef;
    NSString*                   keyChainID;
    NSString*                   modelType;
    NSString*                   appVersion;
    NSString*                   macAddress;
    NSString*                   m_macAddress;
    BOOL                        isJailBreak;
    NetworkState                networkFlag;
    
    NSString*                   carrierName;
    NSString*                   resolution;
    NSDate*                     activeTime;
}

+(UPDDeviceHelper*)shareInstance;

//network
-(NetworkState)getNetworkState;

// 是否网络连接
-(BOOL)isNetworkConnect;

//battery
-(CGFloat)getBatteryLevel;

// 电池状态
-(UIDeviceBatteryState)getBatteryState;

// 硬件设备类型
- (NSString *) platformString;

// iOS7以后，macaddress 和 Identifier 都不能取了
// 自己根据算法随一个唯一标识存起来
- (NSString *)getKeyChainID;
@end

#pragma mark DeviceHelper+MACAddress

@interface UPDDeviceHelper(MACAddress)

// 获取MAC地址
-(NSString*)getDeviceMACAddress:(char*)ifName;
@end

#pragma mark DeviceHelper+Model

@interface UPDDeviceHelper(Model)

// 硬件设备类型字符串
-(NSString*)getDeviceModelType;
@end

#pragma mark DeviceHelper+Jailbreak

@interface UPDDeviceHelper(Jailbreak)

// 机器是否破解
-(BOOL)checkJailBreak;
@end

#pragma mark DeviceHelper+Carrier

@interface UPDDeviceHelper(Carrier)

// 运营商信息
-(void)initCarrierInfo;
@end

#pragma mark DeviceHelper+Resolution

@interface UPDDeviceHelper(Resolution)

// 
-(BOOL)isRetianScreen;

//
-(NSString*)getDeviceScreenResolution;

@end
