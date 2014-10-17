//
//  UIViewController+CHAAlert.m
//  Changers
//
//  Created by Nikita Shitik on 23.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "UIViewController+CHAAlert.h"

@implementation UIViewController (CHAAlert)

- (void)cha_alertWithMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:kCHAMessageOK
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)cha_alertWithWrongEmail {
    [self cha_alertWithMessage:NSLocalizedString(@"You have provided an email which seems to be incorrect.", nil)];
}

@end
