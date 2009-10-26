//
//  RootViewController.m
//  TokenizerDemo
//
//  Created by August Joki on 10/25/09.
//  Copyright Concinnous Software 2009. All rights reserved.
//

#import "RootViewController.h"
#import "SubTokenViewController.h"
#import "CSStringTokenizer.h"

@interface RootViewController ()

- (void)tokenize;

@end


@implementation RootViewController

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return tokens.count;;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
  }
  
	CSStringToken *token = [tokens objectAtIndex:indexPath.row];
  NSString *string = token.string;
  if (token.language != nil) {
    string = [string stringByAppendingFormat:@", %@", token.language];
  }
  if (token.containsNumbers) {
    string = [string stringByAppendingString:@", #"];
  }
  if (token.containsNonLetters) {
    string = [string stringByAppendingString:@", @"];
  }
  
  cell.textLabel.text = string;
  cell.detailTextLabel.text = NSStringFromRange(token.range);
  if (token.hasSubTokens) {
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  else {
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  return cell;
}


// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  CSStringToken *token = [tokens objectAtIndex:indexPath.row];
  if (!token.hasSubTokens) {
    return;
  }
  
  SubTokenViewController *vc = [[SubTokenViewController alloc] initWithNibName:nil bundle:nil];
  vc.tokens = token.subTokens;
  if (token.string) {
    vc.title = token.string;
  }
  else {
    vc.title = NSStringFromRange(token.range);
  }
  [self.navigationController pushViewController:vc animated:YES];
  [vc release];
}


#pragma mark -
#pragma mark Search Bar Delegate


/*
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
  
}


- (void)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
  
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
  
}


- (void)searchBarShouldEndEditing:(UISearchBar *)searchBar {
  
}


- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar {
  
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
  
}
*/


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  [self tokenize];
}


- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
  [self tokenize];
}


- (void)tokenize {
  [search resignFirstResponder];
  if (search.text.length == 0) {
    return;
  }
  CFOptionFlags options;
  switch (search.selectedScopeButtonIndex) {
    case 0:
      options = kCFStringTokenizerUnitWord | kCFStringTokenizerAttributeLatinTranscription;
      break;
    case 1:
      options = kCFStringTokenizerUnitSentence | kCFStringTokenizerAttributeLanguage;
      break;
    case 2:
      options = kCFStringTokenizerUnitWordBoundary;
    default:
      break;
  }
  CSStringTokenizer *tokenizer = [CSStringTokenizer tokenizerWithString:search.text options:options];
  tokenizer.fetchesSubTokens = YES;
  //tokens = [tokenizer.tokens retain];
  NSMutableArray *array = [NSMutableArray array];
  for (CSStringToken *token in tokenizer) {
    NSLog(@"%@, %@", token.string, NSStringFromRange(token.range));
    [array addObject:token];
  }
  tokens = [array retain];
  
  [table reloadData];
}


#pragma mark -
#pragma mark Memory Management


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
  [tokens release];
  [super dealloc];
}


@end

