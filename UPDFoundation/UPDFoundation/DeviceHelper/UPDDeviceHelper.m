//
//  UPDDeviceHelper.m
//  UPDFoundation
//
//  Created by zhangdan on 13-7-24.
//  Copyright (c) 2013年 sogou-inc.com. All rights reserved.
//

#import "UPDDeviceHelper.h"
#import "FoundationDefine.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import "SFHFKeychainUtils.h"
#import "NSString+UPDAddition.h"


//static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info)
//{
//    if(flags & kSCNetworkReachabilityFlagsConnectionRequired){
//		[UPDDeviceHelper shareInstance]->networkFlag = NS_NA;
//    }
//	else if(flags & kSCNetworkReachabilityFlagsReachable){
//		if(flags & kSCNetworkReachabilityFlagsIsWWAN)
//			[UPDDeviceHelper shareInstance]->networkFlag =  WWAN;
//		else
//			[UPDDeviceHelper shareInstance]->networkFlag =  WIFI;
//	}
//    else{
//        [UPDDeviceHelper shareInstance]->networkFlag = NS_NA;
//    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:NetworkState_Update
//                                                        object:nil];
//}


@interface UPDDeviceHelper(PrivateMethod)

- (void)onUIApplicationDidBecomeActive:(NSNotification*)notify;

@end

@implementation UPDDeviceHelper

static UPDDeviceHelper* _DeviceHelper = nil;

+ (UPDDeviceHelper*)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _DeviceHelper = [[UPDDeviceHelper alloc] initSingleton];
    });
    return _DeviceHelper;
}

- (id)init
{
    NSAssert(NO, @"Cannot create instance of Singleton");
    return nil;
}

- (id)initSingleton
{
    self = [super init];
    if(self){
		networkFlag = WIFI;
        //for Network Flag
		NSString* host = kNetworkState_Check_Sample;
		reachabilityRef = SCNetworkReachabilityCreateWithName(NULL, [host UTF8String]);
        [self initCarrierInfo];
        keyChainID = [self getKeyChainID];
        modelType = [self getDeviceModelType];
        resolution = [self getDeviceScreenResolution];
        appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];

        [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUIApplicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (BOOL)isNetworkConnect
{
	return [self getNetworkState];
}

- (NetworkState)getNetworkState
{
    return networkFlag;
}

- (void)onUIApplicationDidBecomeActive:(NSNotification*)notify
{
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
}

- (CGFloat)getBatteryLevel
{
    return [[UIDevice currentDevice] batteryLevel];
}

- (UIDeviceBatteryState)getBatteryState
{
    return [[UIDevice currentDevice] batteryState];
}

- (NSString *) platform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

- (NSString *) platformString
{
    NSString *platform = [self platform];
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4 CDMA";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 WiFi";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 GSM";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 CDMA";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 CDMAS";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini Wifi";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 WiFi";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 CDMA";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 GSM";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 Wifi";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return platform;
}


- (NSString *)getKeyChainID
{
    NSError *error;
    NSString *identifier = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
    NSString *keychainID = [SFHFKeychainUtils getPasswordForUsername:identifier andServiceName:identifier error:&error];
    if (keychainID == nil) {
        NSString *md5String = [[NSString stringWithFormat:@"%lld",(long long)([[NSDate date] timeIntervalSince1970] * 1000ll)] md5];
        NSString *uvid = [NSString stringWithFormat:@"%@%d",md5String,((arc4random() % 999 ) + 100)];
        keychainID = uvid;
        [SFHFKeychainUtils storeUsername:identifier andPassword:uvid forServiceName:identifier updateExisting:YES error:&error];
    }
    return keychainID;
}

@end


#pragma mark UPDDeviceHelper+MACAddress

#include <sys/types.h>
#include <sys/sysctl.h>
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <net/if_dl.h>
#include <ifaddrs.h>

#define IFT_ETHER 0x6

@implementation UPDDeviceHelper(MACAddress)

- (NSString*)getDeviceMACAddress:(char*)ifName
{
    int  success;
    struct ifaddrs * addrs;
    struct ifaddrs * cursor;
    const struct sockaddr_dl * dlAddr;
    const unsigned char* base;
    int i;
    
    NSMutableString* tempAddress = [[NSMutableString alloc] init];
    
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != 0){
            if ( (cursor->ifa_addr->sa_family == AF_LINK)
                && (((const struct sockaddr_dl *) cursor->ifa_addr)->sdl_type == IFT_ETHER)
                && strcmp(ifName,  cursor->ifa_name)==0){
                dlAddr = (const struct sockaddr_dl *) cursor->ifa_addr;
                base = (const unsigned char*) &dlAddr->sdl_data[dlAddr->sdl_nlen];
                
                for (i = 0; i < dlAddr->sdl_alen; i++){
                    if (i != 0)
                        [tempAddress appendString:@":"];
                    
                    [tempAddress appendFormat:@"%02X",base[i]];
                }
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return tempAddress;
}
@end

#pragma mark UPDDeviceHelper+Model

#include <sys/types.h>
#include <sys/sysctl.h>

@implementation UPDDeviceHelper(Model)

- (NSString*)getDeviceModelType
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}
@end

#pragma mark UPDDeviceHelper+Jailbreak

@implementation UPDDeviceHelper(Jailbreak)

- (BOOL)checkJailBreak
{
    BOOL result = (system("ls") == 0) ? YES : NO;
    if(result)
        return result;
    result = [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"];
    return result;
}
@end

#pragma mark UPDDeviceHelper+Carrier

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@implementation UPDDeviceHelper(Carrier)
- (void)initCarrierInfo
{
    Class messageClass = (NSClassFromString(@"CTTelephonyNetworkInfo"));
    if (messageClass==nil) {
        carrierName = @"na";
    }
    else{
        CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = info.subscriberCellularProvider;
        if(carrier != nil)
            carrierName = [carrier carrierName];
        else
            carrierName = @"na";
    }
}
@end

#pragma mark UPDDeviceHelper+Resolution

@implementation UPDDeviceHelper(Resolution)

- (BOOL)isRetianScreen
{
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
        if([[UIScreen mainScreen] scale] == 2.0)
            return YES;
    }
    return NO;
}

- (NSString*)getDeviceScreenResolution
{
    CGSize size = CGSizeZero;
    
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)]){
        CGRect rect = [[UIScreen mainScreen] bounds];
        size = CGSizeMake(rect.size.width * [[UIScreen mainScreen] scale], rect.size.height * [[UIScreen mainScreen] scale]);
    }
    else{
        CGRect rect = [[UIScreen mainScreen] bounds];
        size = rect.size;
    }
    if(size.width > size.height)
        return [NSString stringWithFormat:@"%.0fx%.0f",size.width,size.height];
    else
        return [NSString stringWithFormat:@"%.0fx%.0f",size.height,size.width];
}

@end
