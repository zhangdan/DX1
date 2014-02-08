//
//  NSString+UPDAddition.m
//  UPDFoundation
//
//  Created by zhangdan on 13-7-25.
//  Copyright (c) 2013年 sogou-inc.com. All rights reserved.
//

#import "NSString+UPDAddition.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString(UPD)

- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    if (cStr) {
        CC_MD5(cStr, strlen(cStr), result);
        return [[NSString stringWithFormat:
                 @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                 result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
                 result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
                 ] lowercaseString];
    }
    else {
        return nil;
    }
}


- (NSString *)urlEncode:(NSStringEncoding)stringEncoding
{
    NSArray *escapeChars = [NSArray arrayWithObjects:@";", @"/", @"?", @":",
                            @"@", @"&", @"=", @"+", @"$", @",", @"!",
                            @"'", @"(", @")", @"*", @"-", @"~", @"_", nil];
    NSArray *replaceChars = [NSArray arrayWithObjects:@"%3B", @"%2F", @"%3F", @"%3A",
                             @"%40", @"%26", @"%3D", @"%2B", @"%24", @"%2C", @"%21",
                             @"%27", @"%28", @"%29", @"%2A", @"%2D", @"%7E", @"%5F", nil];
    int len = [escapeChars count];
    NSString *tempStr = [self stringByAddingPercentEscapesUsingEncoding:stringEncoding];
    if (tempStr == nil) {
        return nil;
    }
    NSMutableString *temp = [tempStr mutableCopy];
    int i;
    for (i = 0; i < len; i++) {
        
        [temp replaceOccurrencesOfString:[escapeChars objectAtIndex:i]
                              withString:[replaceChars objectAtIndex:i]
                                 options:NSLiteralSearch
                                   range:NSMakeRange(0, [temp length])];
    }
    NSString *outStr = [NSString stringWithString:temp];
    return outStr;
}

- (CGFloat )heightForStringwidth:(CGFloat )width withFontSize:(CGFloat )size
{
    CGSize constraint = CGSizeMake(width, 20000.0f);
    CGSize contentsize = [self sizeWithFont:[UIFont systemFontOfSize:size] constrainedToSize:constraint lineBreakMode:NSLineBreakByCharWrapping];
    return contentsize.height;
}


- (int)convertToInt
{
    int strlength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0; i < [self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength + 1) / 2;
}

- (BOOL)isURLString
{
    NSString *http = @"http://";
    if ([self hasPrefix:http] &&
        [self length] > [http length]) {
        return YES;
    }else{
        return NO;
    }
}

@end
