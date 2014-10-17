//
//  CHASavedLocationAnnotationView.m
//  Changers
//
//  Created by Denis on 10.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHASavedLocationAnnotationView.h"

@implementation CHASavedLocationAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier color:(UIColor*)color {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.canShowCallout = NO;
        UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 6.f, 6.f)];
        dot.layer.cornerRadius = 3.f;
        dot.backgroundColor = color;
        [self addSubview:dot];
    }
    return self;
}

@end
