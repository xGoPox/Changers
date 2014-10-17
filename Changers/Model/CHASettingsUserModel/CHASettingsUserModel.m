//
//  CHASettingsUserModel.m
//  Changers
//
//  Created by Nikita Shitik on 30.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHASettingsUserModel.h"

//network
#import "CHASettingsClient.h"

#define defs [NSUserDefaults standardUserDefaults]
#define null_to_nil(obj) (obj == [NSNull null]) ? nil : obj;

static NSString *const kCHAUserModelFirstName = @"kCHAUserModelFirstName";
static NSString *const kCHAUserModelSecondName = @"kCHAUserModelSecondName";
static NSString *const kCHAUserModelEmail = @"kCHAUserModelEmail";
static NSString *const kCHAUserModelCountry = @"kCHAUserModelCountry";
static NSString *const kCHAUserModelCity = @"kCHAUserModelCity";
static NSString *const kCHAUserModelBirthday = @"kCHAUserModelBirthday";
static NSString *const kCHAUserModelGender = @"kCHAUserModelGender";
static NSString *const kCHAUserModelCountryCode = @"kCHAUserModelCountryCode";

static NSString *const kCHADummyDataWasFilled = @"kCHADummyDataWasFilled";

static NSString *const kCHAMaleMap = @"m";
static NSString *const kCHAFemaleMap = @"f";

@interface CHASettingsUserModel ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) CHASettingsClient *client;

@end

@implementation CHASettingsUserModel

#pragma mark - Initialization

+ (instancetype)sharedModel {
    static CHASettingsUserModel *userModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userModel = [super new];
        userModel.client = [[CHASettingsClient alloc] init];
    });
    return userModel;
}

#pragma mark - Public

- (void)loadDataWithSuccess:(void (^)(void))success failure:(void (^)(NSString *))failure {
    [self.client downloadSettingsWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 0) {
            [self updateFromDictionary:responseObject];
            if (success) {
                success();
            }
        } else {
            if (failure) {
                failure(nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error.localizedDescription);
        }
    }];
}

- (void)changeOldPassword:(NSString *)oldPassword
           updatePassword:(NSString *)updatePassword
                  success:(CHAEmptyBlock)success
                  failure:(CHAStringBlock)failure {
    CHASuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success();
        }
    };
    
    CHAFailureBlock failureBlock = ^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error.localizedDescription);
        }
    };
    
    [self.client changePasswordWithOldPass:oldPassword
                                updatePass:updatePassword
                                   success:successBlock
                                   failure:failureBlock];
}

#pragma mark - Private

- (NSDateFormatter *)birthdayDateFormatter {
    static NSDateFormatter *_birthdayDateFormatter;
    if (!_birthdayDateFormatter) {
        _birthdayDateFormatter = [NSDateFormatter new];
        _birthdayDateFormatter.dateFormat = @"yyyy.M.d";
    }
    return _birthdayDateFormatter;
}

- (void)updateFromDictionary:(NSDictionary *)dictionary {
    NSDictionary *result = dictionary[@"result"];
    NSDictionary *core = result[@"core"];
    NSDictionary *profileFields = result[@"profile_fields"];
    
    id genderMap = core[@"gender"];
    CHAGender gender = CHAGenderUnknown;
    if ([genderMap isEqual:kCHAFemaleMap]) {
        gender = CHAGenderFemale;
    } else if ([genderMap isEqual:kCHAMaleMap]) {
        gender = CHAGenderMale;
    }
    self.gender = gender;
    
    self.firstName = null_to_nil(core[@"firstName"]);
    self.secondName = null_to_nil(core[@"lastName"]);
    self.city = null_to_nil(profileFields[@"city"][@"value"]);
    self.country = null_to_nil(profileFields[@"country"][@"value"]);
    self.countryCode = null_to_nil(profileFields[@"country"][@"value"]);
    
    if (profileFields[@"birthdate"]) {
        NSLog(@"");
    }
}

- (void)requestUpdate {
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.
                                                  target:self
                                                selector:@selector(sendUpdates)
                                                userInfo:nil
                                                 repeats:NO];
}

- (void)sendUpdates {
    [self.client uploadSettingsFromModel:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"Updated!");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

#pragma mark - Properties

- (NSString *)firstName {
    return [defs objectForKey:kCHAUserModelFirstName];
}

- (void)setFirstName:(NSString *)firstName {
    [self requestUpdate];
    [defs setObject:firstName forKey:kCHAUserModelFirstName];
    [defs synchronize];
}

- (NSString *)secondName {
    return [defs objectForKey:kCHAUserModelSecondName];
}

- (void)setSecondName:(NSString *)secondName {
    [self requestUpdate];
    [defs setObject:secondName forKey:kCHAUserModelSecondName];
    [defs synchronize];
}

- (NSString *)email {
    return [defs objectForKey:kCHAUserModelEmail];
}

- (void)setEmail:(NSString *)email {
    [defs setObject:email forKey:kCHAUserModelEmail];
    [defs synchronize];
}

- (NSString *)country {
    return [defs objectForKey:kCHAUserModelCountry];
}

- (void)setCountry:(NSString *)country {
    [self requestUpdate];
    [defs setObject:country forKey:kCHAUserModelCountry];
}

- (NSString *)city {
    return [defs objectForKey:kCHAUserModelCity];
}

- (void)setCity:(NSString *)city {
    [self requestUpdate];
    [defs setObject:city forKey:kCHAUserModelCity];
    [defs synchronize];
}

- (NSDate *)birthday {
    return [defs objectForKey:kCHAUserModelBirthday];
}

- (void)setBirthday:(NSDate *)birthday {
    [self requestUpdate];
    [defs setObject:birthday forKey:kCHAUserModelBirthday];
    [defs synchronize];
}

- (CHAGender)gender {
    return [[defs objectForKey:kCHAUserModelGender] integerValue];
}

- (void)setGender:(CHAGender)gender {
    [self requestUpdate];
    [defs setObject:@(gender) forKey:kCHAUserModelGender];
    [defs synchronize];
}

- (NSString *)countryCode {
    return [defs objectForKey:kCHAUserModelCountryCode];
}

- (void)setCountryCode:(NSString *)countryCode {
    [self requestUpdate];
    [defs setObject:countryCode forKey:kCHAUserModelCountryCode];
    [defs synchronize];
}

- (NSNumber *)recoins {
    return [defs objectForKey:kCHAUserModelRecoins];
}

- (void)setRecoins:(NSNumber *)recoins {
    [defs setObject:recoins forKey:kCHAUserModelRecoins];
    [defs synchronize];
}

- (NSNumber *)co2Balance {
    return [defs objectForKey:kCHAUserModelCO2Balance];
}

- (void)setCo2Balance:(NSNumber *)co2Balance {
    [defs setObject:co2Balance forKey:kCHAUserModelCO2Balance];
    [defs synchronize];
}
@end
