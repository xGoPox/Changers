//
//  CHAEnergyStatsModel.m
//  Changers
//
//  Created by Nikita Shitik on 09.10.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHAEnergyStatsModel.h"

//networking
#import "CHADashboardAPIClient.h"

//misc
#import "NSDictionary+NSNull.h"

static NSString *const kCHAEnergyStatsCacheKey = @"kCHAEnergyStatsCacheKey";

#define string(obj) [NSString stringWithFormat:@"%@", obj]

@interface CHAEnergyStatsModel ()

@property (nonatomic, strong) CHADashboardAPIClient *client;
@property (nonatomic, strong) NSOperation *reloadingOperation;

@property (nonatomic, strong, readwrite) NSString *message;
@property (nonatomic, strong, readwrite) NSString *communitySavings;
@property (nonatomic, strong, readwrite) NSString *communityEnergy;
@property (nonatomic, strong, readwrite) NSString *userSavings;
@property (nonatomic, strong, readwrite) NSString *userEnergy;

@end

@implementation CHAEnergyStatsModel

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        self.client = [[CHADashboardAPIClient alloc] init];
        self.plotDataSource = [[CHAPlotDataSource alloc] init];
        self.message = nil;
        self.communitySavings = @"-";
        self.communityEnergy = @"-";
        self.userEnergy = @"-";
        self.userSavings = @"-";
    }
    return self;
}

#pragma mark - Public

- (void)refreshWithSuccess:(void (^)(void))success failure:(void (^)(NSString *))failure {
    [self.reloadingOperation cancel];
    
    __weak typeof(self) weakSelf = self;
    CHADashboardSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf updateFromResponse:responseObject];
        if (success) {
            success();
        }
    };
    
    CHADashboardFailureBlock failureBlock = ^(AFHTTPRequestOperation *operation, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf updateFromCache];
        if (failure) {
            failure(@"Error");
        }
    };
    
    self.reloadingOperation = [self.client getEnergyStatsForDate:self.plotDataSource.currentDate
                                                         success:successBlock
                                                         failure:failureBlock];
}

- (void)updateFromCache {
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:kCHAEnergyStatsCacheKey];
    if (dict) {
        [self updateFromResponse:dict];
    }
}

#pragma mark - Private

- (void)updateFromResponse:(NSDictionary *)response {
    [[NSUserDefaults standardUserDefaults] setObject:[response dictionaryByReplacingNullsWithNumbers] forKey:kCHAEnergyStatsCacheKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSDictionary *result = response[@"result"];
    NSDictionary *community = result[@"community"];
    NSDictionary *user = result[@"user"];
    self.message = user[@"lastUploadMessage"];
    self.userEnergy = string(user[@"totalEnergy"]);
    self.userSavings = string(user[@"energySavings"]);
    self.communityEnergy = string(community[@"totalEnergy"]);
    self.communitySavings = string(community[@"energySavings"]);
    
    NSArray *barInput = user[@"energyUploads"];
    NSArray *scatterInput = user[@"energyUploads"];
    
    self.plotDataSource.barChartDataSource = barInput;
    self.plotDataSource.scatterChartDataSource = scatterInput;
}

@end
