//
//  CHASettingsUserModel.h
//  Changers
//
//  Created by Nikita Shitik on 30.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHASettingsUserModel : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *secondName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *countryCode;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSDate *birthday;
@property (nonatomic, assign) CHAGender gender;
@property (nonatomic, assign) NSNumber *recoins;
@property (nonatomic, assign) NSNumber *co2Balance;

+ (instancetype)sharedModel;
- (void)loadDataWithSuccess:(CHAEmptyBlock)success failure:(CHAStringBlock)failure;
- (void)changeOldPassword:(NSString *)oldPassword
           updatePassword:(NSString *)updatePassword
                  success:(CHAEmptyBlock)success
                  failure:(CHAStringBlock)failure;

+ (instancetype)alloc __attribute__((unavailable("alloc is not available, call sharedInstance instead")));
- (instancetype)init __attribute__((unavailable("init is not available, call sharedInstance instead")));
+ (instancetype)new __attribute__((unavailable("new is not available, call sharedInstance instead")));

@end
