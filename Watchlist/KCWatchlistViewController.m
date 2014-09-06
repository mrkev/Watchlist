//
//  KCMasterViewController.m
//  Watchlist
//
//  Created by Kevin Chavez on 12/4/13.
//  Copyright (c) 2013 Kevin Chavez. All rights reserved.
//

#import "KCWatchlistViewController.h"
#import "KCMovieViewController.h"
#import "MCSwipeTableViewCell.h"
#import "KCMovieFetcher.h"

#import "DBMovieEntities.h"

#define s 70.0

@interface KCMasterViewController () <MCSwipeTableViewCellDelegate, KCMovieInformationDataSourceDelegate>
{
    float headerHeight;
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation KCMasterViewController

#pragma mark - 
#pragma mark Initialization && Memory

- (void)awakeFromNib { [super awakeFromNib]; }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    headerHeight = [[_addMovieTitle superview] bounds].size.height;
    
    UIColor *bgColor = [UIColor colorWithRed:227.0 / 255.0 green:227.0 / 255.0 blue:227.0 / 255.0 alpha:1.0];
        
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(test:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    // Setup UI details
    [[_addMovieTitle superview] setBackgroundColor:bgColor];
    [_addMovieTitle setKeyboardAppearance:UIKeyboardAppearanceAlert];
    [_addMovieTitle setReturnKeyType:UIReturnKeyGo];
    [_addMovieTitle setDelegate:self];

    [_addMovieYear setKeyboardType:UIKeyboardTypeNumberPad];
    [_addMovieYear setKeyboardAppearance:UIKeyboardAppearanceAlert];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [backgroundView setBackgroundColor:bgColor];
    [self.tableView setBackgroundView:backgroundView];
    
     //Autocomplete stuffs
    _moveSearchDataSource = [[KCMovieSearchDataSource alloc] init];
    [_addMovieTitle setDataSource:_moveSearchDataSource];
    [_addMovieTitle setAutoCompleteDelegate:self];
    [_addMovieTitle setReferenceView:_addMovieTitle.superview];
    [_addMovieTitle setSuggestionsTablePosition:KCSuggestionsTablePositionInsideReferenceView];
    /*[_addMovieTitle setAutoCompleteDataSource:_moveSearchDataSource];
    [_addMovieTitle setAutoCompleteTableCellBackgroundColor:[UIColor whiteColor]];
    [_addMovieTitle setAutoCompleteTableCornerRadius:0.0f];*/
    
    _movieInformationDataSource = [[KCMovieInformationDataSource alloc] init];
    [_movieInformationDataSource setDelegate:self];
    
    // Header spring view
    self.tableView.contentInset = UIEdgeInsetsMake(-headerHeight, 0, 0, 0);

}

#pragma mark -
#pragma Scrolling / Add movie

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _addMovieTitle) {
        [self addMovie:nil];
    }
    
    return TRUE;
}

- (IBAction)addMovie:(id)sender {
    [_addMovieTitle resignFirstResponder];
    [self addMovieWithTitle:[_addMovieTitle text] year:[_addMovieYear text] imdbid:nil];
}

- (void)addMovieWithTitle:(NSString *)title year:(NSString *)year imdbid:(NSString *)imdbid
{
    NSDictionary *object = [NSDictionary dictionaryWithObjectsAndKeys:
                            title, @"title", year, @"year", imdbid, @"imdbID", nil];
    [self insertNewObject:object];
    
    [_addMovieTitle reset];

    // Hide addMovie header
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsMake(-headerHeight, 0, 0, 0);
    }];
}

- (void)textField:(KCAutoCompleteTextField *)textField didRequestSuggestionsForString:(NSString *)string
{
    
}

- (void)textField:(KCAutoCompleteTextField *)textField didSelectSuggestionWithString:(NSString *)string indexPath:(NSIndexPath *)indexPath
{
    NSDictionary *source = [[_moveSearchDataSource suggestionsInfo] objectAtIndex:indexPath.row];
    [self addMovieWithTitle:source[@"Title"] year:source[@"Year"] imdbid:source[@"imdbID"]];
}

- (void)addedNewObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    if ([object isKindOfClass:[DBMovie class]]) {
        DBMovie *movie = (DBMovie *)object;
        if (movie.imdbID) {
            [self requestMovieInfoForObject:object];
            
        }
        
        
    } //NSLog(@"New Object be like: %@ \n at index path: %@", object, indexPath);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBMovie *movie = [_fetchedResultsController objectAtIndexPath:indexPath];
    if ([movie imdbID]) {
        UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
        [cell setBackgroundColor:[UIColor whiteColor]];
        
        UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [ai startAnimating];
        [cell setAccessoryView:ai];
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    float offset_for_header_textfield_only
    = 0; //(_addMovieView.frame.size.height - ADD_MOVIE_HEADER_SNAP_HEIGHT);
    
    if (scrollView.contentOffset.y <= offset_for_header_textfield_only) {
        // Released above the header
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.contentInset = UIEdgeInsetsMake(-offset_for_header_textfield_only, 0, 0, 0);
        }];
        
        [_addMovieTitle becomeFirstResponder]; // to 2a.
    } else {
        // Released below the header
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.contentInset = UIEdgeInsetsMake(-headerHeight, 0, 0, 0);
        }];
        
        [self.view endEditing:YES];
    }
}

#pragma mark Watchlist

/*
 Setup numbers for the table view. How many, how big... that sort of stuff
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

/*
 Give this table view some cells!
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get a cell or make one
    static NSString *identifier = @"MovieCell";
    MCSwipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[MCSwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    // Configure the cell
    [self configureCell:cell atIndexPath:indexPath];
    
    // Return the cell. Vuala!
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didEndSwipingSwipingWithState:(MCSwipeTableViewCellState)state mode:(MCSwipeTableViewCellMode)mode
{
    if (mode == MCSwipeTableViewCellModeExit) {
        // Do Stuff
        
        // State definitions
        //
        //    MCSwipeTableViewCellState1 = seen.  certain rating.
        //    MCSwipeTableViewCellState2 = seen. write something.
        //    MCSwipeTableViewCellState3 = delete
        //    MCSwipeTableViewCellState4
        //
        
        [self deleteRowAtIndexPath:[self.tableView indexPathForCell:cell]];
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DBMovie *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setMovieObject:object];
    }
}

#pragma mark - 
#pragma mark Fetched results controller && Core Data

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DBMovie" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            if ([self respondsToSelector:@selector(addedNewObject:atIndexPath:)]) {
                [self addedNewObject:anObject atIndexPath:newIndexPath];
            }
            
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */


#pragma mark -
#pragma Row Management

- (void)configureCell:(MCSwipeTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    [cell setDelegate:self];
    //[cell setShowRating:TRUE];
    [cell setFirstStateIconName:@"check.png"
                     firstColor:[UIColor colorWithRed:85.0/255.0 green:213.0/255.0 blue:80.0/255.0 alpha:1.0]
            secondStateIconName:@"check.png"
                    secondColor:[UIColor colorWithRed:85.0/255.0 green:213.0/255.0 blue:80.0/255.0 alpha:1.0]
                  thirdIconName:@"cross.png"
                     thirdColor:[UIColor colorWithRed:232.0/255.0 green:61.0/255.0 blue:14.0/255.0 alpha:1.0]
                 fourthIconName:@"list.png"
                    fourthColor:[UIColor colorWithRed:206.0/255.0 green:149.0/255.0 blue:98.0/255.0 alpha:1.0]];
    [[cell contentView] setBackgroundColor:[UIColor whiteColor]];
    [cell setMode:MCSwipeTableViewCellModeExit];
    
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[object valueForKey:@"title"] description];
    if (cell.detailTextLabel) {
        cell.detailTextLabel.text = [[object valueForKey:@"year"] description];
    }
}


#pragma mark Data management

- (void)insertNewObject:(id)object
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
    if (object && [object isKindOfClass:[NSDictionary class]]) {
        
        /*
         Create DBMovie object.
         */
        
        NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
        NSManagedObject *movieObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
        
        /*
         Create DBMovieDetails object.
         */
        
        entity = [NSEntityDescription entityForName:@"DBMovieDetails" inManagedObjectContext:context];
        NSManagedObject *detailsObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
        
        
        /*
         Create DBMovieRatings object.
         */
        
        entity = [NSEntityDescription entityForName:@"DBMovieRatings" inManagedObjectContext:context];
        NSManagedObject *ratingsObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
        
        /*
         Set it all up
         */
        
        [movieObject setValue:[NSDate date] forKey:@"timeStamp"];
        
        for (NSString *key in object) {
            if ([[object objectForKey:key] isKindOfClass:[NSString class]]) {
                [movieObject setValue:
                 [NSString stringWithFormat:@"%@", [object objectForKey:key]]
                               forKey:key];
            }
        }
        
    [movieObject setValue:detailsObject forKey:@"details"];
    [movieObject setValue:ratingsObject forKey:@"ratings"];
    
    }
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (BOOL)deleteRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
    id object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([object isKindOfClass:[DBMovie class]]) {
        DBMovie *movie = (DBMovie *)object;
        
        [context deleteObject:movie.details];
        [context deleteObject:movie.ratings];
    }
    
    [context deleteObject:object];
    
    
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return TRUE;
}

#pragma mark -
#pragma mark Movie Data Collection

- (void)requestMovieInfoForObject:(DBMovie *)object
{
    [_movieInformationDataSource addObjectToInformationRequestQueue:object];
}

-(void)movieInformationDataSource:(KCMovieInformationDataSource *)mids didFetchInformationForMovie:(DBMovie *)movie
{
    [self saveContext];
}

- (void)movieInformationDataSource:(KCMovieInformationDataSource *)mids didFetchPosterImageForMovie:(DBMovie *)movie
{
    [self saveContext];
    // HIDE ACTIVITY INDICATOR
}

- (BOOL)saveContext
{   NSLog(@"Saving context...");
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return TRUE;
}

#pragma mark -
#pragma mark - Facebook & Social

- (void)facebookPlugDidRecieveUserMovieList:(NSDictionary *)movies
{
    
}

#pragma mark -
#pragma mark - Misc

- (void)test:(id)sender
{
    [self populateMovieInformationRequestQueue];
}

- (void)populateMovieInformationRequestQueue
{
    // Find all movies with details without timestamp.
    //DBMovie *object = nil;
    //[_movieInformationDataSource addObjectToInformationRequestQueue:object];
    
    // There is the posibility posteres wont be loaded even if the timestamp is set, given they are loaded asyncronoulsy after the timestamp has been set. Should check for nil posters when attempting to load them, and request them first from DBMovie.poster if available and if not from iTunes or somewhere else.
    
    NSEntityDescription *details = [NSEntityDescription entityForName:@"DBMovieDetails" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:details];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timeStamp == nil"];
    
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (results == nil) {
        NSLog(@"Fail.");
        return;
    }
    
    for (DBMovieDetails *details in results) {
        [_movieInformationDataSource addObjectToInformationRequestQueue:details.movie];
    }
    
    NSLog(@"%lu items added to queue", (unsigned long)results.count);
}


/*
 I don't think I need this
*/
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteRowAtIndexPath:indexPath];
    }
}

@end
