//
//  UIScreen+CHASize.m
//  Changers
//
//  Created by Nikita Shitik on 07.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "UIScreen+CHASize.h"

@implementation UIScreen (CHASize)

+ (CGRect)cha_bounds {
    return [[[self class] mainScreen] bounds];
}

+ (CGSize)cha_size {
    return [[self class] cha_bounds].size;
}

+ (CGFloat)cha_width {
    return [[self class] cha_size].width;
}

+ (CGFloat)cha_height {
    return [[self class] cha_size].height;
}

+ (BOOL)cha_isPhone4 {
    return [self cha_height] == 480.f;
}

@end
