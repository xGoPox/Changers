//
//  CHADeviceCell.h
//  Changers
//
//  Created by Nikita Shitik on 09.10.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kCHADeleteDeviceNotificationName = @"kCHADeleteDeviceNotificationName";
static NSString *const kCHADeleteDeviceKey = @"kCHADeleteDeviceKey";

@class CHADevice;

@interface CHADeviceCell : UICollectionViewCell

- (void)configureWithDevice:(CHADevice *)device count:(NSInteger)count index:(NSInteger)index;

@end
