//
//  DBMovieRatings.h
//  Watchlist
//
//  Created by Kevin on 17/9/13.
//  Copyright (c) 2013 Kevin Chavez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBMovie;

@interface DBMovieRatings : NSManagedObject

@property (nonatomic, retain) NSNumber * imdbRating;
@property (nonatomic, retain) NSNumber * imdbVotes;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * tomatoConsensus;
@property (nonatomic, retain) NSString * tomatoImage;
@property (nonatomic, retain) NSNumber * tomatoMeter;
@property (nonatomic, retain) NSNumber * tomatoRating;
@property (nonatomic, retain) NSNumber * tomatoReviews;
@property (nonatomic, retain) NSNumber * tomatoReviewsFresh;
@property (nonatomic, retain) NSNumber * tomatoReviewsRotten;
@property (nonatomic, retain) NSNumber * tomatoUserMeter;
@property (nonatomic, retain) NSNumber * tomatoUserRating;
@property (nonatomic, retain) NSNumber * tomatoUserReviews;
@property (nonatomic, retain) DBMovie *movie;

@end
