//
//  CHACHAChooseTransportTypeViewController.h
//  Changers
//
//  Created by Denis on 25.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHATracker.h"
#import "CHAConstants.h"

@protocol CHAChooseTransportDelegate <NSObject>
@optional
- (void)didChooseTransportType:(TrackerType)transportType;
@end

@interface CHACHAChooseTransportTypeViewController : CHABaseViewController
@property (nonatomic, weak) id <CHAChooseTransportDelegate> delegate;
@property (nonatomic, strong) CHATracker *tracker;
@end
