//
//  ListItemDetailViewController.h
//  Listy
//
//  Created by Silstone on 29/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListItemDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *descriptionViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *TableHeight;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UITableView *contentTable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *descriptionHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentDescHeight;
@property (strong, nonatomic) IBOutlet UITextView *descriptionView;
- (IBAction)backBtnAction:(id)sender;
- (IBAction)listBtnOptions:(id)sender;
- (IBAction)saveListItemAction:(id)sender;
- (IBAction)likeDislikeAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *likeUnlikeBtn;
@property (strong, nonatomic) NSMutableArray *itemArray;
@property NSInteger itemIndex;
@property (strong, nonatomic) IBOutlet UILabel *listNameLable;
@property (strong, nonatomic) IBOutlet UILabel *itemNamelbl;
@property (strong, nonatomic) IBOutlet UILabel *itemDescription;
@property (strong, nonatomic) IBOutlet UILabel *numberOfMached;
@property (strong, nonatomic) IBOutlet UILabel *numberOfLikes;
@property (strong, nonatomic) IBOutlet UILabel *numberOfFollowers;
@property (strong, nonatomic) IBOutlet UILabel *numberOfComments;
@property (strong, nonatomic) IBOutlet UIImageView *itemImage;
@property (strong, nonatomic) IBOutlet UIButton *backwordBtn;
@property (strong, nonatomic) IBOutlet UIButton *forwordBtn;
- (IBAction)nextItemAction:(id)sender;
- (IBAction)previousItemAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *savelistItemBtn;
@property (strong, nonatomic) IBOutlet UIView *itemDetailView;
- (IBAction)swipeRight:(id)sender;
- (IBAction)swipeLeft:(id)sender;
@property (strong, nonatomic) NSString *followerid;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *relatedListViewHeight;
@property (strong, nonatomic) IBOutlet UIView *relatedView;
- (IBAction)seeAllList:(id)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *linkView;
@property (strong, nonatomic) IBOutlet UITextView *linkTextView;
@property (strong, nonatomic) IBOutlet UIView *itemLinkView;
@property (strong, nonatomic) IBOutlet UIImage *listCoverImage;

@end
