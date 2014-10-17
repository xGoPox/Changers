//
//  CHAAwardView.h
//  Changers
//
//  Created by Nikita Shitik on 07.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CHAAwardType) {
    CHAAwardTypeNewbie
};

@interface CHAAwardView : UIView

+ (void)showWithType:(CHAAwardType)type hideAfterDelay:(NSTimeInterval)delay;

@end
