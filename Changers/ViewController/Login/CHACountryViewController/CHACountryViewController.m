//
//  CHACountryViewController.m
//  Changers
//
//  Created by Nikita Shitik on 07.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHACountryViewController.h"

@interface CHACountryViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>

//view
@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;

//model
@property (nonatomic, strong, readonly) NSArray *countries;
@property (nonatomic, strong, readonly) NSArray *countryCodes;

@end

@implementation CHACountryViewController

@synthesize countries = _countries;
@synthesize countryCodes = _countryCodes;

#pragma mark - View lifecycle 

- (void)viewDidLoad {
    [super viewDidLoad];
    NSInteger index = [self.countryCodes indexOfObject:self.country];
    if (index != NSNotFound) {
        [self.pickerView selectRow:index inComponent:0 animated:NO];
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.countries.count;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.countries[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([self.delegate respondsToSelector:@selector(countryPicker:didFinishPickingWithCountry:countryCode:)]) {
        NSString *title = self.countries[[self.pickerView selectedRowInComponent:0]];
        NSString *code = self.countryCodes[[self.pickerView selectedRowInComponent:0]];
        [self.delegate countryPicker:self didFinishPickingWithCountry:title countryCode:code];
    }
}

#pragma mark - Public

- (void)dismiss {
    [self.dismissButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)passStartString:(NSString *)startString {
    
}

- (CGSize)controllerSize {
    return CGSizeMake(320.f, 250.f);
}

#pragma mark - Property

- (NSArray *)countries {
    if (!_countries) {
        NSLocale *locale = [NSLocale currentLocale];
        NSArray *countryArray = [NSLocale ISOCountryCodes];
        NSMutableArray *sortedCountryArray = [[NSMutableArray alloc] init];
        for (NSString *countryCode in countryArray) {
            @autoreleasepool {
                NSString *displayNameString = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
                [sortedCountryArray addObject:displayNameString];
            }
        }
        [sortedCountryArray sortUsingSelector:@selector(localizedCompare:)];
        _countries = sortedCountryArray.copy;
    }
    return _countries;
}

- (NSArray *)countryCodes {
    if (!_countryCodes) {
        NSLocale *locale = [NSLocale currentLocale];
        NSArray *array = [NSLocale ISOCountryCodes];
        _countryCodes = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *locale1 = obj1;
            NSString *locale2 = obj2;
            NSString *localizedName1 = [locale displayNameForKey:NSLocaleCountryCode value:locale1];
            NSString *localizedName2 = [locale displayNameForKey:NSLocaleCountryCode value:locale2];
            return [localizedName1 compare:localizedName2 options:0];
        }];
    }
    return _countryCodes;
}

#pragma mark - IBAction

- (IBAction)selectButtonTouchUpInside:(id)sender {
    if ([self.delegate respondsToSelector:@selector(countryPicker:didFinishPickingWithCountry:countryCode:)]) {
        NSString *title = self.countries[[self.pickerView selectedRowInComponent:0]];
        NSString *code = self.countryCodes[[self.pickerView selectedRowInComponent:0]];
        [self.delegate countryPicker:self didFinishPickingWithCountry:title countryCode:code];
    }
}

@end
