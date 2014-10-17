//
//  CHALandingUserModel+CHAFacebookViewController.m
//  Changers
//
//  Created by Nikita Shitik on 09.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHALandingUserModel+CHAFacebookViewController.h"

@implementation CHALandingUserModel (CHAFacebookViewController)

- (NSString *)facebookGreetingString {
    NSString *localizedFormat = @"HEY %@!";
    NSString *firstNameString = self.firstName.length ? self.firstName : @"";
    return [[NSString stringWithFormat:localizedFormat, firstNameString] capitalizedString];
}

- (NSString *)fullNameString {
    return [self.displayName uppercaseString];
}

@end
