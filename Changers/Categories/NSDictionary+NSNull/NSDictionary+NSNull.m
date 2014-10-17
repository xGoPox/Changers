//
//  NSDictionary+NSNull.m
//  Changers
//
//  Created by Nikita Shitik on 14.10.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "NSDictionary+NSNull.h"

@implementation NSDictionary (NSNull)

- (NSDictionary *)dictionaryByReplacingNullsWithNumbers {
    const NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary:self];
    const id nul = [NSNull null];
    const id blank = @0;
    
    for (NSString *key in self) {
        const id object = [self objectForKey: key];
        if (object == nul) {
            [replaced setObject: blank forKey: key];
        }
        else if ([object isKindOfClass: [NSDictionary class]]) {
            [replaced setObject: [(NSDictionary *) object dictionaryByReplacingNullsWithNumbers] forKey: key];
        }
    }
    return [replaced copy];
}

@end
