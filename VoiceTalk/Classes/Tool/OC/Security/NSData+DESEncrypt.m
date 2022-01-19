//
//  NSData+DESEncrypt.m
//  Nicelive
//
//  Created by 刘诗彬 on 16/2/15.
//  Copyright © 2016年 Nice. All rights reserved.
//

#import "NSData+DESEncrypt.h"
#import <CommonCrypto/CommonCryptor.h>
#import "NSData+MKBase64.h"
#import "NSString+VTUtilities.h"

static inline NSString *_gkey()
{
    static NSString *_gkey = nil;
    if (!_gkey) {
        NSString *bundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey];
        _gkey = [bundleId VT_MD5String];
    }
    return _gkey;
}

static inline NSString *_gIv()
{
    static NSString *_gIv = nil;
    if (!_gIv) {
        NSString *bundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey];
        
        //这两个key很重要，不能改！
        _gIv = [[[@"stephen" stringByAppendingString:bundleId] stringByAppendingString:@"encryptkey"] VT_MD5String];
    }
    return _gIv;
}

@implementation NSData (DESEncrypt)
- (NSData *)des_encrypt
{
    return [self des_encryptWithKey:_gkey()];
}

- (NSData *)des_encryptWithKey:(NSString *)key
{
    if (!key) {
        return nil;
    }
    NSData *data = self;
    size_t plainTextBufferSize = [data length];
    const void *vplainText = (const void *)[data bytes];
    
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [key UTF8String];
    const void *vinitVec = (const void *) [_gIv() UTF8String];
    
    CCCrypt(kCCEncrypt,
            kCCAlgorithm3DES,
            kCCOptionPKCS7Padding,
            vkey,
            kCCKeySize3DES,
            vinitVec,
            vplainText,
            plainTextBufferSize,
            (void *)bufferPtr,
            bufferPtrSize,
            &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    NSString *result = [myData base64EncodedString];
    free(bufferPtr);
    return [result dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSData *)des_decrypt
{
    return [self des_decryptWithKey:_gkey()];
}

- (NSData *)des_decryptWithKey:(NSString *)key
{
    if (!key) {
        return nil;
    }
    NSData *encryptData = [NSData dataFromBase64String:[[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding]];
    size_t plainTextBufferSize = [encryptData length];
    const void *vplainText = [encryptData bytes];
    
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [key UTF8String];
    const void *vinitVec = (const void *) [_gIv() UTF8String];
    
    CCCrypt(kCCDecrypt,
            kCCAlgorithm3DES,
            kCCOptionPKCS7Padding,
            vkey,
            kCCKeySize3DES,
            vinitVec,
            vplainText,
            plainTextBufferSize,
            (void *)bufferPtr,
            bufferPtrSize,
            &movedBytes);
    
    NSData *data = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    free(bufferPtr);
    return data;
}
@end
