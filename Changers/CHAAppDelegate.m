//
//  CHAAppDelegate.m
//  Changers
//
//  Created by Nikita Shitik on 05.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHAAppDelegate.h"
#import "CHAApplicationModel.h"
//appearance
#import "CHAAppearance.h"
#import "CHAIAPRecoinsHelper.h"

//Keychain
#import "Lockbox+CHAClear.h"

//facebook
#import <FacebookSDK/FacebookSDK.h>
#import "AFNetworkActivityIndicatorManager.h"

@interface CHAAppDelegate ()

@end

@implementation CHAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [CHAAppearance apply];
    [CHAIAPRecoinsHelper sharedInstance];
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    if ([defs objectForKey:kCHAFirstLaunchKey] == nil) {
        [Lockbox cha_clear];
        [defs setObject:[NSDate date] forKey:kCHAFirstLaunchKey];
        [defs synchronize];
    }
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    // Setting up the Core Data Stack
    [MagicalRecord setupAutoMigratingCoreDataStack];
    self.applicationModel = [CHAApplicationModel new];
    [self.applicationModel startInWindow:self.window];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - Facebook

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    return wasHandled;
}

@end
