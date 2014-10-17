//
//  CHALandingUserModel+CHARecoinTutorialViewController.m
//  Changers
//
//  Created by Nikita Shitik on 08.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHALandingUserModel+CHARecoinTutorialViewController.h"

@implementation CHALandingUserModel (CHARecoinTutorialViewController)

- (NSAttributedString *)tutorialText {
    NSString *name = self.displayName;
    NSString *introText = NSLocalizedString(@", you've just got 10 RC from us as a gift. Because we are awesome!", nil);
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
