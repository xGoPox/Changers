//
//  CHAGenderView.m
//  Changers
//
//  Created by Nikita Shitik on 06.10.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHAGenderView.h"

@interface CHAGenderView ()

@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *labels;
@property (nonatomic, strong) IBOutletCollection(UIImageView) NSArray *images;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *buttons;

@end

@implementation CHAGenderView

#pragma mark - Public

- (void)setGender:(CHAGender)gender {
    NSAssert((gender >= 0 && gender <= 2), @"UNKNOWN GENDER");
    [self.labels makeObjectsPerformSelector:@selector(setTextColor:) withObject:[self normalColor]];
    [self.images makeObjectsPerformSelector:@selector(setImage:) withObject:[self normalImage]];
    UIImageView *imageView = self.images[gender];
    UILabel *label = self.labels[gender];
    imageView.image = [self selectedImage];
    label.textColor = [self selectedColor];
}

#pragma mark - IBAction

- (IBAction)genderButtonTouchDown:(id)sender {
    NSInteger index = [self.buttons indexOfObject:sender];
    [self setGender:index];
    if ([self.delegate respondsToSelector:@selector(genderView:didSelectGender:)]) {
        [self.delegate genderView:self didSelectGender:index];
    }
}

#pragma mark - Private

- (UIColor *)selectedColor {
    return RGB(73.f, 82.f, 92.f);
}

- (UIColor *)normalColor {
    return RGB(177.f, 182.f, 192.f);
}

- (UIImage *)selectedImage {
    return [UIImage imageNamed:@"radio_button_pressed"];
}

- (UIImage *)normalImage {
    return [UIImage imageNamed:@"radio_button_normal"];
}

@end
