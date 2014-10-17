//
//  CHAFirstLaunchViewController.m
//  Changers
//
//  Created by Nikita Shitik on 17.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHAFirstLaunchViewController.h"

//destination controller
#import "CHARegisterViewController.h"

//model
#import "CHALandingUserModel.h"

//FB
#import <FacebookSDK/FacebookSDK.h>

//misc
#import "NSString+CHAEmailValidation.h"
#import "CHAApplicationModel.h"
#import "CHAAppDelegate.h"
#import "MBProgressHUD.h"

@interface CHAFirstLaunchViewController ()<FBLoginViewDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, weak) IBOutlet UILabel *termsLabel;
@property (nonatomic, weak) IBOutlet UILabel *signInLabel;

@property (nonatomic, strong) FBLoginView *loginView;
@property (nonatomic, strong) UIButton *fbButton;
@property (nonatomic, strong) id fbObject;

@end

@implementation CHAFirstLaunchViewController

#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.userModel = [CHALandingUserModel new];
        FBLoginView *loginView = [[FBLoginView alloc] init];
        loginView.delegate = self;
        loginView.readPermissions = @[@"email"];
        self.loginView = loginView;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackground];
    [self setupFacebookControls];
    self.navigationController.navigationBarHidden = YES;
    self.termsLabel.attributedText = [self termsText];
    self.signInLabel.attributedText = [self signInText];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.fbObject = nil;
}

#pragma mark - Private

- (void)setupFacebookControls {
    for (UIView *view in self.loginView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            self.fbButton = (id)view;
        }
    }
}

- (void)setupBackground {
    if ([UIScreen cha_isPhone4]) {
        self.backgroundImageView.image = [UIImage imageNamed:@"2_bg"];
    }
}

- (NSAttributedString *)termsText {
    NSString *text = NSLocalizedString(@"BY SIGNING UP, I AGREE TO CHANGERS’ TERMS OF SERVICE AND PRIVACY POLICY.", nil);
    NSString *boldText1 = NSLocalizedString(@"TERMS OF SERVICE", nil);
    NSString *boldText2 = NSLocalizedString(@"PRIVACY POLICY", nil);
    NSRange range1 = [text rangeOfString:boldText1];
    NSRange range2 = [text rangeOfString:boldText2];
    NSRange fullRange = NSMakeRange(0, text.length);
    UIFont *regularFont = [UIFont fontWithName:kCHAKlavikaFontName size:12.f];
    UIFont *boldFont = [UIFont fontWithName:kCHAKlavikaMediumFontName size:12.f];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSFontAttributeName value:regularFont range:fullRange];
    [attributedString addAttribute:NSFontAttributeName value:boldFont range:range1];
    [attributedString addAttribute:NSFontAttributeName value:boldFont range:range2];
    return attributedString;
}

- (NSAttributedString *)signInText {
    NSString *text = NSLocalizedString(@"ALREADY A CHANGERS USER? SIGN IN", nil);
    NSString *boldText = NSLocalizedString(@"SIGN IN", nil);
    NSRange range = [text rangeOfString:boldText];
    NSRange fullRange = NSMakeRange(0, text.length);
    UIFont *regularFont = [UIFont fontWithName:kCHAKlavikaFontName size:12.f];
    UIFont *boldFont = [UIFont fontWithName:kCHAKlavikaMediumFontName size:12.f];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSFontAttributeName value:regularFont range:fullRange];
    [attributedString addAttribute:NSFontAttributeName value:boldFont range:range];
    return attributedString;
}

#pragma mark - FBLoginViewDelegate

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    if ([user isEqual:self.fbObject] == NO) {
        self.fbObject = user;
        self.userModel.displayName = [user name];
        self.userModel.firstName = [user first_name];
        self.userModel.secondName = [user last_name];
        self.userModel.userName = [user id];
        self.userModel.email = user[@"email"];
        NSString *rawPassword = [NSString stringWithFormat:@"%@=%@", kCHAAPIKey, [user id]];
        self.userModel.password = [rawPassword cha_md5];
        self.userModel.facebookAccount = YES;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.userModel getTokenWithSuccess:^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self markAccountAsFacebook];
            [self enterApp];
        } failure:^(NSString *errorString) {
            [self.userModel registerWithSuccess:^(BOOL success) {
                [self.userModel getTokenWithSuccess:^{
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [self markAccountAsFacebook];
                    [self performSegueWithIdentifier:@"toIntro" sender:nil];
                } failure:^(NSString *errorString) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    [self cha_alertWithMessage:NSLocalizedString(@"A networking error has occured.", nil)];
                }];
            } failure:^(NSString *errorString) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [self cha_alertWithMessage:NSLocalizedString(@"A networking error has occured.", nil)];
            }];
        }];
    }
}

- (void)markAccountAsFacebook {
    [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:kCHAFacebookDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)enterApp {
    CHAAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.applicationModel showHomeScreenOnWindow:appDelegate.window animated:YES];
}

#pragma mark - UIStoryboard 

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"registerSegue"]) {
        UINavigationController *navController = segue.destinationViewController;
        CHARegisterViewController *destinationController = [navController.viewControllers firstObject];
        destinationController.userModel = self.userModel;
    }
}

#pragma mark - IBAction

- (IBAction)facebookButtonTouchUpInside:(id)sender {
    [self.fbButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

//method for unwind segue, default does nothing but requires implementation
- (IBAction)unwindToFirstLaunch:(UIStoryboardSegue *)sender {
    
}

@end
