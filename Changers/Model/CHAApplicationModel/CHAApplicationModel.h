//
//  CHAApplicationModel.h
//  Changers
//
//  Created by Denis on 11.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHATracker.h"
#import "Reachability.h"

@interface CHAApplicationModel : NSObject
@property (nonatomic, strong, readonly) CHATracker *tracker;
- (void)startInWindow:(UIWindow *)window;
- (void)showHomeScreenOnWindow:(UIWindow *)window animated:(BOOL)animated;
- (void)showLoginScreenOnWindow:(UIWindow *)window animated:(BOOL)animated;
- (BOOL)isInternetReachable;
@end
