//
//  CHAEnergyStatsViewController.m
//  Changers
//
//  Created by Nikita Shitik on 23.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHAEnergyStatsViewController.h"
#import "CHADashboardContainerViewController.h"

//core plot
#import "CorePlot-CocoaTouch.h"
#import "CHAPlotFormatter.h"

//datasource
#import "CHAPlotDataSource.h"
#import "CHAEnergyStatsModel.h"

//misc
#import "PKRevealController.h"
#import "UIViewController+PKRevealController.h"

@interface CHAEnergyStatsViewController ()

//plots
@property (nonatomic, strong) CPTXYGraph *graph;
@property (nonatomic, weak) IBOutlet CPTGraphHostingView *graphHostingView;
@property (nonatomic, strong) id barPlot;
@property (nonatomic, strong) id scatterPlot;

//datasource
@property (nonatomic, strong) CHAEnergyStatsModel *model;
@property (nonatomic, strong) CHAPlotDataSource *plotDataSource;
@property (nonatomic, strong, readonly) UIColor *grayColor;

//view
@property (nonatomic, weak) IBOutlet UIView *allView;
@property (nonatomic, weak) IBOutlet UILabel *monthLabel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, weak) IBOutlet UILabel *userSavingsLabel;
@property (nonatomic, weak) IBOutlet UILabel *userEnergyLabel;
@property (nonatomic, weak) IBOutlet UILabel *communitySavingsLabel;
@property (nonatomic, weak) IBOutlet UILabel *communityEnergyLabel;


@property (nonatomic, copy) CHAEmptyBlock hideBlock;

@end

@implementation CHAEnergyStatsViewController

@synthesize grayColor = _grayColor;

#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _model = [[CHAEnergyStatsModel alloc] init];
        _plotDataSource = _model.plotDataSource;
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:.9f green:.9f blue:.0f alpha:1.f];
        self.navigationItem.title = NSLocalizedString(@"ENERGY UPLOADS", nil);
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.alwaysBounceVertical = YES;
    CPTXYGraph *graph = self.graph;
    graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTGraphHostingView *hostingView = self.graphHostingView;
    hostingView.hostedGraph = graph;
    hostingView.collapsesLayers = NO;
    
    // Border
    graph.plotAreaFrame.borderLineStyle = nil;
    graph.plotAreaFrame.cornerRadius    = 0.0;
    graph.plotAreaFrame.masksToBorder   = NO;
    
    // Paddings
    graph.paddingLeft   = 0.0;
    graph.paddingRight  = 0.0;
    graph.paddingTop    = 0.0;
    graph.paddingBottom = 0.0;
    
    graph.plotAreaFrame.paddingLeft   = 40.0;
    graph.plotAreaFrame.paddingTop    = 20.0;
    graph.plotAreaFrame.paddingRight  = 20.0;
    graph.plotAreaFrame.paddingBottom = 80.0;
    
    graph.titleDisplacement        = CGPointMake(0.0, -20.0);
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    self.graph = graph;
    
    [self reloadGraph];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}

#pragma mark - Private

- (void)reloadData {
    __weak typeof(self) weakSelf = self;
    
    if (self.indicator.superview == nil) {
        self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.indicator.color = RGBA(30.f, 50.f, 200.f, .7f);
        self.indicator.center = self.graphHostingView.center;
        [self.containerView addSubview:self.indicator];
        
        self.hideBlock = ^(void){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.indicator removeFromSuperview];
        };
    }
    
    [self.model refreshWithSuccess:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.hideBlock) {
            strongSelf.hideBlock();
        }
        strongSelf.hideBlock = nil;
        [strongSelf reloadGraph];
    } failure:^(NSString *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.hideBlock) {
            strongSelf.hideBlock();
        }
        strongSelf.hideBlock = nil;
        [strongSelf reloadGraph];
    }];
}

- (void)reloadGraph {
    
    self.userEnergyLabel.text = self.model.userEnergy;
    self.userSavingsLabel.text = self.model.userSavings;
    self.communityEnergyLabel.text = self.model.communityEnergy;
    self.communitySavingsLabel.text = self.model.communitySavings;
    
    self.monthLabel.text = [self.model.plotDataSource monthText];
    
    if (self.barPlot) {
        [self.graph removePlot:self.barPlot];
        self.barPlot = nil;
    }
    if (self.scatterPlot) {
        [self.graph removePlot:self.scatterPlot];
        self.scatterPlot = nil;
    }
    
    
    CPTXYGraph *graph = self.graph;
    
    // Add plot space for horizontal bar charts
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(self.plotDataSource.yVisibleRangeLength)];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f)
                                                    length:CPTDecimalFromFloat(self.plotDataSource.xLength)];
    
    //Setup axes
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    
    //Setup X
    CPTXYAxis *x          = axisSet.xAxis;
    x.axisLineStyle               = nil;
    x.majorTickLineStyle          = nil;
    x.minorTickLineStyle          = nil;
    x.majorIntervalLength         = CPTDecimalFromDouble(2.0);
    x.orthogonalCoordinateDecimal = CPTDecimalFromDouble(0.0);
    x.titleLocation               = CPTDecimalFromFloat(7.5f);
    x.titleOffset                 = 55.0;
    
    // Define some custom labels for the data elements
    x.labelRotation  = -M_PI_4;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    CPTMutableTextStyle *labelStyle = [[CPTMutableTextStyle alloc] init];
    labelStyle.fontName = kCHAKlavikaFontName;
    labelStyle.fontSize = 10.f;
    labelStyle.color = [CPTColor colorWithCGColor:self.grayColor.CGColor];
    
    NSDictionary *labels = [self.plotDataSource customTexts];
    NSArray *keys = [labels allKeys];
    NSMutableSet *customLabels   = [NSMutableSet setWithCapacity:[keys count]];
    for ( NSNumber *tickLocation in keys ) {
        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:labels[tickLocation] textStyle:labelStyle];
        newLabel.tickLocation = [tickLocation decimalValue];
        newLabel.offset       = x.labelOffset + x.majorTickLength;
        [customLabels addObject:newLabel];
    }
    
    x.axisLabels = customLabels;
    
    //Setup Y
    CHAPlotFormatter *plotFormatter = [CHAPlotFormatter new];
    
    CPTMutableLineStyle *yLineStyle = [[CPTMutableLineStyle alloc] init];
    yLineStyle.lineColor = [CPTColor colorWithCGColor:self.grayColor.CGColor];
    
    CPTXYAxis *y = axisSet.yAxis;
    y.labelFormatter = plotFormatter;
    y.labelOffset = 5.f;
    y.axisLineStyle               = yLineStyle;
    y.majorTickLineStyle          = yLineStyle;
    y.minorTickLineStyle          = nil;
    y.majorIntervalLength         = CPTDecimalFromDouble([self.plotDataSource yMajorIntervalLength]);
    y.orthogonalCoordinateDecimal = CPTDecimalFromDouble(0.0);
    y.title                       = @"WH";
    y.titleOffset                 = 45.0;
    y.titleLocation               = CPTDecimalFromFloat(50.0f);
    y.visibleRange                = [[CPTPlotRange alloc] initWithLocation:@(0).decimalValue
                                                                    length:@(self.plotDataSource.yVisibleRangeLength).decimalValue];
    
    // First bar plot
    CPTBarPlot *barPlot = [[CPTBarPlot alloc] init];
    
    CPTMutableLineStyle *barStyle = [CPTMutableLineStyle new];
    UIColor *color = [UIColor clearColor];
    CPTColor *lineColor = [CPTColor colorWithCGColor:color.CGColor];
    barStyle.lineColor = lineColor;
    CPTFill *fill = [CPTFill fillWithColor:lineColor];
    barPlot.fill = fill;
    barPlot.lineStyle = barStyle;
    
    
    barPlot.baseValue  = CPTDecimalFromDouble(0.0);
    barPlot.dataSource = self.plotDataSource;
    barPlot.barOffset  = CPTDecimalFromFloat(.2f);
    barPlot.identifier = @"Bar Plot 1";
    self.plotDataSource.barPlot = barPlot;
    
    CABasicAnimation *animation = ({
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
        [anim setDuration:2.0f];
        anim.toValue = [NSNumber numberWithFloat:1.0f];
        anim.fromValue = [NSNumber numberWithFloat:0.0f];
        anim.removedOnCompletion = NO;
        anim.delegate = self;
        anim.fillMode = kCAFillModeForwards;
        anim.duration = .3f;
        anim;
    });
    barPlot.anchorPoint = CGPointMake(0.0, 0.0);
    [barPlot addAnimation:animation forKey:@"grow"];
    self.barPlot = barPlot;
    
    [graph addPlot:barPlot toPlotSpace:plotSpace];
    
    //second bar plot
    CPTScatterPlot *plot = [[CPTScatterPlot alloc] init];
    plot.dataSource = self.plotDataSource;
    CPTMutableLineStyle *style = [CPTMutableLineStyle new];
    style.lineWidth = 2.f;
    style.lineColor = [CPTColor colorWithCGColor:[UIColor orangeColor].CGColor];
    plot.dataLineStyle = style;
    self.scatterPlot = plot;
    
    
    [graph addPlot:plot toPlotSpace:plotSpace];
    
    self.graph = graph;
    
    [graph reloadData];
}

#pragma mark - Properties

- (UIColor *)grayColor {
    if (!_grayColor) {
        _grayColor = [UIColor colorWithRed:165.f/255.f green:172.f/255.f blue:178.f/255.f alpha:1.f];
    }
    return _grayColor;
}

#pragma mark - Private

- (UIImage *)snapshot {
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, UIScreen.mainScreen.scale);
    [self.allView drawViewHierarchyInRect:self.allView.frame afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - IBAction

- (IBAction)nextButtonTouchUpInside:(id)sender {
    if ([self.plotDataSource moveForwardIfPossible]) {
        [self reloadData];
    }
}

- (IBAction)previousButtonTouchUpInside:(id)sender {
    [self.plotDataSource moveBackward];
    [self reloadData];
}

- (IBAction)menuButtonTouchUpInside:(id)sender {
    [self.revealController showViewController:self.revealController.leftViewController];
}

- (IBAction)shareButtonTouchUpInside {
    NSDictionary *userStatistics = [[NSUserDefaults standardUserDefaults] valueForKey:@"statistics.user.dashboard"];
    CGFloat co2balance = [[userStatistics valueForKey:@"co2balance"] floatValue] / 1000.f;
    NSString *shareText = [NSString stringWithFormat:@"My CO2 balance is %.2f kg on @Changerscom\nMonitore your own balance here http://itunes.apple.com/app/id642099621add", co2balance];
    
    UIImage *image = [self snapshot];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:@[shareText, image]
                                                                            applicationActivities:nil];
    controller.excludedActivityTypes = @[UIActivityTypePostToWeibo,
                                         UIActivityTypeMessage,
                                         UIActivityTypeMail,
                                         UIActivityTypePrint,
                                         UIActivityTypeCopyToPasteboard,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypeSaveToCameraRoll,
                                         UIActivityTypeAddToReadingList,
                                         UIActivityTypePostToFlickr,
                                         UIActivityTypePostToVimeo,
                                         UIActivityTypePostToTencentWeibo,
                                         UIActivityTypeAirDrop];
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)leftButtonTouchUpInside:(id)sender {
    CHADashboardContainerViewController *parent = (CHADashboardContainerViewController *)self.parentViewController;
    [parent moveLeft];
}

- (IBAction)rightButtonTouchUpInside:(id)sender {
    CHADashboardContainerViewController *parent = (CHADashboardContainerViewController *)self.parentViewController;
    [parent moveRight];
}

@end
