//
//  KCMovieRatingsViewController.h
//  Watchlist
//
//  Created by Kevin on 16/9/13.
//  Copyright (c) 2013 Kevin Chavez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBMovieEntities.h"

@interface KCMovieRatingsViewController : UIViewController

@property DBMovieRatings *ratingsObject;

@property (weak, nonatomic) IBOutlet UILabel *lbl_tomatometer;
@property (weak, nonatomic) IBOutlet UILabel *lbl_rating;
@property (weak, nonatomic) IBOutlet UILabel *lbl_fresh;
@property (weak, nonatomic) IBOutlet UILabel *lbl_rotten;

@property (weak, nonatomic) IBOutlet UILabel *lbl_usermeter;
@property (weak, nonatomic) IBOutlet UILabel *lbl_userRating;
@property (weak, nonatomic) IBOutlet UILabel *lbl_tomatoimage;

@property (weak, nonatomic) IBOutlet UITextView *txt_consensus;
@property (weak, nonatomic) IBOutlet UIProgressView *prgs_tomatometer;


- (IBAction)goBack:(id)sender;

@end
