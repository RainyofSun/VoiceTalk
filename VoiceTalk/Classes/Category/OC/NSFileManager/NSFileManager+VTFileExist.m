//
//  NSFileManager+VTFileExist.m
//  VoiceTalk
//
//  Created by 刘冉 on 2022/1/19.
//  Copyright © 2022 macos. All rights reserved.
//

#import "NSFileManager+VTFileExist.h"

NSString *NSDocumentsFolder(void) {
    static NSString *documentFolder = nil;
    if (documentFolder == nil)
    {
        documentFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    return documentFolder;
}

NSString *NSLibraryFolder(void) {
    static NSString *libraryFolder = nil;
    if (libraryFolder == nil)
    {
        libraryFolder = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    return libraryFolder;
}

NSString *NSBundleFolder(void) {
    return [[NSBundle mainBundle] bundlePath];
}

NSString *TempFileWithName(NSString *name) {
    NSCAssert(name.length > 0, @"文件名不能为空");
    return [NSTemporaryDirectory() stringByAppendingPathComponent:name];
}

NSString *DocumentFileWithName(NSString *name) {
    NSCAssert(name.length > 0, @"文件名不能为空");
    return [NSDocumentsFolder() stringByAppendingPathComponent:name];
}

NSString *LibraryFileWithName(NSString *name) {
    NSCAssert(name.length > 0, @"文件名不能为空");
    return [NSLibraryFolder() stringByAppendingPathComponent:name];
}

NSString *ResourcePath(void) {
    return [[NSBundle mainBundle] resourcePath];
}

NSString *ResourceWithName(NSString *name) {
    NSCAssert(name.length > 0, @"文件名不能为空");
    return [ResourcePath() stringByAppendingPathComponent:name];
}

NSString *CacheFilePath() {
    static NSString *cachePath = nil;
    if (!cachePath) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        cachePath = [paths firstObject];
    }
    return cachePath;
}

NSString *CacheFileWithName(NSString *name) {
    NSCAssert(name.length > 0, @"文件名不能为空");
    return [CacheFilePath() stringByAppendingPathComponent:name];
}

@implementation NSFileManager (VTFileExist)

- (BOOL)buildFolderPath:(NSString *)path error:(NSError **)error
{
    BOOL isDirectory = NO;
    BOOL exists = [FILEMANAGER fileExistsAtPath:path isDirectory:&isDirectory];
    if (exists)
    {
        if (!isDirectory)
        {
            [FILEMANAGER removeItemAtPath:path error:NULL];
            return [FILEMANAGER createDirectoryAtPath:path
                          withIntermediateDirectories:NO
                                           attributes:nil
                                                error:error];
        }
        else
        {
            return YES;
        }
    }
    else
    {
        NSString *parent = [path stringByDeletingLastPathComponent];
        if ([self buildFolderPath:parent error:error])
        {
            return [FILEMANAGER createDirectoryAtPath:path
                          withIntermediateDirectories:NO
                                           attributes:nil
                                                error:error];
        }
    }
    return NO;
}

+ (NSData*)dataOfFile:(NSString*)filePath offset:(unsigned long long)offset length:(unsigned long long)length
{
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if (!fileHandle) return nil;
    
    NSError *error = nil;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSDictionary *stat = [fileManager attributesOfItemAtPath:filePath error:&error];
    
    if (error != nil) return nil;
    
    unsigned long long totalLength = [stat fileSize];
    
    if (length <= 0 || offset + length > totalLength)
    {
        length = totalLength - offset;
    }
    
    [fileHandle seekToFileOffset:offset];
    return [fileHandle readDataOfLength:(NSUInteger)length];
}

+ (NSString *) pathForItemNamed: (NSString *) fname inFolder: (NSString *) path
{
    NSString *itemPath = [path stringByAppendingPathComponent:fname];
    if (![FILEMANAGER fileExistsAtPath:itemPath])
    {
        return nil;
    }
    return itemPath;
    
    
    NSString *file = nil;
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
    while ((file = [dirEnum nextObject]))
    {
        if ([[file lastPathComponent] isEqualToString:fname])
        {
            return [path stringByAppendingPathComponent:file];
        }
    }
    return nil;
}

+ (NSString *) pathForDocumentNamed: (NSString *) fname
{
    return [NSFileManager pathForItemNamed:fname inFolder:NSDocumentsFolder()];
}

+ (NSString *) pathForBundleDocumentNamed: (NSString *) fname
{
    return [NSFileManager pathForItemNamed:fname inFolder:NSBundleFolder()];
}

+ (NSArray *) filesInFolder: (NSString *) path
{
    NSString *file;
    NSMutableArray *results = [NSMutableArray array];
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
    while ((file = [dirEnum nextObject]))
    {
        BOOL isDir;
        [[NSFileManager defaultManager] fileExistsAtPath:[path stringByAppendingPathComponent:file] isDirectory: &isDir];
        if (!isDir)
        {
            [results addObject:file];
        }
    }
    return results;
}

// Case insensitive compare, with deep enumeration
+ (NSArray *) pathsForItemsMatchingExtension: (NSString *) ext inFolder: (NSString *) path
{
    NSString *file;
    NSMutableArray *results = [NSMutableArray array];
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
    while ((file = [dirEnum nextObject]))
    {
        if ([[file pathExtension] caseInsensitiveCompare:ext] == NSOrderedSame)
        {
            [results addObject:[path stringByAppendingPathComponent:file]];
        }
    }
    return results;
}

+ (NSArray *) pathsForDocumentsMatchingExtension: (NSString *) ext
{
    return [NSFileManager pathsForItemsMatchingExtension:ext inFolder:NSDocumentsFolder()];
}

// Case insensitive compare
+ (NSArray *) pathsForBundleDocumentsMatchingExtension: (NSString *) ext
{
    return [NSFileManager pathsForItemsMatchingExtension:ext inFolder:NSBundleFolder()];
}

+ (BOOL)createDirectoryIfNotExist:(NSString *)directory
{
    NSFileManager *fileManager = FILEMANAGER;
    
    BOOL isDir = NO;
    BOOL isExists = [fileManager fileExistsAtPath:directory isDirectory:&isDir];
    
    if (isExists && !isDir) {
        [fileManager removeItemAtPath:directory error:NULL];
    }
    if (!isExists || !isDir) {
        BOOL result = [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
        return result;
    }
    
    return YES;
    
}

+ (CGFloat)fileSizeWithPath:(NSString *)path
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return 0;
    }
    
    CGFloat fileSize = 0;
    NSError *error = nil;
    NSDictionary *fileAttr = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
    if (error != nil) {
        return fileSize;
    }
    fileSize = [fileAttr fileSize] / 1024.0;
    return fileSize;
}

@end
