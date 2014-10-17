//
//  CHATrackResultsViewController.m
//  Changers
//
//  Created by Denis on 12.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHATrackResultsViewController.h"
#import "CHATrackerTheme.h"
#import "CHAAPIClient.h"
#import "CHAAppDelegate.h"
#import "CHAApplicationModel.h"
#import "CHASemiCircleView.h"
#import "UIImageView+AFNetworking.h"
#import "CHACompensationViewController.h"

static NSInteger kCHAMinDistance = 500;

@interface CHATrackResultsViewController (){
}
@property (weak, nonatomic) IBOutlet UIImageView *adsImageView;
@property (weak, nonatomic) IBOutlet CHASemiCircleView *adsBlockSemiCircle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *adsVerticalConstarint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorViewVerticalSpaceConstraint;
@property (weak, nonatomic) IBOutlet UIView *textBaseView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *co2EmissionLabel;
@property (weak, nonatomic) IBOutlet UILabel *co2SavingLabel;
@property (weak, nonatomic) IBOutlet UILabel *recoinsLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) NSString *adsLink;

- (IBAction)closeButtonTapHandler:(id)sender;
- (IBAction)shareButtonTapHandler:(id)sender;
- (IBAction)adsButtonTapHandler:(id)sender;
- (void)createTransaction;

@end

@implementation CHATrackResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    
    self.title = self.tracker.trackerTheme.title;
    self.textBaseView.backgroundColor = self.tracker.trackerTheme.tintColor;
    [self.closeButton setTitleColor:self.tracker.trackerTheme.tintColor forState:UIControlStateNormal];
    CHAAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    CHAApplicationModel *appModel = appDelegate.applicationModel;
    BOOL isOnline = [appModel isInternetReachable];
    self.distanceLabel.text = [NSString stringWithFormat:@"%.1f", ([self.tracker.tracking.distance integerValue] / 1000.f)];
    self.co2EmissionLabel.text = [NSString stringWithFormat:@"%.2f", [self.tracker.tracking.co2Emitted floatValue] / 1000.f];
    self.co2SavingLabel.text = [NSString stringWithFormat:@"%.2f", [self.tracker.tracking.co2Saved floatValue] / 1000.f];
    self.recoinsLabel.text = [NSString stringWithFormat:@"%.1f", [self.tracker.tracking.recoinsEarned floatValue]];
    self.speedLabel.text = [NSString stringWithFormat:@"%@", self.tracker.tracking.averageSpeed];
    
    switch (self.tracker.trackerType) {
        case TrackerTypeBike:
        case TrackerTypePublicTransport:
        case TrackerTypeTrain:
            if ([self.tracker.tracking.distance integerValue] < kCHAMinDistance) {
                self.titleLabel.text = NSLocalizedString(@"WE ARE SORRY", nil);
                self.descriptionLabel.text = [NSString stringWithFormat:@"We are sorry, however your journey was too short for us to give you any Recoins. You need to travel at least 0.5 kilometer. Thanks heaps for giving it to go, thought!"];
            } else {
                if (isOnline) {
                    self.titleLabel.text = NSLocalizedString(@"WELL DONE!", nil);
                    self.descriptionLabel.text = [NSString stringWithFormat:@"You have earned %.1f Recoins", [self.tracker.tracking.recoinsEarned floatValue]];
                    if ([self.tracker.tracking.imageUrl length]) {
                        [self showAdsView];
                    }
                    [self createTransaction];
                } else {
                    self.titleLabel.text = NSLocalizedString(@"WE ARE SORRY", nil);
                    self.descriptionLabel.text = NSLocalizedString(@"Your internet connection is lost. We'll send your trip data and Recoins when it comes back.", nil);
                    [MagicalRecord saveWithBlock:nil];
                }
            }
            break;
        case TrackerTypeCar:
        case TrackerTypePlane:
            self.titleLabel.text = NSLocalizedString(@"THANKS FOR BEING HONEST", nil);
            self.descriptionLabel.text = [NSString stringWithFormat:@"You %@ journey emitted a total of %.2f kg of CO2", [self.tracker.trackerTheme.title lowercaseString], ([self.tracker.tracking.co2Emitted floatValue] / 1000.f)];
            if ([self.tracker.tracking.distance integerValue] > kCHAMinDistance){
//                [self createTransaction];
            }
            break;
        case TrackerTypesCount:
            break;
    }
}


#pragma mark - Ads

- (void)showAdsView {
    [self.closeButton setBackgroundImage:[UIImage imageNamed:@"close_button_normal"] forState:UIControlStateNormal];
    self.adsLink = self.tracker.tracking.linkUrl;
    NSString *adsUrl = [self.tracker.tracking.imageUrl stringByReplacingOccurrencesOfString:@"stable.changers.com" withString:@"development.changers.com"];
    [self.adsImageView setImageWithURL:[NSURL URLWithString:adsUrl]];
    self.adsBlockSemiCircle.fillColor = self.tracker.trackerTheme.tintColor;
    [self.adsBlockSemiCircle setNeedsDisplay];
    // If it 3.5inch display need change vertical spacing between data boxes and color view
    if ([UIScreen cha_isPhone4]) {
        self.colorViewVerticalSpaceConstraint.constant = 10.f;
    }
    self.adsVerticalConstarint.constant = 0.f;
    [self.view setNeedsUpdateConstraints];
}

- (IBAction)adsButtonTapHandler:(id)sender {
    NSURL *url = [NSURL URLWithString:self.adsLink];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark -

- (void)createTransaction {
    [[CHAAPIClient sharedClient] createChangersBankTransactionForTracking:self.tracker.tracking succes:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject valueForKey:@"status"] integerValue] == 0) {
            [self.tracker.tracking MR_deleteEntity];
        }
        NSLog(@"%@", responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
        // Save tracking for tring resend
        NSLog(@"Save database");
        [MagicalRecord saveWithBlock:nil];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:self.tracker.trackerTheme.tintColor];
}

- (IBAction)closeButtonTapHandler:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)shareButtonTapHandler:(id)sender {
    UIGraphicsBeginImageContextWithOptions(self.navigationController.view.bounds.size, NO, 0.f);
    [self.navigationController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSString *shareText = nil;//[NSString stringWithFormat:@"My current rank on Changers.com is %f. Checkout my profile http://changers.com", self.tracker.trackerInfo.co2Emitted];
    switch (self.tracker.trackerType) {
        case TrackerTypeBike:
        case TrackerTypePublicTransport:
        case TrackerTypeTrain:
            shareText = [NSString stringWithFormat:@"I have earned %.1f Recoins! #Changerscom", [self.tracker.tracking.recoinsEarned floatValue]];
            break;
        case TrackerTypeCar:
            shareText = [NSString stringWithFormat:@"My car journey emitted a total of %.2f kg of CO2 #Changerscom", [self.tracker.tracking.co2Emitted floatValue] / 1000.f];
            break;
        case TrackerTypePlane:
            shareText = [NSString stringWithFormat:@"My plane journey emitted a total of %.2f kg of CO2 #Changerscom", [self.tracker.tracking.co2Emitted floatValue] / 1000.f];
            break;
        default:
            break;
    }
    UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:@[shareText, resultingImage] applicationActivities:nil];
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

- (IBAction)compensationHandler:(id)sender
{
    if ([[self.tracker tracking] co2Emitted] > 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Compensation" bundle:nil];
        CHACompensationViewController *vc = [storyboard instantiateInitialViewController];
        vc.compensation = [CHACompensation new];
        vc.compensation.co2ToCompense = [[self.tracker tracking] co2Emitted];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


@end
