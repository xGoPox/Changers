//
//  CHAAppearance.m
//  Changers
//
//  Created by Nikita Shitik on 06.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHAAppearance.h"

@implementation CHAAppearance

#pragma mark - Public

+ (void)apply {
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: [self navigationFont],
                                                           NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

#pragma mark - Private

+ (UIFont *)navigationFont {
    return [UIFont fontWithName:kCHAKlavikaFontName size:16.f];
}

@end
