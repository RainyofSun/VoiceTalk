//
//  UIImage+SVGManager.h
//  VoiceTalk
//
//  Created by macos on 2021/4/15.
//  Copyright © 2021 macos. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (SVGManager)

/**
 show svg image

 @param name svg name
 @param size image size
 @return svg image
 */
+ (UIImage *)svgImageNamed:(NSString *)name size:(CGSize)size;

/**
 show svg image
 @param  filePath svg filePath
 @return svg image
 */
+ (UIImage *)svgImageWithContentFile:(NSString *)filePath;

/**
 show svg image
 
 @param name svg name
 @param size image size
 @param tintColor image color
 @return svg image
 */
+ (UIImage *)svgImageNamed:(NSString *)name size:(CGSize)size tintColor:(UIColor *)tintColor;

@end

NS_ASSUME_NONNULL_END
