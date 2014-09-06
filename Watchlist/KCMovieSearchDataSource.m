//
//  KCMovieSearchDataSource.m
//  Watchlist
//
//  Created by Kevin on 01/08/13.
//  Copyright (c) 2013 Kevin Chavez. All rights reserved.
//

#import "KCMovieSearchDataSource.h"

@implementation KCMovieSearchDataSource

-(id)init{
    if (self = [super init]) {
        _fetcher = [[KCMovieFetcher alloc] init];
        [_fetcher setDelegate:self];
    }
    return self;
}

- (void)textField:(KCAutoCompleteTextField *)textField requestSuggestionsForString:(NSString *)string
{   if (_field == nil) {
    _field = textField;
}
    [_fetcher searchOMDBAPIWithQuery:string];
}

- (void)movieFetcherDidRecieveOMDBAPISearchResults:(NSDictionary *)results
{
    NSMutableArray *temp = [NSMutableArray array];
    
    for (NSDictionary *item in [results objectForKey:@"Search"]) {
        
        if ([[item objectForKey:@"Type"] isEqualToString:@"movie"]) {
            [temp addObject:[NSString stringWithFormat:@"%@ (%@)",
                             [item objectForKey:@"Title"],
                             [item objectForKey:@"Year"]]];
        }

    }
    _suggestions = [NSArray arrayWithArray:temp];
    [_field reloadSuggestionsWithArray:_suggestions];
    
    //NSLog(@"SUGGESTIONS:%@", _suggestions);

    // Load full data into array for further use
    _suggestionsInfo = [results objectForKey:@"Search"];
}



@end
