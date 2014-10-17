//
//  CHAAPIClient.h
//  Changers
//
//  Created by Denis on 15.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "CHATracker.h"

typedef void (^CHASuccessBlock)(NSURLSessionDataTask *task, id responseObject);
typedef void (^CHAFailureBlock)(NSURLSessionDataTask *task, NSError *error);

@interface CHAAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

- (NSURLSessionDataTask*)getUserProfileWithSuccess:(CHASuccessBlock)success failure:(CHAFailureBlock)failure;

- (NSURLSessionDataTask*)getUserSummaryWithSuccess:(CHASuccessBlock)success
                                          failure:(CHAFailureBlock)failure;
- (NSURLSessionDataTask*)getUserStatisticWithSuccess:(CHASuccessBlock)success
                            failure:(CHAFailureBlock)failure;
- (NSURLSessionDataTask*)getExchangesList:(CHASuccessBlock)succes failure:(CHAFailureBlock)failure;

- (NSURLSessionDataTask*)postChangersBankTransactionWithTracking:(CHATracking*)tracking succes:(CHASuccessBlock)succes failure:(CHAFailureBlock)failure;
- (void)createChangersBankTransactionForTracking:(CHATracking*)tracking succes:(CHASuccessBlock)succes failure:(CHAFailureBlock)failure;

- (NSURLSessionDataTask *)startTrackingWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude succes:(CHASuccessBlock)succes failure:(CHAFailureBlock)failure;

@end
