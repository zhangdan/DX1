//
//  UIImage+UPDAddition.m
//  UPDFoundation
//
//  Created by zhangdan on 13-8-30.
//  Copyright (c) 2013年 sogou-inc.com. All rights reserved.
//

#import "UIImage+UPDAddition.h"

@implementation UIImage (UPD)


- (UIImage *)cropImageWithFitScrolSize:(CGSize )size
{
    CGFloat cwh = size.width / size.height;
    CGFloat swh = self.size.width / self.size.height;
    
    if (cwh == swh) {
        return self;
    }
    if (cwh < swh) {
        CGFloat width = (self.size.height * size.height) / size.height;
        CGFloat x = (self.size.width - width) / 2;
        UIImage *result = [self cropImageWithX:x y:0 width:width height:self.size.height];
        return result;
        
    }
    if (cwh > swh) {
        CGFloat height = (self.size.width * size.width) / size.width;
        CGFloat y = (self.size.height - height) / 2;
        UIImage *result = [self cropImageWithX:0 y:y width:self.size.width height:height];
        return  result;
    }
    return self;
}


- (UIImage *)cropImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height
{
    CGRect rect = CGRectMake(x, y, width, height);
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}


- (UIImage *)generatePhotoThumbnail
{
    CGSize size = self.size;
    CGSize croppedSize;
    CGFloat ratio = 100.0;
    CGFloat offsetX = 0.0;
    CGFloat offsetY = 0.0;
    
    if (size.width > size.height) {
        offsetX = (size.height - size.width) / 2;
        croppedSize = CGSizeMake(size.height, size.height);
    } else {
        offsetY = (size.width - size.height) / 2;
        croppedSize = CGSizeMake(size.width, size.width);
    }
    
    CGRect clippedRect = CGRectMake(offsetX * -1, offsetY * -1, croppedSize.width, croppedSize.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], clippedRect);
    CGRect rect = CGRectMake(0.0, 0.0, ratio, ratio);
    
    UIGraphicsBeginImageContext(rect.size);
    [[UIImage imageWithCGImage:imageRef] drawInRect:rect];
    CGImageRelease(imageRef);
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return thumbnail;
}

@end
