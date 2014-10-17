//
//  CHADashboardAPIClient.m
//  Changers
//
//  Created by Nikita Shitik on 09.10.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHADashboardAPIClient.h"
#import "Lockbox.h"

@interface CHADashboardAPIClient ()

@property (nonatomic, strong, readonly) NSDateFormatter *monthDateFormatter;

@end

@implementation CHADashboardAPIClient

@synthesize monthDateFormatter = _monthDateFormatter;

#pragma mark - Initialization

- (instancetype)init {
    self = [super initWithBaseURL:[NSURL URLWithString:kCHABaseURL]];
    return self;
}

#pragma mark - Public

- (AFHTTPRequestOperation *)getEnergyStatsForDate:(NSDate *)date
                                          success:(CHADashboardSuccessBlock)success
                                          failure:(CHADashboardFailureBlock)failure {
    NSString *path = kCHAJSONPath;
    NSString *method = @"statistics.solar.details";
    NSString *token = [Lockbox stringForKey:kCHATokenName];
    NSString *month = [self.monthDateFormatter stringFromDate:date];
    NSString *username = [[NSUserDefaults standardUserDefaults] valueForKey:kCHAUserNameStoringKey];
    NSDictionary *params = @{@"auth_token": token,
                             @"api_key": kCHAAPIKey,
                             @"method": method,
                             @"username": username,
                             @"month": month};
    return [self POST:path parameters:params success:success failure:failure];
}

- (AFHTTPRequestOperation *)getDashboardDataWithSuccess:(CHADashboardSuccessBlock)success
                                                failure:(CHADashboardFailureBlock)failure {
    NSString *path = kCHAJSONPath;
    NSString *method = @"statistics.footprint_full";
    NSString *token = [Lockbox stringForKey:kCHATokenName];
    NSString *username = [[NSUserDefaults standardUserDefaults] valueForKey:kCHAUserNameStoringKey];
    NSDictionary *params = @{@"auth_token": token,
                             @"api_key": kCHAAPIKey,
                             @"method": method,
                             @"username": username};
    return [self POST:path parameters:params success:success failure:failure];
}

#pragma mark - Properties

- (NSDateFormatter *)monthDateFormatter {
    if (!_monthDateFormatter) {
        _monthDateFormatter = [NSDateFormatter new];
        _monthDateFormatter.dateFormat = @"yyyy-MM";
    }
    return _monthDateFormatter;
}

@end
