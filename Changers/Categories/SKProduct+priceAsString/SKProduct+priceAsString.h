//
//  SKProduct+priceAsString.h
//  Changers
//
//  Created by Clemt Yerochewski on 16/10/14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import <StoreKit/StoreKit.h>

@interface SKProduct (priceAsString)
@property (nonatomic, readonly) NSString *priceAsString;
@end
