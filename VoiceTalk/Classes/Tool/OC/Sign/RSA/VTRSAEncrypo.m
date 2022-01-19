//
//  VTRSAEncrypo.m
//  VoiceTalk
//
//  Created by 刘冉 on 2022/1/11.
//  Copyright © 2022 macos. All rights reserved.
//

#import "VTRSAEncrypo.h"
#import "NSData+MKBase64.h"
#import <Security/Security.h>

#define RSA_KEY_BASE64 @"MIICjjCCAfegAwIBAgIJAO955m+1NjlrMA0GCSqGSIb3DQEBBQUAMGAxCzAJBgNVBAYTAkNOMRAw\
DgYDVQQIDAdCZWlqaW5nMRAwDgYDVQQHDAdCZWlqaW5nMQ4wDAYDVQQKDAVKaXphbjELMAkGA1UE\
CwwCUkQxEDAOBgNVBAMMB0NvbnRhY3QwHhcNMTQwNTIzMTIyMzM3WhcNMTQwNjIyMTIyMzM3WjBg\
MQswCQYDVQQGEwJDTjEQMA4GA1UECAwHQmVpamluZzEQMA4GA1UEBwwHQmVpamluZzEOMAwGA1UE\
CgwFSml6YW4xCzAJBgNVBAsMAlJEMRAwDgYDVQQDDAdDb250YWN0MIGfMA0GCSqGSIb3DQEBAQUA\
A4GNADCBiQKBgQCz6pa76j2c5YVahG5r4YoXPMpOK7gMJKNV01z+agKj3jiGYojK9/unFfB422iY\
WQkx1po5sOVVKU31U19VPZ7ORxauZpEk1A3yTpLPQj++ElVQLGgugERaoi2CY4TIwOd/g68idW+I\
d6jvr+3YqVqb8zwTb3H3OLzz53DYznGO9wIDAQABo1AwTjAdBgNVHQ4EFgQUqpSknq2+LQHE38T3\
NDpHSJSyfAAwHwYDVR0jBBgwFoAUqpSknq2+LQHE38T3NDpHSJSyfAAwDAYDVR0TBAUwAwEB/zAN\
BgkqhkiG9w0BAQUFAAOBgQACSYQyS37LA+N7hRlfyXYRR7F7V1pDqIuCIK1oNBZCmnXAfK+R+w+f\
zN+3All4xyv7dB9qXSZPgnT319TmbD1NIlzP01F5vj2/zJJBDK9fBMoqfH/miAgIoe0yu46LIWrI\
1oXUd30xBTrMDI32f/tfDqKiLXvs9XB4zuQo0ucpHA=="

@implementation VTRSAEncrypo

static SecKeyRef _public_key=nil;
+ (SecKeyRef) getPublicKey{ // 从公钥证书文件中获取到公钥的SecKeyRef指针
    if(_public_key == nil){
        NSData *certificateData = [NSData dataFromBase64String:RSA_KEY_BASE64];
        SecCertificateRef myCertificate =  SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)certificateData);
        SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
        SecTrustRef myTrust;
        OSStatus status = SecTrustCreateWithCertificates(myCertificate,myPolicy,&myTrust);
        SecTrustResultType trustResult;
        if (status == noErr) {
            SecTrustEvaluate(myTrust, &trustResult);
        }
        _public_key = SecTrustCopyPublicKey(myTrust);
        CFRelease(myCertificate);
        CFRelease(myPolicy);
        CFRelease(myTrust);
    }
    return _public_key;
}

+(NSString *)RSAEncrypotoTheData:(NSString *)plainText
{
    SecKeyRef publicKey=nil;
    publicKey=[self getPublicKey];
    size_t cipherBufferSize = SecKeyGetBlockSize(publicKey);
    uint8_t *cipherBuffer = NULL;
    
    cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    memset((void *)cipherBuffer, 0*0, cipherBufferSize);
    
    NSData *plainTextBytes = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    int blockSize = (int)cipherBufferSize-12;  // 这个地方比较重要是加密问组长度
    int numBlock = (int)ceil([plainTextBytes length] / (double)blockSize);
    NSMutableData *encryptedData = [[NSMutableData alloc] init];
    for (int i=0; i<numBlock; i++) {
        int bufferSize = MIN(blockSize,(int)[plainTextBytes length]-i*blockSize);
        NSData *buffer = [plainTextBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        OSStatus status = SecKeyEncrypt(publicKey,
                                        kSecPaddingPKCS1,
                                        (const uint8_t *)[buffer bytes],
                                        [buffer length],
                                        cipherBuffer,
                                        &cipherBufferSize);
        if (status == noErr)
        {
            NSData *encryptedBytes = [[NSData alloc]
                                       initWithBytes:(const void *)cipherBuffer
                                       length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
        }
        else
        {
            return nil;
        }
    }
    if (cipherBuffer)
    {
        free(cipherBuffer);
    }
    NSString *encrypotoResult=[NSString stringWithFormat:@"%@",[encryptedData base64EncodedString]];
    return encrypotoResult;
}

@end
