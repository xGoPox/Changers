//
//  CHAPlotDataSource.h
//  Changers
//
//  Created by Nikita Shitik on 24.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"

@interface CHAPlotDataSource : NSObject<CPTBarPlotDataSource, CPTScatterPlotDataSource>

@property (nonatomic, weak) id barPlot;
@property (nonatomic, strong) NSDate *currentDate;

@property (nonatomic, strong) NSArray *barChartDataSource;
@property (nonatomic, strong) NSArray *scatterChartDataSource;

//datasource
- (double)yMajorIntervalLength;
- (double)yVisibleRangeLength;
- (CGFloat)xLength;
- (NSDictionary *)customTexts;
- (NSString *)monthText;

//adjusts
- (void)startFromNow;
- (void)moveBackward;
- (BOOL)moveForwardIfPossible;

@end
