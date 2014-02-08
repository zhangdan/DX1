//
//  X1BaseService.m
//  X1
//
//  Created by zhangdan on 14-2-7.
//  Copyright (c) 2014年 sogou-inc.com. All rights reserved.
//

#import "X1Define.h"
#import "X1BaseService.h"
#import "AFHTTPRequestOperationManager.h"

@implementation X1BaseService

static AFHTTPRequestOperationManager *sharemanager = nil;

- (id)init
{
    self = [super init];
    if (self) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSURL *baseURL = [NSURL URLWithString:@"http://example.com/"];
            sharemanager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
            
            NSOperationQueue *operationQueue = sharemanager.operationQueue;
            [sharemanager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
                switch (status) {
                    case AFNetworkReachabilityStatusReachableViaWWAN:
                    case AFNetworkReachabilityStatusReachableViaWiFi:
                        [operationQueue setSuspended:NO];
                        break;
                    case AFNetworkReachabilityStatusNotReachable:
                    default:
                        [operationQueue setSuspended:YES];
                        break;
                }
            }];
        });
    }
    return self;
}


- (void)requestJSONWithPath:(NSString *)path
                     method:(NSString *)httpMethod
                     config:(void (^)(NSMutableDictionary *params))configBlock
                    success:(void (^)(id response))successBlock
                    failure:(void (^)(NSError *error))failureBlock
{
    if (sharemanager.reachabilityManager.reachable) {
        NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
        if (configBlock != nil) {
            configBlock(paramsDic);
        }
        
        
        [sharemanager GET:path parameters:paramsDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            successBlock(responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            failureBlock(error);
        }];
        
    }else{
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"reachabilityManager.reachable is NO !", NSLocalizedDescriptionKey, nil];
        NSError *error = [[NSError alloc] initWithDomain:kX1AppErrorDomain
                                                    code:kNoNetWorkingErrorCode
                                                userInfo:userInfo];
        NSLog(@"Error: %@",error);
        failureBlock(error);
    }
}

- (void)cancelAllRequest
{
    [sharemanager.operationQueue cancelAllOperations];
}


- (NSString *)requstStringWithPath:(NSString *)path param:(NSDictionary *)paramDict
{
    if ([paramDict count] > 0) {
        NSArray *keys = [paramDict.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2){
                             return [obj1 compare:obj2];
                         }];
        NSMutableString *sigInfo = [[NSMutableString alloc] init];
        for (NSString *key in keys) {
            [sigInfo appendFormat:@"%@=%@&", key, [paramDict objectForKey:key]];
        }
        if ([keys count] > 0) {
            NSRange range = {[sigInfo length] - 1, 1};
            [sigInfo deleteCharactersInRange:range];
        }
        return [NSString stringWithFormat:@"%@?%@", path, sigInfo];
    } else {
        return [NSString stringWithFormat:@"%@", path];
    }
}


@end
