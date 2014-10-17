//
//  CHADateViewController.m
//  Changers
//
//  Created by Nikita Shitik on 30.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHADateViewController.h"

@interface CHADateViewController ()

@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;

@end

@implementation CHADateViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.startDate) {
        self.datePicker.date = self.startDate;
    }
}

#pragma mark - IBAction

- (IBAction)datePickerValueChanged:(UIDatePicker *)sender {
    if ([self.delegate respondsToSelector:@selector(dateViewController:didPickDate:)]) {
        [self.delegate dateViewController:self didPickDate:sender.date];
    }
}

@end
