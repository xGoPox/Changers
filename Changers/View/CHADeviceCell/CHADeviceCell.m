//
//  CHADeviceCell.m
//  Changers
//
//  Created by Nikita Shitik on 09.10.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHADeviceCell.h"

//model
#import "CHADevice.h"

@interface CHADeviceCell ()

//view
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *serialNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *energyLabel;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;

//model
@property (nonatomic, strong) CHADevice *device;

@end

@implementation CHADeviceCell

#pragma mark - UICollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView addSubview:self.tableView];
}

#pragma mark - Public

- (void)configureWithDevice:(CHADevice *)device count:(NSInteger)count index:(NSInteger)index {
    [self.tableView scrollRectToVisible:CGRectZero animated:NO];
    self.device = device;
    self.nameLabel.text = device.name;
    self.serialNumberLabel.text = device.serialNumber;
    self.energyLabel.text = [NSString stringWithFormat:@"%@", device.totalEnergy];
    self.pageControl.numberOfPages = count;
    self.pageControl.currentPage = index;
}

#pragma mark - Private

- (IBAction)deleteButtonTouchUpInside:(id)sender {
    NSDictionary *userInfo = @{kCHADeleteDeviceKey: self.device};
    [[NSNotificationCenter defaultCenter] postNotificationName:kCHADeleteDeviceNotificationName
                                                        object:nil
                                                      userInfo:userInfo];
}

#pragma mark - UIView

- (void)setHidden:(BOOL)hidden {
    [super setHidden:NO];
}

@end
