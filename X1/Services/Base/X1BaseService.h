//
//  X1BaseService.h
//  X1
//
//  Created by zhangdan on 14-2-7.
//  Copyright (c) 2014年 sogou-inc.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface X1BaseService : NSObject

- (void)requestJSONWithPath:(NSString *)path //请求方法，比如/dst/get.do
                     method:(NSString *)httpMethod //GET or POST
                     config:(void (^)(NSMutableDictionary *params))configBlock //设置请求参数，不需要设置基本参数
                    success:(void (^)(id response))successBlock //response通常是Array或Dictionary
                    failure:(void (^)(NSError *error))failureBlock; //请求失败

- (void)cancelAllRequest;

@end
