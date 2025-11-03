//
//  DiscoverViewController.h
//  Listy
//
//  Created by Silstone on 09/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscoverViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *searchView;
- (IBAction)searchBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *discoverTable;
@property (strong, nonatomic) NSMutableArray *searchArray;

//property array-
@property (strong, nonatomic) NSMutableArray *featuredListArray;
@property (strong, nonatomic) NSMutableArray *friendsActivityArray;
@property (strong, nonatomic) NSMutableArray *listCategoryArray;
@property (strong, nonatomic) IBOutlet UITextField *searchField;

@end
