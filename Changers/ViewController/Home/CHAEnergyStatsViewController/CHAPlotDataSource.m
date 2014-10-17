//
//  CHAPlotDataSource.m
//  Changers
//
//  Created by Nikita Shitik on 24.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHAPlotDataSource.h"
#import "NSDate+Utilities.h"

static double const kCHATicksNumber = 5.;
static double const kCHAMaxDelta = 1.2;

@interface CHAPlotDataSource ()

@property (nonatomic, strong) NSDateFormatter *tickDateFormatter;
@property (nonatomic, strong) NSDateFormatter *monthDateFormatter;

@end

@implementation CHAPlotDataSource

#pragma mark - Initialization

- (id)init {
    self = [super init];
    if (self) {
        self.currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd/MM";
        self.tickDateFormatter = dateFormatter;
        NSDateFormatter *monthDateFormatter = [NSDateFormatter new];
        monthDateFormatter.dateFormat = @"MMMM YYYY";
        self.monthDateFormatter = monthDateFormatter;
    }
    return self;
}

#pragma mark - Public Datasource

- (double)yMajorIntervalLength {
    NSArray *commonArray = [self.barChartDataSource arrayByAddingObjectsFromArray:self.scatterChartDataSource];
    return [[commonArray valueForKeyPath:@"@max.integerValue"] doubleValue] / kCHATicksNumber;
}

- (double)yVisibleRangeLength {
    NSArray *commonArray = [self.barChartDataSource arrayByAddingObjectsFromArray:self.scatterChartDataSource];
    return [[commonArray valueForKeyPath:@"@max.integerValue"] floatValue] * kCHAMaxDelta;
}

- (CGFloat)xLength {
    return self.barChartDataSource.count;
}

- (NSDictionary *)customTexts {
    NSInteger count = [self currentCount] + 1;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:self.currentDate];
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    for (int i = 1; i < count; i++) {
        @autoreleasepool {
            components.day = i;
            NSDate *date = [calendar dateFromComponents:components];
            NSInteger weekday = [date weekday];
            if (weekday == 2) {
                NSString *string = [self.tickDateFormatter stringFromDate:date];
                [dictionary setObject:string forKey:@(i - 1)];
            }
        }
    }
    return dictionary.copy;
}

- (NSString *)monthText {
    return [[self.monthDateFormatter stringFromDate:self.currentDate] uppercaseString];
}

#pragma mark - Public Adjusts

- (void)startFromNow {
    self.currentDate = [NSDate date];
}

- (void)moveBackward {
    self.currentDate = [self.currentDate dateBySubtractingMonths:1];
}

- (BOOL)moveForwardIfPossible {
    if ([self.currentDate isSameMonthAsDate:[NSDate date]] == NO) {
        self.currentDate = [self.currentDate dateByAddingMonths:1];
        return YES;
    }
    return NO;
}

#pragma mark - CPTPlotDataSource

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return self.barChartDataSource.count;
}

- (id)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx {
    NSNumber *num = nil;
    
    switch ( fieldEnum ) {
        case CPTBarPlotFieldBarLocation:
            num = @(idx);
            break;
            
        case CPTBarPlotFieldBarTip:
            num = [plot isEqual:self.barPlot] ? self.barChartDataSource[idx] : self.scatterChartDataSource[idx];
            break;
    }
    
    return num;
}

#pragma mark - CPTBarPlotDataSource

- (CPTLineStyle *)barLineStyleForBarPlot:(CPTBarPlot *)barPlot recordIndex:(NSUInteger)idx {
    CPTMutableLineStyle *style = [CPTMutableLineStyle new];
    UIColor *color = [self weekForIndex:idx] % 2 == 0 ? [self blueColor] : [self yellowColor];
    CPTColor *lineColor = [CPTColor colorWithCGColor:color.CGColor];
    style.lineColor = lineColor;
    style.lineFill = [CPTFill fillWithColor:lineColor];
    return style;
}

- (CPTFill *)barFillForBarPlot:(CPTBarPlot *)barPlot recordIndex:(NSUInteger)idx {
    UIColor *color = [self weekForIndex:idx] % 2 == 0 ? [self blueColor] : [self yellowColor];
    CPTColor *lineColor = [CPTColor colorWithCGColor:color.CGColor];
    return [CPTFill fillWithColor:lineColor];
}

#pragma mark - Private

- (NSInteger)weekForIndex:(NSUInteger)index {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:self.currentDate];
    components.day = index;
    NSDate *date = [calendar dateFromComponents:components];
    return [date week];
}

- (NSInteger)countOfDaysInMonthForDate:(NSDate *)date {
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSDayCalendarUnit
                           inUnit:NSMonthCalendarUnit
                          forDate:date];
    return days.length;
}

- (NSInteger)currentCount {
    return [self countOfDaysInMonthForDate:self.currentDate];
}

#pragma mark - Properties

- (UIColor *)blueColor {
    return [UIColor colorWithRed:84.f/255.f green:195.f/255.f blue:245.f/255.f alpha:1.f];
}

- (UIColor *)yellowColor {
    return [UIColor colorWithRed:252.f/255.f green:217.f/255.f blue:35.f/255.f alpha:1.f];
}

- (NSArray *)barChartDataSource {
    if (!_barChartDataSource) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < [self currentCount]; i++) {
            NSNumber *number = @0;
            [array addObject:number];
        }
        _barChartDataSource = [array copy];
    }
    return _barChartDataSource;
}

- (NSArray *)scatterChartDataSource {
    if (!_scatterChartDataSource) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < [self currentCount]; i++) {
            NSNumber *number = @0;
            [array addObject:number];
        }
        _scatterChartDataSource = [array copy];
    }
    return _scatterChartDataSource;
}

@end
