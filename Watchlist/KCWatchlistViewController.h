//
//  KCWatchlistViewController.h
//  Watchlist
//
//  Created by Kevin Chavez on 12/4/13.
//  Copyright (c) 2013 Kevin Chavez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "KCMovieSearchDataSource.h"
#import "KCMovieInformationDataSource.h"

@interface KCMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate, UITextFieldDelegate, KCAutoCompleteDelegate>

// Core Data
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

// Add Movie View
@property (weak, nonatomic) IBOutlet UIView *addMovieView;
@property (weak, nonatomic) IBOutlet KCAutoCompleteTextField *addMovieTitle;
@property (weak, nonatomic) IBOutlet UITextField *addMovieYear;

@property (strong, nonatomic) KCMovieSearchDataSource *moveSearchDataSource;
@property (strong, nonatomic) KCMovieInformationDataSource *movieInformationDataSource;

- (IBAction)addMovie:(id)sender;


@end
