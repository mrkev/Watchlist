//
//  KCAutoCompleteTextField.m
//  Watchlist
//
//  Created by Kevin on 02/08/13.
//  Copyright (c) 2013 Kevin Chavez. All rights reserved.
//

#import "KCAutoCompleteTextField.h"

#define kTableViewHeight 52.0f
#define kTableViewRowHeight 20.0f
#define kFetchDelay 0.5f
#define kDefaultSuggestionCellIdentifier @"defaultAutoCompleteCell"

@interface KCAutoCompleteTextField()

@property (readonly, strong) UIActivityIndicatorView *activityIndicator;
@property (readonly, strong) RHHorizontalTableView *tableView;
@property (nonatomic, strong) NSArray *suggestionsArray;

@end

@implementation KCAutoCompleteTextField

/*
 Initializers, dealloc and whatnot
 Good stuff
*/

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self start];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self start];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self start];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)start
{   // Register observers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeWithNotification:) name:UITextFieldTextDidChangeNotification object:self];
}

- (BOOL)becomeFirstResponder
{
    if (_referenceView == nil) {
        _referenceView = self;}
    
    // Create table view
    _tableView = [self suggestionTableViewForReferenceView:_referenceView];
    _activityIndicator = [self activityIndicatorForReferenceView:_referenceView];
    
    [self.superview insertSubview:_activityIndicator aboveSubview:self];
    
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{ return [super resignFirstResponder];}

- (void)reset
{
    [_tableView removeFromSuperview];
    [_activityIndicator stopAnimating];
    _suggestionsArray = [NSArray array];
    [self setText:@""];
}

- (void)drawAutoCompleteTableView
{
    if (_suggestionsArray.count > 0) {
        [self.superview insertSubview:_tableView aboveSubview:self];
        [_tableView setUserInteractionEnabled:YES];
        [_activityIndicator stopAnimating];
    } else {
        [_tableView removeFromSuperview];
    }
}    

- (void)textFieldDidChangeWithNotification:(NSNotification *)notification
{
    if ([notification object] == self) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fetchSuggestions) object:nil];
        [self performSelector:@selector(fetchSuggestions) withObject:nil afterDelay:kFetchDelay];
    }
}

- (void)fetchSuggestions {
    [_activityIndicator startAnimating];
    [_dataSource textField:self requestSuggestionsForString:[self text]];
}

- (void)reloadSuggestionsWithArray:(NSArray *)array {
    // Got suggestions from data source
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_activityIndicator stopAnimating];
        _suggestionsArray = array;

        if (_suggestionsArray.count > 0) {
            [self drawAutoCompleteTableView];
            [_tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];

            if ([_tableView numberOfRowsInSection:0] > 0) {
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            } 
        
        
        } else {
            [self drawAutoCompleteTableView];
        }
    });
}

#pragma mark Table View Data Source

/*
 Returns the number of rows the table view will have
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ return [_suggestionsArray count]; }

/*
 Returns configured Table View Cell
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = kDefaultSuggestionCellIdentifier;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //[cell.textLabel sizeToFit];
        [[cell textLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0]];
    }
    
    NSString *title;

    if (_suggestionsArray.count > indexPath.row) {
       title = [NSString stringWithFormat:@"%@", [_suggestionsArray objectAtIndex:[indexPath row]]];

    }
    
    [cell.textLabel setText:title];

    return cell;
}

/*
 Returns the "height" (width actually) of the table view
*/

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = _suggestionsArray[indexPath.row];
    return [text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0]].width + 22.0; // 192 works too.
}

/*
 Returns configured table view
*/

- (RHHorizontalTableView *)suggestionTableViewForReferenceView:(UIView *)rView
{
    // Return table view if its already made
    
    if (_tableView != nil) {
        return _tableView;
    }
    
    // Make table view
    
    float origin_y = 0.0;
    
    if (_suggestionsTablePosition == KCSuggestionsTablePositionBottom ||
        _suggestionsTablePosition == KCSuggestionsTablePositionDefault) {
        
        origin_y = self.frame.origin.y + self.frame.size.height;
        
    } else if (_suggestionsTablePosition == KCSuggestionsTablePositionTop) {
        origin_y = self.frame.origin.y - kTableViewHeight;
        
    } else if (_suggestionsTablePosition == KCSuggestionsTablePositionInsideReferenceView) {
        origin_y = rView.frame.origin.y;
        
    }
    
    CGRect frame = CGRectMake(rView.frame.origin.x,
                              origin_y,
                              rView.frame.size.width,
                              kTableViewHeight);
    
    RHHorizontalTableView *table = [[RHHorizontalTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [table setDelegate:self];
    [table setDataSource:self];
    [table setScrollEnabled:TRUE];
    [table setShowsVerticalScrollIndicator:YES];
    
    UIView *bgView = [[UIView alloc] initWithFrame:table.frame];
    [table setBackgroundView:bgView];
    
    //NSLog(@"Suggestions Table Frame: %f, %f, %f, %f", table.frame.origin.x, table.frame.origin.y, table.frame.size.height, table.frame.size.width);
    
    return table;
}

- (UIActivityIndicatorView *)activityIndicatorForReferenceView:(UIView *)rView
{
    if (_activityIndicator != nil) {
        return _activityIndicator;
    }
    
    CGRect frame = CGRectMake(rView.frame.origin.x + (rView.frame.size.width/2) - 20.0,
                              rView.frame.origin.y,
                              40.0,
                              40.0);

    UIActivityIndicatorView *ind = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [ind setFrame:frame];
    
    return ind;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = [[_tableView cellForRowAtIndexPath:indexPath] textLabel].text;
    self.text = text;
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_autoCompleteDelegate textField:self didSelectSuggestionWithString:text indexPath:indexPath];
    [self resignFirstResponder];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
