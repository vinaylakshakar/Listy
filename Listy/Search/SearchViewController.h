//
//  SearchViewController.h
//  Listy
//
//  Created by Silstone on 20/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController
- (IBAction)backBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *searchView;
- (IBAction)cancelSearch:(id)sender;
@property BOOL isFromDiscover;
@property BOOL isCategoryFeatured;
@property (strong, nonatomic) IBOutlet UITextField *searchField;

@end
