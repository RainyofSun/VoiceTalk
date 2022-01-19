//
//  NSData+DESEncrypt.h
//  Nicelive
//
//  Created by 刘诗彬 on 16/2/15.
//  Copyright © 2016年 Nice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (DESEncrypt)
- (NSData *)des_encrypt;
- (NSData *)des_encryptWithKey:(NSString *)key;
- (NSData *)des_decrypt;
- (NSData *)des_decryptWithKey:(NSString *)key;
@end
