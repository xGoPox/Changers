//
//  CHASettingsClient.h
//  Changers
//
//  Created by Nikita Shitik on 30.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@class CHASettingsUserModel;

typedef void (^CHASuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^CHAFailureBlock)(AFHTTPRequestOperation *operation, NSError *error);

@interface CHASettingsClient : AFHTTPRequestOperationManager

- (AFHTTPRequestOperation *)uploadSettingsFromModel:(CHASettingsUserModel *)model
                                            success:(CHASuccessBlock)success
                                            failure:(CHAFailureBlock)failure;

- (AFHTTPRequestOperation *)downloadSettingsWithSuccess:(CHASuccessBlock)success
                                                failure:(CHAFailureBlock)failure;

- (AFHTTPRequestOperation *)changePasswordWithOldPass:(NSString *)oldPass
                                           updatePass:(NSString *)updatePass
                                              success:(CHASuccessBlock)success
                                              failure:(CHAFailureBlock)failure;

@end
