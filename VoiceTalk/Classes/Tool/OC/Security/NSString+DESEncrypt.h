//
//  NSString+DESEncrypt.h
//  GHLibrary
//
//  Created by Stephen Liu on 14/7/30.
//  Copyright (c) 2014年 Stephen Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DESEncrypt)
- (NSString *)des_encrypt;
- (NSString *)des_decrypt;
@end
