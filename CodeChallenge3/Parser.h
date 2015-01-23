//
//  Parser.h
//  CodeChallenge3
//
//  Created by Gustavo Couto on 2015-01-23.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ParserDelegate <NSObject>

@optional

-(void)fetchedBikes:(NSMutableArray *)bikeArray;

@end

@interface Parser : NSObject

@property (nonatomic, weak) id<ParserDelegate> delegate;

-(void)getBikeInformationFromUrl;


@end
