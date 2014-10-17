//
//  CHAPlotFormatter.m
//  Changers
//
//  Created by Nikita Shitik on 23.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHAPlotFormatter.h"

@implementation CHAPlotFormatter

#pragma mark - NSFormatter

- (NSString *)stringForObjectValue:(id)obj {
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%i", [obj intValue]];
    }
    return nil;
}

- (NSAttributedString *)attributedStringForObjectValue:(id)obj withDefaultAttributes:(NSDictionary *)attrs {
    if ([obj isKindOfClass:[NSNumber class]]) {
        NSString *string = [self stringForObjectValue:obj];
        return [[NSAttributedString alloc] initWithString:string attributes:[self attributes]];
    }
    return nil;
}

#pragma mark - Private

- (NSDictionary *)attributes {
    return @{NSForegroundColorAttributeName: [UIColor colorWithWhite:.6f alpha:1.f], NSFontAttributeName: [UIFont fontWithName:kCHAKlavikaFontName size:12.f]};
}

@end
