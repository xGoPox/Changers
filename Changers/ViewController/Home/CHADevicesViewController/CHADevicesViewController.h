//
//  CHADevicesViewController.h
//  Changers
//
//  Created by Nikita Shitik on 09.10.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHADevice;
@class CHADeviceContainerViewController;

@interface CHADevicesViewController : CHABaseViewController

@property (nonatomic, weak) CHADeviceContainerViewController *container;

- (void)configureWithDevice:(CHADevice *)device count:(NSInteger)count index:(NSInteger)index;

@end
