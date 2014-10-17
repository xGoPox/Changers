//
//  CHASavedLocationAnnotationView.h
//  Changers
//
//  Created by Denis on 10.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface CHASavedLocationAnnotationView : MKAnnotationView
- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier color:(UIColor*)color;
@end
