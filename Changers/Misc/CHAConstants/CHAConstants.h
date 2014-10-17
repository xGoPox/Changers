//
//  CHAConstants.h
//  Changers
//
//  Created by Nikita Shitik on 08.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - API Global

extern NSString *const kCHAAPIKey;
extern NSString *const kCHABaseURL;
extern NSString *const kCHAJSONPath;

#pragma mark - Response keys

extern NSString *const kCHAResponseKeyMessage;
extern NSString *const kCHAResponseKeyStatus;
extern NSString *const kCHAResponseKeyResult;
extern NSString *const kCHAResponseKeySuccess;

#pragma mark - Messages

extern NSString *const kCHAMessageNetworkError;
extern NSString *const kCHAMessageLoginFail;
extern NSString *const kCHAMessageOK;

#pragma mark - Font names

extern NSString *const kCHAKlavikaFontName;
extern NSString *const kCHAKlavikaMediumFontName;

#pragma mark - Image names

static NSString *const kCHANonactiveImageName = @"b12_input_field_normal";
static NSString *const kCHAActiveImageName = @"b12_input_field_active";

#pragma mark - Colors

#define BAR_TINT_COLOR [UIColor colorWithRed:83.f/255.f green:195.f/255.f blue:245.f/255.f alpha:1.f]

#define RGB(r, g, b) \
[UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBA(r, g, b, a) \
[UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#pragma mark - Token storage

extern NSString *const kCHATokenName;
extern NSString *const kCHAFirstLaunchKey;
extern NSString *const kCHAFacebookDefaultsKey;

extern NSString *const kCHAUserNameStoringKey;

extern NSString *const kCHAGuidStoringKey;

#pragma mark - Gender

typedef NS_ENUM(NSInteger, CHAGender) {
    CHAGenderMale,
    CHAGenderFemale,
    CHAGenderUnknown
};

#pragma mark - Block

typedef void (^CHAEmptyBlock)(void);
typedef void (^CHAStringBlock)(NSString *);

#pragma mark - Tracker
typedef NS_ENUM(NSInteger, TrackerType) {
    TrackerTypeBike,
    TrackerTypePublicTransport,
    TrackerTypeTrain,
    TrackerTypeCar,
    TrackerTypePlane, 
    TrackerTypesCount
};

extern NSString * CHAStringFromTrackingType(TrackerType type);

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#pragma mark - UserSettingsModel

extern NSString *const kCHAUserModelRecoins;
extern NSString *const kCHAUserModelCO2Balance;


