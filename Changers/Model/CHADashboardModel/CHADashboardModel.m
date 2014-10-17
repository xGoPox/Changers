//
//  CHADashboardModel.m
//  Changers
//
//  Created by Nikita Shitik on 10.10.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHADashboardModel.h"

//networking
#import "CHADashboardAPIClient.h"

//misc
#import "NSDictionary+NSNull.h"

static NSString *const kCHADashboardCacheKey = @"kCHADashboardCacheKey";
static NSString *const kCHAMySavingsString = @"MY CO2 SAVINGS";
static NSString *const kCHAMyEmissionsString = @"MY CO2 EMISSIONS";
static NSString *const kCHACommunitySavingsString = @"COMMUNITY CO2 SAVINGS";
static NSString *const kCHACommunityEmissionsString = @"COMMUNITY CO2 EMISSIONS";
static NSString *const kCHAKG = @"KG";
static NSString *const kCHAG = @"G";
static NSString *const kCHAMinus = @"-";

@interface CHADashboardModel ()

//model
@property (nonatomic, strong, readwrite) NSNumber *userFootprint;
@property (nonatomic, strong, readwrite) NSNumber *communityFootprint;

@property (nonatomic, strong, readwrite) NSString *userKilometersString;
@property (nonatomic, strong, readwrite) NSString *communityKilometersString;

@property (nonatomic, strong, readwrite) NSAttributedString *userSavingsTitleAttributedString;
@property (nonatomic, strong, readwrite) NSAttributedString *userSavingsValueAttributedString;
@property (nonatomic, strong, readwrite) NSAttributedString *userSavingsKGAttributedString;
@property (nonatomic, strong, readwrite) NSAttributedString *communitySavingsTitleAttributedString;
@property (nonatomic, strong, readwrite) NSAttributedString *communitySavingsValueAttributedString;
@property (nonatomic, strong, readwrite) NSAttributedString *communitySavingsKGAttributedString;

//networking
@property (nonatomic, strong) CHADashboardAPIClient *client;

@end

@implementation CHADashboardModel

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        _client = [CHADashboardAPIClient new];
        _userFootprint = @0;
        _communityFootprint = @0;
        _userKilometersString = kCHAMinus;
        _communityKilometersString = kCHAMinus;
        _userSavingsTitleAttributedString = [[NSAttributedString alloc] initWithString:NSLocalizedString(kCHAMySavingsString, nil)];
        _userSavingsValueAttributedString = [[NSAttributedString alloc] initWithString:kCHAMinus];
        _userSavingsKGAttributedString = [[NSAttributedString alloc] initWithString:kCHAG];
        _communitySavingsTitleAttributedString = [[NSAttributedString alloc] initWithString:kCHACommunitySavingsString];
        _communitySavingsValueAttributedString = [[NSAttributedString alloc] initWithString:kCHAMinus];
        _communitySavingsKGAttributedString = [[NSAttributedString alloc] initWithString:kCHAKG];
    }
    return self;
}

+ (instancetype)sharedDashboardModel {
    static CHADashboardModel *_dashboardModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dashboardModel = [[CHADashboardModel alloc] init];
    });
    return _dashboardModel;
}

#pragma mark - Public

- (void)loadFootprintWithSuccess:(CHAEmptyBlock)success failure:(CHAStringBlock)failure {
    __weak typeof(self) weakSelf = self;
    CHADashboardSuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf updateFromResponse:responseObject];
        if (success) {
            success();
        }
    };
    
    CHADashboardFailureBlock failureBlock = ^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error.localizedDescription);
        }
    };
    
    [self.client getDashboardDataWithSuccess:successBlock failure:failureBlock];
}

- (void)updateFromCache {
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:kCHADashboardCacheKey];
    if (dict) {
        [self updateFromResponse:dict];
    }
}

#pragma mark - Private

- (void)updateFromResponse:(NSDictionary *)response {
    [[NSUserDefaults standardUserDefaults] setValue:[response dictionaryByReplacingNullsWithNumbers] forKey:kCHADashboardCacheKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSDictionary *result = response[@"result"];
    NSDictionary *me = result[@"me"];
    NSDictionary *community = result[@"community"];
    
    self.userFootprint = @([me[@"index"] doubleValue]);
    self.communityFootprint = @([community[@"index"] doubleValue]);
    self.userKilometersString = [NSString stringWithFormat:@"%@", me[@"total_kilometers"]];
    self.communityKilometersString = [NSString stringWithFormat:@"%@", community[@"total_kilometers"]];
    
    double userEmissions = [me[@"total_emissions"] doubleValue];
    
    NSString *title = nil;
    NSString *value = nil;
    NSString *kg = nil;
    NSDictionary *params = nil;
    
    title = NSLocalizedString(kCHAMyEmissionsString, nil);
    value = [NSString stringWithFormat:@"%@", @(userEmissions)];
    kg = NSLocalizedString(kCHAKG, nil);
    params = @{NSForegroundColorAttributeName: [self redColor]};
    
    self.userSavingsTitleAttributedString = [[NSAttributedString alloc] initWithString:title attributes:params];
    self.userSavingsValueAttributedString = [[NSAttributedString alloc] initWithString:value attributes:params];
    self.userSavingsKGAttributedString = [[NSAttributedString alloc] initWithString:kg attributes:params];
    
    double communityEmissions = [community[@"total_emissions"] doubleValue];
    double communitySavings = [community[@"total_savings"] doubleValue];
    
    NSString *communitytitle = nil;
    NSString *communityvalue = nil;
    NSString *communitykg = nil;
    NSDictionary *communityparams = nil;
    
    if (communitySavings >= 0) {
        communitytitle = NSLocalizedString(kCHACommunitySavingsString, nil);
        communityvalue = [NSString stringWithFormat:@"%@", @(communitySavings)];
        communitykg = NSLocalizedString(kCHAKG, nil);
        communityparams = @{NSForegroundColorAttributeName: [self greenColor]};
    } else {
        communitytitle = NSLocalizedString(kCHACommunityEmissionsString, nil);
        communityvalue = [NSString stringWithFormat:@"%@", @(communityEmissions)];
        communitykg = NSLocalizedString(kCHAKG, nil);
        communityparams = @{NSForegroundColorAttributeName: [self redColor]};
    }
    
    self.communitySavingsTitleAttributedString = [[NSAttributedString alloc] initWithString:communitytitle attributes:communityparams];
    self.communitySavingsValueAttributedString = [[NSAttributedString alloc] initWithString:communityvalue attributes:communityparams];
    self.communitySavingsKGAttributedString = [[NSAttributedString alloc] initWithString:communitykg attributes:communityparams];
    
    
}

- (UIColor *)greenColor {
    return RGB(140.f, 198.f, 63.f);
}

- (UIColor *)redColor {
    return RGB(230.f, 71.f, 20.f);
}

@end
