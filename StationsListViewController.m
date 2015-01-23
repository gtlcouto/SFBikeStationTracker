//
//  StationsListViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "StationsListViewController.h"
#import "MapViewController.h"
#import "Parser.h"
#import "Bike.h"
#import <MapKit/MapKit.h>
@interface StationsListViewController () <UITabBarDelegate, UITableViewDataSource, ParserDelegate , CLLocationManagerDelegate, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSMutableArray * bikesMArray;
@property NSMutableArray * filteredBikesMArray;
@property Parser * parser;
@property CLLocationManager * myLocationManager;
@property CLLocation * myLocation;
@property BOOL isFiltered;

@end

@implementation StationsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //alloc init required objects
    [self startUp];
    [self.parser getBikeInformationFromUrl];
    

}


#pragma mark - UITableView Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.isFiltered)
        return self.filteredBikesMArray.count;
    else
        return self.bikesMArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Bike * aBike = [Bike new];
    if (self.isFiltered) {
        aBike = [self.filteredBikesMArray objectAtIndex:indexPath.row];
    }
    else
    {
        aBike = [self.bikesMArray objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = aBike.stationName;
    cell.detailTextLabel.numberOfLines = 5;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Status: %@ \nTotal Docks: %@ \nAvailable Bikes: %@ \nAvailable Docks: %@ \nDistance: %.02f km", aBike.statusValue, aBike.totalDocks, aBike.availableBikes, aBike.availableDocks, aBike.distance];
    return cell;
}

#pragma mark - UISearchBar Delegate Methods

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        self.isFiltered = FALSE;
    }
    else
    {
        self.isFiltered = true;
        self.filteredBikesMArray = [[NSMutableArray alloc] init];

        for (Bike *  bike in self.bikesMArray)
        {
            NSRange nameRange = [bike.stationName rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound)
            {
                [self.filteredBikesMArray addObject:bike];
            }
        }
    }

    [self.tableView reloadData];
}

#pragma mark - Parser Delegate Methods

//get called by parser getBikeInformationFromUrl
-(void)fetchedBikes:(NSMutableArray *)bikeArray
{
    self.bikesMArray = bikeArray;
    [self loadMyLocation];
}

#pragma mark - Location Manager Delegate Methods
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog (@"%@", error);
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *location in locations)
    {
        if (location.verticalAccuracy < 1000 && location.horizontalAccuracy < 1000)
        {
            self.myLocation = location;
            [self.myLocationManager stopUpdatingLocation];
            [self getDistanceAndSortArray];
            break;
        }
    }
}



#pragma mark - Helper Methods

//alloc init any property and set delegates
-(void)startUp
{
    self.bikesMArray = [NSMutableArray new];
    self.parser = [Parser new];
    self.parser.delegate = self;
    self.searchBar.delegate = self;
}

//Helper method to get distance from station and sort the array based on distance
//Get called every time user updates location by didUpdateLocations
-(void)getDistanceAndSortArray
{
    for (Bike * bike in self.bikesMArray) {
        CLLocation *bikeStopLocation = [[CLLocation alloc] initWithLatitude:[bike.latitude doubleValue] longitude:[bike.longitude doubleValue]];
        bike.distance = [bikeStopLocation distanceFromLocation:self.myLocation]/1000;
    }
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES];
    NSArray *sortedArray = [self.bikesMArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    self.bikesMArray = [[NSArray arrayWithArray:sortedArray]mutableCopy];

    [self.tableView reloadData];

}

//start tracking user location
//Get called by fetchedBikes to make sure that we have stations loaded in the array
-(void)loadMyLocation
{
    self.myLocationManager = [CLLocationManager new];
    [self.myLocationManager requestWhenInUseAuthorization];
    self.myLocationManager.delegate = self;
    [self.myLocationManager startUpdatingLocation];
}


#pragma mark - Segue Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MapViewController * mvc = segue.destinationViewController;
    if (self.isFiltered) {
       mvc.currentBike = [self.filteredBikesMArray objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    }
    else {
        mvc.currentBike = [self.bikesMArray objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    }


}

@end
