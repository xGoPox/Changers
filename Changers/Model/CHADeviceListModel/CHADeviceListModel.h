//
//  CHADeviceListModel.h
//  Changers
//
//  Created by Nikita Shitik on 10.10.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CHADevice;

@interface CHADeviceListModel : NSObject

@property (nonatomic, strong, readonly) NSArray *devices;
@property (nonatomic, readonly) BOOL canShowPlaceholder;

+ (instancetype)sharedDeviceListModel;
- (void)loadDevicesWithSuccess:(CHAEmptyBlock)success failure:(CHAStringBlock)failure;
- (void)deleteDevice:(CHADevice *)device success:(CHAEmptyBlock)success failure:(CHAStringBlock)failure;

@end
