//
//  CHATrackCompensationViewController.m
//  Changers
//
//  Created by Clemt Yerochewski on 14/10/14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHACompensationViewController.h"
#import "CHACompensationApprovalViewController.h"
#import "CHACompensation.h"
#import "CHACompensationHelper.h"
#import "CHASettingsUserModel.h"
#import "CHAIAPRecoinsHelper.h"
#import "SKProduct+priceAsString.h"

@interface CHACompensationViewController()
{
    NSArray *_products;
    SKProduct *productIAP;
}

@property (nonatomic, weak) IBOutlet UIImageView *journeyTypeImage;
@property (nonatomic, weak) IBOutlet UILabel *co2ToCompenseLabel;
@property (nonatomic, weak) IBOutlet UIButton *skipButton;
@property (nonatomic, weak) IBOutlet UIButton *compensationRCButton;
@property (nonatomic, weak) IBOutlet UIButton *compensationBuyButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomConstraint;
@end

@implementation CHACompensationViewController

@synthesize compensation = _compensation;

- (void)viewDidLoad {
    if (IS_IPHONE_4) {
        [self.bottomConstraint setConstant:10.f];
    [self.bottomConstraint setConstant:10.f];
    }
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    [self updateUI];
    [self fetchCompensationPrices];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)updateUI
{
    switch (self.tracker.trackerType) {
        case TrackerTypeCar:
            [self.journeyTypeImage setImage:[UIImage imageNamed:@"compensation_car"]];
            break;
        case TrackerTypePlane:
            [self.journeyTypeImage setImage:[UIImage imageNamed:@"compensation_plane"]];
            break;
        default:
            break;
    }
    
    [self.co2ToCompenseLabel setText:[NSString stringWithFormat:@"%@ kg of CO2", self.compensation.co2ToCompense]];
}

- (void)fetchCompensationPrices
{
    __block NSNumber *co2ToCompense = self.compensation.co2ToCompense;

    [[CHAIAPRecoinsHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _products = products;
            
            [[CHACompensationHelper sharedInstance] getIAPForCompensation:co2ToCompense onProducts:_products withCompletionHandler:^(SKProduct *product) {
                productIAP = product;
                [self.compensationBuyButton setTitle:[NSString stringWithFormat:@"%@", [productIAP priceAsString]] forState:UIControlStateNormal];
            }];
        }
        else
        {
            NSLog(@"failed retrieving products");
        }
    }];

    [[CHACompensationHelper sharedInstance] convertCO2CompensationIntoRecoins:co2ToCompense withCompletionHandler:^(NSNumber *recoins) {
        _compensation.co2Recoins = recoins;
        [self.compensationRCButton setTitle:[NSString stringWithFormat:@"%@ RC", _compensation.co2Recoins] forState:UIControlStateNormal];
    }];
}

- (IBAction)buyInAppPurchaseHandle:(id)sender {
    self.compensation.paymentType = CHAInAppPurchasePayment;
    [self showViewController];
}

- (IBAction)buyRecoinsHandle:(id)sender {
    self.compensation.paymentType = CHARecoinsPayment;
    [self showViewController];
}

- (IBAction)closeButtonTapHandler:(id)sender {
    [self.navigationController setNavigationBarHidden:NO animated:FALSE];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)showViewController
{
    if ([self canCompensate]) {
        CHACompensationApprovalViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CHACompensationApprovalViewController"];
        vc.compensation = self.compensation;
        vc.productIAP = productIAP;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (BOOL)canCompensate
{
    if ([self.compensation.co2Recoins compare:[[CHASettingsUserModel sharedModel] recoins]] != NSOrderedAscending ) {
        return TRUE;
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You don't have enough recoins, save more CO2 dude! or buy some :D" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return FALSE;
    }
}


@end
