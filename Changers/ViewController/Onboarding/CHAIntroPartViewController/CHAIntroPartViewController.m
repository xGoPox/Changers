//
//  CHAIntroPartViewController.m
//  Changers
//
//  Created by Nikita Shitik on 02.10.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHAIntroPartViewController.h"

@interface CHAIntroPartViewController ()

@end

@implementation CHAIntroPartViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.canSkip) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCHAIntroCanSkipNotificationName object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCHAIntroCannotSkipNotificationName object:nil];
    }
}

@end
