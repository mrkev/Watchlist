//
//  KCMovieInformationDataSource.h
//  Watchlist
//
//  Created by Kevin on 08/08/13.
//  Copyright (c) 2013 Kevin Chavez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCMovieFetcher.h"
#import "DBMovieEntities.h"


@protocol KCMovieInformationDataSourceDelegate;

@interface KCMovieInformationDataSource : NSObject <KCMovieFetcherDelegate>

@property (assign, nonatomic) id<KCMovieInformationDataSourceDelegate> delegate;

- (void)addObjectToInformationRequestQueue:(id)object;

@end

@protocol KCMovieInformationDataSourceDelegate <NSObject>

@optional

- (void)movieInformationDataSource:(KCMovieInformationDataSource *)mids didFetchInformationForMovie:(DBMovie *)movie;
- (void)movieInformationDataSource:(KCMovieInformationDataSource *)mids didFetchPosterImageForMovie:(DBMovie *)movie;

@end