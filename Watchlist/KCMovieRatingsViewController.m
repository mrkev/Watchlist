//
//  KCMovieRatingsViewController.m
//  Watchlist
//
//  Created by Kevin on 16/9/13.
//  Copyright (c) 2013 Kevin Chavez. All rights reserved.
//

#import "KCMovieRatingsViewController.h"

@interface KCMovieRatingsViewController ()

@end

@implementation KCMovieRatingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)configureView
{
    NSString *tm = (_ratingsObject.tomatoMeter) ?
    [NSString stringWithFormat:@"%@%%", _ratingsObject.tomatoMeter] : @"--";
    _lbl_tomatometer.text = tm;
    
    _lbl_rating.text = [NSString stringWithFormat:@"%@", _ratingsObject.tomatoRating];
    NSString *fresh = [NSString stringWithFormat:@"%@ fresh", _ratingsObject.tomatoReviewsFresh];
    _lbl_fresh.text = fresh;
    NSString *rotten = [NSString stringWithFormat:@"%@ rotten", _ratingsObject.tomatoReviewsRotten];
    _lbl_rotten.text = rotten;
    _lbl_tomatoimage.text = [_ratingsObject.tomatoImage capitalizedString];
    
    NSLog(@"%@", _ratingsObject);
    
    _txt_consensus.text = _ratingsObject.tomatoConsensus;
    _prgs_tomatometer.progress = [_ratingsObject.tomatoReviewsFresh floatValue] / ([_ratingsObject.tomatoReviews floatValue]);
    
    NSString *um = (_ratingsObject.tomatoUserMeter) ?
    [NSString stringWithFormat:@"%@%%", _ratingsObject.tomatoUserMeter] : @"--";
    _lbl_usermeter.text = um;
    
    _lbl_userRating.text = [NSString stringWithFormat:@"%@", _ratingsObject.tomatoUserRating];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self configureView];
    
    UISwipeGestureRecognizer *sgr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack:)];
    [self.view addGestureRecognizer:sgr];
    
    [sgr setDirection:UISwipeGestureRecognizerDirectionRight];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
