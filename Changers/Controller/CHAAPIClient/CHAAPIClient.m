//
//  CHAAPIClient.m
//  Changers
//
//  Created by Denis on 15.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHAAPIClient.h"
#import "CHAConstants.h"
#import "Lockbox.h"

static NSString *const kCHAMethodUserSummary = @"user.summary";

static NSString *const kCHAMethodKey = @"method";
static NSString *const kCHAAPIKeyKey = @"api_key";
static NSString *const kCHATokenKey = @"auth_token";
static NSString *const kCHAUserNameKey = @"username";

@implementation CHAAPIClient

+ (instancetype)sharedClient {
    static CHAAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[CHAAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kCHABaseURL]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    return _sharedClient;
}

- (NSURLSessionDataTask*)getUserProfileWithSuccess:(CHASuccessBlock)success failure:(CHAFailureBlock)failure {
    NSString *path = kCHAJSONPath;
    NSString *token = [Lockbox stringForKey:kCHATokenName];
    NSString *username = [[NSUserDefaults standardUserDefaults] valueForKey:kCHAUserNameStoringKey];
    NSDictionary *params = @{kCHAMethodKey: @"user.get_profile", kCHAAPIKeyKey: kCHAAPIKey, kCHATokenKey: token, kCHAUserNameKey: username};
    return [self POST:path parameters:params success:success failure:failure];
}

- (NSURLSessionDataTask*)getUserSummaryWithSuccess:(CHASuccessBlock)success
                                              failure:(CHAFailureBlock)failure {
    NSString *path = kCHAJSONPath;
    NSString *token = [Lockbox stringForKey:kCHATokenName];
    NSString *username = [[NSUserDefaults standardUserDefaults] valueForKey:kCHAUserNameStoringKey];
    NSDictionary *params = @{kCHAMethodKey: kCHAMethodUserSummary, kCHAAPIKeyKey: kCHAAPIKey, kCHATokenKey: token, kCHAUserNameKey: username};
    return [self POST:path parameters:params success:success failure:failure];
}

- (NSURLSessionDataTask*)getUserStatisticWithSuccess:(CHASuccessBlock)success
                          failure:(CHAFailureBlock)failure {
    NSString *path = kCHAJSONPath;
    NSString *token = [Lockbox stringForKey:kCHATokenName];
    NSString *username = [[NSUserDefaults standardUserDefaults] valueForKey:kCHAUserNameStoringKey];
    NSDictionary *params = @{kCHAMethodKey: @"statistics.user.dashboard", kCHAAPIKeyKey: kCHAAPIKey, kCHATokenKey: token, kCHAUserNameKey: username};
    return [self POST:path parameters:params success:success failure:failure];
}

#pragma mark - BANK

- (NSURLSessionDataTask*)getExchangesList:(CHASuccessBlock)succes failure:(CHAFailureBlock)failure {
    NSString *path = kCHAJSONPath;
    NSString *token = [Lockbox stringForKey:kCHATokenName];
    NSDictionary *params = @{kCHAMethodKey: @"changersBank.exchanges.list", kCHAAPIKeyKey: kCHAAPIKey, kCHATokenKey: token};
    return [self POST:path parameters:params success:succes failure:failure];
}

- (void)createChangersBankTransactionForTracking:(CHATracking*)tracking succes:(CHASuccessBlock)succes failure:(CHAFailureBlock)failure {
    if (!tracking.trackingId) {
        [[CHAAPIClient sharedClient] startTrackingWithLatitude:tracking.startLocation.coordinate.latitude longitude:tracking.startLocation.coordinate.longitude succes:^(NSURLSessionDataTask *task, id responseObject) {
            tracking.trackingId = [responseObject valueForKeyPath:@"result.trackingId"];
           [[CHAAPIClient sharedClient] postChangersBankTransactionWithTracking:tracking succes:succes failure:failure];
        } failure:failure];
    } else {
        [[CHAAPIClient sharedClient] postChangersBankTransactionWithTracking:tracking succes:succes failure:failure];
    }
}

- (NSURLSessionDataTask*)postChangersBankTransactionWithTracking:(CHATracking*)tracking succes:(CHASuccessBlock)succes failure:(CHAFailureBlock)failure {
    NSString *path = kCHAJSONPath;
    NSString *token = [Lockbox stringForKey:kCHATokenName];
    NSString *guid = [[NSUserDefaults standardUserDefaults] valueForKey:kCHAGuidStoringKey];
    NSString *amount = [NSString stringWithFormat:@"%.3f", ([tracking.distance integerValue] / 1000.f)];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *startTime = [dateFormatter stringFromDate:tracking.startDate];
    NSString *stopTime = [dateFormatter stringFromDate:tracking.startDate];
    
    NSString *startLatitude = [NSString stringWithFormat:@"%f", tracking.startLocation.coordinate.latitude];
    NSString *stopLatitude = [NSString stringWithFormat:@"%f", tracking.stopLocation.coordinate.latitude];
    NSString *startLongitude = [NSString stringWithFormat:@"%f", tracking.startLocation.coordinate.longitude];
    NSString *stopLongitude = [NSString stringWithFormat:@"%f", tracking.stopLocation.coordinate.longitude];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"changersBank.transaction.create.params" forKey:kCHAMethodKey];
    [params setValue:kCHAAPIKey forKey:kCHAAPIKeyKey];
    [params setValue:token forKey:kCHATokenKey];
    [params setValue:guid forKey:@"guid"];
    [params setValue:tracking.type forKey:@"type"];
    [params setValue:amount forKey:@"amount"];
    [params setValue:tracking.trackingId forKey:@"trackingId"];
    [params setValue:startTime forKey:@"startTime"];
    [params setValue:stopTime forKey:@"stopTime"];
    [params setValue:startLatitude forKey:@"startLatitude"];
    [params setValue:startLongitude forKey:@"startLongitude"];
    [params setValue:stopLatitude forKey:@"stopLatitude"];
    [params setValue:stopLongitude forKey:@"stopLongitude"];
    
    return [self POST:path parameters:params success:succes failure:failure];
}

#pragma mark - Statistics

- (NSURLSessionDataTask *)startTrackingWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude succes:(CHASuccessBlock)succes failure:(CHAFailureBlock)failure {
    NSString *path = kCHAJSONPath;
    NSString *username = [[NSUserDefaults standardUserDefaults] valueForKey:kCHAUserNameStoringKey];
    NSString *token = [Lockbox stringForKey:kCHATokenName];
    NSDictionary *params = @{kCHAMethodKey: @"statistics.tracking.start",
                             kCHAAPIKeyKey: kCHAAPIKey,
                             kCHATokenKey: token,
                             kCHAUserNameKey: username,
                             @"latitude": [NSString stringWithFormat:@"%f", latitude],
                             @"longitude": [NSString stringWithFormat:@"%f", longitude]};
    return [self POST:path parameters:params success:succes failure:failure];
}

@end
