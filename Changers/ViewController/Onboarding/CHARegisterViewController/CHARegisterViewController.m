//
//  CHARegisterViewController.m
//  Changers
//
//  Created by Nikita Shitik on 17.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHARegisterViewController.h"

//model
#import "CHALandingUserModel.h"

//view
#import "MBProgressHUD.h"

//destination controller
#import "CHASignInViewController.h"

//misc
#import "NSString+CHAEmailValidation.h"

@interface CHARegisterViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *firstNameTextField;
@property (nonatomic, weak) IBOutlet UITextField *secondNameTextField;
@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (nonatomic, weak) IBOutlet UIImageView *firstNameImageView;
@property (nonatomic, weak) IBOutlet UIImageView *secondNameImageView;
@property (nonatomic, weak) IBOutlet UIImageView *emailImageView;
@property (nonatomic, weak) IBOutlet UIImageView *passwordImageView;

@end

@implementation CHARegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIFont *font = [UIFont fontWithName:kCHAKlavikaFontName size:16.f];
    self.emailTextField.font = font;
    self.passwordTextField.font = font;
    self.firstNameTextField.font = font;
    self.secondNameTextField.font = font;
}

#pragma mark - CHABaseKeyboardViewController

- (void)animateTermsView:(CGFloat)height duration:(NSTimeInterval)duration curve:(UIViewAnimationCurve)curve {
    self.bottomConstraint.constant = height;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:duration
                          delay:.0
                        options:(curve << 16)
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:nil];
}

#pragma mark - Private

- (void)fillModel {
    self.userModel.displayName = [NSString stringWithFormat:@"%@ %@", self.firstNameTextField.text,
                                  self.secondNameTextField.text];
    self.userModel.firstName = self.firstNameTextField.text;
    self.userModel.secondName = self.secondNameTextField.text;
    self.userModel.userName = [NSString stringWithFormat:@"%@%@", self.firstNameTextField.text,
                               self.secondNameTextField.text];
    self.userModel.email = self.emailTextField.text;
    self.userModel.password = self.passwordTextField.text;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.firstNameTextField]) {
        self.firstNameImageView.image = [UIImage imageNamed:kCHAActiveImageName];
    } else if ([textField isEqual:self.secondNameTextField]) {
        self.secondNameImageView.image = [UIImage imageNamed:kCHAActiveImageName];
    } else if ([textField isEqual:self.emailTextField]) {
        self.emailImageView.image = [UIImage imageNamed:kCHAActiveImageName];
    } else {
        self.passwordImageView.image = [UIImage imageNamed:kCHAActiveImageName];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:self.firstNameTextField]) {
        self.firstNameImageView.image = [UIImage imageNamed:kCHANonactiveImageName];
    } else if ([textField isEqual:self.secondNameTextField]) {
        self.secondNameImageView.image = [UIImage imageNamed:kCHANonactiveImageName];
    } else if ([textField isEqual:self.emailTextField]) {
        self.emailImageView.image = [UIImage imageNamed:kCHANonactiveImageName];
    } else {
        self.passwordImageView.image = [UIImage imageNamed:kCHANonactiveImageName];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.firstNameTextField]) {
        [self.secondNameTextField becomeFirstResponder];
    } else if ([textField isEqual:self.secondNameTextField]) {
        [self.emailTextField becomeFirstResponder];
    } else if ([textField isEqual:self.emailTextField]) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        [self.view endEditing:YES];
    }
    return NO;
}

#pragma mark - IBAction

- (IBAction)doneButtonTouchUpInside:(id)sender {
    if (self.firstNameTextField.text.length == 0) {
        [self.firstNameTextField becomeFirstResponder];
    } else if (self.secondNameTextField.text.length == 0) {
        [self.secondNameTextField becomeFirstResponder];
    } else if (self.emailTextField.text.length == 0) {
        [self.emailTextField becomeFirstResponder];
    } else if ([self.emailTextField.text cha_isEmailValid] == NO) {
        [self cha_alertWithWrongEmail];
    } else if (self.passwordTextField.text.length == 0) {
        [self.passwordTextField becomeFirstResponder];
    } else if (self.passwordTextField.text.length < 6) {
        NSString *message = NSLocalizedString(@"The password must be a minimum of 6 characters long.", nil);
        [self cha_alertWithMessage:message];

    } else {
        [self fillModel];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.userModel registerWithSuccess:^(BOOL success) {
            if (success) {
                [self.userModel getTokenWithSuccess:^{
                    [hud hide:YES];
                    [self performSegueWithIdentifier:@"introSegue" sender:nil];
                } failure:^(NSString *errorString) {
                    [hud hide:YES];
                    [self cha_alertWithMessage:errorString];
                }];
                
            }
        } failure:^(NSString *errorString) {
            [hud hide:YES];
            [self cha_alertWithMessage:errorString];
        }];

    }
}

- (IBAction)backButtonTouchUpInside:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIStoryboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"signInSegue"]) {
        UINavigationController *destinationController = [segue destinationViewController];
        CHASignInViewController *viewController = [destinationController.viewControllers firstObject];
        viewController.userModel = self.userModel;
    }
}

@end
