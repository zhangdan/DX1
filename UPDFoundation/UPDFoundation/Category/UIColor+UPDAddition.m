//
//  UIColor+UPDAddition.m
//  UPDFoundation
//
//  Created by Chen Qizhi on 8/16/13.
//  Copyright (c) 2013 sogou-inc.com. All rights reserved.
//

#import "UIColor+UPDAddition.h"

@implementation UIColor(UPD)

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert andAlpha:(CGFloat)alpha
{
    //去掉前后空格换行符
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
    else if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    
    if (cString.length != 6) {
        return nil;
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:alpha];
}

@end
