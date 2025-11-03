//
//  ProfileViewController.h
//  Listy
//
//  Created by Silstone on 28/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TTGTagCollectionView/TTGTextTagCollectionView.h>

@interface ProfileViewController : UIViewController<TTGTextTagCollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *detailViewHeight;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet TTGTextTagCollectionView *keywordView;
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UIView *aboutView;
@property (strong, nonatomic) IBOutlet UIView *profileView;
- (IBAction)forwardBtnAction:(id)sender;
- (IBAction)backwardBtnAction:(id)sender;
- (IBAction)settingBtnAction:(id)sender;
- (IBAction)followerBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *listNumberlbl;
@property (strong, nonatomic) IBOutlet UILabel *followerNumberlbl;
@property (strong, nonatomic) IBOutlet UILabel *followingNumberlbl;
@property (strong, nonatomic) IBOutlet UILabel *profileName;
@property (strong, nonatomic) IBOutlet UILabel *location;
@property (strong, nonatomic) IBOutlet UILabel *aboutName;
@property (strong, nonatomic) IBOutlet UITextView *aboutProfile;
@property (strong, nonatomic) IBOutlet UIImageView *coverImage;
- (IBAction)seeAllAction:(id)sender;
- (IBAction)followingBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *profileDetailView;
@property (strong, nonatomic) IBOutlet UIButton *seeAllBtn;
@property (strong, nonatomic) IBOutlet UILabel *noListLable;
@property (strong, nonatomic) IBOutlet UIImageView *locationImage;
- (IBAction)seeAllKeyword:(id)sender;
- (IBAction)myListAction:(id)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textwidthConstant;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topProfileConstraint;

@end
