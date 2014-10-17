//
//  UIButton+CHACustomFontName.m
//  Changers
//
//  Created by Nikita Shitik on 05.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "UIButton+CHACustomFontName.h"

@implementation UIButton (CHACustomFontName)

- (NSString *)customFontName {
    return self.titleLabel.font.fontName;
}

- (void)setCustomFontName:(NSString *)customFontName {
    self.titleLabel.font = [UIFont fontWithName:customFontName size:self.titleLabel.font.pointSize];
}

@end
