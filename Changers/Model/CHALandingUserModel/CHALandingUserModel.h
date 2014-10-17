//
//  CHALandingUserModel.h
//  Changers
//
//  Created by Nikita Shitik on 07.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CHALandingUserModel : NSObject

@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *secondName;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) CLLocation *location;
@property (nonatomic, assign) BOOL acceptedTerms;
@property (nonatomic, assign) BOOL facebookAccount;

- (void)checkNameAvailabilityWithSuccess:(void (^)(BOOL available))success
                                 failure:(void (^)(NSString *errorString))failure;

- (void)checkFacebookAvailabilityWithSuccess:(void (^)(BOOL available))success
                                     failure:(void (^)(NSString *errorString))failure;

- (void)registerWithSuccess:(void (^)(BOOL success))success
                    failure:(void (^)(NSString *errorString))failure;

- (void)getTokenWithSuccess:(void (^)(void))success
                    failure:(void (^)(NSString *errorString))failure;

- (void)getTokenForFacebookAuthWithSuccess:(void (^)(BOOL wasRegistered))success
                                   failure:(void (^)(NSString *errorString))failure;

- (void)getTokenForGoogleAuthWithSuccess:(void (^)(BOOL wasRegistered))success
                                   failure:(void (^)(NSString *errorString))failure;


@end
