//
//  CHACompensationApprovalViewController.m
//  Changers
//
//  Created by Clemt Yerochewski on 14/10/14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHACompensationApprovalViewController.h"
#import "CHACompensationCongratulationViewController.h"
#import "CHACompensation.h"
#import "CHASettingsUserModel.h"
#import "CHAIAPRecoinsHelper.h"
#import "SKProduct+priceAsString.h"

@interface CHACompensationApprovalViewController () 

@property (nonatomic, weak) IBOutlet UILabel *recoinsLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainTextLabel;

@end

@implementation CHACompensationApprovalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self updateUIForCompensationType];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:@"IAPHelperProductPurchasedNotification" object:nil];

    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}

- (void)updateUIForCompensationType
{
    NSString *priceStr;
    switch (self.compensation.paymentType) {
        case CHAInAppPurchasePayment:
            if (self.productIAP)
                priceStr = [self.productIAP priceAsString];
            break;
        case CHARecoinsPayment:
            priceStr = [NSString stringWithFormat:@"%@ RECOINS", self.compensation.co2Recoins];
            break;
    }
    [self.mainTextLabel setText:[NSString stringWithFormat:@"COOL, YOU ARE ABOUT TO PAY %@ FOR %@ KG CO2 SAVINGS", priceStr , self.compensation.co2ToCompense]];
    [self.recoinsLabel setText:[NSString stringWithFormat:@"%@", priceStr]];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeButtonTapHandler:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)makePayment:(id)sender
{
    switch (self.compensation.paymentType) {
        case CHAInAppPurchasePayment: {
            [[CHAIAPRecoinsHelper sharedInstance] buyProduct:self.productIAP];
            break;
        }
        case CHARecoinsPayment:
            [self showController];
            break;
    }
}

- (void)productPurchased:(NSNotification *)notification {
    [self showController];
}

- (void)showController
{
    [[CHASettingsUserModel sharedModel] setCo2Balance:[NSNumber numberWithFloat:[[[CHASettingsUserModel sharedModel] co2Balance] floatValue] - [self.compensation.co2ToCompense  floatValue]]];
    
    CHACompensationCongratulationViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CHACompensationCongratulationViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    [vc setCompensation:self.compensation];

}





@end
