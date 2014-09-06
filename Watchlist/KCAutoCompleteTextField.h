//
//  KCAutoCompleteTextField.h
//  Watchlist
//
//  Created by Kevin on 02/08/13.
//  Copyright (c) 2013 Kevin Chavez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RHHorizontalTableView.h"

typedef enum {
    KCSuggestionsTablePositionDefault = 0,
    KCSuggestionsTablePositionBottom,
    KCSuggestionsTablePositionTop,
    KCSuggestionsTablePositionInsideReferenceView
} KCSuggestionsTablePosition;


@protocol KCAutoCompleteDataSource;
@protocol KCAutoCompleteDelegate;

@interface KCAutoCompleteTextField : UITextField <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) id<KCAutoCompleteDataSource> dataSource;
@property (nonatomic, strong) id<KCAutoCompleteDelegate> autoCompleteDelegate;

@property (nonatomic) KCSuggestionsTablePosition suggestionsTablePosition;

@property (nonatomic, strong) UIView *referenceView;


- (void)reloadSuggestionsWithArray:(NSArray *)array;
- (void)reset;

@end

/*
 KCAutoCompleteDataSource gets called whenever the text field needs
 new suggestions (a short delay after user has typed a phrase).
 
 It should call -reloadSuggestionsWithArray: when it gets the suggestions
 to load.
*/

@protocol KCAutoCompleteDataSource <NSObject>

- (void)textField:(KCAutoCompleteTextField *)textField requestSuggestionsForString:(NSString *)string;

@end

/*
 KCAutoCompleteDelegate gets called whenever a user selects an option.
*/


@protocol KCAutoCompleteDelegate <NSObject>

- (void)textField:(KCAutoCompleteTextField *)textField didSelectSuggestionWithString:(NSString *)string indexPath:(NSIndexPath *)indexPath;

@optional

- (void)textField:(KCAutoCompleteTextField *)textField  didReciveSuggestionsForString:(NSString *)string;
- (void)textField:(KCAutoCompleteTextField *)textField didRequestSuggestionsForString:(NSString *)string;

@end
