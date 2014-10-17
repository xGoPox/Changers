//
//  CHAInAppPurchaseHelper.h
//  Changers
//
//  Created by Clemt Yerochewski on 14/10/14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import <StoreKit/StoreKit.h>

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface CHAInAppPurchase : NSObject

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;
- (void)buyProduct:(SKProduct *)product;

@end
