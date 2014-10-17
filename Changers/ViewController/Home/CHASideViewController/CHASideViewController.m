//
//  CHASideViewController.m
//  Changers
//
//  Created by Nikita Shitik on 13.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHASideViewController.h"

//reveal
#import "PKRevealController.h"
#import "UIViewController+PKRevealController.h"
#import "CHASideSegue.h"

//destination controller
#import "CHAHomeViewController.h"
#import "CHADashboardContainerViewController.h"

//logout
#import "CHALogout.h"
#import "CHAAppDelegate.h"

//misc
#import <MessageUI/MFMailComposeViewController.h>

typedef NS_ENUM(NSUInteger, CHASideType) {
    CHASideTypeHome,
    CHASideTypeDashboard,
    CHASideTypeSettings,
    CHASideTypeInfo
};

@interface CHASideViewController ()<UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

//model
@property (nonatomic, strong) NSMutableArray *viewControllers;

//view
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *screenButtons;
@property (nonatomic, strong) IBOutletCollection(UIImageView) NSArray *screenCheckmarks;

@end

@implementation CHASideViewController

#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _viewControllers = [NSMutableArray array];
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSegueWithIdentifier:@"homeSegue" sender:nil];
    [self performSegueWithIdentifier:@"dashboardSegue" sender:nil];
    [self performSegueWithIdentifier:@"settingsSegue" sender:nil];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"aboutID"];
    [self addViewController:vc];
    self.revealController.frontViewController = self.viewControllers[CHASideTypeHome];
    
    UIButton *button = [self.screenButtons firstObject];
    [button setSelected:YES];
    UIImageView *imageView = [self.screenCheckmarks firstObject];
    imageView.image = [UIImage imageNamed:@"active_item"];
}

#pragma mark - Public

- (void)addViewController:(UIViewController *)viewController {
    viewController.revealController = self.revealController;
    [self.viewControllers addObject:viewController];
}

- (void)showDashboard {
    UIButton *button = self.screenButtons[CHASideTypeDashboard];
    [self screenButtonTouchUpInside:button];
    CHADashboardContainerViewController *viewController = [[(UINavigationController *)self.viewControllers[CHASideTypeDashboard] viewControllers] firstObject];
    [viewController showDashboard];
    self.revealController.frontViewController = self.viewControllers[CHASideTypeDashboard];
    [self.revealController showViewController:self.revealController.frontViewController];
}

- (void)showEnergyStats {
    UIButton *button = self.screenButtons[CHASideTypeDashboard];
    [self screenButtonTouchUpInside:button];
    CHADashboardContainerViewController *viewController = [[(UINavigationController *)self.viewControllers[CHASideTypeDashboard] viewControllers] firstObject];
    [viewController showEnergy];
    viewController.showEnergyScreenOnFirstLaunch = YES;
    self.revealController.frontViewController = self.viewControllers[CHASideTypeDashboard];
    [self.revealController showViewController:self.revealController.frontViewController];
}

#pragma mark - IBAction

- (IBAction)screenButtonTouchUpInside:(UIButton *)sender {
    for (UIButton *button in self.screenButtons) {
        button.selected = NO;
    }
    [self.screenCheckmarks makeObjectsPerformSelector:@selector(setImage:) withObject:nil];
    sender.selected = YES;
    NSInteger index = [self.screenButtons indexOfObject:sender];
    if ((index >= 0) && (index < self.screenCheckmarks.count)) {
        UIImageView *imageView = self.screenCheckmarks[index];
        imageView.image = [UIImage imageNamed:@"active_item"];
    }
}

- (IBAction)mailButtonTouchUpInside:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        [mailController setSubject:NSLocalizedString(@"HELLO CHANGERS", nil)];
        [mailController setToRecipients:@[@"support@changers.com"]];
        mailController.mailComposeDelegate = self;
        mailController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:.3f green:.3f blue:1.f alpha:1.f]};
        [self presentViewController:mailController animated:YES completion:nil];
    } else {
        [self cha_alertWithMessage:NSLocalizedString(@"Your device doesn't support e-mail", nil)];
    }
}

- (IBAction)frontTouchUpInside:(UIButton *)sender {
    self.revealController.frontViewController = self.viewControllers[sender.tag];
    [self.revealController showViewController:self.revealController.frontViewController];
}

- (IBAction)logoutButtonTouchUpInside:(id)sender {
    NSString *title = NSLocalizedString(@"Are you sure?", nil);
    NSString *cancel = NSLocalizedString(@"Cancel", nil);
    NSString *logout = NSLocalizedString(@"Logout", nil);
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:cancel destructiveButtonTitle:logout otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:^{
        if (error) {
            [self cha_alertWithMessage:error.localizedFailureReason];
        }
    }];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:NO];
        CHAAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [CHALogout logoutFromWindow:appDelegate.window];
    }
}

#pragma mark - UIStoryboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue isKindOfClass:[CHASideSegue class]]) {
        UINavigationController *navigationController = segue.destinationViewController;
        navigationController.revealController = self.revealController;
        UIViewController *destinationController = [navigationController.viewControllers firstObject];
        destinationController.revealController = self.revealController;
    }
    if ([segue.identifier isEqualToString:@"homeSegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        CHAHomeViewController *homeViewController = [navigationController.viewControllers firstObject];
        homeViewController.tracker = self.tracker;
    } else if ([segue.identifier isEqualToString:@"dashboardSegue"]) {
        UINavigationController *navController = segue.destinationViewController;
        navController.revealController = self.revealController;
    } else if ([segue.identifier isEqualToString:@"settingsSegue"]) {
        UINavigationController *navController = segue.destinationViewController;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"CHASettingViewController"];
        navController.viewControllers = @[viewController];
    }
}

@end
