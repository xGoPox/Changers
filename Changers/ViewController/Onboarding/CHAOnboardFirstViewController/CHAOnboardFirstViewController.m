//
//  CHAOnboardFirstViewController.m
//  Changers
//
//  Created by Nikita Shitik on 17.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHAOnboardFirstViewController.h"

//model
#import "CHALandingUserModel.h"

//destination controller
#import "CHAFirstLaunchViewController.h"
#import "CHASignInViewController.h"

//FB
#import <FacebookSDK/FacebookSDK.h>

//misc
#import "NSString+CHAEmailValidation.h"
#import "CHAApplicationModel.h"
#import "CHAAppDelegate.h"
#import "MBProgressHUD.h"

static NSString *const kCHASegueNameAnimatedRegister = @"animatedRegister";
static NSString *const kCHASegueNameNonAnimatedRegister = @"nonanimatedRegister";
static NSString *const kCHASegueNameSignIn = @"signInSegue";

@interface CHAOnboardFirstViewController ()<FBLoginViewDelegate>

//view
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;

//model
@property (nonatomic, strong) CHALandingUserModel *userModel;

@property (nonatomic, strong) FBLoginView *loginView;
@property (nonatomic, strong) UIButton *fbButton;
@property (nonatomic, strong) id fbObject;

@end

@implementation CHAOnboardFirstViewController

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
    [self setupNavigationItems];
    [self setupBackground];
    [self setupFacebookControls];
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

- (void)setupNavigationItems {
    UIButton *registerButton = [[[NSBundle mainBundle] loadNibNamed:@"CHAUpperButton" owner:self options:nil] firstObject];
    [registerButton addTarget:self
                       action:@selector(registerButtonTouchUpInside)
             forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:registerButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

- (void)registerButtonTouchUpInside {
    [self dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark - IBAction

- (IBAction)facebookButtonTouchUpInside:(id)sender {
    [self.fbButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - UIStoryboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kCHASegueNameAnimatedRegister] ||
        [segue.identifier isEqualToString:kCHASegueNameNonAnimatedRegister]) {
        UINavigationController *navigationController = segue.destinationViewController;
        CHAFirstLaunchViewController *destinationController = [navigationController.viewControllers firstObject];
        destinationController.userModel = self.userModel;
    } else if ([segue.identifier isEqualToString:kCHASegueNameSignIn]) {
        UINavigationController *navigationController = segue.destinationViewController;
        CHASignInViewController *destinationController = [navigationController.viewControllers firstObject];
        destinationController.userModel = self.userModel;
    }
}

@end
