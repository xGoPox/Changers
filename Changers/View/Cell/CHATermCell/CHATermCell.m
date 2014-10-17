//
//  CHATermCell.m
//  Changers
//
//  Created by Nikita Shitik on 06.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHATermCell.h"

@interface CHATermCell ()

@property (nonatomic, weak) IBOutlet UILabel *termLabel;

@end

@implementation CHATermCell

- (void)configureWithText:(NSString *)text {
    self.termLabel.text = text;
}

@end
