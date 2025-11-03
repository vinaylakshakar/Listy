//
//  ProfileViewController.m
//  Listy
//
//  Created by Silstone on 28/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "ProfileViewController.h"
#import "Listy.pch"

@interface ProfileViewController ()
{
    NSMutableArray *imageArray,*topListArray;
    NSMutableDictionary *userDetailDict;
}

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.detailViewHeight.constant = 700;
    // [self setTagView];
    self.userImage.layer.cornerRadius = self.userImage.frame.size.height/2;
    self.userImage.layer.masksToBounds = YES;
    imageArray = [[NSMutableArray alloc]initWithObjects:@"dummy_image_square_1",@"dummy_image_square_2",@"dummy_image_square_3",@"dummy_image_square_4",@"dummy_image_square_5", nil];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CategoryCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CategoryCollectionCell"];
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        if ((int)[[UIScreen mainScreen] nativeBounds].size.height>=2436) {
            self.topProfileConstraint.constant = self.topProfileConstraint.constant+20;
        }
        
    }
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.profileDetailView setHidden:YES];
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController setNavigationBarHidden:YES];
    [self GetUserInfo];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)setTagView:(NSArray*)tags
{
//    NSArray *tags = @[@"Movies",@"80's",@"Sound track",@"Cult",@"Punk",@"Comics",@"UK",@"Hip hop",@"Skateboarding"];
    [_keywordView removeAllTags];
    self.keywordView.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
    
    TTGTextTagConfig *config = [TTGTextTagConfig new];
    //config.tagTextFont = [UIFont fontWithName:@"SFProText-Regular" size:5];
    
    config.tagTextColor = [UIColor whiteColor];
    // config.tagSelectedTextColor = RED_COLOR;
    config.tagExtraSpace = CGSizeMake(25, 20);
    
    NSUInteger location = 0;
    NSUInteger length = tags.count;
    config.tagBackgroundColor = RED_COLOR;
    config.tagShadowOpacity = 0.0;
    config.tagBorderColor = [UIColor clearColor];
    config.tagShadowRadius =1;
     config.tagSelectedBackgroundColor = RED_COLOR;
    config.tagTextFont = [UIFont fontWithName:@"SFProText-Medium" size:10];
    config.tagCornerRadius = 13;
    config.tagSelectedCornerRadius =13;
    config.tagSelectedBorderColor = [UIColor clearColor];
    config.extraData = @{@"key": @"1"};
    [self.keywordView addTags:[tags subarrayWithRange:NSMakeRange(location, length)] withConfig:[config copy]];
    
    self.keywordView.delegate = self;
    [self.keywordView setUserInteractionEnabled:NO];
    
    
}

-(void)setLayout
{
    [self.profileDetailView setHidden:NO];
    self.profileName.text = [userDetailDict valueForKey:@"UserName"];
    self.aboutName.text = [NSString stringWithFormat:@"About %@",[userDetailDict valueForKey:@"UserName"]];
    self.location.text = [userDetailDict valueForKey:@"Location"];
    if (![self.location.text isEqualToString:@""]) {
        [self.locationImage setHidden:NO];
    }
    self.aboutProfile.text = [userDetailDict valueForKey:@"About"];
    self.listNumberlbl.text = [[userDetailDict valueForKey:@"NoOfList"] stringValue];
    self.followingNumberlbl.text = [[userDetailDict valueForKey:@"NoOFFollowing"] stringValue];
    self.followerNumberlbl.text = [[userDetailDict valueForKey:@"NoFollwer"] stringValue];
    
    
    if ([[userDetailDict valueForKey:@"CoveredProfileImages"] isEqualToString:@""]) {
        [self.coverImage setImage:[UIImage imageNamed:@"profile_background"]];
    } else {
        [self.coverImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"CoveredProfileImages"]]] placeholderImage:nil options:0 progress:nil completed:nil];
    }
    
    CGSize  textSize = {300, 13};
    
    CGSize size = [[NSString stringWithFormat:@"%@", self.location.text]
                   sizeWithFont:[self.location font]
                   constrainedToSize:textSize
                   lineBreakMode:NSLineBreakByWordWrapping];
    self.textwidthConstant.constant = size.width+15;
    
    
    NSMutableDictionary *userDict =[Utility removeNullFromDictionary:userDetailDict];
 
   // [USERDEFAULTS setObject:[userDict valueForKey:@"devicetoken"] forKey:deviceId];
    [USERDEFAULTS setObject:userDict forKey:kuserProfileDict];
    
    
    if ([[userDetailDict valueForKey:@"UserProfileImages"] isEqualToString:@""])
    {
        if (![USERDEFAULTS valueForKey:@"fbPicture"])
        {
            [self.userImage setImage:[UIImage imageNamed:@"user_profile"]];
        }
        else
        {
            [self.userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:@"fbPicture"]]] placeholderImage:nil options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {
                [self UpdateUserInfo:userDict];
            }];
        }
        
    } else
    {
        [self.userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"UserProfileImages"]]] placeholderImage:nil options:0 progress:nil completed:nil];
    }

    
    [self UserTopList:@""];
}

-(NSArray *)returnSortedAlphabetically:(NSArray*)array
{
    NSMutableArray *trimArray = [[NSMutableArray alloc]init];
    for (NSString *str in array)
    {
        NSString *trimmedString = [str stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [trimArray addObject:trimmedString];
    }
    
    NSArray *sortedArray = [trimArray sortedArrayUsingSelector:
                            @selector(localizedCaseInsensitiveCompare:)];
    return sortedArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark-Api methods

-(void)UpdateUserInfo:(NSMutableDictionary*)userDict
{
    
    [kAppDelegate showProgressHUD];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"Userid"];
    [dict setObject:[userDetailDict valueForKey:@"Name"] forKey:@"Name"];
    [dict setObject:[userDetailDict valueForKey:@"UserName"] forKey:@"UserName"];
    [dict setObject:[userDetailDict valueForKey:@"Location"] forKey:@"Location"];
    [dict setObject:[userDetailDict valueForKey:@"email"] forKey:@"Email"];
    [dict setObject:[userDetailDict valueForKey:@"About"] forKey:@"About"];
    [dict setObject:@"profileImage" forKey:@"imageType"];
    
    NSString *filename = [NSString stringWithFormat:@"%ld%c%c.jpg", (long)[[NSDate date] timeIntervalSince1970], arc4random_uniform(26) + 'a', arc4random_uniform(26) + 'a'];
    
    NSLog(@"%@",dict);

    
    [[NetworkEngine sharedNetworkEngine]UpdateUserInfo:^(id object)
     {
         NSLog(@"errekkjk %@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             [userDict setObject:[[object valueForKey:@"Data"] valueForKey:@"UserProfileImages"] forKey:@"UserProfileImages"];
             [USERDEFAULTS setObject:userDict forKey:kuserProfileDict];
             
         }
         
         [kAppDelegate hideProgressHUD];
         
         
     } onError:^(NSError *error)
     {
         NSLog(@"%@",error);
     } filePath:filename imageName:self.userImage.image params:dict];
    
    
}

-(void)GetUserInfo
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"userid"];
    
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]GetUserInfo:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             
             userDetailDict = [[object valueForKey:@"UserDetail"] mutableCopy];
             [self setLayout];
             
         } else
         {
             
             [Utility showAlertMessage:nil message:[object valueForKey:@"Message"]];
             
         }
         
         [kAppDelegate hideProgressHUD];
         
         
         
     }
        onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}


-(void)UserTopList:(NSString*)searchText
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"userid"];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"ownerid"];
    [dict setObject:@"0" forKey:@"offset"];
    [dict setObject:searchText forKey:@"searchtext"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]UserTopList:^(id object)
     {
         
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             topListArray = [object valueForKey:@"List"];
             NSArray *keywords = [[object valueForKey:@"Keyword"] valueForKey:@"keyword"];
             keywords = [self returnSortedAlphabetically:keywords];
             NSMutableArray* mutableKeyword = [[NSMutableArray alloc]initWithArray:keywords];
             [mutableKeyword removeObject:@""];
             
             [self setTagView:mutableKeyword];
             
             if (topListArray.count<1)
             {
                 [self.seeAllBtn setHidden:YES];
                 [self.noListLable setHidden:NO];
             } else
             {
                 [self.collectionView reloadData];
             }
             
         } else
         {
             [Utility showAlertMessage:nil message:[object valueForKey:@"Message"]];
         }
         
         [kAppDelegate hideProgressHUD];
         
         
     }
                                              onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return topListArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CategoryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCollectionCell" forIndexPath:indexPath];
    
    cell.activityImage.layer.cornerRadius = 4;
    cell.activityImage.layer.masksToBounds = YES;
    cell.overlayImage.layer.cornerRadius = 4;
    cell.overlayImage.clipsToBounds = YES;
    //cell.activityImage.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
    NSMutableDictionary *itemDict = [topListArray objectAtIndex:indexPath.row];
  //  NSString *urlStr = [NSString stringWithFormat:kBaseURL@"CreateThumbnailURL?listid=%@&listitemid=%d&url=%@&width=%@&height=0",[itemDict valueForKey:@"id"],0,[itemDict valueForKey:@"list_image"],kCover_width];
    
    NSURL *customUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[itemDict valueForKey:@"list_image"]]];
    
    [cell.activityImage sd_setImageWithURL:customUrl placeholderImage:[UIImage imageNamed:@"profile_background"] options:0 progress:nil completed:nil];
    cell.titleLable.text = [[topListArray objectAtIndex:indexPath.row] valueForKey:@"ListName"];
    cell.likeLable.text = [[topListArray objectAtIndex:indexPath.row] valueForKey:@"LikeCount"];
    cell.percentageLable.text = [NSString stringWithFormat:@"%@%%",[[topListArray objectAtIndex:indexPath.row] valueForKey:@"RecommendedPercentage"]];
    CGSize  textSize = {122, 36};
    
    CGSize size = [[NSString stringWithFormat:@"%@", cell.titleLable.text]
                   sizeWithFont:[cell.titleLable font]
                   constrainedToSize:textSize
                   lineBreakMode:NSLineBreakByWordWrapping];
    cell.titleHeightConstant.constant = size.height+5;
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FeaturedListFirstViewController *featureList = [self.storyboard instantiateViewControllerWithIdentifier:@"FeaturedListFirstViewController"];
    featureList.listDictinfo = [topListArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:featureList animated:YES];
}

//- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return NO;
//}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    return CGSizeMake(self.collectionView.frame.size.width/2-5, 50);
//}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//
//
//    return 10.0;
//}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    
    
    return 19.06;
}

- (IBAction)forwardBtnAction:(id)sender
{
    [self.aboutView setHidden:NO];
    [self.profileView setHidden:YES];
}

- (IBAction)backwardBtnAction:(id)sender
{
    [self.aboutView setHidden:YES];
    [self.profileView setHidden:NO];
}

- (IBAction)settingBtnAction:(id)sender
{
    SettingsViewController *setting  =[self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self.navigationController pushViewController:setting animated:YES];
}

- (IBAction)followerBtnAction:(id)sender
{
    FollowersViewController *follower = [self.storyboard instantiateViewControllerWithIdentifier:@"FollowersViewController"];
    follower.titleStr =@"Followers";
    follower.userIdStr = [[USERDEFAULTS valueForKey:kuserID] stringValue];
    [self.navigationController pushViewController:follower animated:YES];
}
- (IBAction)seeAllAction:(id)sender
{
//    FeaturedViewController *featured = [self.storyboard instantiateViewControllerWithIdentifier:@"FeaturedViewController"];
//    featured.featuredArray = topListArray;
//    featured.isfromUserProfile = YES;
//    [self.navigationController pushViewController:featured animated:YES];
    
    TopListViewController *featured = [self.storyboard instantiateViewControllerWithIdentifier:@"TopListViewController"];
    featured.topListArray = topListArray;
    [self.navigationController pushViewController:featured animated:YES];
}

- (IBAction)followingBtnAction:(id)sender
{
    FollowersViewController *follower = [self.storyboard instantiateViewControllerWithIdentifier:@"FollowersViewController"];
    follower.titleStr =@"Following";
    follower.userIdStr = [[USERDEFAULTS valueForKey:kuserID] stringValue];
    follower.isfollowing = YES;
    [self.navigationController pushViewController:follower animated:YES];
}
- (IBAction)seeAllKeyword:(id)sender
{
    KeywordViewController *keywordView = [self.storyboard instantiateViewControllerWithIdentifier:@"KeywordViewController"];
    keywordView.keywords = [[_keywordView allTags] componentsJoinedByString:@","];
    [self.navigationController pushViewController:keywordView animated:NO];
}

- (IBAction)myListAction:(id)sender {
    
    [self.tabBarController setSelectedIndex:0];
}
@end
