//
//  CHACompensationCongratulationViewController.m
//  Changers
//
//  Created by Clemt Yerochewski on 14/10/14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHACompensationCongratulationViewController.h"
#import "CHASettingsUserModel.h"
#import "CHACompensation.h"

@interface CHACompensationCongratulationViewController ()
@property (nonatomic, weak) IBOutlet UILabel *congratulationLabel;

@end

@implementation CHACompensationCongratulationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.congratulationLabel setText:[NSString stringWithFormat:@"YOU ADDED %@ KG CO2 SAVING TO YOUR ACCOUNT YOU KNOW HAVE %@", self.compensation.co2ToCompense, [[CHASettingsUserModel sharedModel] co2Balance]]];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)finishCompensation:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
