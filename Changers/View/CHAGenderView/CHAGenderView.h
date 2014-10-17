//
//  CHAGenderView.h
//  Changers
//
//  Created by Nikita Shitik on 06.10.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHAGenderView;

@protocol CHAGenderViewDelegate <NSObject>

- (void)genderView:(CHAGenderView *)genderView didSelectGender:(CHAGender)gender;

@end

@interface CHAGenderView : UIView

@property (nonatomic, weak) id<CHAGenderViewDelegate> delegate;

- (void)setGender:(CHAGender)gender;

@end
