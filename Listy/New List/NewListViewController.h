//
//  NewListViewController.h
//  Listy
//
//  Created by Silstone on 23/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TTGTagCollectionView/TTGTextTagCollectionView.h>
#import "AppDelegate.h"
@interface NewListViewController : UIViewController<TTGTextTagCollectionViewDelegate>
{
    AppDelegate *del;
}
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *keywordViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *listTableHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *publishViewHeight;
@property (strong, nonatomic) IBOutlet UIButton *addListBtn;
@property (strong, nonatomic) IBOutlet UIView *CreateListView;
@property (strong, nonatomic) IBOutlet UITableView *listTable;
- (IBAction)addListAction:(id)sender;
@property (strong, nonatomic) IBOutlet TTGTextTagCollectionView *keywordView;
- (IBAction)cancelBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *publishBtn;
@property (strong, nonatomic) IBOutlet UIView *listView;
- (IBAction)tapguesture:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *addImageBtn;
@property (strong, nonatomic) IBOutlet UIButton *listBtn;
- (IBAction) :(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *keywordTxtView;
@property (strong, nonatomic) IBOutlet UITextView *listDescriptionView;
@property (strong, nonatomic) IBOutlet UITextView *listTitleView;
@property (strong, nonatomic) IBOutlet UITextView *addListDescription;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *addListImage;
- (IBAction)addListImageAction:(id)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *addListViewHeight;
- (IBAction)selectFolderAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *selectFolderBtn;
- (IBAction)publishListAction:(id)sender;
- (IBAction)saveListDraftAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *itemTitleView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *listItembottumConstant;
- (IBAction)addKeywordAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *itemUrlField;
- (IBAction)cancelListItem:(id)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *itemDescriptionHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *listDetailHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *listDescriptionHeight;
- (IBAction)viewFromWikiAction:(id)sender;
@property (strong, nonatomic) NSMutableArray *wikiDescArray;
@property (strong, nonatomic) IBOutlet UIView *cancelAddItem;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UISwitch *wikiSwitch;
- (IBAction)switchValueChanged:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *characterLength;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *listTitleHeight;
@property (strong, nonatomic) IBOutlet UITableView *wikiSearhTableView;
@property (strong, nonatomic) IBOutlet UIView *wikiSearchView;
@property (strong, nonatomic) IBOutlet UIButton *addCoverImageBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *addCoverConstraint;
@property (strong, nonatomic) IBOutlet UIView *cancelCreateList;

@end
