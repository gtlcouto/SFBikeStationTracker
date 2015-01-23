//
//  MapViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property CLLocationManager * myLocationManager;
@property MKPointAnnotation * myAnnotation;



@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Load my current location again in case the user took a long time to select a bike station from the table view
    [self loadMyLocation];
    //load map with pins from the current object
    [self loadPinFromObject];
}


#pragma mark - MapView  Delegate Methods
//Gets called for every annotation on map
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{


    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
    pin.image = [UIImage imageNamed:@"bikeImage"];
    pin.canShowCallout = YES;

    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:annotation.title forState:UIControlStateNormal];
    [pin setRightCalloutAccessoryView:rightButton];

    if (annotation == mapView.userLocation)
    {
        return nil;
    }


    return pin;

}

#pragma mark - Location Manager Delegate Methods
//in case location update fails
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog (@"%@", error);
}
//gets called evertime user location updates
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *location in locations)
    {
        if (location.verticalAccuracy < 1000 && location.horizontalAccuracy < 1000)
        {
            //if want to use red pin for user
//            self.myAnnotation = [MKPointAnnotation new];
//            self.myAnnotation.title = @"My Location";
//            self.myAnnotation.coordinate = location.coordinate;
//            [self.mapView addAnnotation:self.myAnnotation];
            //if want to use blue circle
            self.mapView.showsUserLocation = YES;
            [self.myLocationManager stopUpdatingLocation];
            break;
        }
    }
}


#pragma mark - IBAction Methods

//when accessory button in the pin is clicked
- (void)buttonTapped:(UIButton *)sender
{
    //give directions to current station
    [self getDirectionsTo];

    
}


#pragma mark - Helper Methods

//get our location again
-(void)loadMyLocation
{
    self.myLocationManager = [CLLocationManager new];
    [self.myLocationManager requestWhenInUseAuthorization];
    self.myLocationManager.delegate = self;
    [self.myLocationManager startUpdatingLocation];
}

//helper method to get directions to current bike station
-(void)getDirectionsTo
{
    //Create a request using current location as the source
    MKDirectionsRequest *request = [MKDirectionsRequest new];
    request.source = [MKMapItem mapItemForCurrentLocation];
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake([self.currentBike.latitude doubleValue], [self.currentBike.longitude doubleValue]) addressDictionary:nil];
    MKMapItem *destinationMapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    request.destination = destinationMapItem;
    //Get directions for specified request
    MKDirections *directions = [[MKDirections alloc]initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error)
    {
        NSArray *routes = response.routes;
        // Get the first route from array of multiple routes
        MKRoute *route = routes.firstObject;
        int x = 1;
        NSMutableString *directionsString = [NSMutableString string];
        for (MKRouteStep *step in route.steps)
        {
            [directionsString appendFormat:@"%d: %@\n", x, step.instructions];
            x++;
        }
        UIAlertView * directionsAlert = [UIAlertView new];
        directionsAlert.title = [NSString stringWithFormat:@"Directions to: %@", self.currentBike.stationName];
        directionsAlert.message = directionsString;
        [directionsAlert addButtonWithTitle:@"Ok"];
        [directionsAlert show];
    }];
}

//helper method to load the map with pin from the current object
-(void)loadPinFromObject
{
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([self.currentBike.latitude floatValue], [self.currentBike.longitude floatValue]);
    annotation.title = self.currentBike.stationName;
    annotation.subtitle = [NSString stringWithFormat:@"Available Bikes: %@", self.currentBike.availableBikes];
    annotation.coordinate = coordinate;
    [self.mapView addAnnotation:annotation];
    CLLocationCoordinate2D centerCoordinate = coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, span);
    [self.mapView setRegion:region animated:YES];
}
@end
