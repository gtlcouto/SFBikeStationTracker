//
//  Bike.h
//  CodeChallenge3
//
//  Created by Gustavo Couto on 2015-01-23.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Bike : NSObject

@property NSString * stationName;
@property NSNumber * availableBikes;
@property NSNumber * latitude;
@property NSNumber * longitude;
@property NSNumber * totalDocks;
@property NSNumber * availableDocks;
@property NSString * statusValue;
@property CLLocationDistance distance;


-(instancetype)initWithDictionary:(NSDictionary *)bikeDictionary;

@end
