//
//  CHADashboardViewController.m
//  Changers
//
//  Created by Nikita Shitik on 13.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHADashboardViewController.h"

//parent view controller
#import "CHADashboardContainerViewController.h"

//model
#import "CHADashboardModel.h"

//reveal
#import "PKRevealController.h"
#import "UIViewController+PKRevealController.h"

//view
#import <QuartzCore/QuartzCore.h>
#import "CHACommunityView.h"

typedef CGFloat CHAFootprint;
static CHAFootprint const kMinFootprint = -10.f;
static CHAFootprint const kMaxFootprint = 10.f;
static CHAFootprint const kFootprintInRad = 10.f;

static CGFloat const kCHARadius = 83.f;
static CGFloat const kCHACommunityViewOffset = 5.f;
static CGRect const kCHAInitialCommunityInfoFrame = (CGRect){{0.f, 0.f}, {73.f, 57.f}};
static CGPoint const kCHAArrowAnchorPoint = (CGPoint){0.5f, 1.9f};
static CGPoint const kCHACommunityAnchorPoint = (CGPoint){0.5f, 8.8f};
static NSTimeInterval const kCHACommunityFadeOutDuration = .2;
static NSTimeInterval const kCHACommunityFadeInDuration = .15;
static NSTimeInterval const kCHADispatchInterval = 2.2;
static NSTimeInterval const kCHAOnscreenTime = 5.;
static NSTimeInterval const kCHAMovementDuration = 1.;

static CGFloat const kCommunityViewSize = 10.f;

@interface CHADashboardViewController ()

@property (nonatomic, weak) IBOutlet UIView *allView;
@property (nonatomic, weak) IBOutlet UIView *arrowContainerView;

//circular view
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UIView *pointView;
@property (nonatomic, weak) IBOutlet UILabel *footprintLabel;
@property (nonatomic, weak) IBOutlet UIView *centerView;
@property (nonatomic, strong) UIView *communityView;
@property (nonatomic, strong) CHACommunityView *communityInfoView;

//bottom views
@property (nonatomic, weak) IBOutlet UILabel *userKilometersLabel;
@property (nonatomic, weak) IBOutlet UILabel *communityKilometersLabel;
@property (nonatomic, weak) IBOutlet UILabel *userTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *userValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *userKGLabel;
@property (nonatomic, weak) IBOutlet UILabel *communityTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *communityValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *communityKGLabel;

@property (nonatomic, assign) BOOL didSetAnchorPoint;

@end

@implementation CHADashboardViewController

#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.didSetAnchorPoint = NO;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *communityView = [UIView new];
    communityView.frame = CGRectMake(0.f, 0.f, kCommunityViewSize, kCommunityViewSize);
    communityView.backgroundColor = [UIColor orangeColor];
    communityView.layer.cornerRadius = kCommunityViewSize / 2.f;
    CGPoint center = self.pointView.center;
    center.y -= kCHACommunityViewOffset;
    communityView.center = center;
    [self.containerView insertSubview:communityView belowSubview:self.pointView];
    self.communityView = communityView;
    
    CHACommunityView *communityInfoView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CHACommunityView class])
                                                                         owner:self
                                                                       options:nil] firstObject];
    communityInfoView.frame = kCHAInitialCommunityInfoFrame;
    communityInfoView.alpha = 0.f;
    [self.containerView insertSubview:communityInfoView belowSubview:self.pointView];
    self.communityInfoView = communityInfoView;
    [self updateWithFootprintShouldBeReloaded:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.didSetAnchorPoint == NO) {
        self.didSetAnchorPoint = YES;
        CGPoint point = kCHAArrowAnchorPoint;
        CGPoint communityPoint = kCHACommunityAnchorPoint;
        
        [self setAnchorPoint:communityPoint forView:self.communityView];
        [self setAnchorPoint:point forView:self.pointView];
    }
    
    [[CHADashboardModel sharedDashboardModel] loadFootprintWithSuccess:^{
        [self updateWithFootprintShouldBeReloaded:YES];
    } failure:^(NSString *error) {
        [[CHADashboardModel sharedDashboardModel] updateFromCache];
        [self updateWithFootprintShouldBeReloaded:YES];
    }];
}

#pragma mark - Private

- (void)updateWithFootprintShouldBeReloaded:(BOOL)footprintShouldBeReloaded {
    CHADashboardModel *model = [CHADashboardModel sharedDashboardModel];
    if (footprintShouldBeReloaded) {
        [self setFootprint:[model.userFootprint floatValue] animated:YES];
        [self setCommunityFootPrint:[model.communityFootprint floatValue] animated:YES];
    }
    self.userKilometersLabel.text = model.userKilometersString;
    self.communityKilometersLabel.text = model.communityKilometersString;
    self.userTitleLabel.attributedText = model.userSavingsTitleAttributedString;
    self.userValueLabel.attributedText = model.userSavingsValueAttributedString;
    self.userKGLabel.attributedText = model.userSavingsKGAttributedString;
    self.communityTitleLabel.attributedText = model.communitySavingsTitleAttributedString;
    self.communityValueLabel.attributedText = model.communitySavingsValueAttributedString;
    self.communityKGLabel.attributedText = model.communitySavingsKGAttributedString;
}

- (void)setCommunityFootPrint:(CHAFootprint)footprint animated:(BOOL)animated {
    footprint = [self constrainedFootprint:footprint];
    [UIView animateWithDuration:kCHACommunityFadeOutDuration
                     animations:^{
                         self.communityInfoView.alpha = 0.f;
                     } completion:^(BOOL finished) {
                         [self setFootprint:footprint forView:self.communityView animated:animated];
                         NSTimeInterval duration = animated ? kCHADispatchInterval : 0.;
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             CGRect oldFrame = self.communityInfoView.frame;
                             CGPoint point = [self originForCommunityInfoViewForAngle:-M_PI * (footprint/kFootprintInRad)];
                             CGRect frameNew = CGRectMake(point.x,
                                                          point.y,
                                                          oldFrame.size.width,
                                                          oldFrame.size.height);
                             self.communityInfoView.alpha = 0.f;
                             self.communityInfoView.communityFootprintLabel.text = [NSString stringWithFormat:@"%.2f", footprint];
                             self.communityInfoView.frame = frameNew;
                             [UIView animateWithDuration:kCHACommunityFadeInDuration animations:^{
                                 self.communityInfoView.alpha = 1.f;
                             } completion:^(BOOL finished) {
                                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kCHAOnscreenTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                     [UIView animateWithDuration:kCHACommunityFadeOutDuration animations:^{
                                         self.communityInfoView.alpha = 0.f;
                                     }];
                                 });
                             }];
                         });
                     }];
}

- (void)setFootprint:(CHAFootprint)footprint animated:(BOOL)animated {
    footprint = [self constrainedFootprint:footprint];
    self.footprintLabel.text = [NSString stringWithFormat:@"%.2f", footprint];
    [self setFootprint:footprint forView:self.pointView animated:animated];
}

- (void)setFootprint:(CHAFootprint)footprint forView:(UIView *)view animated:(BOOL)animated {
    footprint = [self constrainedFootprint:footprint];
    CGFloat angle = -M_PI * (footprint/kFootprintInRad);
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = 0;
    rotationAnimation.toValue = [NSNumber numberWithFloat:angle];
    NSTimeInterval duration = animated ? kCHAMovementDuration : 0.;
    rotationAnimation.duration = duration;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [rotationAnimation setRemovedOnCompletion:NO];
    [rotationAnimation setFillMode:kCAFillModeForwards];
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view {
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x,
                                   view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x,
                                   view.bounds.size.height * view.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
    
    CGPoint position = view.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
}

- (CGPoint)originForCommunityInfoViewForAngle:(CGFloat)angle {
    CGPoint center = self.centerView.center;
    CGFloat x = kCHARadius * sinf(angle);
    CGFloat y = kCHARadius * -cosf(angle);
    center.x += x;
    center.y += y;
    center.x -= self.communityInfoView.frame.size.width / 2.f;
    center.y -= self.communityInfoView.frame.size.height;
    return center;
}

- (CHAFootprint)constrainedFootprint:(CHAFootprint)footprint {
    footprint = MIN(footprint, kMaxFootprint);
    footprint = MAX(footprint, kMinFootprint);
    return footprint;
}

- (UIImage *)snapshot {
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, UIScreen.mainScreen.scale);
    [self.allView drawViewHierarchyInRect:self.allView.frame afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - IBAction

- (IBAction)revealButtonTouchUpInside:(id)sender {
    [self.revealController showViewController:self.revealController.leftViewController];
}

- (IBAction)leftButtonTouchUpInside:(id)sender {
    CHADashboardContainerViewController *parent = (CHADashboardContainerViewController *)self.parentViewController;
    [parent moveLeft];
}

- (IBAction)rightButtonTouchUpInside:(id)sender {
    CHADashboardContainerViewController *parent = (CHADashboardContainerViewController *)self.parentViewController;
    [parent moveRight];
}

- (IBAction)shareButtonTouchUpInside {
    
    NSDictionary *userStatistics = [[NSUserDefaults standardUserDefaults] valueForKey:@"statistics.user.dashboard"];
    CGFloat co2balance = [[userStatistics valueForKey:@"co2balance"] floatValue] / 1000.f;
    NSString *shareText = [NSString stringWithFormat:@"My CO2 balance is %.2f kg on @Changerscom\nMonitore your own balance here http://itunes.apple.com/app/id642099621add", co2balance];
    
    UIImage *image = [self snapshot];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:@[shareText, image]
                                                                            applicationActivities:nil];
    controller.excludedActivityTypes = @[UIActivityTypePostToWeibo,
                                         UIActivityTypeMessage,
                                         UIActivityTypeMail,
                                         UIActivityTypePrint,
                                         UIActivityTypeCopyToPasteboard,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypeSaveToCameraRoll,
                                         UIActivityTypeAddToReadingList,
                                         UIActivityTypePostToFlickr,
                                         UIActivityTypePostToVimeo,
                                         UIActivityTypePostToTencentWeibo,
                                         UIActivityTypeAirDrop];
    [self presentViewController:controller animated:YES completion:nil];
}

@end
