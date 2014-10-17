//
//  CHACountrySegue.m
//  Changers
//
//  Created by Nikita Shitik on 07.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHACountrySegue.h"

//destination controller
#import "CHACountryViewController.h"

//misc
#import "UIControl+BlocksKit.h"

static CGFloat const kDuration = .25;

@implementation CHACountrySegue

- (void)perform {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CHACountryViewController *destinationViewController = [self destinationViewController];
    
    CGSize destinationViewSize = [destinationViewController controllerSize];
    
    UIButton *dismissButton = [[UIButton alloc] initWithFrame:window.bounds];
    dismissButton.backgroundColor = [UIColor clearColor];
    destinationViewController.dismissButton = dismissButton;
    [window addSubview:dismissButton];
    
    
    [dismissButton bk_addEventHandler:^(UIButton *sender) {
        [sender bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
        
        [UIView animateWithDuration:kDuration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             destinationViewController.view.frame = CGRectMake(window.bounds.origin.x,
                                                                               window.bounds.size.height,
                                                                               destinationViewSize.width,
                                                                               destinationViewSize.height);
                             
                         } completion:^(BOOL finished) {
                             [destinationViewController.view removeFromSuperview];
                             [sender removeFromSuperview];
                         }];
        
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [window addSubview:destinationViewController.view];
    destinationViewController.view.frame = CGRectMake(window.bounds.origin.x,
                                                      window.bounds.size.height,
                                                      destinationViewSize.width,
                                                      destinationViewSize.height);
    
    
    [UIView animateWithDuration:kDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         destinationViewController.view.frame = CGRectMake(window.bounds.origin.x,
                                                                           window.bounds.size.height - destinationViewSize.height,
                                                                           destinationViewSize.width,
                                                                           destinationViewSize.height);
                         
                     } completion:nil];
}

@end
