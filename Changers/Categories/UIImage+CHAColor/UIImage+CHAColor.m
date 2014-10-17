//
//  UIImage+CHAColor.m
//  Changers
//
//  Created by Nikita Shitik on 23.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "UIImage+CHAColor.h"

@implementation UIImage (CHAColor)

+ (instancetype)cha_imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
