//
//  CHATracker.m
//  Changers
//
//  Created by Denis on 09.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHATracker.h"
#import "CHATrackerTheme.h"
#import "CHABankExchange.h"
#import "CHAAPIClient.h"

static CLLocationAccuracy kStartAccuracy = 50.f;
static CLLocationAccuracy kNewLocationAccuracy = 5.f;
static NSInteger kDistanceForMaker = 200;

@interface CHATracker () <CLLocationManagerDelegate>
@property (assign, nonatomic, readwrite) BOOL isTracking;
@property (strong, nonatomic) CHABankExchange *bankExchange;
@property (strong, nonatomic, readwrite) CHATrackerTheme *trackerTheme;
@property (strong, nonatomic, readwrite) CHATracking *tracking;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic, readwrite) CLLocation *startLocation;
@property (strong, nonatomic) CLLocation *lastLocation;
@property (strong, nonatomic) CLLocation *lastSavedLocation;
@property (assign, nonatomic) NSInteger distanceFromSavedLocation;
@property (strong, nonatomic, readwrite) NSMutableArray *savedLocations;
@property (strong, nonatomic) NSMutableArray *allUserLocations;
- (void)saveLocation:(CLLocation*)location;
- (void)startTrackingStatistics;
@end

@implementation CHATracker

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isTracking = NO;
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        self.locationManager.pausesLocationUpdatesAutomatically = YES;
        self.locationManager.distanceFilter = 5.f;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        #if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000)
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
                [self.locationManager requestAlwaysAuthorization];
        #endif
        self.bankExchange = [CHABankExchange new];
    }
    return self;
}

- (void)setLastLocation:(CLLocation *)lastLocation {
    _lastLocation = lastLocation;
    // Save correct user location for calculate avg speed of the journey
    [self.allUserLocations addObject:lastLocation];
}

- (void)setTrackerType:(TrackerType)trackerType {
    _trackerType = trackerType;
    switch (trackerType) {
        case TrackerTypeBike:
            self.locationManager.activityType = CLActivityTypeFitness;
            break;
        case TrackerTypeCar:
            self.locationManager.activityType = CLActivityTypeAutomotiveNavigation;
            break;
        case TrackerTypePlane:
        case TrackerTypePublicTransport:
        case TrackerTypeTrain:
            self.locationManager.activityType = CLActivityTypeOtherNavigation;
            break;
        default:
            break;
    }
    if (self.tracking) {
        self.tracking.type = CHAStringFromTrackingType(self.trackerType);
    }
    self.trackerTheme = [[CHATrackerTheme alloc] initWithTrackerType:trackerType];
}

#pragma mark - LocationManager

- (void)startTracker:(void (^)(BOOL started))callback {
//    if (self.locationManager.location && self.locationManager.location.horizontalAccuracy < 50.f) {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusNotDetermined:
            {
                self.tracking = [CHATracking MR_createEntity];
                self.isTracking = YES;
                self.tracking.startDate = [NSDate date];
                self.tracking.type = CHAStringFromTrackingType(self.trackerType);
                self.savedLocations = [NSMutableArray array];
                self.allUserLocations = [NSMutableArray array];
                if (self.locationManager.location) {
                    // Save start location If the accuracy of the location upon start is not +/- 50m or better
                    if (self.locationManager.location.horizontalAccuracy <= kStartAccuracy) {
                        self.startLocation = self.locationManager.location;
                        [self saveLocation:self.startLocation];
                        self.tracking.startLocation = self.startLocation;
                        self.lastLocation = self.locationManager.location;
                        [self startTrackingStatistics];
                    }
                    self.lastSavedLocation = self.locationManager.location;
                }
                [self.locationManager startUpdatingLocation];
                if (callback) {
                    callback(YES);
                }
            }
            break;
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
        default:
            if (callback) {
                callback(NO);
            }
            break;
    }
}

- (void)stopTracker {
    [self.locationManager stopUpdatingLocation];
    
    if (self.lastLocation)
        [self saveLocation:self.lastLocation];
    
    NSInteger speed = 0;
    for (CLLocation *location in self.allUserLocations) {
        NSInteger speedInKMPH = (location.speed/1000)*3600;
        if (speedInKMPH >= 0)
            speed += speedInKMPH;
    }
    self.tracking.averageSpeed = @((speed / [self.allUserLocations count]));
    self.tracking.ended = @YES;
    self.tracking.stopLocation = self.lastLocation;
    self.tracking.stopDate = [NSDate date];
    self.isTracking = NO;
    self.startLocation = nil;
}

#pragma mark - Create tracking on server 

- (void)startTrackingStatistics {
    [[CHAAPIClient sharedClient] startTrackingWithLatitude:self.startLocation.coordinate.longitude longitude:self.startLocation.coordinate.latitude succes:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        
        self.tracking.trackingId = [responseObject valueForKeyPath:@"result.trackingId"];
        self.tracking.imageUrl = [responseObject valueForKeyPath:@"result.imageUrl"];
        self.tracking.linkUrl = [responseObject valueForKeyPath:@"result.linkUrl"];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *curentLocation = [locations lastObject];

    if (!self.startLocation) {
        /*
         If new location accurancy is +/-50m or better save location as start.
         If new location accurancy is not +/-50m or better - check distance between bad start location and new location if it exceeds the bad location accuracy by 10 times use bad start location as start location. */
        CLLocationDistance distance = [curentLocation distanceFromLocation:self.lastSavedLocation];
        if (curentLocation.horizontalAccuracy <= kStartAccuracy) {
            self.startLocation = curentLocation;
            self.lastLocation = curentLocation;
            self.tracking.startLocation = curentLocation;
            [self saveLocation:curentLocation];
            [self startTrackingStatistics];
        } else if ((distance * 10.f) >= self.lastSavedLocation.horizontalAccuracy) {
            self.startLocation = self.lastSavedLocation;
            self.lastLocation = curentLocation;
            self.tracking.startLocation = self.lastSavedLocation;
            [self saveLocation:self.startLocation];
            [self saveLocation:curentLocation];
            [self startTrackingStatistics];
        }
    }

    if (self.lastLocation) {
        if ((curentLocation.horizontalAccuracy <= kNewLocationAccuracy || [curentLocation distanceFromLocation:self.lastLocation] > self.lastLocation.horizontalAccuracy)) {
            self.tracking.distance = @([self.tracking.distance integerValue] + [curentLocation distanceFromLocation:self.lastLocation]);
            self.distanceFromSavedLocation += [curentLocation distanceFromLocation:self.lastLocation];
            NSLog(@"%@", self.tracking.distance);
            self.lastLocation = curentLocation;
            if (self.distanceFromSavedLocation >= kDistanceForMaker) {
                NSLog(@"Save location");
                self.distanceFromSavedLocation = 0;
                [self saveLocation:curentLocation];
                [self updateTrackInfo];
            }
        }
    }
}

#pragma mark - 

- (void)saveLocation:(CLLocation*)location {
    NSLog(@"%@", location);
    self.lastSavedLocation = location;
    [self.savedLocations addObject:location];
    if ([self.delegate respondsToSelector:@selector(tracker:didSaveLocation:)]) {
        [self.delegate tracker:self didSaveLocation:location];
    }
}

- (void)updateTrackInfo {
    CHAExchange exchange = [self.bankExchange exchangeForType:self.trackerType];
    self.tracking.co2Emitted = @(([self.tracking.distance integerValue] / 1000.f) * exchange.co2e);
    self.tracking.co2Saved = @(([self.tracking.distance integerValue] / 1000.f) * exchange.co2x);
    self.tracking.recoinsEarned = @(([self.tracking.distance integerValue] / 1000.f) * exchange.ccx);
    
    if ([self.delegate respondsToSelector:@selector(tracker:didUpdateInfo:)]) {
        [self.delegate tracker:self didUpdateInfo:self.tracking];
    }
}

- (BOOL)isJourneySpeedInLimits {
    CHASpeedLimits speedLimits = [self.bankExchange limitsForType:self.trackerType];
    NSInteger amountExceedsValues = 0;
    for (CLLocation *location in self.allUserLocations) {
        NSInteger speedInKMPH = (location.speed/1000)*3600;
        if (speedInKMPH > speedLimits.upperThreshold) {
            amountExceedsValues++;
        }
    }
    // if 10% of saved locations does not satisfy the speed settings assume that user chosen incorrect transport type
    if (((amountExceedsValues/[self.allUserLocations count]) * 100) > 10) {
        return NO;
    }
    return YES;
}

@end
