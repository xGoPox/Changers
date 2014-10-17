//
//  CHASignInViewController.m
//  Changers
//
//  Created by Nikita Shitik on 05.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHASignInViewController.h"

//model
#import "CHALandingUserModel.h"

//view
#import "MBProgressHUD.h"

//login
#import "CHAAppDelegate.h"
#import "CHAApplicationModel.h"

//misc
#import "NSString+CHAEmailValidation.h"

@interface CHASignInViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UIImageView *emailImageView;
@property (nonatomic, weak) IBOutlet UIImageView *passwordImageView;

@end

@implementation CHASignInViewController

#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.userModel = [CHALandingUserModel new];
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIFont *textFont = [UIFont fontWithName:kCHAKlavikaFontName size:16.f];
    self.emailTextField.font = textFont;
    self.passwordTextField.font = textFont;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.text.length > 0) {
        if ([textField isEqual:self.emailTextField]) {
            [self.passwordTextField becomeFirstResponder];
        } else {
            [self.view endEditing:YES];
        }
    }
    
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.emailTextField]) {
        self.emailImageView.image = [UIImage imageNamed:kCHAActiveImageName];
    } else if ([textField isEqual:self.passwordTextField]) {
        self.passwordImageView.image = [UIImage imageNamed:kCHAActiveImageName];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:self.emailTextField]) {
        self.emailImageView.image = [UIImage imageNamed:kCHANonactiveImageName];
    } else if ([textField isEqual:self.passwordTextField]) {
        self.passwordImageView.image = [UIImage imageNamed:kCHANonactiveImageName];
    }
}

#pragma mark - UIStoryboard

//method for unwind segue, default does nothing but requires implementation
- (IBAction)unwindToSignIn:(UIStoryboardSegue *)sender {
    
}

#pragma mark - IBAction

- (IBAction)backButtonTouchUpInside:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)signInButtonTouchUpInside:(id)sender {
    if (self.emailTextField.text.length == 0) {
        [self.emailTextField becomeFirstResponder];
    } else if (self.passwordTextField.text.length == 0) {
        [self.passwordTextField becomeFirstResponder];
    } else if ([self.emailTextField.text cha_isEmailValid] == NO) {
        [self cha_alertWithWrongEmail];
    } else if (self.passwordTextField.text.length < 6) {
        [self cha_alertWithMessage:NSLocalizedString(@"The password length is shorter than 6 symbols.", nil)];
    } else {
        self.userModel.email = self.emailTextField.text;
        self.userModel.password = self.passwordTextField.text;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.userModel getTokenWithSuccess:^{
            [hud hide:YES];
            CHAAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            CHAApplicationModel *appModel = appDelegate.applicationModel;
            [appModel showHomeScreenOnWindow:appDelegate.window animated:YES];
        } failure:^(NSString *errorString) {
            [hud hide:YES];
            [self cha_alertWithMessage:errorString];
        }];
    }
}

@end
