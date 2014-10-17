//
//  CHALandingUserModel.m
//  Changers
//
//  Created by Nikita Shitik on 07.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHALandingUserModel.h"

//model
#import "CHASettingsUserModel.h"

//networking
#import "CHALoginAPIClient.h"

//data storing
#import "Lockbox.h"

static NSString *const alphas = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
static NSString *const kCHAEmailRegisteredMessage = @"This email address has already been registered.";
static NSInteger const kCHASaltLength = 12;

@interface CHALandingUserModel ()

@property (nonatomic, strong) CHALoginAPIClient *client;

@end

@implementation CHALandingUserModel

#pragma mark - Init

- (id)init {
    self = [super init];
    if (self) {
        _client = [CHALoginAPIClient loginAPIClient];
    }
    return self;
}

#pragma mark - Public

- (NSString *)userNameWithRandomLength:(NSUInteger)length {
    NSString *userName = [self.userName stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableString *string = [NSMutableString stringWithString:userName];
    for (NSUInteger i = 0; i < length; i++) {
        [string appendFormat:@"%c", [alphas characterAtIndex:arc4random_uniform((int)alphas.length)]];
    }
    return string.copy;
}

- (void)checkNameAvailabilityWithSuccess:(void (^)(BOOL available))success
                                 failure:(void (^)(NSString *))failure {
    self.userName = [self userNameWithRandomLength:12];
    [self checkAvailabilityWithSuccess:success failure:failure];
}

- (void)checkFacebookAvailabilityWithSuccess:(void (^)(BOOL available))success failure:(void (^)(NSString *))failure {
    [self checkAvailabilityWithSuccess:success failure:failure];
}

- (void)checkAvailabilityWithSuccess:(void (^)(BOOL available))success failure:(void (^)(NSString *errorString))failure {
    
    CHASuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            if ([responseObject[kCHAResponseKeyStatus] integerValue] == -1) {
                success(NO);
            } else if ([responseObject[kCHAResponseKeyStatus] integerValue] == 0) {
                if ([responseObject[kCHAResponseKeyResult] boolValue] == YES) {
                    success(YES);
                } else {
                    success(NO);
                }
            }
        }
    };
    
    CHAFailureBlock failureBlock = ^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(NSLocalizedString(kCHAMessageNetworkError, nil));
        }
    };
    
    [self.client checkNameAvailability:self.userName success:successBlock failure:failureBlock];
}

- (void)registerWithSuccess:(void (^)(BOOL))success failure:(void (^)(NSString *))failure {
    self.userName = [self userNameWithRandomLength:kCHASaltLength];
    __weak typeof(self) weakSelf = self;
    CHASuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[kCHAResponseKeyResult][kCHAResponseKeySuccess] integerValue] == 0) {
            BOOL used = [responseObject[kCHAResponseKeyMessage] isEqualToString:kCHAEmailRegisteredMessage];
            NSString *error = used ? @"The email is already used. Please, try another one." : @"This email is not valid. Please, try another one.";
            NSString *localizedError = NSLocalizedString(error, nil);
            if (failure) {
                failure(localizedError);
            }
        } else if ([responseObject[kCHAResponseKeyResult][kCHAResponseKeySuccess] integerValue] == 1) {
            [[NSUserDefaults standardUserDefaults] setObject:weakSelf.email forKey:kCHAUserNameStoringKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (success) {
                success(YES);
            }
        }
    };
    
    CHAFailureBlock failureBlock = ^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(NSLocalizedString(kCHAMessageNetworkError, nil));
        }
    };
    
    [self.client registerWithModel:self success:successBlock failure:failureBlock];
}

- (void)getTokenWithSuccess:(void (^)(void))success failure:(void (^)(NSString *))failure {
    __weak typeof(self) weakSelf = self;
    CHASuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger status = [responseObject[kCHAResponseKeyStatus] integerValue];
        if (status != 0) {
            NSString *errorString = NSLocalizedString(@"You've provided wrong email or password. Please, check and try again.", nil);
            if (failure) {
                failure(errorString);
            }
        } else {
            NSString *token = responseObject[kCHAResponseKeyResult];
            [Lockbox setString:token forKey:kCHATokenName];
            [CHASettingsUserModel sharedModel].email = weakSelf.email;
            [[NSUserDefaults standardUserDefaults] setObject:weakSelf.email forKey:kCHAUserNameStoringKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if (success) {
                success();
            }
        }
    };
    CHAFailureBlock failureBlock = ^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(NSLocalizedString(kCHAMessageNetworkError, nil));
        }
    };
    
    [self.client getTokenWithModel:self success:successBlock failure:failureBlock];
}

- (void)getTokenForFacebookAuthWithSuccess:(void (^)(BOOL))success failure:(void (^)(NSString *))failure {
    //Temporary implementation while no API.
    if (success) {
        success(NO);
    }
}

- (void)getTokenForGoogleAuthWithSuccess:(void (^)(BOOL))success failure:(void (^)(NSString *))failure {
    //Temporary implementation while no API.
    if (success) {
        success(NO);
    }
}

@end
