//
//  CHAIAPRecoinsHelper.m
//  Changers
//
//  Created by Clemt Yerochewski on 15/10/14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHAIAPRecoinsHelper.h"

@implementation CHAIAPRecoinsHelper

+ (CHAIAPRecoinsHelper *)sharedInstance {
    static dispatch_once_t once;
    static CHAIAPRecoinsHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet *productIdentifiers = [NSSet setWithObjects:
//                                      [NSDictionary dictionaryWithObjects:@[@"25kg", [NSNumber numberWithInt:2500000]] forKeys:@[@"identifier", @"amount"]],
//                                     [NSDictionary dictionaryWithObjects:@[@"35kg", [NSNumber numberWithInt:2500]] forKeys:@[@"identifier", @"amount"]],
//
//                                     [NSDictionary dictionaryWithObjects:@[@"45kg", [NSNumber numberWithInt:325000]] forKeys:@[@"identifier", @"amount"]],

                                      @"20kg",
                                     @"30kg",
                                     @"40kg",
//                                      @"com.razeware.inapprage.nightlyrage",
//                                      @"com.razeware.inapprage.studylikeaboss",
//                                      @"com.razeware.inapprage.updogsadness",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}





@end
