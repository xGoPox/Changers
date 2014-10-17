//
//  CHASemiCircleView.m
//  Changers
//
//  Created by Denis on 10.10.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHASemiCircleView.h"

@implementation CHASemiCircleView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    if (!self.fillColor)
        self.fillColor = [UIColor blackColor];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef gc = UIGraphicsGetCurrentContext();
    CGContextBeginPath(gc);
    CGFloat radius = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    CGContextAddArc(gc, CGRectGetWidth(self.bounds)/2, 0, radius, -(float)M_PI, (float)M_PI, 1);
    CGContextClosePath(gc); // could be omitted
    CGContextSetFillColorWithColor(gc, self.fillColor.CGColor);
    CGContextFillPath(gc);
}

@end
