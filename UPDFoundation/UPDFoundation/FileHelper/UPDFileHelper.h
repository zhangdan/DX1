//
//  UPDFileHelper.h
//  UPDFoundation
//
//  Created by zhangdan on 13-7-24.
//  Copyright (c) 2013年 sogou-inc.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UPDFileHelper : NSObject


+(UPDFileHelper *)shareInstance;

//检查是否是Cydia安装的，NO:默认安装；YES:Cydia安装
-(BOOL)checkCydiaPath;

//NSDocumentDirectory,NSCachesDirectory
//获取沙盒内NSSearchPathDirectory 对应的目录。
-(NSString*)getAppDirectory:(NSSearchPathDirectory)directoryType;

//检查filePath路径对应的文件是否存在。
-(BOOL)isFileExist:(NSString*)filePath;

//检查directoryPath路径对应的文件夹是否存在。
-(BOOL)isDirectoryExist:(NSString*)directoryPath;

//获取指定文件夹directoryPath 下某种类型的所有文件。
-(NSArray*)getFilesInDirectory:(NSString*)directoryPath byType:(NSString*)fileType error:(NSError*)error;

//获取filePath对应文件的属性。
-(NSDictionary*)getAttributeInFile:(NSString*)filePath error:(NSError*)error;

//给filePath对应的文件设置属性。
-(void)setFile:(NSString*)filePath  attribute:(NSDictionary*)attribute error:(NSError*)error;

//在应用沙盒内指定位置directoryPath创建一个目录。
-(void)createDirectory:(NSString*)directoryPath error:(NSError*)error;

//在应用沙盒内删除directoryPath文件夹及其目录下的内容。
-(void)deleteDirectory:(NSString*)directoryPath error:(NSError*)error;

//删除filePath对应的文件。
-(void)deleteFile:(NSString*)filePath error:(NSError*)error;

//将一个文件从sourcePath复制到targetPath。
-(void)copyItemFrom:(NSString*)sourcePath to:(NSString*)targetPath error:(NSError*)error;

//删除文件夹directoryPath下所有文件并保留这个目录。
-(void)clearDirectory:(NSString*)directoryPath error:(NSError*)error;

//设置filePath路径对应文件属性，使得文件不被自动上传到iCloud.
-(BOOL)disableFileBackup:(NSString*)filePath;

//更新一个filePath路径对应文件的最近更新时间
-(void)updateFileModifyTime:(NSString*)filePath;

//获取指定目录path下，所有文件占磁盘空间大小。
-(double)getDirectorySizeForPath:(NSString*)path;

//获取系统还剩余多少磁盘空间。
-(double)getFileSystemFreeSize;

//获取当前应用程序所占磁盘空间大小
-(double)getApplicationSize;

//获取应用文件系统大小
-(double)getFileSystemTotalSize;

//清理缓存数据
-(void)clearCachedData;

//不要备份数据到iCloud
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

@end
