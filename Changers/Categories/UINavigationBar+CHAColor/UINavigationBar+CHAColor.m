//
//  UINavigationBar+CHAColor.m
//  Changers
//
//  Created by Nikita Shitik on 23.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "UINavigationBar+CHAColor.h"

#import "UIImage+CHAColor.h"

@implementation UINavigationBar (CHAColor)

- (void)cha_setBackgroundColor:(UIColor *)color {
    UIImage *image = [UIImage cha_imageWithColor:color size:self.bounds.size];
    [self setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.shadowImage = [UIImage new];
}

@end
