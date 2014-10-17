//
//  CHADashboardContainerViewController.h
//  Changers
//
//  Created by Nikita Shitik on 01.10.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHADashboardContainerViewController : CHABaseViewController

- (void)showEnergy;
- (void)showDashboard;

- (void)moveLeft;
- (void)moveRight;

@property (nonatomic, assign) BOOL showEnergyScreenOnFirstLaunch;

@end
