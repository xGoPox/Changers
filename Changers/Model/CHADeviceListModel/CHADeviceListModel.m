//
//  CHADeviceListModel.m
//  Changers
//
//  Created by Nikita Shitik on 10.10.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHADeviceListModel.h"

//networking
#import "CHADeviceAPIClient.h"

//model
#import "CHADevice.h"

@interface CHADeviceListModel ()

@property (nonatomic, strong, readwrite) NSArray *devices;
@property (nonatomic, readwrite) BOOL canShowPlaceholder;
@property (nonatomic, strong) CHADeviceAPIClient *client;

@end

@implementation CHADeviceListModel

#pragma mark - Initialization

+ (instancetype)sharedDeviceListModel {
    static CHADeviceListModel *model;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[self alloc] init];
    });
    return model;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.client = [[CHADeviceAPIClient alloc] init];
        self.canShowPlaceholder = NO;
    }
    return self;
}

#pragma mark - Public

- (void)loadDevicesWithSuccess:(CHAEmptyBlock)success failure:(CHAStringBlock)failure {
    __weak typeof(self) weakSelf = self;
    CHADeviceSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.canShowPlaceholder = YES;
        [strongSelf updateFromResponse:responseObject];
        if (success) {
            success();
        }
    };
    
    CHADeviceFailureBlock failureBlock = ^(AFHTTPRequestOperation *operation, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.canShowPlaceholder = YES;
        if (failure) {
            failure(error.localizedDescription);
        }
    };
    
    [self.client loadDevicesWithSuccess:successBlock failure:failureBlock];
}

- (void)deleteDevice:(CHADevice *)device success:(CHAEmptyBlock)success failure:(CHAStringBlock)failure {
    [self.client deleteDevice:device
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          NSMutableArray *devices = [self.devices mutableCopy];
                          [devices removeObject:device];
                          self.devices = [devices copy];
                          if (success) {
                              success();
                          }
                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          if (failure) {
                              failure(error.localizedFailureReason);
                          }
                      }];
}

#pragma mark - Private

- (void)updateFromResponse:(NSDictionary *)response {
    NSDictionary *result = response[@"result"];
    BOOL hasDevice = [result[@"hasDevice"] boolValue];
    if (hasDevice) {
        NSArray *devices = result[@"devices"];
        NSMutableArray *deviceContainer = [NSMutableArray arrayWithCapacity:devices.count];
        for (NSDictionary *deviceDictionary in devices) {
            CHADevice *device = [[CHADevice alloc] initWithDictionary:deviceDictionary];
            [deviceContainer addObject:device];
        }
        self.devices = [deviceContainer copy];
    }
}

@end
