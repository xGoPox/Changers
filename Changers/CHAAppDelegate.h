//
//  CHAAppDelegate.h
//  Changers
//
//  Created by Nikita Shitik on 05.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHAApplicationModel;

@interface CHAAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) CHAApplicationModel *applicationModel;

@end
