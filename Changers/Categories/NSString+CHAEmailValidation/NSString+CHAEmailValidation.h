//
//  NSString+CHAEmailValidation.h
//  Changers
//
//  Created by Nikita Shitik on 14.10.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CHAEmailValidation)

- (BOOL)cha_isEmailValid;
- (NSString *)cha_md5;

@end
