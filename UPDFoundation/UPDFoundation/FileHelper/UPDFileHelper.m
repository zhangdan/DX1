//
//  UPDFileHelper.m
//  UPDFoundation
//
//  Created by zhangdan on 13-7-24.
//  Copyright (c) 2013年 sogou-inc.com. All rights reserved.
//

#import "UPDFileHelper.h"

@interface UPDFileHelper ()

@property(nonatomic,strong)NSFileManager * fileManager;
@property(nonatomic,strong)NSMutableDictionary *appDirectoryDic;
@property(nonatomic,assign)BOOL isCydiaPath;

@end

@implementation UPDFileHelper

static UPDFileHelper* m_FilePathHelper_Instance = nil;

+(UPDFileHelper *)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m_FilePathHelper_Instance = [[UPDFileHelper alloc] initSingleton];
    });
    return m_FilePathHelper_Instance;
}

-(id)init
{
    NSAssert(NO, @"Cannot create instance of Singleton");
    return nil;
}


-(id)initSingleton
{
    self = [super init];
    if(self){
        self.fileManager = [[NSFileManager alloc] init];
        self.appDirectoryDic = [NSMutableDictionary dictionary];
        {
			NSArray* dirArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *documentPath = [dirArray objectAtIndex:0];
            if ([documentPath rangeOfString:@"Applications"].length == 0) {
                documentPath = @"/User/Library/Kuaiapp/Documents/";
                _isCydiaPath = YES;
            }
            [self.appDirectoryDic setObject:documentPath
                                     forKey:[NSNumber numberWithUnsignedInteger:NSDocumentDirectory]];
		}
		{
			NSArray* dirArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
            NSString *cachePath = [dirArray objectAtIndex:0];
            if ([cachePath rangeOfString:@"Applications"].length == 0) {
                cachePath = @"/User/Library/Kuaiapp/Library/";
                _isCydiaPath = YES;
            }
            [self.appDirectoryDic setObject:cachePath
                                     forKey:[NSNumber numberWithUnsignedInteger:NSCachesDirectory]];
		}
    }
    return self;
}

-(BOOL)checkCydiaPath
{
    return self.isCydiaPath;
}


-(NSString*)getAppDirectory:(NSSearchPathDirectory)directoryType{
    return [self.appDirectoryDic objectForKey:[NSNumber numberWithUnsignedInteger:directoryType]];
}


-(NSArray*)getFilesInDirectory:(NSString*)directoryPath byType:(NSString*)fileType error:(NSError*)error{
	NSArray* files = [self.fileManager contentsOfDirectoryAtPath:directoryPath error:&error];
    if(error != nil)
        return nil;
	NSMutableArray* resultArray = [[NSMutableArray alloc] init];
	for (NSInteger index=0; index < [files count]; index++){
		NSString* fileName = [files objectAtIndex:index];
		NSString* extType = [fileName pathExtension];
		if(fileType != nil && NO == [extType isEqualToString:fileType])
			continue;
		[resultArray addObject:fileName];
	}
	return resultArray;
}

-(NSDictionary*)getAttributeInFile:(NSString*)filePath error:(NSError*)error{
    NSDictionary* result = [self.fileManager attributesOfItemAtPath:filePath
                                                              error:&error];
    if(error != nil)
        return nil;
    return result;
}

-(void)updateFileModifyTime:(NSString*)filePath{
    NSDictionary* attribute = [NSDictionary dictionaryWithObject:[NSDate date]
                                                          forKey:NSFileModificationDate];
    NSError* error = nil;
    [self setFile:filePath attribute:attribute error:error];
}

-(void)setFile:(NSString*)filePath  attribute:(NSDictionary*)attribute error:(NSError*)error{
    if(NO == [self isFileExist:filePath])
        return;
    [self.fileManager setAttributes:attribute ofItemAtPath:filePath error:&error];
}

-(BOOL)isFileExist:(NSString*)filePath{
	BOOL isDirectory = NO;
	BOOL result = [self.fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
	return result&!isDirectory;
}

-(BOOL)isDirectoryExist:(NSString*)directoryPath{
	BOOL isDirectory = NO;
	BOOL result = [self.fileManager fileExistsAtPath:directoryPath isDirectory:&isDirectory];
	return result&isDirectory;
}

-(void)createDirectory:(NSString*)directoryPath error:(NSError*)error{
    [self.fileManager createDirectoryAtPath:directoryPath
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:&error];
}

-(void)deleteDirectory:(NSString*)directoryPath error:(NSError*)error{
	if(NO == [self isDirectoryExist:directoryPath])
		return;
	[self.fileManager removeItemAtPath:directoryPath error:&error];
}

-(void)clearDirectory:(NSString*)directoryPath error:(NSError*)error{
   	NSArray* files = [self.fileManager contentsOfDirectoryAtPath:directoryPath error:&error];
    if(error != nil)
        return;
    for(NSString* file in files){
        [self.fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",directoryPath,file]
                                     error:&error];
    }
}

-(void)deleteFile:(NSString*)filePath error:(NSError*)error{
	if(NO == [self isFileExist:filePath])
        return;
    
	[self.fileManager removeItemAtPath:filePath error:&error];
}

-(void)copyItemFrom:(NSString*)sourcePath to:(NSString*)targetPath error:(NSError*)error{
    if([self isFileExist:targetPath])
        [self deleteFile:targetPath error:error];
    [self.fileManager copyItemAtPath:sourcePath toPath:targetPath error:&error];
}

-(double)getDirectorySizeForPath:(NSString*)directoryPath{
    if(NO == [self isDirectoryExist:directoryPath])
        return -1;
    NSDirectoryEnumerator* e = [self.fileManager enumeratorAtPath:directoryPath];
    if(e == NULL)
        return -1;
	double totalSize = 0;
	while ([e nextObject]){
		NSDictionary *attributes = [e fileAttributes];
		NSNumber *fileSize = [attributes objectForKey:NSFileSize];
		totalSize += [fileSize longLongValue];
	}
	return totalSize;
}

-(double)getFileSystemFreeSize{
    NSError* error = nil;
	NSDictionary* attribute = [self.fileManager attributesOfFileSystemForPath:[self.appDirectoryDic objectForKey:[NSNumber numberWithUnsignedInteger:NSDocumentDirectory]]
                                                                        error:&error];
    if(error != nil)
        return -1;
	NSNumber* size = [attribute objectForKey:NSFileSystemFreeSize];
	return 	[size doubleValue];
}

-(double)getApplicationSize{
    NSString* appPath = [[self.appDirectoryDic objectForKey:[NSNumber numberWithUnsignedInteger:NSDocumentDirectory]] stringByDeletingLastPathComponent];
	NSDirectoryEnumerator* e = [self.fileManager enumeratorAtPath:appPath];
    if(e == NULL)
        return -1;
	
	double totalSize = 0;
	while ([e nextObject]){
		NSDictionary *attributes = [e fileAttributes];
		NSNumber *fileSize = [attributes objectForKey:NSFileSize];
		totalSize += [fileSize longLongValue];
	}
	return totalSize;
}

-(double)getFileSystemTotalSize{
    NSError* error = nil;
	NSDictionary* attribute = [self.fileManager attributesOfFileSystemForPath:[self.appDirectoryDic objectForKey:[NSNumber numberWithUnsignedInteger:NSDocumentDirectory]] error:&error];
    if(error != nil)
        return -1;
	NSNumber* size = [attribute objectForKey:NSFileSystemSize];
	return 	[size doubleValue];
}


-(BOOL)disableFileBackup:(NSString*)filePath
{
    return YES;
}

//清理缓存数据
-(void)clearCachedData
{
//    if ([self checkNeedToClear]) {
//        return;
//    }
//    
//    UIApplication* app = [UIApplication sharedApplication];
//	self.cleanExpiredTask = [app beginBackgroundTaskWithExpirationHandler:^{
//		[app endBackgroundTask:self.cleanExpiredTask];
//		self.cleanExpiredTask = UIBackgroundTaskInvalid;
//	}];
//	
//	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//		[self cleanCacheExpiredCacheBackground];
//		[app endBackgroundTask:self.cleanExpiredTask];
//		self.cleanExpiredTask = UIBackgroundTaskInvalid;
//	});

}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

@end
