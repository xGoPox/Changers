//
//  CHACompensation.h
//  Changers
//
//  Created by Clemt Yerochewski on 14/10/14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CHAPaymentType) {
    CHARecoinsPayment,
    CHAInAppPurchasePayment,
};

@interface CHACompensation : NSObject

@property (nonatomic, strong) NSNumber * co2ToCompense;
@property (nonatomic, strong) NSNumber * co2Recoins;
@property (nonatomic) CGFloat co2Price;
@property (nonatomic) CHAPaymentType paymentType;

@end
