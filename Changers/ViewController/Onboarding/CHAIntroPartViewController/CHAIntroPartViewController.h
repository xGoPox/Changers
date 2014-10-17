//
//  CHAIntroPartViewController.h
//  Changers
//
//  Created by Nikita Shitik on 02.10.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const kCHAIntroCanSkipNotificationName = @"kCHAIntroCanSkipNotificationName";
static NSString *const kCHAIntroCannotSkipNotificationName = @"kCHAIntroCannotSkipNotificationName";

@interface CHAIntroPartViewController : CHABaseViewController

@property (nonatomic, weak) IBOutlet UILabel *topLabel;
@property (nonatomic, weak) IBOutlet UIImageView *detailImageView;
@property (nonatomic, weak) IBOutlet UIButton *bottomButton;
@property (nonatomic, assign) BOOL canSkip;

@end
