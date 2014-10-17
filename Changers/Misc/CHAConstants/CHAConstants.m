//
//  CHAConstants.m
//  Changers
//
//  Created by Nikita Shitik on 08.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHAConstants.h"

#pragma mark - API

NSString *const kCHAAPIKey = @"440485f417a91afb943178bf507e870a880d10fd";
NSString *const kCHABaseURL = @"https://development.changers.com/services/api/rest/";
NSString *const kCHAJSONPath = @"json/";

#pragma mark - Response keys

NSString *const kCHAResponseKeyMessage = @"message";
NSString *const kCHAResponseKeyStatus = @"status";
NSString *const kCHAResponseKeyResult = @"result";
NSString *const kCHAResponseKeySuccess = @"success";

#pragma mark - Messages

NSString *const kCHAMessageNetworkError = @"A network error has occured. Please, try again later.";
NSString *const kCHAMessageLoginFail = @"Failed to log in with the given email and password. If you are registering at the moment, please, try to sign in with the email and the password you've entered.";
NSString *const kCHAMessageOK = @"OK";

#pragma mark - Font names

NSString *const kCHAKlavikaFontName = @"Klavika-Regular";
NSString *const kCHAKlavikaMediumFontName = @"Klavika-Medium";

#pragma mark - Token storage

NSString *const kCHATokenName = @"kCHATokenName";
NSString *const kCHAFirstLaunchKey = @"kCHAFirstLaunchKey";
NSString *const kCHAUserNameStoringKey = @"kCHAUserNameStoringKey";
NSString *const kCHAFacebookDefaultsKey = @"kCHAFacebookDefaultsKey";

NSString *const kCHAGuidStoringKey = @"kCHAGuidStoringKey";

NSString * CHAStringFromTrackingType(TrackerType type) {
    switch (type) {
        case TrackerTypeBike:
            return @"Cycling";
            break;
        case TrackerTypePublicTransport:
            return @"Local";
            break;
        case TrackerTypeTrain:
            return @"Regional";
            break;
        case TrackerTypeCar:
            return @"Auto";
            break;
        case TrackerTypePlane:
            return @"Aero";
            break;
        default:
            return nil;
            break;
    }
}

#pragma mark - UserSettingsModel


NSString *const kCHAUserModelRecoins = @"kCHAUserModelRecoins";
NSString *const kCHAUserModelCO2Balance = @"kCHAUserModelCO2Balance";
