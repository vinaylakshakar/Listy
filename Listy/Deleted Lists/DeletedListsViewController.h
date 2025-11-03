//
//  DeletedListsViewController.h
//  Listy
//
//  Created by Silstone on 14/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeletedListsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *searchView;
- (IBAction)backBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *listTable;
- (IBAction)searchBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property BOOL isfromdraft;
- (IBAction)removeMultpleLists:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *searchField;

@end
