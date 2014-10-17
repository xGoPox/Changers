//
//  CHAKeyboardSegue.m
//  Changers
//
//  Created by Nikita Shitik on 30.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHAKeyboardSegue.h"
#import "UIControl+BlocksKit.h"

static NSTimeInterval const kCHAKeyboardAnimationDuration = .25;
static CGFloat const kCHAKeyboardHeight = 216.f;

@implementation CHAKeyboardSegue

- (void)perform {
    UIColor *startColor = [UIColor clearColor];
    UIColor *endColor = [UIColor colorWithWhite:.4f alpha:.5f];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIViewController *destinationController = self.destinationViewController;
    UIButton *dismissButton = [[UIButton alloc] initWithFrame:window.bounds];
    dismissButton.backgroundColor = startColor;
    [window addSubview:dismissButton];
    CGSize destinationViewSize = CGSizeMake(window.bounds.size.width, kCHAKeyboardHeight);
    
    [dismissButton bk_addEventHandler:^(UIButton *sender) {
        [sender bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
        
        [UIView animateWithDuration:kCHAKeyboardAnimationDuration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             dismissButton.backgroundColor = startColor;
                             destinationController.view.frame = CGRectMake(window.bounds.origin.x,
                                                                           window.bounds.size.height,
                                                                           destinationViewSize.width,
                                                                           destinationViewSize.height);
                             
                         } completion:^(BOOL finished) {
                             [destinationController.view removeFromSuperview];
                             [sender removeFromSuperview];
                         }];
        
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [window addSubview:destinationController.view];
    destinationController.view.frame = CGRectMake(window.bounds.origin.x,
                                                      window.bounds.size.height,
                                                      destinationViewSize.width,
                                                      destinationViewSize.height);
    
    
    [UIView animateWithDuration:kCHAKeyboardAnimationDuration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         dismissButton.backgroundColor = endColor;
                         destinationController.view.frame = CGRectMake(window.bounds.origin.x,
                                                                           window.bounds.size.height - destinationViewSize.height,
                                                                           destinationViewSize.width,
                                                                           destinationViewSize.height);
                         
                     } completion:nil];
}

@end
