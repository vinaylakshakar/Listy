//
//  FeaturedListFirstViewController.h
//  Listy
//
//  Created by Silstone on 22/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TTGTagCollectionView/TTGTextTagCollectionView.h>
#import "JBKenBurnsView.h"

@interface FeaturedListFirstViewController : UIViewController<TTGTextTagCollectionViewDelegate,KenBurnsViewDelegate,UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *featuredTableHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *commentTableHeight;

@property (strong, nonatomic) IBOutlet UITableView *feturedTable;
@property (strong, nonatomic) IBOutlet UITableView *commentTable;
@property (strong, nonatomic) IBOutlet UIView *commentHeader;

@property (strong, nonatomic) IBOutlet UIButton *commentBtn;
@property (strong, nonatomic) IBOutlet UIView *postView;
- (IBAction)backBtnAction:(id)sender;

@property (strong, nonatomic) IBOutlet TTGTextTagCollectionView *keywordView;

//@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (nonatomic, strong) IBOutlet JBKenBurnsView *mainView;
@property (strong, nonatomic) IBOutlet UIView *detailView;
- (IBAction)flipViewAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *postCommentTxt;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *commentViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *commentTxtWidth;
- (IBAction)listBtnOptions:(id)sender;

@property (strong, nonatomic) NSMutableDictionary *listDictinfo;
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *categoryName;
@property (strong, nonatomic) IBOutlet UILabel *listName;
@property (strong, nonatomic) IBOutlet UILabel *createdTime;
@property (strong, nonatomic) IBOutlet UILabel *listDescription;
@property (strong, nonatomic) IBOutlet UIImageView *sliderImageItems;
@property (strong, nonatomic) IBOutlet UILabel *no_of_maches;
@property (strong, nonatomic) IBOutlet UILabel *no_of_likes;
@property (strong, nonatomic) IBOutlet UILabel *no_of_followers;
@property (strong, nonatomic) IBOutlet UILabel *no_of_comments;
@property (strong, nonatomic) IBOutlet UILabel *match_percentage;
@property (strong, nonatomic) IBOutlet UIImageView *userImage2;
@property (strong, nonatomic) IBOutlet UILabel *categoryName2;
@property (strong, nonatomic) IBOutlet UILabel *listName2;
@property (strong, nonatomic) IBOutlet UILabel *userName2;
- (IBAction)postBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *likeUnlikeBtn;
@property (strong, nonatomic) IBOutlet UIButton *likeUnlikeBtn2;
- (IBAction)listLikeAction:(id)sender;
- (IBAction)showAllKeywordAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *listImageFirst;
@property (strong, nonatomic) IBOutlet UIImageView *listimageFlipped;

- (IBAction)savelistAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *savelistBtn;
@property (strong, nonatomic) IBOutlet UIButton *savelistBtn2;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mainViewHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *detailVIewHeight;
@property (strong, nonatomic) NSString *followerid;
- (IBAction)showUserProfile:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *seeAllKeywordBtn;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIButton *optionBtn;
@property (strong, nonatomic) IBOutlet UITableView *tagViewTable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tagViewConstant;
@property (strong, nonatomic) IBOutlet UIView *tagCommentView;
@property (strong, nonatomic) IBOutlet JBKenBurnsView *animationView;


@end
