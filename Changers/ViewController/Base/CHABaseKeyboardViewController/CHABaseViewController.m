//
//  CHABaseViewController.m
//  Changers
//
//  Created by Nikita Shitik on 23.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHABaseViewController.h"
#import "UINavigationBar+Addition.h"

@interface CHABaseViewController ()

@end

@implementation CHABaseViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self.title uppercaseString];
    self.navigationItem.title = [self.navigationItem.title uppercaseString];
    [self.navigationController.navigationBar hideBottomHairline];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self baseKeyboardSubscribe];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self baseKeyboardUnsubscribe];
    [super viewWillDisappear:animated];
}

#pragma mark - NSNotification

- (void)baseKeyboardSubscribe {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)baseKeyboardUnsubscribe {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveNotification:(NSNotification *)aNotification {
    NSString *name = aNotification.name;
    BOOL willShow = [name isEqualToString:UIKeyboardWillShowNotification];
    BOOL willHide = [name isEqualToString:UIKeyboardWillHideNotification];
    if (willShow || willHide) {
        NSDictionary *userInfo = aNotification.userInfo;
        CGRect keyboardRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardHeight = willShow ? keyboardRect.size.height : 0.f;
        NSTimeInterval timeInterval = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        [self animateTermsView:keyboardHeight duration:timeInterval curve:curve];
    }
    
}

- (void)animateTermsView:(CGFloat)height duration:(NSTimeInterval)duration curve:(UIViewAnimationCurve)curve {
    
}


@end
