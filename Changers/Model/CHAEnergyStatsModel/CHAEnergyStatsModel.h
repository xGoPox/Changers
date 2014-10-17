//
//  CHAEnergyStatsModel.h
//  Changers
//
//  Created by Nikita Shitik on 09.10.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import <Foundation/Foundation.h>

//model
#import "CHAPlotDataSource.h"

@interface CHAEnergyStatsModel : NSObject

@property (nonatomic, strong) CHAPlotDataSource *plotDataSource;

@property (nonatomic, strong, readonly) NSString *message;
@property (nonatomic, strong, readonly) NSString *communitySavings;
@property (nonatomic, strong, readonly) NSString *communityEnergy;
@property (nonatomic, strong, readonly) NSString *userSavings;
@property (nonatomic, strong, readonly) NSString *userEnergy;

- (void)refreshWithSuccess:(void (^)(void))success failure:(void (^)(NSString *))failure;
- (void)updateFromCache;

@end
