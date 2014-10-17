//
//  CHAInfoViewController.m
//  Changers
//
//  Created by Nikita Shitik on 13.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHAInfoViewController.h"

//reveal
#import "PKRevealController.h"
#import "UIViewController+PKRevealController.h"

@interface CHAInfoViewController ()

@end

@implementation CHAInfoViewController

#pragma mark - IBAction

- (IBAction)revealButtonTouchUpInside:(id)sender {
    [self.revealController showViewController:self.revealController.leftViewController];
}

- (IBAction)visitButtonTouchUpInside:(id)sender {
    NSURL *URL = [NSURL URLWithString:@"http://changers.com"];
    if ([[UIApplication sharedApplication] canOpenURL:URL]) {
        [[UIApplication sharedApplication] openURL:URL];
    }
}

@end
