//
//  CHALandingUserModel+CHAFetchedLocationViewController.m
//  Changers
//
//  Created by Nikita Shitik on 07.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHALandingUserModel+CHAFetchedLocationViewController.h"

@implementation CHALandingUserModel (CHAFetchedLocationViewController)

- (NSAttributedString *)locationText {
    NSString *introText = NSLocalizedString(@", the Changers app lets you measure your CO2 footprint. Step up for your hometown and take part in our country and city ranking.", nil);
    NSString *name = self.displayName;
    NSString *resultString = [NSString stringWithFormat:@"%@%@", name, introText];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:resultString];
    NSRange nameRange = NSMakeRange(0, name.length);
    NSRange fullRange = NSMakeRange(0, resultString.length);
    UIFont *fullFont = [UIFont fontWithName:kCHAKlavikaFontName size:14.f];
    UIFont *nameFont = [UIFont fontWithName:kCHAKlavikaMediumFontName size:14.f];
    [attributedString addAttribute:NSFontAttributeName value:fullFont range:fullRange];
    [attributedString addAttribute:NSFontAttributeName value:nameFont range:nameRange];
    return attributedString.copy;
}

@end
