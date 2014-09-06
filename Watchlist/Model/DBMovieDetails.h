//
//  DBMovieDetails.h
//  Watchlist
//
//  Created by Kevin on 12/9/13.
//  Copyright (c) 2013 Kevin Chavez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBMovie;

@interface DBMovieDetails : NSManagedObject

@property (nonatomic, retain) NSString * actors;
@property (nonatomic, retain) NSString * boxOffice;
@property (nonatomic, retain) NSString * director;
@property (nonatomic, retain) NSString * dvdDate;
@property (nonatomic, retain) NSString * genre;
@property (nonatomic, retain) NSString * plot;
@property (nonatomic, retain) NSData * posterData;
@property (nonatomic, retain) NSString * poster;
@property (nonatomic, retain) NSString * production;
@property (nonatomic, retain) NSString * rated;
@property (nonatomic, retain) NSString * released;
@property (nonatomic, retain) NSString * runtime;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * trailerURL;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSString * writer;
@property (nonatomic, retain) DBMovie *movie;

@end
