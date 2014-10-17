//
//  CHAInAppPurchaseHelper.m
//  Changers
//
//  Created by Clemt Yerochewski on 14/10/14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHAInAppPurchase.h"
#import <StoreKit/StoreKit.h>

@interface CHAInAppPurchase () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@end

@implementation CHAInAppPurchase {
    SKProductsRequest * _productsRequest;
    RequestProductsCompletionHandler _completionHandler;

    NSSet * _productIdentifiers;
//    NSMutableSet * _purchasedProductIdentifiers;
}


- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    
    if ((self = [super init])) {
        
        _productIdentifiers = productIdentifiers;
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];

        
    }
    return self;
}


- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
    
    _completionHandler = [completionHandler copy];
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _productsRequest.delegate = self;
    [_productsRequest start];
    
}

//- (BOOL)productPurchased:(NSString *)productIdentifier {
//    return [_purchasedProductIdentifiers containsObject:productIdentifier];
//}

- (void)buyProduct:(SKProduct *)product {
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    
    if ([productIdentifier isEqualToString:@"20kg"]) {
        
        NSNumber *currentValue = [[NSUserDefaults standardUserDefaults]
                            objectForKey:kCHAUserModelRecoins];
        NSNumber *sum = [NSNumber numberWithFloat:([currentValue floatValue] + [@25 floatValue])];
        
        [[NSUserDefaults standardUserDefaults] setObject:sum
                                                   forKey:kCHAUserModelRecoins];
        [[NSUserDefaults standardUserDefaults] synchronize];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"IAPHelperProductPurchasedNotification" object:productIdentifier userInfo:nil];

    }
}


#pragma mark - SKPaymentTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"Transaction state -> Purchasing");
                break;
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    };
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"completeTransaction...");

    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"restoreTransaction...");
    
    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];

}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"failedTransaction...");
    if (transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }

    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSLog(@"Loaded list of products...");
    _productsRequest = nil;
    
    NSArray * skProducts = response.products;
    for (SKProduct * skProduct in skProducts) {
        NSLog(@"Found product: %@ %@ %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
    }
    
    _completionHandler(YES, skProducts);
    _completionHandler = nil;
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    NSLog(@"Failed to load list of products.");
    _productsRequest = nil;
    
    _completionHandler(NO, nil);
    _completionHandler = nil;
    
}





@end
