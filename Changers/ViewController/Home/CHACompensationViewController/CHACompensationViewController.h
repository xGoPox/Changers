//
//  CHATrackCompensationViewController.h
//  Changers
//
//  Created by Clemt Yerochewski on 14/10/14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CHACompensation.h"
#import "CHATracker.h"

@interface CHACompensationViewController : UIViewController

@property (strong, nonatomic) CHATracker *tracker;
@property (strong, nonatomic) CHACompensation *compensation;

@end
