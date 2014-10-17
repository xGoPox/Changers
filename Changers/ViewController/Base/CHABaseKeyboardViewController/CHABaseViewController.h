//
//  CHABaseViewController.h
//  Changers
//
//  Created by Nikita Shitik on 23.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHABaseViewController : UIViewController

/**
  Override this method and animate your view controller as you need.
 */
- (void)animateTermsView:(CGFloat)height duration:(NSTimeInterval)duration curve:(UIViewAnimationCurve)curve;

@end
