//
//  RootViewController.h
//  TokenizerDemo
//
//  Created by August Joki on 10/25/09.
//  Copyright Concinnous Software 2009. All rights reserved.
//


@interface RootViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
  IBOutlet UITableView *table;
  IBOutlet UISearchBar *search;
  
  NSArray *tokens;
}

@end
