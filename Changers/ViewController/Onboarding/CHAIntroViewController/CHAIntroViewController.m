//
//  CHAIntroViewController.m
//  Changers
//
//  Created by Nikita Shitik on 17.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHAIntroViewController.h"

//login
#import "CHAApplicationModel.h"
#import "CHAAppDelegate.h"

//child controller
#import "CHAIntroPartViewController.h"

@interface CHAIntroViewController ()<UIPageViewControllerDataSource>

//model
@property (nonatomic, strong, readonly) NSArray *customViewControllers;

//view
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) UIPageViewController *pageViewController;

@end

@implementation CHAIntroViewController

@synthesize customViewControllers = _customViewControllers;

#pragma mark - Memory management

- (void)dealloc {
    [self unsubscribe];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self subscribe];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.hidesBackButton = YES;
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;
    [[self.pageViewController view] setFrame:CGRectMake(0, 0, [[self view] bounds].size.width, [[self view] bounds].size.height + 37.f)];
    UIViewController *initialViewController = [self.customViewControllers firstObject];
    [self.pageViewController setViewControllers:@[initialViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:self.pageViewController];
    [[self view] addSubview:[self.pageViewController view]];
    [self.pageViewController didMoveToParentViewController:self];
    [self.view bringSubviewToFront:self.pageControl];
}

#pragma mark - NSNotification

- (void)subscribe {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(allowNext)
                                                 name:kCHAIntroCanSkipNotificationName
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(forbidNext)
                                                 name:kCHAIntroCannotSkipNotificationName
                                               object:nil];
}

- (void)unsubscribe {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)allowNext {
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)forbidNext {
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self.customViewControllers indexOfObject:viewController];
    [self.pageControl setCurrentPage:index];
    index++;
    if (index == self.customViewControllers.count) {
        return nil;
    }
    return self.customViewControllers[index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self.customViewControllers indexOfObject:viewController];
    [self.pageControl setCurrentPage:index];
    if (index == 0) {
        return nil;
    }
    index--;
    return self.customViewControllers[index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return self.customViewControllers.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

#pragma mark - IBAction

- (IBAction)backButtonTouchUpInside:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)forwardButtonTouchUpInside:(id)sender {
    CHAAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    CHAApplicationModel *appModel = appDelegate.applicationModel;
    [appModel showHomeScreenOnWindow:[UIApplication sharedApplication].keyWindow animated:YES];
}

#pragma mark - Properties

- (NSArray *)customViewControllers {
    if (!_customViewControllers) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Onboarding" bundle:nil];
        CHAIntroPartViewController *controller1 = [storyboard instantiateViewControllerWithIdentifier:@"intropart"];
        CHAIntroPartViewController *controller2 = [storyboard instantiateViewControllerWithIdentifier:@"intropart"];
        CHAIntroPartViewController *controller3 = [storyboard instantiateViewControllerWithIdentifier:@"intropart"];
        CHAIntroPartViewController *controller4 = [storyboard instantiateViewControllerWithIdentifier:@"intropart"];
        [controller1 loadView];
        [controller2 loadView];
        [controller3 loadView];
        [controller4 loadView];
        
        controller1.topLabel.text = NSLocalizedString(@"Welcome to Changers", nil);
        controller1.detailImageView.image = [UIImage imageNamed:@"slide_1"];
        controller1.bottomButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        controller1.bottomButton.titleLabel.numberOfLines = 0;
        [controller1.bottomButton setTitle:NSLocalizedString(@"Do something good for yourself and the\nenvironment.", nil) forState:UIControlStateNormal];
        
        controller2.topLabel.text = NSLocalizedString(@"Environmentally friendly from A to B", nil);
        controller2.detailImageView.image = [UIImage imageNamed:@"slide_2"];
        controller2.bottomButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        controller2.bottomButton.titleLabel.numberOfLines = 0;
        [controller2.bottomButton setTitle:NSLocalizedString(@"Measure your daily trips to work, free\ntime and on vacation. Get rewarded for\nevery sustainably travelled kilometer.", nil) forState:UIControlStateNormal];
        
        controller3.topLabel.text = NSLocalizedString(@"Earn Recoins", nil);
        controller3.detailImageView.image = [UIImage imageNamed:@"slide_3"];
        controller3.bottomButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        controller3.bottomButton.titleLabel.numberOfLines = 0;
        [controller3.bottomButton setTitle:NSLocalizedString(@"Collect Recoins for CO2 compensations\nand more.", nil) forState:UIControlStateNormal];
        
        controller4.topLabel.text = NSLocalizedString(@"Click for click your life can be CO2 free", nil);
        controller4.detailImageView.image = [UIImage imageNamed:@"slide_4"];
        controller4.bottomButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        controller4.bottomButton.titleLabel.numberOfLines = 0;
        [controller4.bottomButton setTitle:NSLocalizedString(@"The first app that with one click can free\nyour life of CO2.", nil) forState:UIControlStateNormal];
        controller4.canSkip = YES;
        
        _customViewControllers = @[controller1, controller2, controller3, controller4];
    }
    return _customViewControllers;
}

@end
