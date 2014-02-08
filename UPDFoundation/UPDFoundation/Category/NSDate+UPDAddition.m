//
//  NSDate+UPDAddition.m
//  UPDFoundation
//
//  Created by zhangdan on 13-8-22.
//  Copyright (c) 2013年 sogou-inc.com. All rights reserved.
//

#import "NSDate+UPDAddition.h"

@implementation NSDate (UPD)

+ (NSString *)stringFromDate:(NSDate *)date  withFormate:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)readabilityStringFromDate:(double )timeStamp
{
    NSDate *tsdate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *from;
    NSDate *to;
    NSDate *fromDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:tsdate]];
    NSDate *toDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:now]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&from
                 interval:NULL forDate:fromDate];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&to
                 interval:NULL forDate:toDate];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit | NSYearCalendarUnit
                                               fromDate:from toDate:to options:0];
    if (difference.year > 0) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    else if (difference.day == 0) {
        [dateFormatter setDateFormat:@"HH:mm"];
    }
    else if (difference.day == 1) {
        [dateFormatter setDateFormat:@"昨天"];
    }
    else {
        [dateFormatter setDateFormat:@"MM-dd"];
    }
    return [dateFormatter stringFromDate:tsdate];
}


@end
