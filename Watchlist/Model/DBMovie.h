//
//  DBMovie.h
//  Watchlist
//
//  Created by Kevin on 9/5/13.
//  Copyright (c) 2013 Kevin Chavez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBMovieDetails, DBMovieRatings;

@interface DBMovie : NSManagedObject

@property (nonatomic, retain) NSString * imdbID;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * userLiked;
@property (nonatomic, retain) NSString * userReview;
@property (nonatomic, retain) NSNumber * userStars;
@property (nonatomic, retain) NSString * year;
@property (nonatomic, retain) DBMovieDetails *details;
@property (nonatomic, retain) DBMovieRatings *ratings;

@end
