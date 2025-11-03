//
//  CategoryDetailViewController.h
//  Listy
//
//  Created by Silstone on 13/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *categoryTable;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)flipViewAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *searchView;
- (IBAction)backBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UICollectionView *featuredCollection;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)searchBtnAction:(id)sender;
@property BOOL isShowFeatured;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *featuredViewHeight;
@property (strong, nonatomic) IBOutlet UIButton *seeAllBtn;
@property (strong, nonatomic) IBOutlet UILabel *featuredLable;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) NSString *titleStr;
@property (strong, nonatomic) NSString *categoryId;
@property (strong, nonatomic) NSString *searchText;
@property (strong, nonatomic) NSMutableArray *activityArray;
- (IBAction)seeAllAction:(id)sender;
@property BOOL isfromDiscoverSearch;
@property (strong, nonatomic) IBOutlet UITextField *searchField;

@end
