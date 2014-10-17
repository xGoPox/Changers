//
//  CHAAwardView.m
//  Changers
//
//  Created by Nikita Shitik on 07.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHAAwardView.h"

static CGFloat const kCHAAwardViewHeight = 84.f;

@implementation CHAAwardView

#pragma mark - Public

+ (void)showWithType:(CHAAwardType)type hideAfterDelay:(NSTimeInterval)delay {
    CHAAwardView *view = [self awardViewWithType:type];
    [view show];
    [view performSelector:@selector(hide) withObject:nil afterDelay:delay];
}

#pragma mark - Private

+ (instancetype)awardViewWithType:(CHAAwardType)type {
    CHAAwardView *view;
    if (type == CHAAwardTypeNewbie) {
        CGFloat width = [UIScreen cha_width];
        CGFloat height = kCHAAwardViewHeight;
        CGFloat y = [UIScreen cha_height];
        CGFloat x = 0.f;
        CGRect frame = CGRectMake(x, y, width, height);
        view = [[NSBundle mainBundle] loadNibNamed:@"CHAAwardNewbieView" owner:nil options:nil][0];
        view.frame = frame;
    }
    return view;
}

#pragma mark - Show & hide

- (void)show {
    UIView *superView = [[UIApplication sharedApplication] keyWindow];
    [superView addSubview:self];
    [UIView animateWithDuration:.2f animations:^{
        CGRect rect = self.frame;
        rect.origin.y -= rect.size.height;
        self.frame = rect;
    }];
}

- (void)hide {
    [UIView animateWithDuration:.2 animations:^{
        CGRect rect = self.frame;
        rect.origin.y += rect.size.height;
        self.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
