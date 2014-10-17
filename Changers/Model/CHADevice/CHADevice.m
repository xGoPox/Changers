//
//  CHADevice.m
//  Changers
//
//  Created by Nikita Shitik on 09.10.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHADevice.h"

@implementation CHADevice

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.deviceId = [NSString stringWithFormat:@"%@", dictionary[@"deviceId"]];
        self.name = dictionary[@"name"];
        self.serialNumber = dictionary[@"serialNumber"];
        self.totalEnergy = @([dictionary[@"totalEnergy"] doubleValue]);
    }
    return self;
}

@end
