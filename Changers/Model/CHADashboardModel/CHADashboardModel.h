//
//  CHADashboardModel.h
//  Changers
//
//  Created by Nikita Shitik on 10.10.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHADashboardModel : NSObject

@property (nonatomic, strong, readonly) NSNumber *userFootprint;
@property (nonatomic, strong, readonly) NSNumber *communityFootprint;

@property (nonatomic, strong, readonly) NSString *userKilometersString;
@property (nonatomic, strong, readonly) NSString *communityKilometersString;

@property (nonatomic, strong, readonly) NSAttributedString *userSavingsTitleAttributedString;
@property (nonatomic, strong, readonly) NSAttributedString *userSavingsValueAttributedString;
@property (nonatomic, strong, readonly) NSAttributedString *userSavingsKGAttributedString;
@property (nonatomic, strong, readonly) NSAttributedString *communitySavingsTitleAttributedString;
@property (nonatomic, strong, readonly) NSAttributedString *communitySavingsValueAttributedString;
@property (nonatomic, strong, readonly) NSAttributedString *communitySavingsKGAttributedString;


+ (instancetype)sharedDashboardModel;
- (void)loadFootprintWithSuccess:(CHAEmptyBlock)success failure:(CHAStringBlock)failure;
- (void)updateFromCache;

@end
