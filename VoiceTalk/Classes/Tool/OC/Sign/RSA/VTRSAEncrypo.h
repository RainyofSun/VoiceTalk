//
//  VTRSAEncrypo.h
//  VoiceTalk
//
//  Created by 刘冉 on 2022/1/11.
//  Copyright © 2022 macos. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VTRSAEncrypo : NSObject

+ (SecKeyRef) getPublicKey;
+ (NSString *)RSAEncrypotoTheData:(NSString *)plainText;

@end

NS_ASSUME_NONNULL_END
