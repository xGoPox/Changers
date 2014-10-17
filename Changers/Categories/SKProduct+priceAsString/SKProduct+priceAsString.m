//
//  SKProduct+priceAsString.m
//  Changers
//
//  Created by Clemt Yerochewski on 16/10/14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "SKProduct+priceAsString.h"

@implementation SKProduct (priceAsString)

- (NSString *) priceAsString
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:[self priceLocale]];
    
    NSString *str = [formatter stringFromNumber:[self price]];
    return str;
}

@end
