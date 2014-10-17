//
//  UILabel+CHACustomFontName.m
//  Changers
//
//  Created by Nikita Shitik on 05.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "UILabel+CHACustomFontName.h"

@implementation UILabel (CHACustomFontName)

- (NSString *)customFontName {
    return self.font.fontName;
}

- (void)setCustomFontName:(NSString *)customFontName {
    self.font = [UIFont fontWithName:customFontName size:self.font.pointSize];
}


@end
