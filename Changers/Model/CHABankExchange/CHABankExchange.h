//
//  CHABankExchange.h
//  Changers
//
//  Created by Denis on 17.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHAConstants.h"

typedef struct {
    CGFloat ccx, co2x, co2e;
} CHAExchange;

typedef struct {
    double lowerThreshold, upperThreshold;
} CHASpeedLimits;

@interface CHABankExchange : NSObject
- (CHAExchange)exchangeForType:(TrackerType)type;
- (CHASpeedLimits)limitsForType:(TrackerType)type;
@end
