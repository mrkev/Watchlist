///Users/Kevin/Dropbox/Develop/iOS/Watchlist/Watchlist/KCMovieViewController.h
//  KCMovieViewController.h
//  Watchlist
//
//  Created by Kevin Chavez on 12/4/13.
//  Copyright (c) 2013 Kevin Chavez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBMovieEntities.h"

@interface KCDetailViewController : UIViewController

@property (strong, nonatomic) DBMovie *movieObject;

@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_actors;
@property (weak, nonatomic) IBOutlet UILabel *lbl_director;

@property (weak, nonatomic) IBOutlet UILabel *lbl_duration;
@property (weak, nonatomic) IBOutlet UILabel *lbl_release;
@property (weak, nonatomic) IBOutlet UILabel *lbl_genre;
@property (weak, nonatomic) IBOutlet UITextView *txt_summary;
@property (weak, nonatomic) IBOutlet UIImageView *img_poster;
@property (weak, nonatomic) IBOutlet UIImageView *img_rated;

@property (weak, nonatomic) IBOutlet UIView *view_ratings;
@property (weak, nonatomic) IBOutlet UILabel *lbl_tomatometer;
@property (weak, nonatomic) IBOutlet UILabel *lbl_imbdRating;

- (IBAction)expandRatings:(id)sender;
- (IBAction)back:(id)sender;

@end
