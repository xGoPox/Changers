//
//  CHACompensationHelper.h
//  Changers
//
//  Created by Clemt Yerochewski on 16/10/14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import <StoreKit/StoreKit.h>

@class CHACompensation;

typedef void (^RequestCompensationRecoins)(NSNumber *recoins);
typedef void (^RequestCompensationIAP)(SKProduct *product);

@interface CHACompensationHelper : NSObject

+ (CHACompensationHelper *)sharedInstance;

- (void)convertCO2CompensationIntoRecoins:(NSNumber *)compensation withCompletionHandler:(RequestCompensationRecoins)completionHandler;
- (void)getIAPForCompensation:(NSNumber *)compensation onProducts:(NSArray *)products withCompletionHandler:(RequestCompensationIAP)completionHandler;


@end
