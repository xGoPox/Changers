//
//  CHASideViewController.h
//  Changers
//
//  Created by Nikita Shitik on 13.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHATracker;

@interface CHASideViewController : UIViewController

@property (nonatomic, strong) CHATracker *tracker;

- (void)addViewController:(UIViewController *)viewController;

- (void)showDashboard;
- (void)showEnergyStats;

@end
