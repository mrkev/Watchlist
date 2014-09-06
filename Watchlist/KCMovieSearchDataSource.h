//
//  KCMovieSearchDataSource.h
//  Watchlist
//
//  Created by Kevin on 01/08/13.
//  Copyright (c) 2013 Kevin Chavez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLPAutoCompleteTextField.h"
#import "KCMovieFetcher.h"
#import "KCAutoCompleteTextField.h"

@interface KCMovieSearchDataSource : NSObject <MLPAutoCompleteTextFieldDataSource, KCMovieFetcherDelegate, KCAutoCompleteDataSource>

@property (strong, nonatomic) KCMovieFetcher *fetcher;
@property (strong, nonatomic) KCAutoCompleteTextField *field;

@property (strong, nonatomic) NSArray *suggestions;
@property (strong, nonatomic) NSArray *suggestionsInfo;

@end
