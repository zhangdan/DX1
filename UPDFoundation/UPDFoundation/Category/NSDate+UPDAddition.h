//
//  NSDate+UPDAddition.h
//  UPDFoundation
//
//  Created by zhangdan on 13-8-22.
//  Copyright (c) 2013年 sogou-inc.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (UPD)

+ (NSString *)stringFromDate:(NSDate *)date  withFormate:(NSString *)formatter;

+ (NSString *)readabilityStringFromDate:(double )timeStamp;
@end
