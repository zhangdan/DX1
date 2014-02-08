//
//  UIImage+UPDAddition.h
//  UPDFoundation
//
//  Created by zhangdan on 13-8-30.
//  Copyright (c) 2013年 sogou-inc.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UPD)


- (UIImage *)cropImageWithFitScrolSize:(CGSize )size;

- (UIImage *)generatePhotoThumbnail;

@end
