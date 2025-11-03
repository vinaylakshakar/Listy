//
//  DiscoverViewController.m
//  Listy
//
//  Created by Silstone on 09/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "DiscoverViewController.h"
#import "Listy.pch"

@interface DiscoverViewController ()
{
    bool EnableApiCall;
    NSMutableArray *titleArray;
    //*featuredListArray,*friendsActivityArray,*listCategoryArray;
    NSString *searchText;
    UIActivityIndicatorView *spinner;
    int offsetLimit,savedScrollPosition;
    UIRefreshControl *refreshControl;
}

@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.discoverTable.rowHeight = UITableViewAutomaticDimension;
    self.discoverTable.estimatedRowHeight = UITableViewAutomaticDimension;
    EnableApiCall = true;
    // Do any additional setup after loading the view.
    offsetLimit =0;
    searchText =@"";
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner stopAnimating];
    spinner.hidesWhenStopped = YES;
    spinner.frame = CGRectMake(0, 0, 320, 44);
    self.discoverTable.tableFooterView = spinner;
    self.searchView.layer.cornerRadius = 5;
    titleArray = [[NSMutableArray alloc]initWithObjects:@"Featured",@"Friends activity",@"Movies",@"Music",@"Vegan food", nil];
//    if ([searchTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
//        UIColor *color = [UIColor purpleColor];
//        [searchTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Search" attributes:@{NSForegroundColorAttributeName: color}]];
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshDiscover:) forControlEvents:UIControlEventValueChanged];
    [self.discoverTable addSubview:refreshControl];
//    }
    [self discover_list:@""];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDiscoverList:)
                                                 name:@"receiveDiscoverList"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(DiscoverList:)
                                                 name:@"DiscoverList"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(UpdatedBudge:)
                                                 name:@"UpdatedBudge"
                                               object:nil];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    [textField resignFirstResponder];
    return YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cacheUpdated:) name:@"MyCacheUpdatedNotificationDiscover" object:nil];
    
    [self.discoverTable setContentOffset:CGPointMake(0,0) animated:YES];
    [self.tabBarController.tabBar setHidden:NO];
    [self update_badge];
    NSDate *savedTime = [USERDEFAULTS valueForKey:discoverTime];
    NSDate *currentTime = [NSDate date];
    
    NSTimeInterval interval = [currentTime timeIntervalSinceDate:savedTime];
    //NSLog(@"time interval:%f", interval);
    
    if (interval>1800) {
        offsetLimit =0;
        [self discover_list:@""];
    }
    
//    [self discover_list];
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)] &&
//        gestureRecognizer == self.navigationController.interactivePopGestureRecognizer) {
//        return NO;
//    }
//    return YES;
//}


- (void)refreshDiscover:(UIRefreshControl *)refreshControl
{
    offsetLimit =0;
    EnableApiCall = true;
    [self discover_list:@""];
    [refreshControl endRefreshing];
}
- (void)UpdatedBudge:(NSNotification *)notification
{
    [self update_badge];
    NSInteger num = [[UIApplication sharedApplication] applicationIconBadgeNumber];
    if (num==1)
    {
        [self update_badge];
    }
}


-(void)update_badge {
    
    // Get the trolley size.
    //int num = 3;
    NSInteger num = [[UIApplication sharedApplication] applicationIconBadgeNumber];
    //
    //    // Get RootViewController That is surely your tabbarcontroller
    //    UITabBarController *tabBarController =(UITabBarController*)[[(YourAppDelegate*)
    //                                                                 [[UIApplication sharedApplication]delegate] window] rootViewController];
    
    // Set the tab bar number badge.
    UITabBarItem *tab_bar = [[self.tabBarController.viewControllers objectAtIndex:3] tabBarItem];
    
    // Show the badge if the count is
    // greater than 0 otherwise hide it.
    
    for (UIView *tabBarButton in self.navigationController.tabBarController.tabBar.subviews)
    {
        for (UIView *badgeView in tabBarButton.subviews)
        {
            NSString *className = NSStringFromClass([badgeView class]);
            
            // Looking for _UIBadgeView
            if ([className rangeOfString:@"BadgeView"].location != NSNotFound)
            {
                badgeView.layer.transform = CATransform3DIdentity;
                badgeView.layer.transform = CATransform3DMakeTranslation(-30.0, 1.0, 1.0);
            }
        }
    }
    
    if (num > 0) {
        [tab_bar setBadgeValue:[NSString stringWithFormat:@"%ld", (long)num]];
    }
    
    else {
        [tab_bar setBadgeValue:nil];
    }
    
    return;
}

- (void)cacheUpdated:(NSNotification *)notification
{
    [self EditSetting];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)receiveDiscoverList:(NSNotification *)notification
{
    NSDictionary *listDict = [notification userInfo];
    //NSLog(@"listDict %@",listDict);
    FeaturedListFirstViewController *featureList = [self.storyboard instantiateViewControllerWithIdentifier:@"FeaturedListFirstViewController"];
    featureList.listDictinfo = [listDict mutableCopy];
    [self.navigationController pushViewController:featureList animated:YES];
}

- (void)DiscoverList:(NSNotification *)notification
{
    searchText = [notification.userInfo valueForKey:@"searchText"];
    offsetLimit=0;
    
    if (![searchText isEqualToString:@""])
    {
        CategoryDetailViewController *categorydetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryDetailViewController"];
        categorydetailVC.titleStr = searchText;
        categorydetailVC.isfromDiscoverSearch = YES;
        categorydetailVC.isShowFeatured = YES;
        [self.navigationController pushViewController:categorydetailVC animated:YES];
    }
   
    
}

#pragma mark-Api methods

-(void)EditSetting
{
    
    {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"userid"];
        [dict setObject:@"" forKey:@"email"];
        [dict setObject:@"" forKey:@"password"];
        [dict setObject:@"" forKey:@"emailnotification"];
        [dict setObject:@"1" forKey:@"pushnotification"];
        [dict setObject:@"" forKey:@"facebookconnected"];
        [dict setObject:@"" forKey:@"name"];
        
        if ([USERDEFAULTS valueForKey:fbConnectid])
        {
            [dict setObject:[USERDEFAULTS valueForKey:fbConnectid] forKey:@"facebookid"];
        } else {
            [dict setObject:@"" forKey:@"facebookid"];
            
        }
        
        if ([USERDEFAULTS valueForKey:deviceId]!=nil)
        {
            [dict setObject:[USERDEFAULTS valueForKey:deviceId] forKey:@"devicetoken"];
            
        }
        else
        {
            [dict setObject:@"" forKey:@"devicetoken"];
            
        }
        
        NSLog(@"%@",dict);
        
        [[NetworkEngine sharedNetworkEngine]EditSetting:^(id object)
         {
             NSLog(@"%@",object);
             
             if ([[object valueForKey:@"status"] isEqualToString:@"success"])
             {
                 //NSDictionary *dict = [Utility removeNullFromDictionary:[object valueForKey:@"Data"]];
                 //[Utility showAlertMessage:nil message:@"Settings saved!"];
             } else
             {
                 
                // [Utility showAlertMessage:nil message:[object valueForKey:@"Message"]];
                 
             }
             
             [kAppDelegate hideProgressHUD];
             
             
             
         }
                                                onError:^(NSError *error)
         {
             NSLog(@"Error : %@",error);
         }params:dict];
        
    }
    
}

-(void)discover_list:(NSString*)searchtext
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"userid"];
    //[dict setObject:@"99" forKey:@"userid"];
    [dict setObject:@"0" forKey:@"categoryid"];
    
    if (offsetLimit==0) {
//        [featuredListArray removeAllObjects];
//        [friendsActivityArray removeAllObjects];
//        [listCategoryArray removeAllObjects];
        [self.discoverTable setHidden:YES];
        
        _featuredListArray =[[NSMutableArray alloc]init];
        _friendsActivityArray =[[NSMutableArray alloc]init];
        _listCategoryArray =[[NSMutableArray alloc]init];
        
        [kAppDelegate showProgressHUD];
    }
    NSString *offsetStr = [NSString stringWithFormat:@"%d",offsetLimit];
    [dict setObject:offsetStr forKey:@"offset"];
    [dict setObject:searchtext forKey:@"searchtext"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]discover_list:^(id object)
     {
         
         NSLog(@"%@",object);
         
   if ([[object valueForKey:@"status"] isEqualToString:@"success"])
       
         {
             [USERDEFAULTS setObject:[NSDate date] forKey:discoverTime];
             
             EnableApiCall = true;
             if (offsetLimit==0)
             {
                 [self.discoverTable setHidden:NO];
                 _featuredListArray = [[object valueForKey:@"FeaturedList"] mutableCopy];
                 _friendsActivityArray = [[object valueForKey:@"FriendsActivity"] mutableCopy];
                 _listCategoryArray = [[object valueForKey:@"ListCategory"] mutableCopy];
             }
             else
             {
                 [_featuredListArray addObjectsFromArray:[object valueForKey:@"FeaturedList"]];
                 [_friendsActivityArray addObjectsFromArray:[object valueForKey:@"FriendsActivity"]];
                 [_listCategoryArray addObjectsFromArray:[object valueForKey:@"ListCategory"]];
             }

             if (_featuredListArray.count==0&&_friendsActivityArray.count==0&&_listCategoryArray.count==0)
             {
                 [Utility showAlertMessage:nil message:@"No List Found!"];
             } else if ([[object valueForKey:@"ListCategory"] count]==0)
             {
                 //[self.discoverTable reloadData];
                 EnableApiCall =false;
                 
             }
             
             
         } else
         {
             [Utility showAlertMessage:nil message:[object valueForKey:@"Message"]];
         }
         
         if (offsetLimit==0) {
             [kAppDelegate hideProgressHUD];
             if (EnableApiCall)
             {
                 [self.discoverTable reloadData];
             }
             
         }else
         {
             [spinner stopAnimating];
             if (EnableApiCall)
             {
                 [self.discoverTable reloadData];
             }
//             [self.discoverTable scrollToNearestSelectedRowAtScrollPosition:savedScrollPosition animated:YES];
//
//             [NSTimer scheduledTimerWithTimeInterval:0.0 target: self
//                                            selector: @selector(callAfterSixtySecond:) userInfo: nil repeats: NO];
         }
         
         //EnableApiCall = true;
     }
                                               onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}

-(void)callAfterSixtySecond:(NSTimer*) t
{
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:[_listCategoryArray count]+1  inSection:0];
    [self.discoverTable scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
}

#pragma tableview methods-

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _listCategoryArray.count+2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    static NSString *propertyIdentifier = @"FeaturedViewCell";
    
    FeaturedViewCell *cell = (FeaturedViewCell *)[tableView dequeueReusableCellWithIdentifier:propertyIdentifier];
    
    static NSString *propertyIdentifier1 = @"ActivityViewCell";
    
    ActivityViewCell *cell1 = (ActivityViewCell *)[tableView dequeueReusableCellWithIdentifier:propertyIdentifier1];
    
    static NSString *propertyIdentifier2 = @"CategoryTableViewCell";
    
    CategoryTableViewCell *cell2 = (CategoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:propertyIdentifier2];
    
    if (indexPath.row==0)
    {
        
        if (cell == nil)
        {
            
            NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"FeaturedViewCell" owner:self options:nil];
            cell = [nib1 objectAtIndex:0];
        }
        
        //if (_featuredListArray.count>0&&[searchText isEqualToString:@""])
        if (_featuredListArray.count>0)
        {
            [cell.titleLable setHidden:NO];
            [cell.seeAllBtn setHidden:NO];
            
            cell.titleLable.text = [titleArray objectAtIndex:indexPath.row];
            cell.listArray = _featuredListArray;
            [cell.collectionView reloadData];
            cell.seeAllBtn.tag = indexPath.row;
            [cell.seeAllBtn addTarget:self
                               action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        } else
        {
            [cell.titleLable setHidden:YES];
            [cell.seeAllBtn setHidden:YES];
        }
        
        
        return cell;
        
    }
    if (indexPath.row==1)
    {
        
        if (cell1 == nil)
        {
            
            NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"ActivityViewCell" owner:self options:nil];
            cell1 = [nib1 objectAtIndex:0];
        }
        
        if ([searchText isEqualToString:@""]&&_friendsActivityArray.count>0)
        {
            [cell.titleLable setHidden:NO];
            [cell.seeAllBtn setHidden:NO];
            cell1.titleLable.text = [titleArray objectAtIndex:indexPath.row];
            cell1.friendsActivity = _friendsActivityArray;
            [cell1.collectionView reloadData];
            cell1.seeAllBtn.tag = indexPath.row;
            [cell1.seeAllBtn addTarget:self
                                action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
            
        }else
        {
            [cell1.titleLable setHidden:YES];
            [cell1.seeAllBtn setHidden:YES];
            
        }
        
        return cell1;
    }
    
    if (cell2 == nil)
    {
        
        NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"CategoryTableViewCell" owner:self options:nil];
        cell2 = [nib1 objectAtIndex:0];
    }
    
    if (_listCategoryArray.count>0)
    {
//        cell2.tit leLable.text = [[_listCategoryArray objectAtIndex:indexPath.row-2] valueForKey:@"Category Name"];
//        cell2.listArray = [[_listCategoryArray objectAtIndex:indexPath.row-2] valueForKey:@"List"];
//        [cell2.collectionView reloadData];
//        cell2.seeAllBtn.tag = indexPath.row;
//        [cell2.seeAllBtn addTarget:self
//                            action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//
        NSMutableArray*listArray = [[_listCategoryArray objectAtIndex:indexPath.row-2] valueForKey:@"List"];
        if (listArray.count>=5)
        {
            cell2.titleLable.text = [[_listCategoryArray objectAtIndex:indexPath.row-2] valueForKey:@"Category Name"];
            cell2.listArray = [[_listCategoryArray objectAtIndex:indexPath.row-2] valueForKey:@"List"];
            [cell2.collectionView reloadData];
            cell2.seeAllBtn.tag = indexPath.row;
            [cell2.seeAllBtn addTarget:self
                                action:@selector(BtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        } else
        {
            [cell2.titleLable setHidden:YES];
            [cell2.seeAllBtn setHidden:YES];
        }
    }
    
    
    [cell2 setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell2;

   
}

-(void)BtnClicked:(UIButton *)sender
{
    //NSLog(@"%ld",(long)sender.tag);
    
    if ([sender tag]==1)
    {
        CategoryDetailViewController *categorydetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryDetailViewController"];
       // categorydetailVC.titleStr = [titleArray objectAtIndex:[sender tag]];
        categorydetailVC.titleStr = @"Friends Activity";
        categorydetailVC.activityArray = _friendsActivityArray;
        [self.navigationController pushViewController:categorydetailVC animated:YES];
        
    }
    else if ([sender tag]>1)
    {
        CategoryDetailViewController *categorydetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryDetailViewController"];
        categorydetailVC.isShowFeatured = YES;
        categorydetailVC.titleStr = [[_listCategoryArray objectAtIndex:[sender tag]-2] valueForKey:@"Category Name"];
        //NSLog(@"%@",categorydetailVC.titleStr);
        
        categorydetailVC.categoryId = [[_listCategoryArray objectAtIndex:[sender tag]-2] valueForKey:@"Category Id"];
        categorydetailVC.searchText = @"";
        [self.navigationController pushViewController:categorydetailVC animated:YES];
        
    }
    else
    {
        FeaturedViewController *featured = [self.storyboard instantiateViewControllerWithIdentifier:@"FeaturedViewController"];
        featured.featuredArray = _featuredListArray;
        [self.navigationController pushViewController:featured animated:YES];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // some code that compute row's height
    if (indexPath.row==1)
    {
        if (![searchText isEqualToString:@""]||_friendsActivityArray.count<1)
        {
            return 0;
        }
        return 263;
        
    }
    if (indexPath.row>1&&_listCategoryArray.count>0)
    {
       NSMutableArray*listArray=  [[NSMutableArray alloc] initWithArray:[[_listCategoryArray objectAtIndex:indexPath.row-2] valueForKey:@"List"]];
        
        if (listArray.count>=5)
        {
             return 245;
        } else
        {
             return 0;
        }
       
        
    }
    if (indexPath.row==0&&_featuredListArray.count<1)
    {
        return 0;
    }
    
    return 203;
    
}
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//   NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];//first get total rows in that section by current indexPath.
//
//
//    if(indexPath.row == totalRow - 1)
//    {
//        if (indexPath.section == 0) {
//
//        }
//        else if (indexPath.section == 1){
//
//        }
//        else if (indexPath.section == 2){
//
//        }
//         NSLog(@"%ld",(long)indexPath.row);
////             offsetLimit =offsetLimit+1;
////             [spinner setHidden:NO];
////             [spinner startAnimating];
////            savedScrollPosition=lastRow;
////             [self discover_list:searchText]; //Method to request to server to get more data
//    }
//}

//- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView
//                  willDecelerate:(BOOL)decelerate{
//
//    CGPoint offset = aScrollView.contentOffset;
//    CGRect bounds = aScrollView.bounds;
//    CGSize size = aScrollView.contentSize;
//    UIEdgeInsets inset = aScrollView.contentInset;
//    float y = offset.y + bounds.size.height - inset.bottom;
//    float h = size.height;
//
//    float reload_distance = 50;
//    if(y > h + reload_distance) {
//        NSLog(@"load more data");
//        [spinner setHidden:NO];
//        [spinner startAnimating];
//
//        offsetLimit =offsetLimit+1;
//       [self discover_list:searchText];
//
//    }
//}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSArray *arrr =  self.discoverTable.indexPathsForVisibleRows;
    NSMutableArray *sss  = [arrr mutableCopy];
    NSMutableArray *couterArr = [[NSMutableArray alloc]init];
    for (NSIndexPath *index in sss) {
        [couterArr addObject:[NSString stringWithFormat:@"%ld",(long)index.row]];
    }
    int counter = (int)_listCategoryArray.count+2;
    int lastRow=counter-1;

    if([couterArr containsObject:[NSString stringWithFormat:@"%d",lastRow]])
    {
        if(EnableApiCall)
        {
            EnableApiCall = false;
            offsetLimit =offsetLimit+1;
            [spinner setHidden:NO];
            [spinner startAnimating];
           savedScrollPosition=lastRow;
            [self discover_list:searchText]; //Method to request to server to get more data
        }
    }


}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGPoint offset = scrollView.contentOffset;
//    CGRect bounds = scrollView.bounds;
//    CGSize size = scrollView.contentSize;
//    UIEdgeInsets inset = scrollView.contentInset;
//    float y = offset.y + bounds.size.height - inset.bottom;
//    float h = size.height;
//
//    float reload_distance = 15;
//    if(y > h + reload_distance)
//    {
//
//            [spinner setHidden:NO];
//            [spinner startAnimating];
//        offsetLimit =offsetLimit+1;
//        [self discover_list:searchText];
//    }
//}

- (IBAction)searchBtnAction:(id)sender
{
    SearchViewController *search =[self.storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    search.isFromDiscover = YES;
    [self presentViewController:search animated:YES completion:nil];
}
@end
