//
//  CHATrackerTheme.m
//  Changers
//
//  Created by Denis on 09.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHATrackerTheme.h"

@interface CHATrackerTheme ()
@property (nonatomic, strong, readwrite) NSString *title;
@property (nonatomic, strong, readwrite) UIColor *tintColor;
@property (nonatomic, strong, readwrite) UIImage *userAnnotationImage;
@property (nonatomic, strong, readwrite) UIImage *startButtonNormalImage;
@property (nonatomic, strong, readwrite) UIImage *startButtonHighlitedImage;
@property (nonatomic, strong, readwrite) UIImage *stopButtonNormalImage;
@property (nonatomic, strong, readwrite) UIImage *stopButtonHighlitedImage;
@end

@implementation CHATrackerTheme

- (instancetype)initWithTrackerType:(TrackerType)trackerType {
    self = [super init];
    if (self) {
        [self updateWithTrackerType:trackerType];
    }
    return self;
}

- (void)updateWithTrackerType:(TrackerType)trackerType {
    switch (trackerType) {
        case TrackerTypeBike:
            self.title = NSLocalizedString(@"BIKE", nil);
            self.tintColor = [UIColor colorWithRed:0.200 green:0.816 blue:0.851 alpha:1.000];
            self.userAnnotationImage = [UIImage imageNamed:@"pin_cycling_icon"];
            self.startButtonNormalImage = [UIImage imageNamed:@"start_cycling_button_normal"];
            self.startButtonHighlitedImage = [UIImage imageNamed:@"start_cycling_button_pressed"];
            self.stopButtonNormalImage = [UIImage imageNamed:@"pause_plane_button_normal"];
            self.stopButtonHighlitedImage = [UIImage imageNamed:@"pause_plane_button_pressed"];
            break;
        case TrackerTypeCar:
            self.title = NSLocalizedString(@"CAR", nil);
            self.tintColor = [UIColor colorWithRed:0.976 green:0.592 blue:0.020 alpha:1.000];
            self.userAnnotationImage = [UIImage imageNamed:@"pin_car"];
            self.startButtonNormalImage = [UIImage imageNamed:@"start_car_button_normal"];
            self.startButtonHighlitedImage = [UIImage imageNamed:@"start_car_button_pressed"];
            self.stopButtonNormalImage = [UIImage imageNamed:@"pause_plane_button_normal"];
            self.stopButtonHighlitedImage = [UIImage imageNamed:@"pause_plane_button_pressed"];
            break;
        case TrackerTypePlane:
            self.title = NSLocalizedString(@"PLANE", nil);
            self.tintColor = [UIColor colorWithRed:0.898 green:0.275 blue:0.075 alpha:1.000];
            self.userAnnotationImage = [UIImage imageNamed:@"pin_plane"];
            self.startButtonNormalImage = [UIImage imageNamed:@"start_plane_button_normal"];
            self.startButtonHighlitedImage = [UIImage imageNamed:@"start_plane_button_pressed"];
            self.stopButtonNormalImage = [UIImage imageNamed:@"pause_plane_button_normal"];
            self.stopButtonHighlitedImage = [UIImage imageNamed:@"pause_plane_button_pressed"];
            break;
        case TrackerTypePublicTransport:
            self.title = NSLocalizedString(@"PUBLIC TRANSPORT", nil);
            self.tintColor = [UIColor colorWithRed:0.608 green:0.831 blue:0.129 alpha:1.000];
            self.userAnnotationImage = [UIImage imageNamed:@"pin_public"];
            self.startButtonNormalImage = [UIImage imageNamed:@"start_public_button_normal"];
            self.startButtonHighlitedImage = [UIImage imageNamed:@"start_public_button_pressed"];
            self.stopButtonNormalImage = [UIImage imageNamed:@"pause_plane_button_normal"];
            self.stopButtonHighlitedImage = [UIImage imageNamed:@"pause_plane_button_pressed"];
            break;
        case TrackerTypeTrain:
            self.title = NSLocalizedString(@"TRAIN", nil);
            self.tintColor = [UIColor colorWithRed:0.271 green:0.792 blue:0.459 alpha:1.000];
            self.userAnnotationImage = [UIImage imageNamed:@"pin_train"];
            self.startButtonNormalImage = [UIImage imageNamed:@"start_train_button_normal"];
            self.startButtonHighlitedImage = [UIImage imageNamed:@"start_train_button_pressed"];
            self.stopButtonNormalImage = [UIImage imageNamed:@"pause_plane_button_normal"];
            self.stopButtonHighlitedImage = [UIImage imageNamed:@"pause_plane_button_pressed"];
            break;
        default:
            break;
    }
}

#pragma mark -

@end
