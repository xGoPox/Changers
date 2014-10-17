//
//  CHADeviceAPIClient.m
//  Changers
//
//  Created by Nikita Shitik on 11.10.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHADeviceAPIClient.h"
#import "Lockbox.h"
#import "CHADevice.h"

@implementation CHADeviceAPIClient

#pragma mark - Initialization

- (instancetype)init {
    self = [super initWithBaseURL:[NSURL URLWithString:kCHABaseURL]];
    return self;
}

#pragma mark - Public

- (AFHTTPRequestOperation *)loadDevicesWithSuccess:(CHADeviceSuccessBlock)success failure:(CHADeviceFailureBlock)failure {
    NSString *path = kCHAJSONPath;
    NSString *method = @"solardevice.getDevices";
    NSString *token = [Lockbox stringForKey:kCHATokenName];
    NSString *username = [[NSUserDefaults standardUserDefaults] valueForKey:kCHAUserNameStoringKey];
    NSDictionary *params = @{@"auth_token": token,
                             @"api_key": kCHAAPIKey,
                             @"method": method,
                             @"username": username};
    return [self POST:path parameters:params success:success failure:failure];
}

- (AFHTTPRequestOperation *)deleteDevice:(CHADevice *)device
                                 success:(CHADeviceSuccessBlock)success
                                 failure:(CHADeviceFailureBlock)failure {
    NSString *path = kCHAJSONPath;
    NSString *method = @"solardevice.disconnect";
    NSString *token = [Lockbox stringForKey:kCHATokenName];
    NSString *username = [[NSUserDefaults standardUserDefaults] valueForKey:kCHAUserNameStoringKey];
    NSDictionary *params = @{@"auth_token": token,
                             @"api_key": kCHAAPIKey,
                             @"method": method,
                             @"username": username,
                             @"deviceId": device.deviceId};
    return [self POST:path parameters:params success:success failure:failure];
}

@end
