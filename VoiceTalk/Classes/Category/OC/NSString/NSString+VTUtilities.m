//
//  NSString+VTUtilities.m
//  VoiceTalk
//
//  Created by 刘冉 on 2022/1/11.
//  Copyright © 2022 macos. All rights reserved.
//

#import "NSString+VTUtilities.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>

@implementation NSString (VTUtilities)

- (NSString *)VT_MD5String {
    unsigned char hashedChars[CC_MD5_DIGEST_LENGTH];
    
    const char *cData = [self cStringUsingEncoding:NSUTF8StringEncoding];
    
    CC_MD5(cData, (CC_LONG)strlen(cData), hashedChars);
    
    char hash[2 * sizeof(hashedChars) + 1];
    for (size_t i = 0; i < sizeof(hashedChars); ++i) {
        snprintf(hash + (2 * i), 3, "%02x", (int)(hashedChars[i]));
    }
    
    return [NSString stringWithUTF8String:hash];
}

@end
