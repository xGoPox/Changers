//
//  CHADashboardContainerViewController.m
//  Changers
//
//  Created by Nikita Shitik on 01.10.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHADashboardContainerViewController.h"

//children
#import "CHADashboardViewController.h"
#import "CHAEnergyStatsViewController.h"

#import "UIViewController+PKRevealController.h"
#import "PKRevealController.h"

@interface CHADashboardContainerViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, strong) UIViewController *child;
@property (nonatomic, strong) NSArray *viewControllers;

@end

@implementation CHADashboardContainerViewController

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self reloadControllers];
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.containerView = self.view;
    
    if (self.showEnergyScreenOnFirstLaunch) {
        [self showEnergy];
    } else {
        [self showDashboard];
    }
    
    UISwipeGestureRecognizer *rightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moveLeft)];
    [rightGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:rightGestureRecognizer];
    rightGestureRecognizer.delegate = self;
    
    UISwipeGestureRecognizer *leftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moveRight)];
    [leftGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:leftGestureRecognizer];
    leftGestureRecognizer.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadControllers];
    
    if ([self.child isKindOfClass:[CHADashboardViewController class]]) {
        [self showDashboard];
    } else {
        [self showEnergy];
    }
    
    self.revealController.revealPanGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.revealController.revealPanGestureRecognizer.enabled = YES;
}

#pragma mark - Public

- (void)showEnergy {
    [self.containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.child removeFromParentViewController];
    [self.child didMoveToParentViewController:nil];
    UIViewController *dashboard = [self.viewControllers lastObject];
    [self setupWithViewController:dashboard];
    [self addChildViewController:dashboard];
    dashboard.view.frame = [UIScreen mainScreen].bounds;
    [self.containerView addSubview:dashboard.view];
    [dashboard didMoveToParentViewController:self];
    self.child = dashboard;
}

- (void)showDashboard {
    [self.containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.child removeFromParentViewController];
    [self.child didMoveToParentViewController:nil];
    UIViewController *dashboard = [self.viewControllers firstObject];
    [self setupWithViewController:dashboard];
    [self addChildViewController:dashboard];
    dashboard.view.frame = [UIScreen mainScreen].bounds;
    [self.containerView addSubview:dashboard.view];
    [dashboard didMoveToParentViewController:self];
    self.child = dashboard;
}

- (void)moveLeft {
    [self moveWithStartFrame:CGRectMake(-[UIScreen cha_width], 0, [UIScreen cha_width], [UIScreen cha_height])
                    endFrame:CGRectMake([UIScreen cha_width], 0, [UIScreen cha_width], [UIScreen cha_height])];
}

- (void)moveRight {
    [self moveWithStartFrame:CGRectMake([UIScreen cha_width], 0, [UIScreen cha_width], [UIScreen cha_height])
                    endFrame:CGRectMake(-[UIScreen cha_width], 0, [UIScreen cha_width], [UIScreen cha_height])];
}

#pragma mark - Private

- (void)reloadControllers {
    UIViewController *viewController1 = ({
        NSString *identifier = @"dashboard";
        UIStoryboard *st = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
        UIViewController *dashboard = [(UINavigationController *)[st instantiateViewControllerWithIdentifier:identifier] viewControllers][0];
        dashboard;
    });
    UIViewController *viewController2 = ({
        NSString *identifier = @"energy";
        UIStoryboard *st = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
        UIViewController *energy = [(UINavigationController *)[st instantiateViewControllerWithIdentifier:identifier] viewControllers][0];
        energy;
    });
    self.viewControllers = @[viewController1, viewController2];
}

- (void)moveWithStartFrame:(CGRect)startFrame endFrame:(CGRect)endFrame {
    UIViewController *viewController = [self nextViewController];
    [self setupWithViewController:viewController];
    [self addChildViewController:viewController];
    viewController.view.frame = startFrame;
    [self.containerView addSubview:viewController.view];
    [self.child willMoveToParentViewController:nil];
    [UIView animateWithDuration:.25 animations:^{
        CGRect endRectNew = CGRectMake(0, 0, [UIScreen cha_width], [UIScreen cha_height]);
        CGRect endRectOld = endFrame;
        self.child.view.frame = endRectOld;
        viewController.view.frame = endRectNew;
    } completion:^(BOOL finished) {
        [self.child removeFromParentViewController];
        [viewController didMoveToParentViewController:self];
        self.child = viewController;
    }];
}

- (void)setupWithViewController:(UIViewController *)viewController {
    self.navigationItem.title = [viewController.navigationItem.title uppercaseString];
    self.navigationController.navigationBar.barTintColor = [viewController isKindOfClass:[CHADashboardViewController class]] ?
                                                            BAR_TINT_COLOR : RGB(252, 217, 35);
    self.navigationItem.leftBarButtonItems = viewController.navigationItem.leftBarButtonItems;
    self.navigationItem.rightBarButtonItems = viewController.navigationItem.rightBarButtonItems;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (UIViewController *)nextViewController {
    UIViewController *currentViewController = self.child;
    if ([currentViewController isKindOfClass:[CHADashboardViewController class]]) {
        return [self.viewControllers lastObject];
    } else {
        return [self.viewControllers firstObject];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
