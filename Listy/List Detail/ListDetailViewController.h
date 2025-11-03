//
//  ListDetailViewController.h
//  Listy
//
//  Created by Silstone on 14/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ListDetailViewController : UIViewController
{
    AppDelegate *del;
}
@property (strong, nonatomic) IBOutlet UIView *searchView;
- (IBAction)backBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *listTable;
- (IBAction)searchBtnAction:(id)sender;
@property (strong, nonatomic) NSString *categoryIDStr;
@property (strong, nonatomic) IBOutlet UITextField *searchField;
@property (strong, nonatomic) NSString *titleStr;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property BOOL isfromdraft;
- (IBAction)editBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *editBtn;
@property BOOL isfromSaveItem;
@property (strong, nonatomic) NSString *itemIDStr;
@property (strong, nonatomic) NSString *followerid;

@end
