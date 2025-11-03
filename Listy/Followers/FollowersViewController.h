//
//  FollowersViewController.h
//  Listy
//
//  Created by Silstone on 27/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowersViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *searchView;
- (IBAction)backBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *searchField;
@property (strong, nonatomic) NSString *userIdStr;
@property (strong, nonatomic) NSString *titleStr;
@property BOOL isfollowing;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end
