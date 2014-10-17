//
//  CHARevealLeftSegue.m
//  Changers
//
//  Created by Nikita Shitik on 13.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHARevealLeftSegue.h"

//source controller
#import "PKRevealController.h"

@implementation CHARevealLeftSegue

- (void)perform {
    PKRevealController *sourceViewController = self.sourceViewController;
    UIViewController *destinationController = self.destinationViewController;
    sourceViewController.leftViewController = destinationController;
}

@end
