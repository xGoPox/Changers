//
//  CHATermsPreviewViewController.h
//  Changers
//
//  Created by Nikita Shitik on 05.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHALandingUserModel;

@protocol CHATermsPreviewDelegate;

@interface CHATermsPreviewViewController : UIViewController

@property (nonatomic, weak) id<CHATermsPreviewDelegate> delegate;
@property (nonatomic, strong) CHALandingUserModel *userModel;

@end

@protocol CHATermsPreviewDelegate <NSObject>

@optional
- (void)termsPreviewControllerDidPressTermsButton:(CHATermsPreviewViewController *)termsPreviewController;
- (void)termsPreviewController:(CHATermsPreviewViewController *)termsPreviewController acceptedTerms:(BOOL)accepted;

@end
