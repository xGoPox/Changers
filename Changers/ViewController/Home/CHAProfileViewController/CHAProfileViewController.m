//
//  CHAProfileViewController.m
//  Changers
//
//  Created by Nikita Shitik on 14.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHAProfileViewController.h"

//view
#import "CHAGenderView.h"

//model
#import "CHASettingsUserModel.h"
#import "CHASettingsUserModel+CHAProfileViewController.h"

//destination controllers
#import "CHADateViewController.h"
#import "CHACountryViewController.h"

//misc
#import "NSString+CHAEmailValidation.h"

@interface CHAProfileViewController ()<
    UITextFieldDelegate,
    CHACountryPickerDelegate,
    CHADateViewControllerDelegate,
    CHAGenderViewDelegate
>

//view
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (nonatomic, strong) IBOutletCollection(UITextField) NSArray *textFields;
@property (nonatomic, strong) IBOutletCollection(UIImageView) NSArray *highlightImages;
@property (nonatomic, weak) IBOutlet UIButton *countryButton;
@property (nonatomic, weak) IBOutlet UIButton *birthdayButton;
@property (nonatomic, weak) IBOutlet UITextField *firstNameTextField;
@property (nonatomic, weak) IBOutlet UITextField *secondNameTextField;
@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITextField *cityTextField;
@property (nonatomic, weak) IBOutlet UIView *genderContainer;
@property (nonatomic, strong) CHAGenderView *genderView;
@property (nonatomic, weak) IBOutlet UITextField *oldPasswordTextField;
@property (nonatomic, weak) IBOutlet UITextField *updatePasswordTextField;
@property (nonatomic, weak) IBOutlet UITextField *confirmPasswordTextField;

@end

@implementation CHAProfileViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[CHASettingsUserModel sharedModel] loadDataWithSuccess:^{
        [self updateUI];
    } failure:nil];
    
    
    UIFont *textFieldFont = [UIFont fontWithName:kCHAKlavikaFontName size:16.f];
    [self.textFields makeObjectsPerformSelector:@selector(setFont:) withObject:textFieldFont];
    
    CHAGenderView *genderView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CHAGenderView class])
                                                               owner:self
                                                             options:nil] firstObject];
    genderView.frame = self.genderContainer.bounds;
    genderView.delegate = self;
    [self.genderContainer addSubview:genderView];
    self.genderView = genderView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
}

#pragma mark - Private

- (void)updateUI {
    CHASettingsUserModel *model = [CHASettingsUserModel sharedModel];
    self.firstNameTextField.text = model.firstName;
    self.secondNameTextField.text = model.secondName;
    self.emailTextField.text = model.email;
    NSAttributedString *country = [model countryAttributedString];
    [self.countryButton setAttributedTitle:country forState:UIControlStateNormal];
    [self.countryButton setAttributedTitle:country forState:UIControlStateHighlighted];
    [self.countryButton setAttributedTitle:country forState:UIControlStateHighlighted|UIControlStateNormal];
    self.cityTextField.text = model.city;
    NSAttributedString *text = [model birthdayAttributedString];
    [self.birthdayButton setAttributedTitle:text forState:UIControlStateNormal];
    [self.birthdayButton setAttributedTitle:text forState:UIControlStateHighlighted];
    [self.birthdayButton setAttributedTitle:text forState:UIControlStateHighlighted|UIControlStateNormal];
    [self.genderView setGender:model.gender];
}

- (void)updateModelFromTextFields {
    CHASettingsUserModel *model = [CHASettingsUserModel sharedModel];
    model.firstName = self.firstNameTextField.text;
    model.secondName = self.secondNameTextField.text;
    model.email = self.emailTextField.text;
    model.city = self.cityTextField.text;
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

#pragma mark - CHACountryPickerDelegate

- (void)countryPicker:(CHACountryViewController *)countryPicker didFinishPickingWithCountry:(NSString *)country countryCode:(NSString *)countryCode {
    [CHASettingsUserModel sharedModel].country = countryCode;
    [CHASettingsUserModel sharedModel].countryCode = countryCode;
    [self updateUI];
}

#pragma mark - CHADateViewControllerDelegate

- (void)dateViewController:(CHADateViewController *)dateViewController didPickDate:(NSDate *)date {
    [CHASettingsUserModel sharedModel].birthday = date;
    [self updateUI];
}

#pragma mark - CHAGenderViewDelegate

- (void)genderView:(CHAGenderView *)genderView didSelectGender:(CHAGender)gender {
    [CHASettingsUserModel sharedModel].gender = gender;
    [self updateUI];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSInteger index = [self.textFields indexOfObject:textField];
    if (index >= 0 && index < self.highlightImages.count) {
        UIImageView *imageView = self.highlightImages[index];
        imageView.image = [UIImage imageNamed:kCHAActiveImageName];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSInteger index = [self.textFields indexOfObject:textField];
    if (index >= 0 && index < self.highlightImages.count) {
        UIImageView *imageView = self.highlightImages[index];
        imageView.image = [UIImage imageNamed:kCHANonactiveImageName];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (![textField isEqual:self.emailTextField] || [self.emailTextField.text cha_isEmailValid]) {
        [self updateModelFromTextFields];
        [self updateUI];
        [self.view endEditing:YES];
        if ([textField isEqual:self.confirmPasswordTextField]) {
            [self changePasswordTouchUpInside:textField];
        }
    } else {
        [self cha_alertWithWrongEmail];
    }
    return NO;
}

#pragma mark - IBAction

- (IBAction)changePasswordTouchUpInside:(id)sender {
    if (self.oldPasswordTextField.text.length == 0) {
        [self cha_alertWithMessage:NSLocalizedString(@"Please, enter your current password.", nil)];
    } else if (self.updatePasswordTextField.text.length == 0) {
        [self cha_alertWithMessage:NSLocalizedString(@"Please, enter your new password", nil)];
    } else if (self.confirmPasswordTextField.text.length == 0) {
        [self cha_alertWithMessage:NSLocalizedString(@"Please, confirm your new password", nil)];
    } else if ([self.confirmPasswordTextField.text isEqualToString:self.updatePasswordTextField.text] == NO) {
        [self cha_alertWithMessage:NSLocalizedString(@"Entered confirmation doesn't match your new password", nil)];
    } else if (([self.updatePasswordTextField.text length] < 6) || ([self.confirmPasswordTextField.text length] < 6)) {
        [self cha_alertWithMessage:NSLocalizedString(@"Your password can't be shorter than 6 symbols.", nil)];
    } else {
        [[CHASettingsUserModel sharedModel] changeOldPassword:self.oldPasswordTextField.text
                                               updatePassword:self.updatePasswordTextField.text
                                                      success:^{
                                                          [self cha_alertWithMessage:@"Password successfully updated"];
                                                      } failure:^(NSString *errorString) {
                                                          [self cha_alertWithMessage:errorString];
                                                      }];
    }
}

#pragma mark - UIStoryboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"date"]) {
        [self.view endEditing:YES];
        CHADateViewController *viewController = segue.destinationViewController;
        viewController.delegate = self;
        viewController.startDate = [CHASettingsUserModel sharedModel].birthday;
    } else if ([segue.identifier isEqualToString:@"country"]) {
        [self.view endEditing:YES];
        CHACountryViewController *viewController = segue.destinationViewController;
        viewController.delegate = self;
        viewController.country = [CHASettingsUserModel sharedModel].countryCode;
    }
}

@end
