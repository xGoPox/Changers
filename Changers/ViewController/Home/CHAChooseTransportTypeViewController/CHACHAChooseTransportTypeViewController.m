//
//  CHACHAChooseTransportTypeViewController.m
//  Changers
//
//  Created by Denis on 25.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHACHAChooseTransportTypeViewController.h"
#import "CHATransportCell.h"
#import "CHATrackerTheme.h"

@interface CHACHAChooseTransportTypeViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *currentTransportImageView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewFlowLayout;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (assign, nonatomic) NSInteger numberOfItems;
@end

@implementation CHACHAChooseTransportTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentTransportImageView.image = [self imageForTrackerType:self.tracker.trackerType];
    self.numberOfItems = TrackerTypePlane - (self.tracker.trackerType + 1);
    [self.collectionViewFlowLayout setItemSize:CGSizeMake((CGRectGetWidth(self.collectionView.frame)/self.numberOfItems), 60.f)];
    self.descriptionLabel.text = [NSString stringWithFormat:@"Your speed tells us you are probably not using %@. Please tell us what kind of mobility type you used?", self.tracker.trackerTheme.title];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.numberOfItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CHATransportCell * cell = (CHATransportCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"transportCell" forIndexPath:indexPath];
    cell.imageView.image = [self imageForTrackerType:(self.tracker.trackerType + (indexPath.row + 1))];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(didChooseTransportType:)]) {
        [self.delegate didChooseTransportType:(self.tracker.trackerType + (indexPath.row + 1))];
    }
}

#pragma mark - private

- (UIImage*)imageForTrackerType:(TrackerType)trackerType {
    NSString *imageName = nil;
    switch (trackerType) {
        case TrackerTypeBike:
            imageName = @"cycle_icon_normal";
            break;
        case TrackerTypePublicTransport:
            imageName = @"public_icon_normal";
            break;
        case TrackerTypeCar:
            imageName = @"car_icon_normal";
            break;
        case TrackerTypeTrain:
            imageName = @"train_icon_normal";
            break;
        case TrackerTypePlane:
            imageName = @"plane_icon_normal";
            break;
        default:
            break;
    }
    return [UIImage imageNamed:imageName];
}

@end
