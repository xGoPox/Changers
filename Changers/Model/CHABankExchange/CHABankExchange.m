//
//  CHABankExchange.m
//  Changers
//
//  Created by Denis on 17.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHABankExchange.h"
#import "CHAAPIClient.h"

@interface CHABankExchange ()
@property (nonatomic, strong) NSDictionary *exchangeData;
- (NSString*)datafilePath;
- (void)updateExchangeData;
- (void)loadExchangeData;
- (void)updateExchangeDataIfNeeded;
@end

@implementation CHABankExchange

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[self datafilePath]]) {
            [self loadExchangeData];
            [self updateExchangeDataIfNeeded];
        } else {
            [self updateExchangeData];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateExchangeDataIfNeeded) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (NSString*)datafilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *dataPath = [[paths firstObject]
                          stringByAppendingPathComponent:@"exchange.data"];
    return dataPath;
}

- (void)loadExchangeData {
    self.exchangeData = [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:[self datafilePath]]];
}

- (void)updateExchangeDataIfNeeded {
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    NSDate *lastUpdateDate = [self.exchangeData objectForKey:@"updateDate"];
    NSDateComponents *breakdownInfo = [sysCalendar components:NSMonthCalendarUnit fromDate:[NSDate date]  toDate:lastUpdateDate  options:0];
    if ([breakdownInfo month] > 0) {
        [self updateExchangeData];
    }
}

- (void)updateExchangeData {
    [[CHAAPIClient sharedClient] getExchangesList:^(NSURLSessionDataTask *operation, id responseObject) {
        if ([[responseObject valueForKey:@"status"] integerValue] == 0) {
            NSArray *result = [responseObject valueForKey:@"result"];
            NSMutableDictionary *exchageList = [NSMutableDictionary dictionary];
            for (NSDictionary *exchangeDictionary in result) {
                [exchageList setObject:exchangeDictionary forKey:[exchangeDictionary objectForKey:@"type"]];
            }
            [exchageList setObject:[NSDate date] forKey:@"updateDate"];
            self.exchangeData = [NSDictionary dictionaryWithDictionary:exchageList];
            [[NSKeyedArchiver archivedDataWithRootObject:self.exchangeData] writeToFile:[self datafilePath] atomically:YES];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"Error loadExchangeData %@", [error localizedDescription]);
    }];
}

- (CHAExchange)exchangeForType:(TrackerType)type {
    NSDictionary *exchangeDictionary = [self.exchangeData valueForKey:CHAStringFromTrackingType(type)];
    CHAExchange exchange;
    exchange.ccx = [[exchangeDictionary valueForKey:@"ccx"] floatValue];
    exchange.co2e = [[exchangeDictionary valueForKey:@"co2e"] floatValue];
    exchange.co2x = [[exchangeDictionary valueForKey:@"co2x"] floatValue];
    return exchange;
}

- (CHASpeedLimits)limitsForType:(TrackerType)type {
    NSDictionary *exchangeDictionary = [self.exchangeData valueForKey:CHAStringFromTrackingType(type)];
    CHASpeedLimits speedLimits;
    speedLimits.lowerThreshold = [[exchangeDictionary valueForKey:@"lower_threshold"] doubleValue];
    speedLimits.upperThreshold = [[exchangeDictionary valueForKey:@"upper_threshold"] doubleValue];
    return speedLimits;
}


@end
