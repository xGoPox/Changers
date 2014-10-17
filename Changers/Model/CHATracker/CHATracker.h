//
//  CHATracker.h
//  Changers
//
//  Created by Denis on 09.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHAConstants.h"
#import <CoreLocation/CoreLocation.h>
#import "CHATracking.h"

@class CHATracker;
@protocol CHATrackerDelegate <NSObject>
@optional
- (void)tracker:(CHATracker*)tracker didSaveLocation:(CLLocation*)location;
- (void)tracker:(CHATracker *)tracker didUpdateInfo:(CHATracking*)trackerInfo;
@end

@class CHATrackerTheme;
@interface CHATracker : NSObject
@property (assign, nonatomic, readonly) BOOL isTracking;
@property (assign, nonatomic) TrackerType trackerType;
@property (strong, nonatomic, readonly) CLLocation *startLocation;
@property (strong, nonatomic, readonly) CHATrackerTheme *trackerTheme;
@property (strong, nonatomic, readonly) CHATracking *tracking;
@property (nonatomic, weak) id<CHATrackerDelegate> delegate;
@property (strong, nonatomic, readonly) NSMutableArray *savedLocations;
- (void)startTracker:(void (^)(BOOL started))callback;
- (void)stopTracker;
- (void)updateTrackInfo;
- (BOOL)isJourneySpeedInLimits;
@end
