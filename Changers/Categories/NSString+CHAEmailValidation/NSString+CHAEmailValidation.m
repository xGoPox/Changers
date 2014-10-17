//
//  NSString+CHAEmailValidation.m
//  Changers
//
//  Created by Nikita Shitik on 14.10.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "NSString+CHAEmailValidation.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (CHAEmailValidation)

- (BOOL)cha_isEmailValid {
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,10}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    return [emailTest evaluateWithObject:self];
}

- (NSString *)cha_md5 {
    const char *cStr = [self UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest );
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return  output;
}

@end
