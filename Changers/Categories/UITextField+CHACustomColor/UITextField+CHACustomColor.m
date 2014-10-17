//
//  UITextField+CHACustomColor.m
//  Changers
//
//  Created by Nikita Shitik on 05.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "UITextField+CHACustomColor.h"

@implementation UITextField (CHACustomColor)

- (UIColor *)customPlaceholderColor {
    return nil;
}

- (void)setCustomPlaceholderColor:(UIColor *)customPlaceholderColor {
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder
                                                                 attributes:@{NSForegroundColorAttributeName:
                                                                                  customPlaceholderColor}];
}

@end
