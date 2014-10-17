//
//  CHAApplicationModel.m
//  Changers
//
//  Created by Denis on 11.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHAApplicationModel.h"
#import "CHARevealViewController.h"
#import "Lockbox.h"
#import "Reachability.h"
#import "CHAAPIClient.h"

@interface CHAApplicationModel ()
@property (nonatomic, strong, readwrite) CHATracker *tracker;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic, assign) NetworkStatus netStatus;
@property (nonatomic, assign) BOOL isPresenting;
- (void)resendFailedTransactions;
@end

@implementation CHAApplicationModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resendFailedTransactions) name:UIApplicationWillEnterForegroundNotification object:nil];
        [self resendFailedTransactions];
        self.internetReachability = [Reachability reachabilityForInternetConnection];
        self.netStatus = self.internetReachability.currentReachabilityStatus;
        [self.internetReachability startNotifier];
        self.isPresenting = NO;
    }
    return self;
}

- (void)startInWindow:(UIWindow *)window {
    NSString *token = [Lockbox stringForKey:kCHATokenName];
    if (token.length == 0) {
        [self showLoginScreenOnWindow:window animated:NO];
    } else {
        [self showHomeScreenOnWindow:window animated:NO];
    }
}

- (void)showLoginScreenOnWindow:(UIWindow *)window animated:(BOOL)animated {
    NSString *name = @"Onboarding";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateInitialViewController];
    if (animated == NO) {
        window.rootViewController = navigationController;
    } else {
        UIView *destinationView = navigationController.view;
        UIView *startView = [window.subviews lastObject];
        [window insertSubview:destinationView belowSubview:startView];
        [UIView animateWithDuration:.4
                              delay:0.
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGRect rect = startView.frame;
                             rect.origin.y += CGRectGetHeight(startView.frame);
                             startView.frame = rect;
                         } completion:^(BOOL finished) {
                             window.rootViewController = nil;
                             [[window subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
                             window.rootViewController = navigationController;
                         }];
    }

}

- (void)showHomeScreenOnWindow:(UIWindow *)window animated:(BOOL)animated {
    if (self.isPresenting == NO) {
        self.isPresenting = YES;
        self.tracker = [CHATracker new];
        UIStoryboard *homeStoryboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        CHARevealViewController *homeViewController = [homeStoryboard instantiateInitialViewController];
        homeViewController.tracker = self.tracker;
        if (animated == NO) {
            self.isPresenting = NO;
            [window setRootViewController:homeViewController];
        } else {
            UIView *destinationView = homeViewController.view;
            UIView *startView = [window.subviews lastObject];
            destinationView.frame = CGRectMake(0, -CGRectGetHeight(destinationView.frame), CGRectGetWidth(destinationView.frame), CGRectGetHeight(destinationView.frame));
            [window insertSubview:destinationView aboveSubview:startView];
            [UIView animateWithDuration:.4
                                  delay:0.
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 CGRect rect = startView.frame;
                                 rect.origin.y = 0.f;
                                 destinationView.frame = rect;
                             } completion:^(BOOL finished) {
                                 window.rootViewController = nil;
                                 [[window subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
                                 window.rootViewController = homeViewController;
                                 self.isPresenting = NO;
                             }];
        }
    }
}

#pragma mark - Reachability

- (BOOL)isInternetReachable {
    switch (self.netStatus) {
        case ReachableViaWiFi:
        case ReachableViaWWAN:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

- (void) reachabilityChanged:(NSNotification *)note {
    Reachability* reachability = [note object];
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    BOOL connectionRequired = [reachability connectionRequired];
    self.netStatus = netStatus;
    switch (netStatus)
    {
        case NotReachable:        {
            NSLog(@"Access Not Available");
            connectionRequired = NO;
            break;
        }
            
        case ReachableViaWWAN:
        case ReachableViaWiFi:
            if (!connectionRequired)
                [self resendFailedTransactions];
            break;
    }
}

- (void)resendFailedTransactions {
    NSArray *savedTrackings = [CHATracking MR_findByAttribute:@"ended" withValue:@YES];
    for (CHATracking *tracking in savedTrackings) {
        [[CHAAPIClient sharedClient] createChangersBankTransactionForTracking:tracking succes:^(NSURLSessionDataTask *task, id responseObject) {
            [tracking MR_deleteEntity];
            [MagicalRecord saveWithBlock:nil];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@", [error localizedDescription]);
        }];
    }
}

@end
