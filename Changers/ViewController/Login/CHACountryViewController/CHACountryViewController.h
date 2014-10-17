//
//  CHACountryViewController.h
//  Changers
//
//  Created by Nikita Shitik on 07.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CHACountryPickerDelegate;

@interface CHACountryViewController : UIViewController

@property (nonatomic, weak) id<CHACountryPickerDelegate> delegate;
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) NSString *country;

- (void)dismiss;
- (void)passStartString:(NSString *)startString;

- (CGSize)controllerSize;

@end

@protocol CHACountryPickerDelegate <NSObject>

@optional
- (void)countryPicker:(CHACountryViewController *)countryPicker didFinishPickingWithCountry:(NSString *)country
          countryCode:(NSString *)countryCode;

@end
