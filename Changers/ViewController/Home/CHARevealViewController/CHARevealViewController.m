//
//  CHARevealViewController.m
//  Changers
//
//  Created by Nikita Shitik on 13.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHARevealViewController.h"

#import "UIViewController+PKRevealController.h"

//model
#import "CHASettingsUserModel.h"

//destination controller
#import "CHASideViewController.h"

@interface CHARevealViewController ()

//model
@property (nonatomic, strong) CHASettingsUserModel *model;

@end

@implementation CHARevealViewController

#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.model = [CHASettingsUserModel sharedModel];
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.model loadDataWithSuccess:nil failure:nil];
    self.animationDuration = 0.3;
    [self performSegueWithIdentifier:@"leftSegue" sender:nil];
    [self.leftViewController view];
}

#pragma mark - UIStoryboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"leftSegue"]) {
        CHASideViewController *sideController = segue.destinationViewController;
        sideController.revealController = self;
        sideController.tracker = self.tracker;
    }
}

@end
