//
//  FollowingUserProfileViewController.h
//  Listy
//
//  Created by Silstone on 28/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface FollowingUserProfileViewController : UIViewController
{
    AppDelegate *del;
}

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *listCollectionHeight;
@property (strong, nonatomic) IBOutlet UICollectionView *listCollectionView;
- (IBAction)backBtnAction:(id)sender;
- (IBAction)seeAllAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *listNameLable;
- (IBAction)followerBtnAction:(id)sender;
- (IBAction)followingBtnAction:(id)sender;
@property (strong, nonatomic) NSString *followerIdStr;
@property (strong, nonatomic) IBOutlet UIButton *followBtn;
@property (strong, nonatomic) IBOutlet UIImageView *coverImage;
@property (strong, nonatomic) IBOutlet UILabel *listNumberlbl;
@property (strong, nonatomic) IBOutlet UILabel *followerNumberlbl;
@property (strong, nonatomic) IBOutlet UILabel *followingNumberlbl;
@property (strong, nonatomic) IBOutlet UILabel *profileName;
- (IBAction)followBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *userListLable;
@property (strong, nonatomic) IBOutlet UIButton *seeAllBtn;
@property (strong, nonatomic) IBOutlet UILabel *nolistLable;
@property (strong, nonatomic) IBOutlet UIImageView *locationImage;
@property (strong, nonatomic) IBOutlet UILabel *locationlbl;
@property (strong, nonatomic) IBOutlet UIImageView *followImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *textwidthConstant;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topProfileConstraint;

@end
