//
//  CHADismissSegue.m
//  Changers
//
//  Created by Denis on 26.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHADismissSegue.h"

@implementation CHADismissSegue

- (void)perform {
    UIViewController *sourceViewController = self.sourceViewController;
    [sourceViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
