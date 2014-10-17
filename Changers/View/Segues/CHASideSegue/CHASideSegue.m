//
//  CHASideSegue.m
//  Changers
//
//  Created by Nikita Shitik on 13.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHASideSegue.h"

//source controller
#import "CHASideViewController.h"

@implementation CHASideSegue

- (void)perform {
    CHASideViewController *sourceController = self.sourceViewController;
    [sourceController addViewController:self.destinationViewController];
}

@end
