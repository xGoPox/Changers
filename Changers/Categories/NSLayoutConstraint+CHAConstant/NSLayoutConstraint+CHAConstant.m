//
//  NSLayoutConstraint+CHAConstant.m
//  Changers
//
//  Created by Nikita Shitik on 25.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "NSLayoutConstraint+CHAConstant.h"

@implementation NSLayoutConstraint (CHAConstant)

- (NSString *)chaConstant {
    return [NSString stringWithFormat:@"%@", @(self.constant)];
}

- (void)setChaConstant:(NSString *)chaConstant {
    if ([UIScreen cha_isPhone4]) {
        self.constant = [chaConstant floatValue];
    }
}

@end
