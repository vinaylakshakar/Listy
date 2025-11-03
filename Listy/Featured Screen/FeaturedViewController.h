//
//  FeaturedViewController.h
//  Listy
//
//  Created by Silstone on 13/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeaturedViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *searchView;
- (IBAction)backBtnAction:(id)sender;
- (IBAction)searchBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *featuredTable;
@property (strong, nonatomic) NSMutableArray *featuredArray;
@property BOOL isfromUserProfile;
@property (strong, nonatomic) IBOutlet UIButton *searchBtn;
@property (strong, nonatomic) IBOutlet UITextField *searchField;

@end
