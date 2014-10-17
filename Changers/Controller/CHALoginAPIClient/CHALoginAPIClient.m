//
//  CHALoginAPIClient.m
//  Changers
//
//  Created by Nikita Shitik on 05.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHALoginAPIClient.h"

//model
#import "CHALandingUserModel.h"

//Keys
static NSString *const kCHAMethodKey = @"method";
static NSString *const kCHAAPIKeyKey = @"api_key";
static NSString *const kCHAUserNameKey = @"username";
static NSString *const kCHAEmailKey = @"email";
static NSString *const kCHANameKey = @"name";
static NSString *const kCHAPasswordKey = @"password";

//Methods
static NSString *const kCHAMethodCheckName = @"user.check_username_availability";
static NSString *const kCHAMethodRegister = @"user.register";
static NSString *const KCHAMethodGetToken = @"auth.gettoken";
static NSString *const kCHAMethodForgotPassword = @"user.password.requestNew";
static NSString *const kCHAMethodGetNameByEmail = @"user.get_user_by_email ";

@implementation CHALoginAPIClient

+ (instancetype)loginAPIClient {
    NSURL *URL = [NSURL URLWithString:kCHABaseURL];
    CHALoginAPIClient *client = [[[self class] alloc] initWithBaseURL:URL];
    return client;
}

- (AFHTTPRequestOperation *)checkNameAvailability:(NSString *)name
                                          success:(CHASuccessBlock)success
                                          failure:(CHAFailureBlock)failure {
    NSString *path = kCHAJSONPath;
    NSDictionary *params = @{kCHAMethodKey: kCHAMethodCheckName, kCHAAPIKeyKey: kCHAAPIKey, kCHAUserNameKey: name};
    return [self GET:path parameters:params success:success failure:failure];
}

- (AFHTTPRequestOperation *)registerWithModel:(CHALandingUserModel *)model
                                      success:(CHASuccessBlock)success
                                      failure:(CHAFailureBlock)failure {
    NSString *path = kCHAJSONPath;
    NSDictionary *params = @{
                             kCHAAPIKeyKey: kCHAAPIKey,
                             kCHAMethodKey: kCHAMethodRegister,
                             kCHAUserNameKey: model.userName,
                             kCHANameKey: model.displayName,
                             kCHAPasswordKey: model.password,
                             kCHAEmailKey: model.email
                             };
    return [self GET:path parameters:params success:success failure:failure];
}

- (AFHTTPRequestOperation *)getTokenWithModel:(CHALandingUserModel *)model
                                      success:(CHASuccessBlock)success
                                      failure:(CHAFailureBlock)failure {
    NSString *path = kCHAJSONPath;
    NSDictionary *params = @{kCHAAPIKeyKey: kCHAAPIKey,
                             kCHAUserNameKey: model.email,
                             kCHAPasswordKey: model.password,
                             kCHAMethodKey: KCHAMethodGetToken};
    return [self POST:path parameters:params success:success failure:failure];
}

- (AFHTTPRequestOperation *)forgotPasswordForUsername:(NSString *)userName
                                              success:(CHASuccessBlock)success
                                              failure:(CHAFailureBlock)failure {
    NSString *path = kCHAJSONPath;
    NSDictionary *params = @{kCHAAPIKeyKey: kCHAAPIKey,
                             kCHAUserNameKey: userName,
                             kCHAMethodKey: kCHAMethodForgotPassword};
    return [self POST:path parameters:params success:success failure:failure];
}

- (AFHTTPRequestOperation *)getUsernameWithEmail:(NSString *)email
                                         success:(CHASuccessBlock)success
                                         failure:(CHAFailureBlock)failure {
    NSString *path = kCHAJSONPath;
    NSDictionary *params = @{kCHAAPIKeyKey: kCHAAPIKey,
                             kCHAEmailKey: email,
                             kCHAMethodKey: kCHAMethodGetNameByEmail};
    return [self POST:path parameters:params success:success failure:failure];
}

@end
