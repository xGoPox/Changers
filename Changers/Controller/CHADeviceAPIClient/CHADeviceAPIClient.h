//
//  CHADeviceAPIClient.h
//  Changers
//
//  Created by Nikita Shitik on 11.10.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@class CHADevice;

typedef void (^CHADeviceSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^CHADeviceFailureBlock)(AFHTTPRequestOperation *operation, NSError *error);

@interface CHADeviceAPIClient : AFHTTPRequestOperationManager

- (AFHTTPRequestOperation *)loadDevicesWithSuccess:(CHADeviceSuccessBlock)success
                                           failure:(CHADeviceFailureBlock)failure;

- (AFHTTPRequestOperation *)deleteDevice:(CHADevice *)device
                                 success:(CHADeviceSuccessBlock)success
                                 failure:(CHADeviceFailureBlock)failure;

@end
