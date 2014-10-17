//
//  CHACompensationApprovalViewController.h
//  Changers
//
//  Created by Clemt Yerochewski on 14/10/14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>


@class CHACompensation;

@interface CHACompensationApprovalViewController : UIViewController

@property (strong, nonatomic) CHACompensation *compensation;
@property (strong, nonatomic) SKProduct *productIAP;

@end
