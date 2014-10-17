//
//  CHADashboardAPIClient.h
//  Changers
//
//  Created by Nikita Shitik on 09.10.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

typedef void (^CHADashboardSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^CHADashboardFailureBlock)(AFHTTPRequestOperation *operation, NSError *error);

@interface CHADashboardAPIClient : AFHTTPRequestOperationManager

- (AFHTTPRequestOperation *)getEnergyStatsForDate:(NSDate *)date
                                          success:(CHADashboardSuccessBlock)success
                                          failure:(CHADashboardFailureBlock)failure;
- (AFHTTPRequestOperation *)getDashboardDataWithSuccess:(CHADashboardSuccessBlock)success
                                                failure:(CHADashboardFailureBlock)failure;

@end
