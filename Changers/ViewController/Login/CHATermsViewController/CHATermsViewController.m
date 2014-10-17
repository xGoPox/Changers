//
//  CHATermsViewController.m
//  Changers
//
//  Created by Nikita Shitik on 05.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHATermsViewController.h"

//view
#import "CHATermCell.h"

@interface CHATermsViewController ()

//view
@property (weak, nonatomic) IBOutlet UITextView *termOfUseTextView;
@property (weak, nonatomic) IBOutlet UITextView *privacyTextView;
@property (nonatomic, weak) IBOutlet UIButton *leftButton;
@property (nonatomic, weak) IBOutlet UIButton *rightButton;

@end

@implementation CHATermsViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *privacyFile = [[NSBundle mainBundle] pathForResource:@"privacy" ofType:@"html"];
    NSString *termsFile = [[NSBundle mainBundle] pathForResource:@"terms" ofType:@"html"];
    NSString* privacyHtmlString = [NSString stringWithContentsOfFile:privacyFile encoding:NSUTF8StringEncoding error:nil];
    NSString* termsHtmlString = [NSString stringWithContentsOfFile:termsFile encoding:NSUTF8StringEncoding error:nil];

    NSAttributedString *privacyAttributedString = [[NSAttributedString alloc] initWithData:[privacyHtmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    NSAttributedString *termsAttributedString = [[NSAttributedString alloc] initWithData:[termsHtmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.privacyTextView.attributedText = privacyAttributedString;
    self.termOfUseTextView.attributedText = termsAttributedString;
    
    [self.leftButton sendActionsForControlEvents:UIControlEventTouchDown];
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"left_segment_button_pressed"]
                               forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"right_segment_button_pressed"]
                                forState:UIControlStateSelected | UIControlStateHighlighted];
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - IBAction

- (IBAction)backButtonTouchUpInside:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)leftButtonTouchDown:(id)sender {
    self.leftButton.selected = YES;
    self.rightButton.selected = NO;
    self.termOfUseTextView.hidden = NO;
    [self.privacyTextView setContentOffset:CGPointZero animated:NO];
    self.privacyTextView.hidden = YES;
}

- (IBAction)rightButtonTouchDown:(id)sender {
    self.leftButton.selected = NO;
    self.rightButton.selected = YES;
    self.termOfUseTextView.hidden = YES;
    [self.termOfUseTextView setContentOffset:CGPointZero animated:NO];
    self.privacyTextView.hidden = NO;
}

#pragma mark - UIViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
