    //
//  CHAHomeViewController.m
//  Changers
//
//  Created by Denis on 08.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHAHomeViewController.h"
#import "CHATrackViewController.h"
#import "UIView+Glow.h"
#import "PKRevealController.h"
#import "UIViewController+PKRevealController.h"
#import "CHAAPIClient.h"
#import "BlurryModalSegue.h"
#import "CHAAppDelegate.h"
#import "CHARevealViewController.h"
#import "UIViewController+PKRevealController.h"
#import "CHASideViewController.h"
#import "CHASettingsUserModel.h"

@interface CHAHomeViewController ()
- (UIButton*)activeTrackingButton;
- (IBAction)transportButtonTapHandler:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *co2IndexBackgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *co2IndexLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankingLabel;
@property (weak, nonatomic) IBOutlet UILabel *recoinsLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *transportButtons;
@property (weak, nonatomic) IBOutlet UILabel *co2IndexTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *measureLabel;
- (IBAction)co2IndexTapHandler:(id)sender;
- (IBAction)sunIconTapHandler:(id)sender;
@end

@implementation CHAHomeViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *infoButton = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 30.f, 30.f)];
    [infoButton addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
    [infoButton setImage:[UIImage imageNamed:@"info_icon_normal"] forState:UIControlStateNormal];
    [infoButton setImage:[UIImage imageNamed:@"info_icon_pressed"] forState:UIControlStateHighlighted];
    UIBarButtonItem *qrButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareButtonTapHandler)];
    NSArray *rightButtons = @[qrButtonItem, shareButton];
    self.navigationItem.rightBarButtonItems = rightButtons;

    // Update user profile. Need create user model and rewrite it
    [[CHAAPIClient sharedClient] getUserProfileWithSuccess:^(NSURLSessionDataTask *operation, id responseObject) {
        if ([[responseObject valueForKey:@"status"] integerValue] == 0) {
            NSString *guid = [responseObject valueForKeyPath:@"result.core.guid"];
            [[NSUserDefaults standardUserDefaults] setObject:guid forKey:kCHAGuidStoringKey];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"Error %@", [error localizedDescription]);
    }];
    
    //Update UI with cached data
    NSDictionary *userStatistics = [[NSUserDefaults standardUserDefaults] valueForKey:@"statistics.user.dashboard"];
    if (userStatistics)
        [self updateUIWithUserStaticstics:userStatistics];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stopGlowingButton)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startGlowingButton)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

#pragma mark - Glowing Active Button

- (void)startGlowingButton {
    if (self.tracker.isTracking) {
        UIButton *activeButton = [self activeTrackingButton];
        [activeButton startGlowingWithColor:[UIColor whiteColor] intensity:0.75];
    }
}

- (void)stopGlowingButton {
    if (self.tracker.isTracking) {
        UIButton *activeButton = [self activeTrackingButton];
        [activeButton stopGlowing];
    }
}

#pragma mark - Update UI

- (void)updateUIWithUserStaticstics:(NSDictionary*)userStatistics {
    //Green [UIColor colorWithRed:0.334 green:0.801 blue:0.369 alpha:1.000]
    //Red [UIColor colorWithRed:0.890 green:0.180 blue:0.111 alpha:1.000]
    CGFloat co2balance = [[userStatistics valueForKey:@"co2balance"] floatValue] / 1000.f; //CO2 Balance should be shown in KG not in G
    //Co2 emissions should be savings if the value is negative.
    if (co2balance < 0) {
        self.co2IndexTitleLabel.text = NSLocalizedString(@"CO2 SAVINGS", nil);
        self.co2IndexLabel.textColor = [UIColor colorWithRed:0.334 green:0.801 blue:0.369 alpha:1.000];
        self.measureLabel.textColor = [UIColor colorWithRed:0.334 green:0.801 blue:0.369 alpha:1.000];
    } else {
        self.co2IndexTitleLabel.text = NSLocalizedString(@"CO2 EMISSIONS", nil);
        self.co2IndexLabel.textColor = [UIColor colorWithRed:0.890 green:0.180 blue:0.111 alpha:1.000];
        self.measureLabel.textColor = [UIColor colorWithRed:0.890 green:0.180 blue:0.111 alpha:1.000];
    }
    
    [[CHASettingsUserModel sharedModel] setRecoins:[userStatistics valueForKey:@"recoins"]];
    [[CHASettingsUserModel sharedModel] setCo2Balance:[userStatistics valueForKey:@"co2balance"]];
    
    self.co2IndexLabel.text =  [NSString stringWithFormat:@"%.2f", fabsf(co2balance)];
    self.recoinsLabel.text =  [NSString stringWithFormat:@"%.2f", [[userStatistics valueForKey:@"recoins"] floatValue]];
    self.rankingLabel.text =  [NSString stringWithFormat:@"%@",[userStatistics valueForKey:@"rank"]];
}

#pragma mark -

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar.layer removeAllAnimations];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self startGlowingButton];
    
    //---------------------------------------
    // Move
    //---------------------------------------
    __typeof__(self) __weak wself = self;
    [[CHAAPIClient sharedClient] getUserStatisticWithSuccess:^(NSURLSessionDataTask *operation, id responseObject) {
        if ([[responseObject valueForKey:@"status"] integerValue] == 0) {
            NSLog(@"%@", [responseObject valueForKey:@"result"]);
            NSDictionary *userStatistics = [responseObject valueForKey:@"result"];
            [[NSUserDefaults standardUserDefaults] setObject:userStatistics forKey:@"statistics.user.dashboard"];
            [wself updateUIWithUserStaticstics:userStatistics];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
    //---------------------------------------
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopGlowingButton];
}

- (UIButton*)activeTrackingButton {
    for (UIButton *button in self.transportButtons) {
        if (button.tag == self.tracker.trackerType) {
            return button;
        }
    }
    return nil;
}

- (void)showInfo {
    [self performSegueWithIdentifier:@"infoSugue" sender:nil];
}

- (void)shareButtonTapHandler {
    NSDictionary *userStatistics = [[NSUserDefaults standardUserDefaults] valueForKey:@"statistics.user.dashboard"];
    CGFloat co2balance = [[userStatistics valueForKey:@"co2balance"] floatValue] / 1000.f;
    NSString *shareText = [NSString stringWithFormat:@"My CO2 balance is %.2f kg on @Changerscom\nMonitore your own balance here http://itunes.apple.com/app/id642099621add", co2balance];

    UIGraphicsBeginImageContextWithOptions(self.navigationController.view.bounds.size, NO, 0.f);
    [self.navigationController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
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

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TrackerCO2EmissionSegue"] || [segue.identifier isEqualToString:@"TrackerCO2SaveSegue"]) {
        CHATrackViewController *trackerViewController = [segue destinationViewController];
        trackerViewController.tracker = self.tracker;
    } else if ([segue.identifier isEqualToString:@"ongoingSegue"]) {
        if ([segue isKindOfClass:[BlurryModalSegue class]]) {
            BlurryModalSegue* bms = (BlurryModalSegue*)segue;
            bms.backingImageTintColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        }
    }
}

- (IBAction)transportButtonTapHandler:(UIButton *)sender {
    if (self.tracker.isTracking && self.tracker.trackerType != sender.tag) {
        [self performSegueWithIdentifier:@"ongoingSegue" sender:nil];
    } else {
        [self.tracker setTrackerType:sender.tag];
        if (sender.tag == TrackerTypeCar || sender.tag == TrackerTypePlane) {
            [self performSegueWithIdentifier:@"TrackerCO2EmissionSegue" sender:nil];
        } else {
            [self performSegueWithIdentifier:@"TrackerCO2SaveSegue" sender:nil];
        }
    }
}

- (IBAction)revealButtonTouchUpInside:(id)sender {
    [self.revealController showViewController:self.revealController.leftViewController];
}

- (IBAction)co2IndexTapHandler:(id)sender {
    CHASideViewController *sideViewController = (CHASideViewController *)[self.revealController leftViewController];
    sideViewController.revealController = self.revealController;
    [sideViewController showDashboard];
}

- (IBAction)sunIconTapHandler:(id)sender {
    CHASideViewController *sideViewController = (CHASideViewController *)[self.revealController leftViewController];
    sideViewController.revealController = self.revealController;
    [sideViewController showEnergyStats];
}

@end
