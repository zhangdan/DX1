//
//  UPDUtility.h
//  UPDFoundation
//
//  Created by zhangdan on 13-8-7.
//  Copyright (c) 2013年 sogou-inc.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UPDUtility : NSObject

/**
 *	base64forData
 *
 *	@param	theData	theData
 *
 *	@return	base64String
 */
+ (NSString*)base64forData:(NSData*)theData;

/**
 *	获取签名串
 *
 *	@param	key
 *	@param	string	等待用key签名的字符创
 *
 *	@return	签名后的字符串
 */
+ (NSData *)HMACSHA1withKey:(NSString *)key forString:(NSString *)string;

/**
 *  获取GUID
 *
 *  @return 返回GUID
 */
+ (NSString *)generateGUID;

@end
