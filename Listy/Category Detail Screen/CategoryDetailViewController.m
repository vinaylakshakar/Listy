//
//  CategoryDetailViewController.m
//  Listy
//
//  Created by Silstone on 13/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "CategoryDetailViewController.h"
#import "Listy.pch"

@interface CategoryDetailViewController ()
{
    NSMutableArray *imageArray,*iconImageArray,*featuredimageArray,*friendsActivityArray;
    UIActivityIndicatorView *spinner;
    int offsetLimit;
    BOOL isForDiscover;
    bool EnableApiCall;
}

@end

@implementation CategoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    EnableApiCall = true;
    offsetLimit =0;
    friendsActivityArray = [[NSMutableArray alloc]init];
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner stopAnimating];
    spinner.hidesWhenStopped = YES;
    spinner.frame = CGRectMake(0, self.view.frame.size.height-125, self.view.frame.size.width, 44);
   // [self.scrollView addSubview:spinner];
    [self.view insertSubview:spinner aboveSubview:self.collectionView];
    //self.categoryTable.tableFooterView = spinner;
       self.searchView.layer.cornerRadius = 5;
    imageArray = [[NSMutableArray alloc]initWithObjects:@"dummy_image_square_1",@"dummy_image_square_2",@"dummy_image_square_3",@"dummy_image_square_4",@"dummy_image_square_5", nil];
    iconImageArray = [[NSMutableArray alloc]initWithObjects:@"images-1",@"Unknown",@"images-1",@"Unknown",@"images-1", nil];
    //featuredimageArray = [[NSMutableArray alloc]initWithObjects:@"dummy_image_portrait_1",@"dummy_image_portrait_2",@"dummy_image_portrait_3",@"dummy_image_portrait_1",@"dummy_image_portrait_2",@"dummy_image_portrait_3", nil];
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CategoryCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CategoryCollectionCell"];
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.featuredCollection registerNib:[UINib nibWithNibName:@"FeaturedCategoryCell" bundle:nil] forCellWithReuseIdentifier:@"FeaturedCategoryCell"];
    self.featuredCollection.backgroundColor = [UIColor clearColor];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ActivityCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"ActivityCollectionCell"];
    self.collectionView.backgroundColor = [UIColor clearColor];
    

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(searchCategory:)
                                                 name:@"categoryDetail"
                                               object:nil];
    if (!self.isShowFeatured) {
        self.featuredViewHeight.constant = 0;
        [self.seeAllBtn setHidden:YES];
        [self.featuredLable setHidden:YES];
        friendsActivityArray = self.activityArray;
        self.titleLable.text = self.titleStr; 
        self.searchText=@"";
        [self reloadData];
    }else
    {
        if (self.searchText)
        {
            if (self.isfromDiscoverSearch) {
                isForDiscover = YES;
                [self discover_Search:self.titleStr];
            } else {
                 [self discover_list:self.searchText];
                 self.titleLable.text = self.titleStr; 
            }
           
        }
        else
        {
            self.searchText=@"";
            if (self.isfromDiscoverSearch) {
                isForDiscover = YES;
                self.titleLable.text =@"";
                [self discover_Search:self.titleStr];
            } else {
                self.titleLable.text = self.titleStr;
                [self discover_list:@""];
            }
           
        }
        
    }
    
//    self.titleLable.text = self.titleStr;
   // [self discover_list];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    [textField resignFirstResponder];
    return YES;
}

- (void)searchCategory:(NSNotification *)notification
{
    self.searchText = [notification.userInfo valueForKey:@"searchText"];
    offsetLimit=0;
    
    if (self.isfromDiscoverSearch)
    {
        if ([self.searchText isEqualToString:@""])
        {
            [self.navigationController popViewControllerAnimated:NO];
        } else {
             [self discover_Search:self.searchText];
        }
       
    } else {
        [self discover_list:self.searchText];
    }

//    isForDiscover = YES;
//    [self discover_Search:self.searchText];
    
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

-(void)discover_list:(NSString*)searchText
{
    self.searchField.text = searchText;
    if (offsetLimit==0) {
        [featuredimageArray removeAllObjects];
        [friendsActivityArray removeAllObjects];
        [kAppDelegate showProgressHUD];
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"userid"];
    //[dict setObject:@"1" forKey:@"userid"];
    
    if (!self.isShowFeatured)
    {
        [dict setObject:@"0" forKey:@"categoryid"];
    } else {
        [dict setObject:self.categoryId forKey:@"categoryid"];
    }
   // [dict setObject:@"0" forKey:@"categoryid"];
    NSString *offsetStr = [NSString stringWithFormat:@"%d",offsetLimit];
    [dict setObject:offsetStr forKey:@"offset"];
    [dict setObject:searchText forKey:@"searchtext"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]discover_list:^(id object)
     {
         
         //NSLog(@"%@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             if (!self.isShowFeatured) {
                 
                 if (offsetLimit==0)
                 {
                     friendsActivityArray = [[object valueForKey:@"FriendsActivity"] mutableCopy];
                 }
                 else
                 {
                     [friendsActivityArray addObjectsFromArray:[object valueForKey:@"FriendsActivity"]];
                     NSMutableArray* ActivityArray= [[object valueForKey:@"FriendsActivity"] mutableCopy];
                     if (ActivityArray.count==0) {
                        //[self reloadData];
                         EnableApiCall= false;
                     }
                 }
                 
             } else {
                 
                 if (offsetLimit==0) {
                     
                     NSMutableArray* listArray= [[object valueForKey:@"ListCategory"] mutableCopy];
                     if (listArray.count>0) {
                         if ([self.searchField.text isEqualToString:@""]) {
                             friendsActivityArray = [[[[object valueForKey:@"ListCategory"]objectAtIndex:0] valueForKey:@"List"] mutableCopy];
                         } else {
                             friendsActivityArray = [[object valueForKey:@"ListCategory"] mutableCopy];
                         }
                         
                     }
                     featuredimageArray = [[object valueForKey:@"FeaturedList"] mutableCopy];
                 } else {
                     
                     NSMutableArray *listCategory = [object valueForKey:@"ListCategory"];
                     
                     if (listCategory.count>0) {
                         [friendsActivityArray addObjectsFromArray:[[listCategory objectAtIndex:0] valueForKey:@"List"]];
                     }
                     
                     [featuredimageArray addObjectsFromArray:[object valueForKey:@"FeaturedList"]];
                     
                     if ([[[object valueForKey:@"FeaturedList"] mutableCopy] count]==0&&listCategory.count==0)
                     {
                          //[self reloadData];
                         EnableApiCall =false;
                     }
                 }
                 
                 if (featuredimageArray.count<1) {
                     self.featuredViewHeight.constant = 0;
                     [self.seeAllBtn setHidden:YES];
                     [self.featuredLable setHidden:YES];
                 }else
                 {
                     self.featuredViewHeight.constant = 213;
                     [self.seeAllBtn setHidden:NO];
                     [self.featuredLable setHidden:NO];
                 }
                 
             }
          
             if (EnableApiCall) {
                 [self reloadData];
             }
            
             
         } else
         {
             [Utility showAlertMessage:nil message:[object valueForKey:@"Message"]];
         }
         
         if (offsetLimit==0) {
             [kAppDelegate hideProgressHUD];
         }else
         {
             [spinner stopAnimating];
         }
         
         
     }
                                              onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}

-(void)discover_Search:(NSString*)searchText
{
    self.searchField.text = searchText;
    if (offsetLimit==0) {
        [featuredimageArray removeAllObjects];
        [friendsActivityArray removeAllObjects];
        [kAppDelegate showProgressHUD];
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"userid"];
    //[dict setObject:@"1" forKey:@"userid"];
     [dict setObject:@"0" forKey:@"categoryid"];
    // [dict setObject:@"0" forKey:@"categoryid"];
    NSString *offsetStr = [NSString stringWithFormat:@"%d",offsetLimit];
    [dict setObject:offsetStr forKey:@"offset"];
    [dict setObject:searchText forKey:@"searchtext"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]discover_list:^(id object)
     {
         
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             if (offsetLimit==0) {
                 
                 NSMutableArray* listArray= [[object valueForKey:@"ListCategory"] mutableCopy];
                 if (listArray.count>0) {
                     
                     if ([self.searchField.text isEqualToString:@""]) {
                         friendsActivityArray = [[[[object valueForKey:@"ListCategory"]objectAtIndex:0] valueForKey:@"List"] mutableCopy];
                     } else {
                         friendsActivityArray = [[object valueForKey:@"ListCategory"] mutableCopy];
                     }
                    // friendsActivityArray = [[object valueForKey:@"ListCategory"] mutableCopy];
                 }
                 featuredimageArray = [[object valueForKey:@"FeaturedList"] mutableCopy];
             } else {
                 
                 NSMutableArray *listCategory = [object valueForKey:@"ListCategory"];
                 
                 if (listCategory.count>0) {
                     [friendsActivityArray addObjectsFromArray:[[listCategory objectAtIndex:0] valueForKey:@"List"]];
                 }
                 
                 [featuredimageArray addObjectsFromArray:[object valueForKey:@"FeaturedList"]];
             }
             
             if (featuredimageArray.count<1) {
                 self.featuredViewHeight.constant = 0;
                 [self.seeAllBtn setHidden:YES];
                 [self.featuredLable setHidden:YES];
             }else
             {
                 self.featuredViewHeight.constant = 213;
                 [self.seeAllBtn setHidden:NO];
                 [self.featuredLable setHidden:NO];
             }
             
             
             [self reloadData];
             
         } else
         {
             [Utility showAlertMessage:nil message:[object valueForKey:@"Message"]];
         }
         
         if (offsetLimit==0) {
             [kAppDelegate hideProgressHUD];
         }else
         {
             [spinner stopAnimating];
         }
         
         
     }
                                              onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}

-(void)reloadData
{
    [self.categoryTable reloadData];
    [self.collectionView reloadData];
    [self.featuredCollection layoutIfNeeded];
    [self.featuredCollection reloadData];
    
    if ([self.categoryTable isHidden])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //This code will run in the main thread:
            CGFloat height = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
            // CGFloat Collectionheight = self.collectionView.contentSize.height;
            self.tableViewHeight.constant = height+30;
            //self.scrollHeight.constant = self.tableViewHeight.constant+350;
        });
    } else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //This code will run in the main thread:
            CGFloat height = self.categoryTable.contentSize.height;
            //CGFloat Collectionheight = self.featuredCollection.contentSize.height;
            //self.collectionHeight.constant = height;
            self.tableViewHeight.constant = height+70;
        });
        
    }
    

}

#pragma tableview methods-

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return friendsActivityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    static NSString *propertyIdentifier = @"CategoryDetailCell";
    
    CategoryDetailCell *cell = (CategoryDetailCell *)[tableView dequeueReusableCellWithIdentifier:propertyIdentifier];
    

        if (cell == nil)
        {
            
            NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"CategoryDetailCell" owner:self options:nil];
            cell = [nib1 objectAtIndex:0];
        }

   // cell.categoryImage.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
    //cell.profileImage.image =[UIImage imageNamed:[iconImageArray objectAtIndex:indexPath.row]];
    
    cell.categoryImage.layer.cornerRadius = 10;
    cell.categoryImage.clipsToBounds = YES;
    cell.gradientImage.layer.cornerRadius = 10;
    cell.gradientImage.clipsToBounds = YES;
    
    NSMutableDictionary *itemDict = [friendsActivityArray objectAtIndex:indexPath.row];
  //  NSString *urlStr = [NSString stringWithFormat:kBaseURL@"CreateThumbnailURL?listid=%@&listitemid=%d&url=%@&width=%@&height=0",[itemDict valueForKey:@"id"],0,[itemDict valueForKey:@"list_image"],kCover_width];

    NSURL *customUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[itemDict valueForKey:@"list_image"]]];
    
    [cell.categoryImage sd_setImageWithURL:customUrl placeholderImage:[UIImage imageNamed:@"profile_background"] options:0 progress:nil completed:nil];

    cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width/2;
    cell.profileImage.clipsToBounds = YES;
    
    if (self.isShowFeatured)
    {
        cell.dotBtn.hidden = false;
        cell.listName.text = [NSString stringWithFormat:@"%@",[[friendsActivityArray objectAtIndex:indexPath.row] valueForKey:@"ListName"]];
        cell.userName.text = [[friendsActivityArray objectAtIndex:indexPath.row] valueForKey:@"ownername"];
        [cell.profileImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[friendsActivityArray objectAtIndex:indexPath.row] valueForKey:@"ownerimage"]]] placeholderImage:[UIImage imageNamed:@"user_profile"] options:0 progress:nil completed:nil];
        cell.likeLable.text = [[friendsActivityArray objectAtIndex:indexPath.row] valueForKey:@"LikeCount"];
        cell.percentageLable.text = [NSString stringWithFormat:@"%@%%",[[friendsActivityArray objectAtIndex:indexPath.row] valueForKey:@"recPercentage"]];
        
        NSArray *keywords = [[[friendsActivityArray objectAtIndex:indexPath.row] valueForKey:@"listkeyword"] componentsSeparatedByString:@","];
        NSMutableArray* mutableKeyword = [[NSMutableArray alloc]initWithArray:keywords];
        [mutableKeyword removeObject:@""];
        
        [self setTagView:cell :[mutableKeyword componentsJoinedByString:@","]];
    }else
    {
//        if ([[[friendsActivityArray objectAtIndex:indexPath.row] valueForKey:@"actionPerformed"] isEqualToString:@"Created"])
//        {
//            cell.listName.text = [NSString stringWithFormat:@"%@ a list",[[friendsActivityArray objectAtIndex:indexPath.row] valueForKey:@"actionPerformed"]];
//        } else {
//            cell.listName.text = [NSString stringWithFormat:@"%@ %@'s list",[[friendsActivityArray objectAtIndex:indexPath.row] valueForKey:@"actionPerformed"],[[friendsActivityArray objectAtIndex:indexPath.row] valueForKey:@"listOwnerName"]];
//        }
        //vinay here-
        cell.listName.text = [NSString stringWithFormat:@"%@",[[friendsActivityArray objectAtIndex:indexPath.row] valueForKey:@"ListName"]];
        [cell.profileImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[friendsActivityArray objectAtIndex:indexPath.row] valueForKey:@"actionUserImage"]]] placeholderImage:[UIImage imageNamed:@"user_profile"] options:0 progress:nil completed:nil];
        cell.userName.text = [[friendsActivityArray objectAtIndex:indexPath.row] valueForKey:@"actionUserName"];
        
        if ([self.titleStr isEqualToString:@"Friends Activity"])
        {
            cell.likeLable.text = [[friendsActivityArray objectAtIndex:indexPath.row] valueForKey:@"likecount"];
            
        } else {
            cell.likeLable.text = [[friendsActivityArray objectAtIndex:indexPath.row] valueForKey:@"likeCount"];
            
        }
        NSLog(@"like number-%@",cell.likeLable.text);
        
        cell.percentageLable.text = [NSString stringWithFormat:@"%@%%",[[friendsActivityArray objectAtIndex:indexPath.row] valueForKey:@"recPercentage"]];
        
        NSArray *keywords = [[[friendsActivityArray objectAtIndex:indexPath.row] valueForKey:@"listkeyword"] componentsSeparatedByString:@","];
        NSMutableArray* mutableKeyword = [[NSMutableArray alloc]initWithArray:keywords];
        [mutableKeyword removeObject:@""];
        
        [self setTagView:cell :[mutableKeyword componentsJoinedByString:@","]];
    }
    
     cell.dotBtn.tag = indexPath.row;
     [cell.dotBtn addTarget:self action:@selector(OwnerOptions:) forControlEvents:UIControlEventTouchUpInside];
   
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeaturedListFirstViewController *featureList = [self.storyboard instantiateViewControllerWithIdentifier:@"FeaturedListFirstViewController"];
    featureList.listDictinfo = [friendsActivityArray objectAtIndex:indexPath.row];
    //NSLog(@"listDict %@",featureList.listDictinfo);
    [self.navigationController pushViewController:featureList animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView
                  willDecelerate:(BOOL)decelerate{
    
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = 50;
    if(y > h + reload_distance) {
        //NSLog(@"load more data");
        [spinner setHidden:NO];
        [spinner startAnimating];
        
        offsetLimit =offsetLimit+1;
        
        if (isForDiscover)
        {
            //[self discover_Search:self.searchText];
            [self discover_Search:self.searchField.text];
        } else {
           // [self discover_list:self.searchText];
            [self discover_list:self.searchField.text];
        }
        
        
        
        
    }
}

-(void)OwnerOptions:(UIButton*)sender
{
//    OwnerOptionsViewController *Owner =[self.storyboard instantiateViewControllerWithIdentifier:@"OwnerOptionsViewController"];
//    [self.navigationController pushViewController:Owner animated:NO];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    CategoryDetailCell *cell = (CategoryDetailCell *)[self.categoryTable cellForRowAtIndexPath:indexPath];
    
    
    //NSLog(@"%@ tag %ld",[friendsActivityArray objectAtIndex:sender.tag],(long)sender.tag);
    
    if ([[[friendsActivityArray objectAtIndex:sender.tag] valueForKey:@"userid"] isEqualToString:[[USERDEFAULTS valueForKey:kuserID] stringValue]])
    {
        OwnerOptionsViewController *Owner =[self.storyboard instantiateViewControllerWithIdentifier:@"OwnerOptionsViewController"];
        Owner.isfromList = YES;
        Owner.isfromDiscoverCategory=YES;
        Owner.listImage = cell.categoryImage.image;
        Owner.detailDict = [friendsActivityArray objectAtIndex:sender.tag];
        [self displayContentController:Owner];
        //[self presentViewController:Owner animated:YES completion:nil];
        //        [UIView transitionWithView:self.view
        //                          duration:1.0
        //                           options:UIViewAnimationOptionCurveEaseIn
        //                        animations:^{
        //
        //                        }
        //                        completion:NULL];
        //        [self.view addSubview:Owner.view];
        
    }else
    {
        GeneralOptionsViewController *General =[self.storyboard instantiateViewControllerWithIdentifier:@"GeneralOptionsViewController"];
        General.isfromList = YES;
        General.isfromDiscoverCategory=YES;
        General.listImage = cell.categoryImage.image;
        General.detailDict = [friendsActivityArray objectAtIndex:sender.tag];
        [self displayContentController:General];
        //[self presentViewController:General animated:YES completion:nil];
        
    }
    
}


- (void)displayContentController:(UIViewController *)content {
    [self addChildViewController:content];
    content.view.frame = [[UIScreen mainScreen] bounds];
    
    //vinay here-
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [content.view.layer addAnimation:transition forKey:nil];
    [self.view addSubview:content.view];
    
    [content didMoveToParentViewController:self];
}


-(void)setTagView:(CategoryDetailCell *)Cell :(NSString*)keywords
{
    //NSArray *tags = @[@"Movies",@"80's",@"Sound track",@"Cult",@"Punk"];
    NSArray *tags;
    if ([keywords isEqualToString:@""]) {
        tags = [[NSArray alloc]init];
    } else {
        tags = [keywords componentsSeparatedByString:@","];
    }
    
    Cell.tagView.alignment = TTGTagCollectionAlignmentLeft;
    
    TTGTextTagConfig *config = [TTGTextTagConfig new];
    //config.tagTextFont = [UIFont fontWithName:@"SFProText-Regular" size:5];
    
    config.tagTextColor = [UIColor whiteColor];
    config.tagSelectedTextColor = [UIColor whiteColor];
   // config.tagSelectedTextColor = RED_COLOR;
    config.tagExtraSpace = CGSizeMake(20, 15);
    
    NSUInteger location = 0;
    NSUInteger length = tags.count;
    config.tagBackgroundColor = [UIColor colorWithRed:0.71 green:0.72 blue:0.77 alpha:1.0];
    config.tagSelectedBackgroundColor = [UIColor colorWithRed:0.71 green:0.72 blue:0.77 alpha:1.0];
    config.tagShadowOpacity = 0.0;
    config.tagBorderColor = [UIColor clearColor];
    config.tagShadowRadius =1;
   // config.tagSelectedBackgroundColor = [UIColor whiteColor];
    config.tagTextFont = [UIFont fontWithName:@"SFProText-Regular" size:10];
    config.tagCornerRadius = 13;
    config.tagSelectedCornerRadius =13;
    config.tagSelectedBorderColor = [UIColor clearColor];
    config.extraData = @{@"key": @"1"};
    [Cell.tagView addTags:[tags subarrayWithRange:NSMakeRange(location, length)] withConfig:[config copy]];
    
    Cell.tagView.delegate = Cell.self;
    [Cell.tagView setUserInteractionEnabled:NO];
    
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (collectionView==self.featuredCollection) {
        return featuredimageArray.count;
    }
    return friendsActivityArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (collectionView==self.featuredCollection)
    {
       FeaturedCategoryCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeaturedCategoryCell" forIndexPath:indexPath];
        
        cell1.featuredImage.layer.cornerRadius = 4;
        cell1.featuredImage.layer.masksToBounds = YES;
        cell1.gradientImage.layer.cornerRadius = 4;
        cell1.gradientImage.layer.masksToBounds = YES;
        //cell1.featuredImage.image =[UIImage imageNamed:[featuredimageArray objectAtIndex:indexPath.row]];
        UIImage *placeholderImage = [UIImage imageNamed:@"profile_background"];
        [cell1.featuredImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[featuredimageArray objectAtIndex:indexPath.row] valueForKey:@"list_image"]]] placeholderImage:placeholderImage options:0 progress:nil completed:nil];
        cell1.listTitle.text = [[featuredimageArray objectAtIndex:indexPath.row] valueForKey:@"ListName"];
        return cell1;
    }
    
    if (!self.isShowFeatured)
    {
      ActivityCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ActivityCollectionCell" forIndexPath:indexPath];
        cell.activityImage.layer.cornerRadius = 4;
        cell.activityImage.layer.masksToBounds = YES;
        // cell.activityImage.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
        cell.iconImage.layer.cornerRadius = cell.iconImage.frame.size.height/2;
        cell.iconImage.layer.masksToBounds = YES;
        // cell.iconImage.image = [UIImage imageNamed:[iconImageArray objectAtIndex:indexPath.row]];
        cell.gradientImage.layer.cornerRadius = 4;
        cell.gradientImage.clipsToBounds = YES;
        
        NSMutableDictionary *itemDict = [friendsActivityArray objectAtIndex:indexPath.row];
      //  NSString *urlStr = [NSString stringWithFormat:kBaseURL@"CreateThumbnailURL?listid=%@&listitemid=%d&url=%@&width=%@&height=0",[itemDict valueForKey:@"id"],0,[itemDict valueForKey:@"list_image"],kCover_width];
        
        NSURL *customUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[itemDict valueForKey:@"list_image"]]];
        
        
        [cell.activityImage sd_setImageWithURL:customUrl placeholderImage:[UIImage imageNamed:@"profile_background"] options:0 progress:nil completed:nil];
        [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[friendsActivityArray objectAtIndex:indexPath.row] valueForKey:@"actionUserImage"]]] placeholderImage:[UIImage imageNamed:@"user_profile"] options:0 progress:nil completed:nil];
        cell.userName.text = [[friendsActivityArray objectAtIndex:indexPath.row] valueForKey:@"actionUserName"];
        
        if ([[[friendsActivityArray objectAtIndex:indexPath.row] valueForKey:@"actionPerformed"] isEqualToString:@"Created"])
        {
            cell.activityName.text = [NSString stringWithFormat:@"%@ a list",[[friendsActivityArray objectAtIndex:indexPath.row] valueForKey:@"actionPerformed"]];
        } else {
            cell.activityName.text = [NSString stringWithFormat:@"%@ %@'s list",[[friendsActivityArray objectAtIndex:indexPath.row] valueForKey:@"actionPerformed"],[[friendsActivityArray objectAtIndex:indexPath.row] valueForKey:@"listOwnerName"]];
        }
        
        cell.listName.text = [[friendsActivityArray objectAtIndex:indexPath.row] valueForKey:@"actionListName"];
        
        CGSize  textSize = {122, 36};
        //NSString * str = [NSString stringWithFormat:@"%@",cell.listName.text];
        NSString *trimmedNameList = [cell.listName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        CGSize size = [[NSString stringWithFormat:@"%@", trimmedNameList]
                       sizeWithFont:[cell.listName font]
                       constrainedToSize:textSize
                       lineBreakMode:NSLineBreakByWordWrapping];
        if (IS_IPHONE_5)
        {
             cell.titleHeightConstant.constant = size.height+15;
        }else
        {
            cell.titleHeightConstant.constant = size.height+5;
        }
        
        return cell;
    }
    CategoryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCollectionCell" forIndexPath:indexPath];

    cell.dotBtn.hidden = false;
    cell.activityImage.layer.cornerRadius = 4;
    cell.activityImage.layer.masksToBounds = YES;
    cell.overlayImage.layer.cornerRadius = 4;
    cell.overlayImage.clipsToBounds = YES;
    //cell.activityImage.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
    NSMutableDictionary *itemDict = [friendsActivityArray objectAtIndex:indexPath.row];
    //NSString *urlStr = [NSString stringWithFormat:kBaseURL@"CreateThumbnailURL?listid=%@&listitemid=%d&url=%@&width=%@&height=0",[itemDict valueForKey:@"id"],0,[itemDict valueForKey:@"list_image"],kCover_width];
    
    NSURL *customUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[itemDict valueForKey:@"list_image"]]];
    
    [cell.activityImage sd_setImageWithURL:customUrl placeholderImage:[UIImage imageNamed:@"profile_background"] options:0 progress:nil completed:nil];
    cell.titleLable.text = [[friendsActivityArray objectAtIndex:indexPath.row] valueForKey:@"ListName"];
    cell.likeLable.text = [[friendsActivityArray objectAtIndex:indexPath.row] valueForKey:@"LikeCount"];
    cell.percentageLable.text = [NSString stringWithFormat:@"%@%%",[[friendsActivityArray objectAtIndex:indexPath.row] valueForKey:@"recPercentage"]];
    cell.dotBtn.tag = indexPath.row;
    [cell.dotBtn addTarget:self action:@selector(selectList:) forControlEvents:UIControlEventTouchUpInside];
    
    CGSize  textSize = {122, 36};
    
    CGSize size = [[NSString stringWithFormat:@"%@", cell.titleLable.text]
                   sizeWithFont:[cell.titleLable font]
                   constrainedToSize:textSize
                   lineBreakMode:NSLineBreakByWordWrapping];
    cell.titleHeightConstant.constant = size.height+5;
    
    if (IS_IPHONE_5) {
        cell.imageHeightConstant.constant = 125;
    }
    
    return cell;
}

//- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return NO;
//}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  
    if (collectionView==self.collectionView)
    {
        if(IS_IPHONE_5)
        {
            NSLog(@"i am an iPhone 5!");
            return CGSizeMake(135, 175);
        }
        return CGSizeMake(165, 195);
    }

    return CGSizeMake(111, 161);
}

-(void)selectList:(UIButton*)sender
{
//    GeneralOptionsViewController *general =[self.storyboard instantiateViewControllerWithIdentifier:@"GeneralOptionsViewController"];
//    [self.navigationController pushViewController:general animated:NO];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
//    CategoryDetailCell *cell = (CategoryDetailCell *)[self.categoryTable cellForRowAtIndexPath:indexPath];
    CategoryCollectionCell *cell = (CategoryCollectionCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    //NSLog(@"%@ tag %ld",[friendsActivityArray objectAtIndex:sender.tag],(long)sender.tag);
    
    if ([[[friendsActivityArray objectAtIndex:sender.tag] valueForKey:@"userid"] isEqualToString:[[USERDEFAULTS valueForKey:kuserID] stringValue]])
    {
        OwnerOptionsViewController *Owner =[self.storyboard instantiateViewControllerWithIdentifier:@"OwnerOptionsViewController"];
        Owner.isfromList = YES;
        Owner.isfromDiscoverCategory = YES;
        Owner.listImage = cell.activityImage.image;
        Owner.detailDict = [friendsActivityArray objectAtIndex:sender.tag];
        [self displayContentController:Owner];
        //[self presentViewController:Owner animated:YES completion:nil];
        //        [UIView transitionWithView:self.view
        //                          duration:1.0
        //                           options:UIViewAnimationOptionCurveEaseIn
        //                        animations:^{
        //
        //                        }
        //                        completion:NULL];
        //        [self.view addSubview:Owner.view];
        
    }else
    {
        GeneralOptionsViewController *General =[self.storyboard instantiateViewControllerWithIdentifier:@"GeneralOptionsViewController"];
        General.isfromList = YES;
        General.isfromDiscoverCategory = YES;
        General.listImage = cell.activityImage.image;
        General.detailDict = [friendsActivityArray objectAtIndex:sender.tag];
        [self displayContentController:General];
        //[self presentViewController:General animated:YES completion:nil];
        
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *HeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        reusableview = HeaderView;
    }
    
    return reusableview;
}


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


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath

{
    if (collectionView==self.featuredCollection)
    {
        FeaturedListFirstViewController *featureList = [self.storyboard instantiateViewControllerWithIdentifier:@"FeaturedListFirstViewController"];
        featureList.listDictinfo = [featuredimageArray objectAtIndex:indexPath.row];
        //NSLog(@"listDict %@",featureList.listDictinfo);
        [self.navigationController pushViewController:featureList animated:YES];

    }else
    {
        FeaturedListFirstViewController *featureList = [self.storyboard instantiateViewControllerWithIdentifier:@"FeaturedListFirstViewController"];
        featureList.listDictinfo = [friendsActivityArray objectAtIndex:indexPath.row];
        //NSLog(@"listDict %@",featureList.listDictinfo);
        [self.navigationController pushViewController:featureList animated:YES];

    }
    
}

- (IBAction)flipViewAction:(id)sender {
    
    EnableApiCall =true;
    if (![sender isSelected]) {
        [sender setSelected:YES];
        [self.collectionView setHidden:true];
        [self.categoryTable setHidden:false];
//        imageArray = [[NSMutableArray alloc]initWithObjects:@"dummy_image_wide_1",@"dummy_image_wide_2",@"dummy_image_wide_3",@"dummy_image_wide_4",@"dummy_image_wide_1", nil];
//
//        [self.categoryTable reloadData];

        dispatch_async(dispatch_get_main_queue(), ^{
            //This code will run in the main thread:
            CGFloat height = self.categoryTable.contentSize.height;
            self.tableViewHeight.constant = height+70;;
            //self.scrollHeight.constant = self.tableViewHeight.constant+350;
        });
    }
    else
    {
        [sender setSelected:NO];
        [self.collectionView setHidden:false];
         [self.categoryTable setHidden:true];
//        imageArray = [[NSMutableArray alloc]initWithObjects:@"dummy_image_square_1",@"dummy_image_square_2",@"dummy_image_square_3",@"dummy_image_square_4",@"dummy_image_square_5", nil];
//        [self.collectionView reloadData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //This code will run in the main thread:
            CGFloat height = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
           // CGFloat Collectionheight = self.collectionView.contentSize.height;
                self.tableViewHeight.constant = height+30;
            //self.scrollHeight.constant = self.tableViewHeight.constant+350;
        });
    }
    
}
- (IBAction)backBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)searchBtnAction:(id)sender
{
    SearchViewController *search =[self.storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [self presentViewController:search animated:YES completion:nil];
}
- (IBAction)seeAllAction:(id)sender
{
    FeaturedViewController *featured = [self.storyboard instantiateViewControllerWithIdentifier:@"FeaturedViewController"];
    featured.featuredArray = featuredimageArray;
    [self.navigationController pushViewController:featured animated:YES];
}
@end
