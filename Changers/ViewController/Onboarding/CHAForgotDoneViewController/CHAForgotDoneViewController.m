//
//  CHAForgotDoneViewController.m
//  Changers
//
//  Created by Nikita Shitik on 03.10.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHAForgotDoneViewController.h"

@implementation CHAForgotDoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"unwind" sender:nil];
    });
}

@end
