//
//  FollowingUserProfileViewController.m
//  Listy
//
//  Created by Silstone on 28/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "FollowingUserProfileViewController.h"
#import "Listy.pch"

@interface FollowingUserProfileViewController ()
{
    NSMutableArray *imageArray,*listImageArray,*listNameArray,*topListArray,*categoryArray;
    NSMutableDictionary *userDetailDict;
    NSMutableArray *finalCategoryArray;
}

@end

@implementation FollowingUserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // self.listCollectionHeight.constant = 700;
    self.userImage.layer.cornerRadius = self.userImage.frame.size.height/2;
    self.userImage.layer.masksToBounds = YES;
    
//    imageArray = [[NSMutableArray alloc]initWithObjects:@"dummy_image_square_1",@"dummy_image_square_2",@"dummy_image_square_3",@"dummy_image_square_4",@"dummy_image_square_5", nil];
//
//    listImageArray = [[NSMutableArray alloc]initWithObjects:@"image_22",@"image_23",@"image_24",@"image_25",@"image_26",@"image_27",@"image_28",@"image_29",@"image_30", nil];
//
//    listNameArray = [[NSMutableArray alloc]initWithObjects:@"Music",@"Film & TV",@"Food",@"Sport",@"DIY",@"Travel",@"To do’s",@"Bucket list",@"Fashion", nil];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CategoryCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CategoryCollectionCell"];
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.listCollectionView registerNib:[UINib nibWithNibName:@"MyListViewCell" bundle:nil] forCellWithReuseIdentifier:@"MyListViewCell"];
    self.listCollectionView.backgroundColor = [UIColor clearColor];
    
    if ([[[USERDEFAULTS valueForKey:kuserID] stringValue] isEqualToString:self.followerIdStr])
    {
        [self.followBtn setHidden:YES];
    }
    
    self.profileName.text = @"";
    self.listNumberlbl.text = @"";
    self.followingNumberlbl.text = @"";
    self.followerNumberlbl.text = @"";
    self.listNameLable.text = @"";
    self.userListLable.text = @"";
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        if ((int)[[UIScreen mainScreen] nativeBounds].size.height>=2436) {
            self.topProfileConstraint.constant = self.topProfileConstraint.constant+20;
        }
        
    }
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    [self GetFollowerInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)setLayout
{
//    [self.profileDetailView setHidden:NO];
    
    CGSize  textSize = {300, 13};
    
    CGSize size = [[NSString stringWithFormat:@"%@", self.locationlbl.text]
                   sizeWithFont:[self.locationlbl font]
                   constrainedToSize:textSize
                   lineBreakMode:NSLineBreakByWordWrapping];
    self.textwidthConstant.constant = size.width;
    
    self.locationlbl.text = [userDetailDict valueForKey:@"Location"];
    if (![self.locationlbl.text isEqualToString:@""]) {
        [self.locationImage setHidden:NO];
    }
    
    self.profileName.text = [userDetailDict valueForKey:@"Follwerusername"];
    self.listNumberlbl.text = [[userDetailDict valueForKey:@"numberoflist"] stringValue];
    self.followingNumberlbl.text = [[userDetailDict valueForKey:@"numberoffollowing"] stringValue];
    self.followerNumberlbl.text = [[userDetailDict valueForKey:@"numberoffollower"] stringValue];
    
    if (![userDetailDict valueForKey:@"numberoflist"]) {
        [self.listNumberlbl setText:@"0"];
    }
    if ([self.followingNumberlbl.text isEqualToString:@""]) {
        [self.followingNumberlbl setText:@"0"];
    }
    if ([self.followerNumberlbl.text isEqualToString:@""]) {
        [self.followerNumberlbl setText:@"0"];
    }
    self.listNameLable.text = [NSString stringWithFormat:@"%@'s Top Lists",[userDetailDict valueForKey:@"Follwerusername"]];
    self.userListLable.text = [NSString stringWithFormat:@"%@'s Lists",[userDetailDict valueForKey:@"Follwerusername"]];
    
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"UserProfileImages"]]] placeholderImage:[UIImage imageNamed:@"user_profile"] options:0 progress:nil completed:nil];
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[userDetailDict valueForKey:@"CoveredProfileImages"]]] placeholderImage:[UIImage imageNamed:@"profile_background"] options:0 progress:nil completed:nil];
    
    if (![[userDetailDict valueForKey:@"Status"] isEqualToString:@"follow"]) {
        [self.followBtn setSelected:YES];
        
    }else
    {
        [self.followImage setHidden:NO];
    }
    
    [self UserCategories];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
    CGFloat height = self.listCollectionView.collectionViewLayout.collectionViewContentSize.height;
    if (IS_IPHONE_5) {
        self.listCollectionHeight.constant = height+25;
    } else {
        self.listCollectionHeight.constant = height+10;
    }
    
    [self.view layoutIfNeeded];
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

-(void)GetFollowerInfo
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"userid"];
    [dict setObject:self.followerIdStr forKey:@"followerid"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]GetFollowerInfo:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             userDetailDict = [[[object valueForKey:@"GetFollowerinfo"] objectAtIndex:0]  mutableCopy];
             userDetailDict = [Utility removeNullFromDictionary:userDetailDict];
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
    [dict setObject:self.followerIdStr forKey:@"ownerid"];
    [dict setObject:@"0" forKey:@"offset"];
    [dict setObject:searchText forKey:@"searchtext"];
    
    //NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]UserTopList:^(id object)
     {
         
         //NSLog(@"%@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
             
         {
             topListArray = [object valueForKey:@"List"];
             
             if (topListArray.count<1)
             {
                 [self.seeAllBtn setHidden:YES];
                 [self.nolistLable setHidden:NO];
             } else {
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


-(void)UserCategories
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:self.followerIdStr forKey:@"userid"];
    [dict setObject:@"1" forKey:@"offset"];
    
    
    //NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]UserCategories:^(id object)
     {
         //NSLog(@"%@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {

             categoryArray = [[object valueForKey:@"UserCategory"] mutableCopy];
             //finalCategoryArray = [[NSMutableArray alloc]initWithArray:categoryArray];
             //vinay here-
//             NSArray *selectedCategory = [[object valueForKey:@"SelectedCategory"] mutableCopy];
//
//             [categoryArray addObjectsFromArray:selectedCategory];
             
             finalCategoryArray = [[NSMutableArray alloc]init];
             
             for (NSMutableDictionary *dict in categoryArray)
             {
                 if ([[dict valueForKey:@"no_of_lists"] integerValue]>0) {
                     [finalCategoryArray addObject:dict];
                 }
             }
             
             //NSLog(@"%@",categoryArray);
             [self.listCollectionView reloadData];
             CGFloat height = self.listCollectionView.collectionViewLayout.collectionViewContentSize.height;
             self.listCollectionHeight.constant = height+10;
             [self.view layoutIfNeeded];
             [self UserTopList:@""];
            
             
         } else
         {
             //[Utility showAlertMessage:nil message:[object valueForKey:@"Message"]];
             //NSLog(@"%@",categoryArray);
             [self.listCollectionView reloadData];
             
         }
         
         [kAppDelegate hideProgressHUD];
         
         
         
     }
                                               onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}

-(void)Userfollow
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"userid"];
    [dict setObject:self.followerIdStr forKey:@"userfollowid"];
 
    if ([self.followBtn isSelected]) {
         [dict setObject:@"follow" forKey:@"Status"];
    } else {
         [dict setObject:@"unfollow" forKey:@"Status"];
    }
    
    //NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]Userfollow:^(id object)
     {
         //NSLog(@"%@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             NSString *userfollow = [NSString stringWithFormat:@"%@",[[object  valueForKey:@"Userfollow"] valueForKey:@"Status"]];
             
             if (![userfollow isEqualToString:@"follow"]) {
                 [self.followBtn setSelected:YES];
                 [self.followImage setHidden:YES];
             } else {
                 [self.followBtn setSelected:NO];
                 [self.followImage setHidden:NO];
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
   
    if (collectionView==self.listCollectionView)
    {
        return finalCategoryArray.count;
    }
    return topListArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (collectionView==self.listCollectionView)
    {
        MyListViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyListViewCell" forIndexPath:indexPath];
        
        cell.listNameLable.text = [[finalCategoryArray objectAtIndex:indexPath.row] valueForKey:@"Categoryname"];
        
        //    cell.dotBtn.hidden = false;
        cell.listImage.layer.cornerRadius = 4;
        cell.listImage.layer.masksToBounds = YES;
        [cell.listImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[finalCategoryArray objectAtIndex:indexPath.row] valueForKey:@"CategoryImage"]]] placeholderImage:[UIImage imageNamed:@"listy_folder"] options:0 progress:nil completed:nil];
        
        return cell;
    }
    
    CategoryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCollectionCell" forIndexPath:indexPath];
    
    cell.activityImage.layer.cornerRadius = 4;
    cell.activityImage.layer.masksToBounds = YES;
    cell.overlayImage.layer.cornerRadius = 4;
    cell.overlayImage.clipsToBounds = YES;
   // cell.activityImage.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
    NSMutableDictionary *itemDict = [topListArray objectAtIndex:indexPath.row];
//    NSString *urlStr = [NSString stringWithFormat:kBaseURL@"CreateThumbnailURL?listid=%@&listitemid=%d&url=%@&width=%@&height=0",[itemDict valueForKey:@"id"],0,[itemDict valueForKey:@"list_image"],kCover_width];
    
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

//- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return NO;
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath

{
    if (collectionView==self.listCollectionView)
    {
        ListDetailViewController *listDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"ListDetailViewController"];
        listDetail.categoryIDStr = [[finalCategoryArray objectAtIndex:indexPath.row] valueForKey:@"Categoryid"];
        listDetail.titleStr = [[finalCategoryArray objectAtIndex:indexPath.row] valueForKey:@"Categoryname"];
        listDetail.followerid = self.followerIdStr;
        [self.navigationController pushViewController:listDetail animated:YES];
    }else
    {

            FeaturedListFirstViewController *featureList = [self.storyboard instantiateViewControllerWithIdentifier:@"FeaturedListFirstViewController"];
            featureList.listDictinfo = [topListArray objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:featureList animated:YES];

    }

    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView==self.listCollectionView)
    {
        if(IS_IPHONE_5)
        {
            NSLog(@"i am an iPhone 5!");
            return CGSizeMake(80, 120);
        }
        return CGSizeMake(101, 135);
    }
    
    return CGSizeMake(159, 189);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    
    
    return 19.06;
}

- (IBAction)backBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
- (IBAction)followerBtnAction:(id)sender
{
    FollowersViewController *follower = [self.storyboard instantiateViewControllerWithIdentifier:@"FollowersViewController"];
    follower.titleStr =@"Followers";
    follower.userIdStr = self.followerIdStr;
    [self.navigationController pushViewController:follower animated:YES];
}

- (IBAction)followingBtnAction:(id)sender
{
    FollowersViewController *follower = [self.storyboard instantiateViewControllerWithIdentifier:@"FollowersViewController"];
    follower.titleStr =@"Following";
    follower.userIdStr = self.followerIdStr;
    follower.isfollowing = YES;
    [self.navigationController pushViewController:follower animated:YES];
}
- (IBAction)followBtnAction:(id)sender
{
    [self Userfollow];
}
@end
