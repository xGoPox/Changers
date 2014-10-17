//
//  CHALoginAPIClient.h
//  Changers
//
//  Created by Nikita Shitik on 05.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@class CHALandingUserModel;

typedef void (^CHASuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^CHAFailureBlock)(AFHTTPRequestOperation *operation, NSError *error);

@interface CHALoginAPIClient : AFHTTPRequestOperationManager

+ (instancetype)loginAPIClient;

- (AFHTTPRequestOperation *)checkNameAvailability:(NSString *)name
                                          success:(CHASuccessBlock)success
                                          failure:(CHAFailureBlock)failure;

- (AFHTTPRequestOperation *)registerWithModel:(CHALandingUserModel *)model
                                      success:(CHASuccessBlock)success
                                      failure:(CHAFailureBlock)failure;

- (AFHTTPRequestOperation *)getTokenWithModel:(CHALandingUserModel *)model
                                      success:(CHASuccessBlock)success
                                      failure:(CHAFailureBlock)failure;

- (AFHTTPRequestOperation *)forgotPasswordForUsername:(NSString *)userName
                                           success:(CHASuccessBlock)success
                                           failure:(CHAFailureBlock)failure;

- (AFHTTPRequestOperation *)getUsernameWithEmail:(NSString *)email
                                         success:(CHASuccessBlock)success
                                         failure:(CHAFailureBlock)failure;

@end
