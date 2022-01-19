//
//  NSString+DESEncrypt.m
//  GHLibrary
//
//  Created by Stephen Liu on 14/7/30.
//  Copyright (c) 2014年 Stephen Liu. All rights reserved.
//

#import "NSString+DESEncrypt.h"
#import "NSData+DESEncrypt.h"

@implementation NSString (DESEncrypt)

- (NSString *)des_encrypt
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptData = [data des_encrypt];
    return [[NSString alloc] initWithData:encryptData encoding:NSUTF8StringEncoding];
}

- (NSString *)des_decrypt
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptData = [data des_decrypt];
    return [[NSString alloc] initWithData:encryptData encoding:NSUTF8StringEncoding];
}

@end
