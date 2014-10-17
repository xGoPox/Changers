//
//  CHADevicesViewController.m
//  Changers
//
//  Created by Nikita Shitik on 09.10.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHADevicesViewController.h"

//model
#import "CHADevice.h"
#import "CHADeviceListModel.h"

//parent
#import "CHADeviceContainerViewController.h"

@interface CHADevicesViewController ()<UIAlertViewDelegate>

//model
@property (nonatomic, strong) CHADevice *device;

//view
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *serialNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *energyLabel;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;

@end

@implementation CHADevicesViewController

#pragma mark - Public

- (void)configureWithDevice:(CHADevice *)device count:(NSInteger)count index:(NSInteger)index {
    self.device = device;
    [self.tableView scrollRectToVisible:CGRectZero animated:NO];
    self.nameLabel.text = device.name;
    self.serialNumberLabel.text = device.serialNumber;
    self.energyLabel.text = [NSString stringWithFormat:@"%@", device.totalEnergy];
    self.pageControl.numberOfPages = count;
    self.pageControl.currentPage = index;
}

#pragma mark - IBAction

- (IBAction)deleteButtonTouchUpInside:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Delete?", nil)
                                                    message:NSLocalizedString(@"Are you sure you want to delete this device?", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                          otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [[CHADeviceListModel sharedDeviceListModel] deleteDevice:self.device
                                                         success:^{
                                                             [self.container moveLeft];
                                                         } failure:^(NSString *errorString) {
                                                             [self cha_alertWithMessage:NSLocalizedString(@"Failed to delete the device.", nil)];
                                                         }];
    }
}

@end
