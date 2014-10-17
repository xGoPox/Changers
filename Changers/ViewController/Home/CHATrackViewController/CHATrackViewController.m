//
//  CHATrackViewController.m
//  Changers
//
//  Created by Denis on 08.09.14.
//  Copyright (c) 2014 Changers. All rights reserved.
//

#import "CHATrackViewController.h"
#import <MapKit/MapKit.h>
#import "CHATrackerTheme.h"
#import "BlurryModalSegue.h"
#import <CoreLocation/CoreLocation.h>
#import "CHASavedLocationAnnotationView.h"
#import "CHATrackResultsViewController.h"
#import "CHACHAChooseTransportTypeViewController.h"

#define MINIMUM_ZOOM_ARC 0.045 //approximately 5 km (1 degree of arc ~= 111 km)
#define ANNOTATION_REGION_PAD_FACTOR 1.8
#define MAX_DEGREES_ARC 360

@interface CHATrackViewController () <MKMapViewDelegate, CLLocationManagerDelegate, CHATrackerDelegate, CHAChooseTransportDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *startStopButton;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) NSTimer *durationTimer;
@property (weak, nonatomic) IBOutlet UILabel *co2EmissionLabel;
@property (weak, nonatomic) IBOutlet UILabel *co2SavingLabel;
@property (weak, nonatomic) IBOutlet UILabel *recoinsLabel;

- (IBAction)backButtonTapHandler:(id)sender;
- (IBAction)startStopButtonTapHandler:(id)sender;
@end

@implementation CHATrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.tracker.trackerTheme.title;
    self.tracker.delegate = self;
    if (self.tracker.isTracking) {
        for (CLLocation *location in self.tracker.savedLocations) {
            MKPointAnnotation *annotation = [MKPointAnnotation new];
            annotation.coordinate = location.coordinate;
            [self.mapView addAnnotation:annotation];
        }
        [self zoomMapViewToFitAnnotations:self.mapView animated:YES];
        
        //Move
        [self durationTimerTick:nil];
        self.durationTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(durationTimerTick:) userInfo:nil repeats:YES];
        [self.tracker updateTrackInfo];
    }
    
    if ([[UIApplication sharedApplication] backgroundRefreshStatus] != UIBackgroundRefreshStatusAvailable) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Background Refresh Disabled", nil) message:NSLocalizedString(@"You must enable Background Refresh in order for GPS to work correctley. To do this please go to your iPhone Settings > General > Background App Refresh", nil) delegate:nil cancelButtonTitle:kCHAMessageOK otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:self.tracker.trackerTheme.tintColor];
    if (self.tracker.isTracking) {
        [self.startStopButton setImage:self.tracker.trackerTheme.stopButtonNormalImage forState:UIControlStateNormal];
        [self.startStopButton setImage:self.tracker.trackerTheme.stopButtonHighlitedImage forState:UIControlStateHighlighted];
    } else {
        [self.startStopButton setImage:self.tracker.trackerTheme.startButtonNormalImage forState:UIControlStateNormal];
        [self.startStopButton setImage:self.tracker.trackerTheme.startButtonHighlitedImage forState:UIControlStateHighlighted];
        self.timerLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timer_bg"]];
    }
}

#pragma mark - User interaction

- (IBAction)backButtonTapHandler:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)startStopButtonTapHandler:(id)sender {
    if (self.tracker.isTracking) {
        [self.tracker stopTracker];
        [self.durationTimer invalidate];
        self.durationTimer = nil;
        [self.startStopButton setImage:self.tracker.trackerTheme.startButtonNormalImage forState:UIControlStateNormal];
        [self.startStopButton setImage:self.tracker.trackerTheme.startButtonHighlitedImage forState:UIControlStateHighlighted];
        
        //------------
        if ([self.tracker isJourneySpeedInLimits]) {
            if (self.tracker.trackerType == TrackerTypeCar || self.tracker.trackerType == TrackerTypePlane) {
                [self performSegueWithIdentifier:@"TrackerEmmissionResultSegue" sender:nil];
            } else {
                [self performSegueWithIdentifier:@"TrackerResultSegue" sender:nil];
            }
        } else {
            [self performSegueWithIdentifier:@"ChooseTransportTypeSegue" sender:nil];
        }
    } else {
        [self.tracker startTracker:^(BOOL started) {
            if (started) {
                self.timerLabel.text = @"00:00:00";
                self.speedLabel.text = @"0";
                self.durationTimer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(durationTimerTick:) userInfo:nil repeats:YES];
                [self tracker:self.tracker didUpdateInfo:self.tracker.tracking];
                [self.startStopButton setImage:self.tracker.trackerTheme.stopButtonNormalImage forState:UIControlStateNormal];
                [self.startStopButton setImage:self.tracker.trackerTheme.stopButtonHighlitedImage forState:UIControlStateHighlighted];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"Location services are disabled for Changers. You must enable Location Services in the iPhone Settings > Privacy > Location Services." delegate:nil cancelButtonTitle:kCHAMessageOK otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
}

#pragma mark - Timer

- (void)durationTimerTick:(NSTimer *)timer {
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.tracker.tracking.startDate];
    NSInteger ti = (NSInteger)timeInterval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    self.timerLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (!self.tracker.isTracking) {
        if (self.mapView.region.span.latitudeDelta > 5 || self.mapView.region.span.longitudeDelta > 5) {
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, 5000, 5000);
            
            [self.mapView setRegion:region animated:YES];
        }
    } else {
        if (userLocation.location.speed > 0.f) {
            self.speedLabel.text = [NSString stringWithFormat:@"%.f", userLocation.location.speed/1000*3600];
        } else {
            self.speedLabel.text = @"0";
        }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString* annotationIdentifier = @"UserLocationAnnottion";
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        MKAnnotationView *pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (!pinView) {
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
            pinView.image = self.tracker.trackerTheme.userAnnotationImage;
            CGPoint imageOffset = CGPointMake(0, -(pinView.image.size.height/2));
            pinView.centerOffset = imageOffset;
            pinView.canShowCallout = NO;
        }
        return pinView;
    } else {
        CHASavedLocationAnnotationView *annotationView = (CHASavedLocationAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"savedLocationAnnotationView"];
        if (!annotationView) {
            annotationView = [[CHASavedLocationAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"savedLocationAnnotationView" color:self.tracker.trackerTheme.tintColor];
        } else {
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    return nil;
}

#pragma mark - CHATrackerDelegate

- (void)tracker:(CHATracker *)tracker didSaveLocation:(CLLocation *)location {
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotation.coordinate = location.coordinate;
    [self.mapView addAnnotation:annotation];
    [self zoomMapViewToFitAnnotations:self.mapView animated:YES];
}

- (void)tracker:(CHATracker *)tracker didUpdateInfo:(CHATracking *)trackerInfo {
    NSLog(@"%@", trackerInfo);
    self.distanceLabel.text = [NSString stringWithFormat:@"%.1f", ([trackerInfo.distance integerValue] / 1000.f)];
    self.co2EmissionLabel.text = [NSString stringWithFormat:@"%.2f", [trackerInfo.co2Emitted floatValue] / 1000.f];
    self.co2SavingLabel.text = [NSString stringWithFormat:@"%.2f", [trackerInfo.co2Saved floatValue] / 1000.f];
    self.recoinsLabel.text = [NSString stringWithFormat:@"%.1f", [trackerInfo.recoinsEarned floatValue]];
}

#pragma mark - Map Zooming

- (void)zoomMapViewToFitAnnotations:(MKMapView *)mapView animated:(BOOL)animated
{
    NSArray *annotations = mapView.annotations;
    NSInteger count = [mapView.annotations count];
    if ( count == 0) { return; } //bail if no annotations
    
    //convert NSArray of id <MKAnnotation> into an MKCoordinateRegion that can be used to set the map size
    //can't use NSArray with MKMapPoint because MKMapPoint is not an id
    MKMapPoint points[count]; //C array of MKMapPoint struct
    for( int i=0; i<count; i++ ) //load points C array by converting coordinates to points
    {
        CLLocationCoordinate2D coordinate = [(id <MKAnnotation>)[annotations objectAtIndex:i] coordinate];
        points[i] = MKMapPointForCoordinate(coordinate);
    }
    //create MKMapRect from array of MKMapPoint
    MKMapRect mapRect = [[MKPolygon polygonWithPoints:points count:count] boundingMapRect];
    //convert MKCoordinateRegion from MKMapRect
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    
    //add padding so pins aren't scrunched on the edges
    region.span.latitudeDelta  *= ANNOTATION_REGION_PAD_FACTOR;
    region.span.longitudeDelta *= ANNOTATION_REGION_PAD_FACTOR;
    //but padding can't be bigger than the world
    if( region.span.latitudeDelta > MAX_DEGREES_ARC ) { region.span.latitudeDelta  = MAX_DEGREES_ARC; }
    if( region.span.longitudeDelta > MAX_DEGREES_ARC ){ region.span.longitudeDelta = MAX_DEGREES_ARC; }
    
    //and don't zoom in stupid-close on small samples
    if( region.span.latitudeDelta  < MINIMUM_ZOOM_ARC ) { region.span.latitudeDelta  = MINIMUM_ZOOM_ARC; }
    if( region.span.longitudeDelta < MINIMUM_ZOOM_ARC ) { region.span.longitudeDelta = MINIMUM_ZOOM_ARC; }
    //and if there is a sample of 1 we want the max zoom-in instead of max zoom-out
    if( count == 1 )
    {
        region.span.latitudeDelta = MINIMUM_ZOOM_ARC;
        region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
    }
    [mapView setRegion:region animated:animated];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TrackerResultSegue"] || [segue.identifier isEqualToString:@"TrackerEmmissionResultSegue"]) {
        CHATrackResultsViewController *trackResultsViewController = [segue destinationViewController];
        trackResultsViewController.tracker = self.tracker;
    } else if ([segue.identifier isEqualToString:@"ChooseTransportTypeSegue"]) {
        if ([segue isKindOfClass:[BlurryModalSegue class]]) {
            BlurryModalSegue* bms = (BlurryModalSegue*)segue;
            bms.backingImageTintColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        }
        CHACHAChooseTransportTypeViewController *controller = (CHACHAChooseTransportTypeViewController*)segue.destinationViewController;
        controller.tracker = self.tracker;
        controller.delegate = self;
    }
}

#pragma mark - CHAChooseTransportDelegate

- (void)didChooseTransportType:(TrackerType)transportType {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tracker setTrackerType:transportType];
    [self.tracker updateTrackInfo];
    if ([self.tracker isJourneySpeedInLimits]) {
        if (self.tracker.trackerType == TrackerTypeCar || self.tracker.trackerType == TrackerTypeCar) {
            [self performSegueWithIdentifier:@"TrackerEmmissionResultSegue" sender:nil];
        } else {
            [self performSegueWithIdentifier:@"TrackerResultSegue" sender:nil];
        }
    } else {
        [self performSegueWithIdentifier:@"ChooseTransportTypeSegue" sender:nil];
    }
}

@end
