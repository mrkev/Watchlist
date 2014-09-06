//
//  KCMovieInformationDataSource.m
//  Watchlist
//
//  Created by Kevin on 08/08/13.
//  Copyright (c) 2013 Kevin Chavez. All rights reserved.
//

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#import "KCMovieInformationDataSource.h"
#import "DBMovieEntities.h"

@interface KCMovieInformationDataSource ()
{
    KCMovieFetcher *_fetcher;
    NSMutableArray *_requests;
    DBMovie *_object;

}

@end

@implementation KCMovieInformationDataSource

- (id)init
{
    self = [super init];
    if (self) {
        _fetcher = [[KCMovieFetcher alloc] init];
        _requests = [NSMutableArray array];
        [_fetcher setDelegate:self];
    }
    return self;
}

- (void)addObjectToInformationRequestQueue:(DBMovie *)object
{
    [_requests addObject:object];
    [self fetchNextMovie];
}

- (void)fetchNextMovie
{
    // TODO:
    // Will only fetch movies with imdbid. Those are the ones
    // gotten from seach. We don't want to override any custom
    // movie by the user.
    
    if ([_requests count] > 0) {
        _object = [_requests objectAtIndex:0];
        [_fetcher fetchAPIDataForMovieTitle:_object.title year:_object.year imdbID:_object.imdbID];
        [_requests removeObjectAtIndex:0];
    }

    else {
        // TODO:
        // Will have to make a new CD entitiy for this maybe?
        // Or somehow check which movies haven't been fetched.
        // Could use timestamp.
    }
}

- (void)movieFetcherDidLoadDataForMovieTags:(NSDictionary *)movie inDictionary:(NSDictionary *)info
{
    // Error detection
    
    if (!_object.details){
        NSLog(@"damn");
        return;
    }
        
    DBMovieDetails *details = _object.details;
    
    details.actors      = [info objectForKey:@"Actors"];
    details.boxOffice   = [info objectForKey:@"BoxOffice"];
    details.dvdDate     = [info objectForKey:@"dvdDate"];
    details.director    = [info objectForKey:@"Director"];
    details.genre       = [info objectForKey:@"Genre"];
    details.plot        = [info objectForKey:@"Plot"];
    details.production  = [info objectForKey:@"Genre"];
    details.rated       = [info objectForKey:@"Rated"];
    details.released    = [info objectForKey:@"Released"];
    details.runtime     = [info objectForKey:@"Runtime"];
    details.website     = [info objectForKey:@"Website"];
    details.writer      = [info objectForKey:@"Writer"];
    details.poster      = [info objectForKey:@"Poster"];
    
    [self requestImageFromURL:[NSURL URLWithString:[info objectForKey:@"Poster"]]];
    
    details.timeStamp = [NSDate date];
    
    
    if (!_object.ratings) {
        NSLog(@"damn ratings");
        return;
    }
    
    DBMovieRatings *ratings = _object.ratings;
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    
    ratings.tomatoConsensus     = [info objectForKey:@"tomatoConsensus"];
    ratings.tomatoMeter         = [f numberFromString:[info objectForKey:@"tomatoMeter"]];
    ratings.tomatoRating        = [f numberFromString:[info objectForKey:@"tomatoRating"]];
    ratings.tomatoReviews       = [f numberFromString:[info objectForKey:@"tomatoReviews"]];
    ratings.tomatoReviewsFresh  = [f numberFromString:[info objectForKey:@"tomatoFresh"]];
    ratings.tomatoReviewsRotten = [f numberFromString:[info objectForKey:@"tomatoRotten"]];
    ratings.tomatoUserMeter     = [f numberFromString:[info objectForKey:@"tomatoUserMeter"]];
    ratings.tomatoUserRating    = [f numberFromString:[info objectForKey:@"tomatoUserRating"]];
    ratings.tomatoUserReviews   = [f numberFromString:[info objectForKey:@"tomatoUserReviews"]];
    ratings.imdbRating          = [f numberFromString:[info objectForKey:@"imdbRating"]];
    ratings.imdbVotes           = [f numberFromString:[info objectForKey:@"imdbVotes"]];
    ratings.tomatoImage         = [info objectForKey:@"tomatoImage"];

    ratings.timeStamp = [NSDate date];
    
    [_delegate movieInformationDataSource:self didFetchInformationForMovie:_object];
    
    [self fetchNextMovie];
}

- (void)movieFetcherDidFailToLoadAPIDataForMovieTags:(NSDictionary *)movieTags withError:(NSError *)error
{
    NSLog(@"Failed to load data. Error: %@", error);
}

#pragma mark -
#pragma mark Information Keys Array Contructors

- (void)requestImageFromURL:(NSURL *)url
{
    dispatch_async(kBgQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        [self performSelectorOnMainThread:@selector(didReciveImageData:)
                               withObject:data waitUntilDone:FALSE];
    });
}

- (void)didReciveImageData:(NSData *)data
{
    DBMovieDetails *details = _object.details;
    details.posterData = data;
    
    [_delegate movieInformationDataSource:self didFetchPosterImageForMovie:_object];
    
    NSLog(@"poster ready");
}

- (NSArray *)arrayWithRatingsKeys
{
    return [NSArray arrayWithObjects:
            @"imdbRating",
            @"imdbVotes",
            @"tomatoConsensus",
            @"tomatoFresh",
            @"tomatoImage",
            @"tomatoMeter",
            @"tomatoRating",
            @"tomatoReviews",
            @"tomatoRotten",
            @"tomatoUserMeter",
            @"tomatoUserRating",
            @"tomatoUserReviews", nil];
}

- (NSArray *)arrayWithDetailsKeys
{
    return [NSArray arrayWithObjects:
            @"Actors",
            @"BoxOffice",
            @"DVD",
            @"Director",
            @"Genre",
            @"Plot",
            @"Poster",
            @"Rated",
            @"Released",
            @"Response",
            @"Runtime",
            @"Type",
            @"Website", nil];
}

- (NSArray *)arrayWithMovieKeys
{
    return [NSArray arrayWithObjects:
            @"Year",
            @"Title",
            @"imdbID", nil];
}

@end