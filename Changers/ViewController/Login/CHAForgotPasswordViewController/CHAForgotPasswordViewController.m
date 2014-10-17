//
//  CHAForgotPasswordViewController.m
//  Changers
//
//  Created by Nikita Shitik on 05.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHAForgotPasswordViewController.h"

//network
#import "CHALoginAPIClient.h"

//view
#import "MBProgressHud.h"

//misc
#import "NSString+CHAEmailValidation.h"

@interface CHAForgotPasswordViewController ()<UITextFieldDelegate>

//model
@property (nonatomic, strong) CHALoginAPIClient *client;

//view
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UIImageView *passwordImageView;

@end

@implementation CHAForgotPasswordViewController

#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.client = [CHALoginAPIClient loginAPIClient];
    }
    return self;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.textField]) {
        self.passwordImageView.image = [UIImage imageNamed:kCHAActiveImageName];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:self.textField]) {
        self.passwordImageView.image = [UIImage imageNamed:kCHANonactiveImageName];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return NO;
}

#pragma mark - Private

- (void)requestUpdate {
    __weak typeof(self) weakSelf = self;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    CHASuccessBlock successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        if (![responseObject objectForKey:@"error"]) {
            [self performSegueWithIdentifier:@"done" sender:nil];
        } else {
            NSString *errorString = NSLocalizedString(@"Email is not valid", nil);
            NSString *message = responseObject[@"error"];
            if ([message rangeOfString:@"24 hours"].location != NSNotFound) {
                errorString = NSLocalizedString(@"You've already requested password for this account within 24 hours.", nil);
            }
            [self cha_alertWithMessage:errorString];
        }
    };
    
    CHAFailureBlock failureBlock = ^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        [self cha_alertWithMessage:NSLocalizedString(kCHAMessageNetworkError, nil)];
    };
    
    [weakSelf.client forgotPasswordForUsername:self.textField.text success:successBlock failure:failureBlock];
}

#pragma mark - IBAction

- (IBAction)forgotButtonTouchUpInside:(id)sender {
    if ([self.textField.text cha_isEmailValid]) {
        [self requestUpdate];
    } else {
        [self cha_alertWithWrongEmail];
    }
}

@end
