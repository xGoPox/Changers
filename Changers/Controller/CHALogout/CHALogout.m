//
//  CHALogout.m
//  Changers
//
//  Created by Nikita Shitik on 13.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHALogout.h"

#import <FacebookSDK/FacebookSDK.h>
#import "CHAAppDelegate.h"
#import "CHAApplicationModel.h"
#import "Lockbox+CHAClear.h"

@implementation CHALogout

+ (void)logoutFromWindow:(UIWindow *)window {
    
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
    
    if ([FBSession activeSession].isOpen) {
        [[FBSession activeSession] closeAndClearTokenInformation];
    }
    [Lockbox cha_clear];
    // Remove all unsending tracks
    [CHATracking MR_truncateAll];
    CHAAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.applicationModel showLoginScreenOnWindow:window animated:YES];
}

@end
