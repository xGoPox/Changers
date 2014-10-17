//
//  CHATracking.h
//  Changers
//
//  Created by Denis on 14.10.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>

@interface CHATracking : NSManagedObject

@property (nonatomic, retain) NSString * amount;
@property (nonatomic, retain) NSNumber * averageSpeed;
@property (nonatomic, retain) NSNumber * co2Emitted;
@property (nonatomic, retain) NSNumber * co2Saved;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSNumber * recoinsEarned;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * stopDate;
@property (nonatomic, retain) CLLocation *startLocation;
@property (nonatomic, retain) CLLocation *stopLocation;
@property (nonatomic, retain) NSString * trackingId;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSNumber *ended;
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) NSString *linkUrl;

@end
