//
//  CHACompensationHelper.m
//  Changers
//
//  Created by Clemt Yerochewski on 16/10/14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHACompensationHelper.h"

@implementation CHACompensationHelper
{
    NSArray *compensationPackages;
    RequestCompensationRecoins _completionHandlerRecoins;
    RequestCompensationIAP _completionHandlerIAP;
    
}
- (id)initCompensationPackage
{
    if ((self = [super init])) {
        compensationPackages = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:50000],
                                [NSNumber numberWithInt:1000000],
                                [NSNumber numberWithInt:2000000],
                                [NSNumber numberWithInt:3000000],
                                nil];
    }
    return self;
}

+ (CHACompensationHelper *)sharedInstance {
    static dispatch_once_t once;
    static CHACompensationHelper * sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] initCompensationPackage];
    });
    return sharedInstance;
}

- (void)convertCO2CompensationIntoRecoins:(NSNumber *)compensation withCompletionHandler:(RequestCompensationRecoins)completionHandler
{
    _completionHandlerRecoins = [completionHandler copy];
    
    __block NSNumber *currentPack;

    [compensationPackages enumerateObjectsUsingBlock:^(NSNumber *compensationPack, NSUInteger idx, BOOL *stop) {
        
        if ([compensation compare:compensationPack] != NSOrderedDescending) {
            if (currentPack == nil) {
                currentPack = compensationPack;
            }
            else if ([currentPack compare:compensationPack] == NSOrderedDescending)
            {
                currentPack = compensationPack;
            }
        }
    }];

    _completionHandlerRecoins(currentPack);
}

- (void)getIAPForCompensation:(NSNumber *)compensation onProducts:(NSArray *)products withCompletionHandler:(RequestCompensationIAP)completionHandler
{
    _completionHandlerIAP = [completionHandler copy];
    
    __block NSNumber *_amount = nil;
    __block SKProduct *_product;
    [products enumerateObjectsUsingBlock:^(SKProduct *product, NSUInteger idx, BOOL *stop) {
        NSNumber *amoutTmp = [self amountCO2CompensationForIdentifier:product.productIdentifier];
        if ([amoutTmp compare:compensation] != NSOrderedAscending) {
            if (_amount == nil) {
                _amount = amoutTmp;
                _product = product;
            }
            else if ([amoutTmp compare:_amount] == NSOrderedAscending)
            {
                _amount = amoutTmp;
                _product = product;
            }
        }
    }];
    _completionHandlerIAP(_product);
}

- (NSNumber *)amountCO2CompensationForIdentifier:(NSString *)identifier
{
    NSNumber *amount;
    if ([identifier isEqualToString:@"20kg"]) {
        amount = @20000;
    }
    else if ([identifier isEqualToString:@"30kg"]) {
        amount = @40000;
    }
    else if ([identifier isEqualToString:@"40kg"]) {
        amount = @60000;
    }
    NSLog(@"amount : %@", amount);
    return amount;
}

@end
