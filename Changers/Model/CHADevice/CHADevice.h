//
//  CHADevice.h
//  Changers
//
//  Created by Nikita Shitik on 09.10.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHADevice : NSObject

@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic, copy) NSNumber *totalEnergy;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
