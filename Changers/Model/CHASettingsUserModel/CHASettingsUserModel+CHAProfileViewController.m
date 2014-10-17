//
//  CHASettingsUserModel+CHAProfileViewController.m
//  Changers
//
//  Created by Nikita Shitik on 06.10.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHASettingsUserModel+CHAProfileViewController.h"

static NSDateFormatter *dateFormatter;

@implementation CHASettingsUserModel (CHAProfileViewController)

#pragma mark - Public

- (NSAttributedString *)countryAttributedString {
    NSString *string = nil;
    NSDictionary *params = nil;
    if (self.countryCode.length && [[self countryCodes] indexOfObject:self.countryCode] != NSNotFound) {
        string = [[self countries] objectAtIndex:[[self countryCodes] indexOfObject:self.countryCode]];
        UIColor *color = [self darkColor];
        params = @{NSForegroundColorAttributeName: color};
    } else {
        string = NSLocalizedString(@"Country", nil);
        params = @{NSForegroundColorAttributeName: [self lightColor]};
    }
    return [[NSAttributedString alloc] initWithString:string attributes:params];
}

- (NSAttributedString *)birthdayAttributedString {
    NSString *string = nil;
    NSDictionary *params = nil;
    NSString *bdayText = [self birthdayText];
    if (bdayText.length) {
        string = bdayText;
        params = @{NSForegroundColorAttributeName: [self darkColor]};
    } else {
        string = NSLocalizedString(@"Birthday", nil);
        params = @{NSForegroundColorAttributeName: [self lightColor]};
    }
    return [[NSAttributedString alloc] initWithString:string attributes:params];
}

#pragma mark - Private

- (UIColor *)lightColor {
    return [UIColor lightGrayColor];
}

- (UIColor *)darkColor {
    return RGB(78.f, 85.f, 97.f);
}

- (NSDateFormatter *)dateFormatter {
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"d MMMM yyyy";
    }
    return dateFormatter;
}

- (NSString *)birthdayText {
    return [[self dateFormatter] stringFromDate:self.birthday];
}

- (NSArray *)countries {
    NSLocale *locale = [NSLocale currentLocale];
    NSArray *countryArray = [NSLocale ISOCountryCodes];
    NSMutableArray *sortedCountryArray = [[NSMutableArray alloc] init];
    for (NSString *countryCode in countryArray) {
        @autoreleasepool {
            NSString *displayNameString = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
            [sortedCountryArray addObject:displayNameString];
        }
    }
    [sortedCountryArray sortUsingSelector:@selector(localizedCompare:)];
    return sortedCountryArray;
}

- (NSArray *)countryCodes {
    NSLocale *locale = [NSLocale currentLocale];
    NSArray *array = [NSLocale ISOCountryCodes];
    return [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *locale1 = obj1;
        NSString *locale2 = obj2;
        NSString *localizedName1 = [locale displayNameForKey:NSLocaleCountryCode value:locale1];
        NSString *localizedName2 = [locale displayNameForKey:NSLocaleCountryCode value:locale2];
        return [localizedName1 compare:localizedName2 options:0];
    }];
}

@end
