//
//  NSString+UPDAddition.h
//  UPDFoundation
//
//  Created by zhangdan on 13-7-25.
//  Copyright (c) 2013年 sogou-inc.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString(UPD)

- (NSString *)md5;

- (NSString *)urlEncode:(NSStringEncoding)stringEncoding;

- (CGFloat )heightForStringwidth:(CGFloat )width withFontSize:(CGFloat )size;

- (int)convertToInt;

- (BOOL)isURLString;

@end
