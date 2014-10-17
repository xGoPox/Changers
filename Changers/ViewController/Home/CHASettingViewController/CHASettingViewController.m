//
//  CHASettingViewController.m
//  Changers
//
//  Created by Nikita Shitik on 13.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHASettingViewController.h"

//reveal
#import "PKRevealController.h"
#import "UIViewController+PKRevealController.h"

@interface CHASettingViewController ()

@end

@implementation CHASettingViewController

#pragma mark - IBAction

- (IBAction)revealButtonTouchUpInside:(id)sender {
    [self.revealController showViewController:self.revealController.leftViewController];
}

#pragma mark - UIStoryboard

//method for unwind segue, default does nothing, but requires implementation
- (IBAction)unwindToSettings:(UIStoryboardSegue *)sender {
    
}

@end
