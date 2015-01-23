//
//  Bike.m
//  CodeChallenge3
//
//  Created by Gustavo Couto on 2015-01-23.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import "Bike.h"

@implementation Bike

-(instancetype)initWithDictionary:(NSDictionary *)bikeDictionary
{
    self = [super init];
    if (self) {

        self.stationName = bikeDictionary[@"stationName"];
        self.availableBikes = bikeDictionary[@"availableBikes"];
        self.latitude = bikeDictionary[@"latitude"];
        self.longitude = bikeDictionary[@"longitude"];
        self.totalDocks = bikeDictionary[@"totalDocks"];
        self.availableDocks = bikeDictionary[@"availableDocks"];
        self.statusValue = bikeDictionary[@"statusValue"];

    }
    return self;
}

@end
