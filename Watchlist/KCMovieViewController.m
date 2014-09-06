//
//  KCDetailViewController.m
//  Watchlist
//
//  Created by Kevin Chavez on 12/4/13.
//  Copyright (c) 2013 Kevin Chavez. All rights reserved.
//

#import "KCMovieViewController.h"
#import "KCMovieRatingsViewController.h"

@interface KCDetailViewController ()
- (void)configureView;
@end

@implementation KCDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_movieObject != newDetailItem) {
        _movieObject = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (_movieObject) {
        DBMovieDetails *_detailsObject = _movieObject.details;
        
        _lbl_title.text    = _movieObject.title;
        
        _lbl_duration.text  = _detailsObject.runtime;
        _lbl_actors.text  = _detailsObject.actors;
        _lbl_director.text = _detailsObject.director;
        _lbl_release.text   = _detailsObject.released;
        _lbl_genre.text     = _detailsObject.genre;
        
        _txt_summary.text   = _detailsObject.plot;
        
        CGRect frame        = _txt_summary.frame;
        frame.size.height   = _txt_summary.contentSize.height;
        _txt_summary.frame  = frame;
        
        // Box Office
        // DVD
        // Website
        
        // Response
        // Type
        
        _img_poster.image   = [UIImage imageWithData:_detailsObject.posterData];
        _img_rated.image    = [[self movieRatingImageDictionary] objectForKey:_detailsObject.rated];
        NSLog(@"%@", _detailsObject.rated);
        
        [self updateRatings];
    }
}

- (void)updateRatings
{
    DBMovieRatings *_ratingsObject = _movieObject.ratings;
    
    NSString *ir = (_ratingsObject.imdbRating) ?
    [NSString stringWithFormat:@"%@", _ratingsObject.imdbRating] : @"--";
    
    NSString *tm = (_ratingsObject.tomatoMeter) ?
    [NSString stringWithFormat:@"%@%%", _ratingsObject.tomatoMeter] : @"--";
    
    _lbl_imbdRating.text    = ir;
    _lbl_tomatometer.text   = tm;

}

- (void)expandRatings:(id)sender
{
    [UIView animateWithDuration:1.0 animations:^{
        CGRect frame = _view_ratings.frame;
        frame.size.height = _view_ratings.frame.size.height + 100;
        _view_ratings.frame = frame;
    }];
}

- (IBAction)back:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (NSDictionary *)movieRatingImageDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [UIImage imageNamed:@"RATED_G"], @"G",
            [UIImage imageNamed:@"RATED_PG"], @"PG-13",
            [UIImage imageNamed:@"RATED_PG-13" ], @"PG",
            [UIImage imageNamed:@"RATED_NC-17"], @"NC-17",
            [UIImage imageNamed:@"RATED_R"], @"R",
            [UIImage imageNamed:@"RATED_NA"], @"Unrated",
            [UIImage imageNamed:@"RATED_NA"], @"N/A", nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showRating"]) {
        [[segue destinationViewController] setRatingsObject:_movieObject.ratings];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
