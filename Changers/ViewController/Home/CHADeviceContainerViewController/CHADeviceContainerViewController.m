//
//  CHADeviceContainerViewController.m
//  Changers
//
//  Created by Nikita Shitik on 15.10.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHADeviceContainerViewController.h"

//model
#import "CHADeviceListModel.h"

//child controller
#import "CHADevicesViewController.h"

//reveal
#import "PKRevealController.h"
#import "UIViewController+PKRevealController.h"

@interface CHADeviceContainerViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, strong) NSArray *childControllers;
@property (nonatomic, strong) UIViewController *emptyViewController;
@property (nonatomic, strong) UIViewController *child;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation CHADeviceContainerViewController

#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.currentIndex = 0;
        self.childControllers = ({
            CHADevicesViewController *viewController1 = ({
                UIStoryboard *st = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
                CHADevicesViewController *viewController = (id)[st instantiateViewControllerWithIdentifier:NSStringFromClass([CHADevicesViewController class])];
                [viewController loadView];
                viewController;
            });
            CHADevicesViewController *viewController2 = ({
                UIStoryboard *st = [UIStoryboard storyboardWithName:@"Dashboard" bundle:nil];
                CHADevicesViewController *viewController = (id)[st instantiateViewControllerWithIdentifier:NSStringFromClass([CHADevicesViewController class])];
                [viewController loadView];
                viewController;
            });
            NSArray *array = @[viewController1, viewController2];
            array;
        });
        self.emptyViewController = ({
            UIViewController *viewController = [[UIViewController alloc] init];
            viewController.view.backgroundColor = RGB(235.f, 235.f, 235.f);
            UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"CHADevicePlaceholderCell" owner:self options:nil] firstObject];
            view.frame = [UIScreen mainScreen].bounds;
            [viewController.view addSubview:view];
            viewController;
        });
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [[CHADeviceListModel sharedDeviceListModel] loadDevicesWithSuccess:^{
        [self setup];
    } failure:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.revealController.revealPanGestureRecognizer setEnabled:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.revealController.revealPanGestureRecognizer setEnabled:YES];
}

#pragma mark - Private

- (void)setup {
    [self setupViewControllers];
    
    UISwipeGestureRecognizer *rightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moveLeft)];
    [rightGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:rightGestureRecognizer];
    rightGestureRecognizer.delegate = self;
    
    UISwipeGestureRecognizer *leftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moveRight)];
    [leftGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:leftGestureRecognizer];
    leftGestureRecognizer.delegate = self;
}

- (void)setupViewControllers {
    UIViewController *viewController = nil;
    if ([CHADeviceListModel sharedDeviceListModel].devices.count > 0) {
        viewController = [self.childControllers firstObject];
        CHADeviceListModel *model = [CHADeviceListModel sharedDeviceListModel];
        [(CHADevicesViewController *)viewController configureWithDevice:model.devices[self.currentIndex]
                                                                  count:model.devices.count
                                                                  index:self.currentIndex];
        [(CHADevicesViewController *)viewController setContainer:self];
    } else {
        viewController = self.emptyViewController;
    }
    [self addChildViewController:viewController];
    viewController.view.frame = [UIScreen mainScreen].bounds;
    [self.containerView addSubview:viewController.view];
    self.child = viewController;
    
}

- (void)moveLeft {
    if ([self.child isKindOfClass:[CHADevicesViewController class]]) {
        if (self.currentIndex > 0) {
            self.currentIndex--;
        } else {
            self.currentIndex = [CHADeviceListModel sharedDeviceListModel].devices.count - 1;
        }
        
        [self moveWithStartFrame:CGRectMake(-[UIScreen cha_width], 0, [UIScreen cha_width], [UIScreen cha_height])
                        endFrame:CGRectMake([UIScreen cha_width], 0, [UIScreen cha_width], [UIScreen cha_height])];
    }
}

- (void)moveRight {
    if ([self.child isKindOfClass:[CHADevicesViewController class]]) {
        if (self.currentIndex < [CHADeviceListModel sharedDeviceListModel].devices.count - 1) {
            self.currentIndex++;
        } else {
            self.currentIndex = 0;
        }
        
        [self moveWithStartFrame:CGRectMake([UIScreen cha_width], 0, [UIScreen cha_width], [UIScreen cha_height])
                        endFrame:CGRectMake(-[UIScreen cha_width], 0, [UIScreen cha_width], [UIScreen cha_height])];
    }
}

- (void)moveWithStartFrame:(CGRect)startFrame endFrame:(CGRect)endFrame {
    UIViewController *viewController = [self nextViewController];
    
    if ([viewController isKindOfClass:[CHADevicesViewController class]]) {
        [(CHADevicesViewController *)viewController setContainer:self];
        
        CHADeviceListModel *model = [CHADeviceListModel sharedDeviceListModel];
        [(CHADevicesViewController *)viewController configureWithDevice:model.devices[self.currentIndex]
                                                                  count:model.devices.count
                                                                  index:self.currentIndex];
    }
   
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

- (UIViewController *)nextViewController {
    if ([CHADeviceListModel sharedDeviceListModel].devices.count > 0) {
        if ([self.childControllers indexOfObject:self.child] == 0) {
            return [self.childControllers lastObject];
        } else if ([self.childControllers indexOfObject:self.child] == 1) {
            return [self.childControllers firstObject];
        } else {
            return nil;
        }
    } else {
        return self.emptyViewController;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
