//
//  CHASettingsClient.m
//  Changers
//
//  Created by Nikita Shitik on 30.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHASettingsClient.h"
#import "Lockbox.h"

//model
#import "CHASettingsUserModel.h"

#define nil_to_null(obj) obj ? : [NSNull null]

static NSString *const kCHAMethodKey = @"method";
static NSString *const kCHAAPIKeyKey = @"api_key";
static NSString *const kCHATokenKey = @"auth_token";
static NSString *const kCHAUserNameKey = @"username";

@implementation CHASettingsClient

#pragma mark - Initialization

- (instancetype)init {
    self = [super initWithBaseURL:[NSURL URLWithString:kCHABaseURL]];
    if (self) {
        self.operationQueue.maxConcurrentOperationCount = 1;
        self.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    }
    return self;
}

#pragma mark - Public

- (AFHTTPRequestOperation *)downloadSettingsWithSuccess:(CHASuccessBlock)success failure:(CHAFailureBlock)failure {
    NSString *path = kCHAJSONPath;
    NSString *token = [Lockbox stringForKey:kCHATokenName];
    NSString *username = [[NSUserDefaults standardUserDefaults] valueForKey:kCHAUserNameStoringKey];
    NSDictionary *params = @{kCHAMethodKey: @"user.get_profile", kCHAAPIKeyKey: kCHAAPIKey, kCHATokenKey: token, kCHAUserNameKey: username};
    return [self POST:path parameters:params success:success failure:failure];
}

- (AFHTTPRequestOperation *)uploadSettingsFromModel:(CHASettingsUserModel *)model success:(CHASuccessBlock)success failure:(CHAFailureBlock)failure {
    
    NSString *path = kCHAJSONPath;
    NSString *token = [Lockbox stringForKey:kCHATokenName];
    NSString *userName = [[NSUserDefaults standardUserDefaults] valueForKey:kCHAUserNameStoringKey];
    
    id birthday = [NSNull null];
    if (model.birthday) {
        birthday = [[self birthdayDateFormatter] stringFromDate:model.birthday];
    }
    
    id gender = [NSNull null];
    if (model.gender == CHAGenderMale) {
        gender = @"m";
    } else if (model.gender == CHAGenderFemale) {
        gender = @"f";
    }
    
    NSDictionary *params = @{kCHAMethodKey: @"user.save_profile.params",
                             kCHAAPIKeyKey: kCHAAPIKey,
                             kCHATokenKey: token,
                             kCHAUserNameKey: userName,
                             @"firstName": nil_to_null(model.firstName),
                             @"lastName": nil_to_null(model.secondName),
                             @"email": nil_to_null(model.email),
                             @"city": nil_to_null(model.city),
                             @"country": nil_to_null(model.country),
                             @"countryId": nil_to_null(model.countryCode),
                             @"birthdate": birthday,
                             @"gender": gender};
    
    
    return [self POST:path parameters:params success:success failure:failure];
}

- (AFHTTPRequestOperation *)changePasswordWithOldPass:(NSString *)oldPass
                                           updatePass:(NSString *)updatePass
                                              success:(CHASuccessBlock)success
                                              failure:(CHAFailureBlock)failure {
    NSString *path = kCHAJSONPath;
    NSString *token = [Lockbox stringForKey:kCHATokenName];
    NSString *userName = [[NSUserDefaults standardUserDefaults] valueForKey:kCHAUserNameStoringKey];
    NSDictionary *params = @{kCHAMethodKey: @"user.password.change",
                             kCHAAPIKeyKey: kCHAAPIKey,
                             kCHATokenKey: token,
                             kCHAUserNameKey: userName,
                             @"currentPassword": oldPass,
                             @"newPassword": updatePass};
    
    return [self POST:path parameters:params success:success failure:failure];
    
}

#pragma mark - Private

- (NSDateFormatter *)birthdayDateFormatter {
    static NSDateFormatter *_birthdayDateFormatter;
    if (!_birthdayDateFormatter) {
        _birthdayDateFormatter = [NSDateFormatter new];
        _birthdayDateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return _birthdayDateFormatter;
}

@end
