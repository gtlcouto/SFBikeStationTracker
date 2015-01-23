//
//  Parser.m
//  CodeChallenge3
//
//  Created by Gustavo Couto on 2015-01-23.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import "Parser.h"
#import "Bike.h"

@implementation Parser


-(void)getBikeInformationFromUrl
{
        NSMutableArray * bikeObjArray = [NSMutableArray new];
        NSURL *url = [NSURL URLWithString:@"http://www.bayareabikeshare.com/stations/json"];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            NSDictionary * bikesJsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSArray * bikesJsonArray = bikesJsonDictionary[@"stationBeanList"];

            for (NSDictionary * bike in bikesJsonArray)
            {
                Bike * myBike = [[Bike alloc] initWithDictionary:bike];
                [bikeObjArray addObject:myBike];
            }
            //DELEGATE
            [self.delegate fetchedBikes:bikeObjArray];
            
            
        }];
}

@end
