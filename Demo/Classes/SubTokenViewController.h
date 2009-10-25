//
//  SubTokenViewController.h
//  CSStringTokenizer
//
//  Created by August Joki on 10/25/09.
//  Copyright 2009 Concinnous Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SubTokenViewController : UITableViewController {
  NSArray *tokens;
}

@property(nonatomic, retain) NSArray *tokens;

@end
