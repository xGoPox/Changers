//
//  CHADateViewController.h
//  Changers
//
//  Created by Nikita Shitik on 30.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CHADateViewControllerDelegate;

@interface CHADateViewController : UIViewController

@property (nonatomic, weak) id<CHADateViewControllerDelegate> delegate;
@property (nonatomic, copy) NSDate *startDate;

@end

@protocol CHADateViewControllerDelegate <NSObject>

@optional
- (void)dateViewController:(CHADateViewController *)dateViewController didPickDate:(NSDate *)date;

@end