//
//  CHATermsPreviewViewController.m
//  Changers
//
//  Created by Nikita Shitik on 05.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHATermsPreviewViewController.h"

//model
#import "CHALandingUserModel.h"

@interface CHATermsPreviewViewController ()

@property (nonatomic, weak) IBOutlet UIButton *checkButton;
@property (nonatomic, weak) IBOutlet UILabel *conditionsLabel;

@end

@implementation CHATermsPreviewViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.checkButton.selected = self.userModel.acceptedTerms;
    self.checkButton.layer.borderWidth = .5f;
    self.checkButton.layer.borderColor = [UIColor colorWithRed:79.f/255.f green:194.f/255.f blue:245.f/255.f alpha:1.f].CGColor;
    
    NSString *text = NSLocalizedString(@"YES, I HAVE ACKNOWLEDGED THE TERMS OF USE AND PRIVACY POLICY AND I AGREE WITH IT", nil);
    NSString *boldText1 = NSLocalizedString(@"TERMS OF USE", nil);
    NSString *boldText2 = NSLocalizedString(@"PRIVACY POLICY", nil);
    NSRange range1 = [text rangeOfString:boldText1];
    NSRange range2 = [text rangeOfString:boldText2];
    NSRange fullRange = NSMakeRange(0, text.length);
    UIFont *regularFont = [UIFont fontWithName:kCHAKlavikaFontName size:12.f];
    UIFont *boldFont = [UIFont fontWithName:kCHAKlavikaMediumFontName size:12.f];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSFontAttributeName value:regularFont range:fullRange];
    [attributedString addAttribute:NSFontAttributeName value:boldFont range:range1];
    [attributedString addAttribute:NSFontAttributeName value:boldFont range:range2];
    self.conditionsLabel.attributedText = attributedString;
}

#pragma mark - IBAction

- (IBAction)termsButtonTouchUpInside:(id)sender {
    if ([self.delegate respondsToSelector:@selector(termsPreviewControllerDidPressTermsButton:)]) {
        [self.delegate termsPreviewControllerDidPressTermsButton:self];
    }
}

- (IBAction)checkButtonTouchDown:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.userModel.acceptedTerms = sender.selected;
    if ([self.delegate respondsToSelector:@selector(termsPreviewController:acceptedTerms:)]) {
        [self.delegate termsPreviewController:self acceptedTerms:sender.selected];
    }
}

@end
