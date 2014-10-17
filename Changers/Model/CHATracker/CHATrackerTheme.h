//
//  CHATrackerTheme.h
//  Changers
//
//  Created by Denis on 09.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHATracker.h"
#import "CHAConstants.h"

@interface CHATrackerTheme : NSObject
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) UIColor *tintColor;
@property (nonatomic, strong, readonly) UIImage *userAnnotationImage;
@property (nonatomic, strong, readonly) UIImage *startButtonNormalImage;
@property (nonatomic, strong, readonly) UIImage *startButtonHighlitedImage;
@property (nonatomic, strong, readonly) UIImage *stopButtonNormalImage;
@property (nonatomic, strong, readonly) UIImage *stopButtonHighlitedImage;
- (instancetype)initWithTrackerType:(TrackerType)trackerType;
@end
