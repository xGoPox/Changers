//
//  UIScreen+CHASize.h
//  Changers
//
//  Created by Nikita Shitik on 07.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (CHASize)

+ (CGFloat)cha_width;
+ (CGFloat)cha_height;
+ (CGSize)cha_size;
+ (CGRect)cha_bounds;
+ (BOOL)cha_isPhone4;

@end
