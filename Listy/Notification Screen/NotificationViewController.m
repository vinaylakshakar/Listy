//
//  NotificationViewController.m
//  Listy
//
//  Created by Silstone on 13/11/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "NotificationViewController.h"
#import "Listy.pch"

@interface NotificationViewController ()
{
    NSMutableArray *notificationArray;
    int offsetLimit,savedScrollPosition;
    UIActivityIndicatorView *spinner;
    bool EnableApiCall;
}

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner stopAnimating];
    spinner.hidesWhenStopped = YES;
    spinner.frame = CGRectMake(0, 0, 320, 44);
    self.notificationTable.tableFooterView = spinner;
    
    self.notificationTable.rowHeight = UITableViewAutomaticDimension;
    self.notificationTable.estimatedRowHeight = 147;
    //self.notificationTable.tableFooterView = [UIView new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLikedList:)
                                                 name:@"receiveLikedList"
                                               object:nil];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    notificationArray = [[NSMutableArray alloc]init];
    offsetLimit =0;
    EnableApiCall = true;
    [self update_badge];
    [self.tabBarController.tabBar setHidden:NO];
    [self GetAllNotification];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark-Api methods


-(void)GetAllNotification
{
     NSString *offsetStr = [NSString stringWithFormat:@"%d",offsetLimit];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"Userid"];
    [dict setObject:offsetStr forKey:@"offset"];
    //[dict setObject:@"1" forKey:@"Userid"];
    if (offsetLimit==0)
    {
        [kAppDelegate showProgressHUD];
    }

    
    [[NetworkEngine sharedNetworkEngine]Notification:^(id object)
     {
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
            [self update_badge];
             NSMutableDictionary *dict =[Utility removeNullFromDictionary:object];
             
             if ([[[dict valueForKey:@"Data"] mutableCopy] count]<20) {
                 EnableApiCall = false;
                [notificationArray addObjectsFromArray:[dict valueForKey:@"Data"]];
             } else {
                 EnableApiCall = true;
                 [notificationArray addObjectsFromArray:[dict valueForKey:@"Data"]];
             }
             [self.notificationTable reloadData];
             
         } else
         {
             
             //[Utility showAlertMessage:nil message:[object valueForKey:@"Message"]];
             
         }
         
         if (offsetLimit==0)
         {
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

#pragma tableview methods--

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return notificationArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    static NSString *propertyIdentifier = @"LikedViewCell";
    
    LikedViewCell *cell = (LikedViewCell *)[tableView dequeueReusableCellWithIdentifier:propertyIdentifier];
    CommentNotificationViewCell *cell1 = (CommentNotificationViewCell *)[tableView dequeueReusableCellWithIdentifier:propertyIdentifier];
    FollowingViewCell *cell2 = (FollowingViewCell *)[tableView dequeueReusableCellWithIdentifier:propertyIdentifier];
    SavedListViewCell *cell3 = (SavedListViewCell *)[tableView dequeueReusableCellWithIdentifier:propertyIdentifier];
    FollowingViewCell *cell4 = (FollowingViewCell *)[tableView dequeueReusableCellWithIdentifier:propertyIdentifier];
    
    
    if (cell == nil)
    {
        
        NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"LikedViewCell" owner:self options:nil];
        cell = [nib1 objectAtIndex:0];
    }
    
    if (cell1 == nil)
    {
        
        NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"CommentNotificationViewCell" owner:self options:nil];
        cell1 = [nib1 objectAtIndex:0];
    }
    
    if (cell2 == nil)
    {
        
        NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"FollowingViewCell" owner:self options:nil];
        cell2 = [nib1 objectAtIndex:0];
    }
    if (cell3 == nil)
    {
        
        NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"SavedListViewCell" owner:self options:nil];
        cell3 = [nib1 objectAtIndex:0];
    }
    if (cell4 == nil)
    {
        
        NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"FollowingViewCell" owner:self options:nil];
        cell4 = [nib1 objectAtIndex:1];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell1 setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell2 setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell3 setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell4 setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if ([[notificationArray[indexPath.row] valueForKey:@"NotificationType"] isEqualToString:@"likeitem"])
    {
        cell.userName.text = [notificationArray[indexPath.row] valueForKey:@"username"];
        cell.itemArray = [notificationArray[indexPath.row] valueForKey:@"listitems"];
        
       // NSLog(@"notificationDict- %@",notificationArray[indexPath.row]);
        cell.notificationDict = notificationArray[indexPath.row];
        
        NSString *listNameStr = [notificationArray[indexPath.row] valueForKey:@"listname"];
        NSString *notification;
        if (cell.itemArray.count>1) {
            notification = [NSString stringWithFormat:@"Liked %lu items in your %@ list",(unsigned long)cell.itemArray.count,listNameStr];
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:notification];
            [text addAttribute: NSForegroundColorAttributeName value:[UIColor colorWithRed:0.96 green:0.19 blue:0.24 alpha:1.0] range: NSMakeRange(22, listNameStr.length+5)];
            [cell.listname setAttributedText:text];
        } else {
            notification = [NSString stringWithFormat:@"Liked %lu item in your %@ list",(unsigned long)cell.itemArray.count,listNameStr];
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:notification];
            [text addAttribute: NSForegroundColorAttributeName value:[UIColor colorWithRed:0.96 green:0.19 blue:0.24 alpha:1.0] range: NSMakeRange(21, listNameStr.length+5)];
            [cell.listname setAttributedText:text];
        }
        
        
        
        //cell.listname.text = [NSString stringWithFormat:@"Liked %lu items in your %@ list ",(unsigned long)cell.itemArray.count,[notificationArray[indexPath.row] valueForKey:@"listname"]];
        [cell.collectionView reloadData];
        [cell.userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[notificationArray objectAtIndex:indexPath.row] valueForKey:@"UserProfileImages"]]] placeholderImage:[UIImage imageNamed:@"user_profile"] options:0 progress:nil completed:nil];
        [self setRoundedView:cell.userImage toDiameter:cell1.userImage.frame.size.width];
        cell.userImage.clipsToBounds = YES;
        
        NSString *dateString = [[notificationArray objectAtIndex:indexPath.row] valueForKey:@"CreatedDate"];
        NSString *localTime = [self getLocalTimeFromUTC:dateString];
        
        NSString* leftTimeStr = [self remaningTime:[self getNSDate:localTime] endDate:[NSDate date]];
        cell.timeLbl.text =[NSString stringWithFormat:@"%@ ago",leftTimeStr];
        cell.profileBtn.tag = indexPath.row;
        [cell.profileBtn addTarget:self action:@selector(ProfileButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    if ([[notificationArray[indexPath.row] valueForKey:@"NotificationType"] isEqualToString:@"saveitemlist"])
    {
        NSMutableDictionary *saveitemlistDict = [Utility removeNullFromDictionary:notificationArray[indexPath.row]];
//        cell.userName.text = [notificationArray[indexPath.row] valueForKey:@"username"];
        cell.itemArray = [saveitemlistDict valueForKey:@"saveitems"];
        cell.userName.text = [[Utility removeNullFromDictionary:[cell.itemArray objectAtIndex:0]] valueForKey:@"username"];
        cell.notificationDict = saveitemlistDict;
        
        NSString *listNameStr = [saveitemlistDict valueForKey:@"listname"];
        NSString *notification;
        if (cell.itemArray.count>1) {
            notification = [NSString stringWithFormat:@"Saved %lu items in your %@ list",(unsigned long)cell.itemArray.count,listNameStr];
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:notification];
            [text addAttribute: NSForegroundColorAttributeName value:[UIColor colorWithRed:0.96 green:0.19 blue:0.24 alpha:1.0] range: NSMakeRange(22, listNameStr.length+5)];
            [cell.listname setAttributedText:text];
        } else {
            notification = [NSString stringWithFormat:@"Saved %lu item in your %@ list",(unsigned long)cell.itemArray.count,listNameStr];
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:notification];
            [text addAttribute: NSForegroundColorAttributeName value:[UIColor colorWithRed:0.96 green:0.19 blue:0.24 alpha:1.0] range: NSMakeRange(21, listNameStr.length+5)];
            [cell.listname setAttributedText:text];
        }
        
        
        
        //cell.listname.text = [NSString stringWithFormat:@"Liked %lu items in your %@ list ",(unsigned long)cell.itemArray.count,[notificationArray[indexPath.row] valueForKey:@"listname"]];
        [cell.collectionView reloadData];
        [cell.userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[saveitemlistDict valueForKey:@"UserProfileImages"]]] placeholderImage:[UIImage imageNamed:@"user_profile"] options:0 progress:nil completed:nil];
        [self setRoundedView:cell.userImage toDiameter:cell1.userImage.frame.size.width];
        cell.userImage.clipsToBounds = YES;
        
        NSString *dateString = [saveitemlistDict valueForKey:@"CreatedDate"];
        NSString *localTime = [self getLocalTimeFromUTC:dateString];
        
        NSString* leftTimeStr = [self remaningTime:[self getNSDate:localTime] endDate:[NSDate date]];
        cell.timeLbl.text =[NSString stringWithFormat:@"%@ ago",leftTimeStr];
        cell.profileBtn.tag = indexPath.row;
        [cell.profileBtn addTarget:self action:@selector(ProfileButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    if ([[notificationArray[indexPath.row] valueForKey:@"NotificationType"] isEqualToString:@"likelist"])
    {
        cell.userName.text = [notificationArray[indexPath.row] valueForKey:@"username"];
        cell.itemArray = [notificationArray[indexPath.row] valueForKey:@"list"];
        cell.notificationDict = notificationArray[indexPath.row];
        
        NSString *listNameStr = [notificationArray[indexPath.row] valueForKey:@"listname"];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Liked your %@ list",listNameStr]];
        [text addAttribute: NSForegroundColorAttributeName value:[UIColor colorWithRed:0.96 green:0.19 blue:0.24 alpha:1.0] range: NSMakeRange(11, listNameStr.length+5)];
        [cell.listname setAttributedText:text];
        //cell.listname.text = [NSString stringWithFormat:@"Liked your %@ list ",[notificationArray[indexPath.row] valueForKey:@"listname"]];
        [cell.collectionView reloadData];
        [cell.userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[notificationArray objectAtIndex:indexPath.row] valueForKey:@"UserProfileImages"]]] placeholderImage:[UIImage imageNamed:@"user_profile"] options:0 progress:nil completed:nil];
        [self setRoundedView:cell.userImage toDiameter:cell1.userImage.frame.size.width];
        cell.userImage.clipsToBounds = YES;
        
        NSString *dateString = [[notificationArray objectAtIndex:indexPath.row] valueForKey:@"CreatedDate"];
        NSString *localTime = [self getLocalTimeFromUTC:dateString];
        
        NSString* leftTimeStr = [self remaningTime:[self getNSDate:localTime] endDate:[NSDate date]];
        cell.timeLbl.text =[NSString stringWithFormat:@"%@ ago",leftTimeStr];
        cell.profileBtn.tag = indexPath.row;
        [cell.profileBtn addTarget:self action:@selector(ProfileButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    if ([[notificationArray[indexPath.row] valueForKey:@"NotificationType"] isEqualToString:@"Follow"])
    {
        cell2.userName.text = [notificationArray[indexPath.row] valueForKey:@"username"];
        [self setRoundedView:cell2.userImage toDiameter:cell2.userImage.frame.size.width];
        cell2.userImage.clipsToBounds = YES;
        [cell2.userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[notificationArray objectAtIndex:indexPath.row] valueForKey:@"UserProfileImages"]]] placeholderImage:[UIImage imageNamed:@"user_profile"] options:0 progress:nil completed:nil];
        cell2.activityLable.text= @"has started following you";
        
        NSString *dateString = [[notificationArray objectAtIndex:indexPath.row] valueForKey:@"CreatedDate"];
        NSString *localTime = [self getLocalTimeFromUTC:dateString];
        
        NSString* leftTimeStr = [self remaningTime:[self getNSDate:localTime] endDate:[NSDate date]];
        cell2.timeLbl.text =[NSString stringWithFormat:@"%@ ago",leftTimeStr];
        cell2.profileBtn.tag = indexPath.row;
        [cell2.profileBtn addTarget:self action:@selector(ProfileButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        return cell2;
    }
    if ([[notificationArray[indexPath.row] valueForKey:@"NotificationType"] isEqualToString:@"FriendFollow"])
    {
        cell2.userName.text = [notificationArray[indexPath.row] valueForKey:@"username"];
        [self setRoundedView:cell2.userImage toDiameter:cell2.userImage.frame.size.width];
        cell2.userImage.clipsToBounds = YES;
        [cell2.userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[notificationArray objectAtIndex:indexPath.row] valueForKey:@"UserProfileImages"]]] placeholderImage:[UIImage imageNamed:@"user_profile"] options:0 progress:nil completed:nil];
        NSMutableDictionary *followDict = [[[notificationArray objectAtIndex:indexPath.row] valueForKey:@"userfriendfollow"] objectAtIndex:0];
        cell2.activityLable.text =[NSString stringWithFormat:@"has started following %@",[followDict valueForKey:@"FollowUserName"]];
        
        NSString *dateString = [[notificationArray objectAtIndex:indexPath.row] valueForKey:@"CreatedDate"];
        NSString *localTime = [self getLocalTimeFromUTC:dateString];
        
        NSString* leftTimeStr = [self remaningTime:[self getNSDate:localTime] endDate:[NSDate date]];
        cell2.timeLbl.text =[NSString stringWithFormat:@"%@ ago",leftTimeStr];
        cell2.profileBtn.tag = indexPath.row;
        [cell2.profileBtn addTarget:self action:@selector(ProfileButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        return cell2;
    }
    if ([[notificationArray[indexPath.row] valueForKey:@"NotificationType"] isEqualToString:@"savelist"])
    {
        NSArray *userArray = [notificationArray[indexPath.row] valueForKey:@"savelist"];
        if (userArray.count>1)
        {
             cell3.userName.text = [NSString stringWithFormat:@"%@ and %lu Friends",[userArray[0] valueForKey:@"username"],userArray.count-1];
        } else {
             cell3.userName.text = [userArray[0] valueForKey:@"username"];
        }
        
        NSString *listNameStr = [notificationArray[indexPath.row] valueForKey:@"listname"];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Saved your %@ list",listNameStr]];
        [text addAttribute: NSForegroundColorAttributeName value:[UIColor colorWithRed:0.96 green:0.19 blue:0.24 alpha:1.0] range: NSMakeRange(11, listNameStr.length+5)];
        [cell3.listName setAttributedText:text];
       
        //cell3.listName.text = [NSString stringWithFormat:@"Saved your %@ list",[notificationArray[indexPath.row] valueForKey:@"listname"]];
        NSMutableDictionary *savedDict = [[[notificationArray objectAtIndex:indexPath.row] valueForKey:@"savelist"] objectAtIndex:0];
        [cell3.userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[savedDict valueForKey:@"Userimages"]]] placeholderImage:[UIImage imageNamed:@"Unknown"] options:0 progress:nil completed:nil];
        [self setRoundedView:cell3.userImage toDiameter:cell3.userImage.frame.size.width];
        cell3.userImage.clipsToBounds = YES;
        
        NSString *dateString = [[notificationArray objectAtIndex:indexPath.row] valueForKey:@"CreatedDate"];
        NSString *localTime = [self getLocalTimeFromUTC:dateString];
        
        NSString* leftTimeStr = [self remaningTime:[self getNSDate:localTime] endDate:[NSDate date]];
        cell3.timeLbl.text =[NSString stringWithFormat:@"%@ ago",leftTimeStr];
        cell3.profileBtn.tag = indexPath.row;
        [cell3.profileBtn addTarget:self action:@selector(ProfileButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        return cell3;
    }
    if ([[notificationArray[indexPath.row] valueForKey:@"NotificationType"] isEqualToString:@"Comment"]||[[notificationArray[indexPath.row] valueForKey:@"NotificationType"] isEqualToString:@"CommentTag"])
    {
        cell1.userName.text = [notificationArray[indexPath.row] valueForKey:@"username"];
        cell1.commentTxt.text = [notificationArray[indexPath.row] valueForKey:@"Commenttext"];
        [self setRoundedView:cell1.userImage toDiameter:cell1.userImage.frame.size.width];
        cell1.userImage.clipsToBounds = YES;
        [cell1.userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[notificationArray objectAtIndex:indexPath.row] valueForKey:@"UserProfileImages"]]] placeholderImage:[UIImage imageNamed:@"user_profile"] options:0 progress:nil completed:nil];
        [cell1.listImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[notificationArray objectAtIndex:indexPath.row] valueForKey:@"listimage"]]] placeholderImage:[UIImage imageNamed:@"profile_background"] options:0 progress:nil completed:nil];
        cell1.listImage.layer.cornerRadius = 15;
        cell1.listImage.clipsToBounds =YES;
        
        NSString *dateString = [[notificationArray objectAtIndex:indexPath.row] valueForKey:@"CreatedDate"];
        
        NSString *localTime = [self getLocalTimeFromUTC:dateString];
        
        NSString* leftTimeStr = [self remaningTime:[self getNSDate:localTime] endDate:[NSDate date]];
        cell1.timeLbl.text =[NSString stringWithFormat:@"%@ ago",leftTimeStr];
        cell1.profileBtn.tag = indexPath.row;
        cell1.listBtn.tag = indexPath.row;
        [cell1.profileBtn addTarget:self action:@selector(ProfileButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell1.listBtn addTarget:self action:@selector(ListButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        return cell1;
    }
    
    cell4.userName.text = [notificationArray[indexPath.row] valueForKey:@"username"];
    [cell4.userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[notificationArray objectAtIndex:indexPath.row] valueForKey:@"UserProfileImages"]]] placeholderImage:[UIImage imageNamed:@"user_profile"] options:0 progress:nil completed:nil];
    [self setRoundedView:cell4.userImage toDiameter:cell4.userImage.frame.size.width];
    cell4.userImage.clipsToBounds = YES;
    
    NSString *dateString = [[notificationArray objectAtIndex:indexPath.row] valueForKey:@"CreatedDate"];
    NSString *localTime = [self getLocalTimeFromUTC:dateString];
    
    NSString* leftTimeStr = [self remaningTime:[self getNSDate:localTime] endDate:[NSDate date]];
    cell4.timeLbl.text =[NSString stringWithFormat:@"%@ ago",leftTimeStr];
    cell4.profileBtn.tag = indexPath.row;
    [cell4.profileBtn addTarget:self action:@selector(ProfileButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return cell4;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!([[notificationArray[indexPath.row] valueForKey:@"NotificationType"] isEqualToString:@"Follow"]||[[notificationArray[indexPath.row] valueForKey:@"NotificationType"] isEqualToString:@"FriendFollow"]))
    {
        NSDictionary *listDict = notificationArray[indexPath.row] ;
        NSMutableDictionary *listDict2 =[[NSMutableDictionary alloc]init];
        [listDict2 setObject:[listDict valueForKey:@"listid"] forKey:@"listid"];
        [listDict2 setObject:[listDict valueForKey:@"ownerid"] forKey:@"userid"];
        
        FeaturedListFirstViewController *featureList = [self.storyboard instantiateViewControllerWithIdentifier:@"FeaturedListFirstViewController"];
        featureList.listDictinfo = listDict2;
        [self.navigationController pushViewController:featureList animated:YES];
    }
    
   
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSArray *arrr =  self.notificationTable.indexPathsForVisibleRows;
    NSMutableArray *sss  = [arrr mutableCopy];
    NSMutableArray *couterArr = [[NSMutableArray alloc]init];
    for (NSIndexPath *index in sss) {
        [couterArr addObject:[NSString stringWithFormat:@"%ld",(long)index.row]];
    }
    int counter = (int)notificationArray.count;
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
            [self GetAllNotification]; //Method to request to server to get more data
        }
    }
    
    
}

-(NSString*)getLocalTimeFromUTC:(NSString*)utcDate
{
    // create dateFormatter with UTC time format
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ssa"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *date = [dateFormatter dateFromString:utcDate]; // create date from string
    
    // change to a readable time format and change to local time zone
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ssa"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *timestamp = [dateFormatter stringFromDate:date];
    
    return timestamp;
}

-(void)ProfileButtonClicked:(UIButton*)sender
{
    FollowingUserProfileViewController *follower = [self.storyboard instantiateViewControllerWithIdentifier:@"FollowingUserProfileViewController"];
    follower.followerIdStr = [notificationArray[sender.tag] valueForKey:@"userid"];
    [self.navigationController pushViewController:follower animated:YES];
}

-(void)ListButtonClicked:(UIButton*)sender
{
    NSDictionary *listDict = notificationArray[sender.tag];
    //NSLog(@"listDict %@",listDict);
    NSMutableDictionary *listDict2 =[[NSMutableDictionary alloc]init];
    [listDict2 setObject:[listDict valueForKey:@"listid"] forKey:@"listid"];
    [listDict2 setObject:[listDict valueForKey:@"ownerid"] forKey:@"userid"];
    
    FeaturedListFirstViewController *featureList = [self.storyboard instantiateViewControllerWithIdentifier:@"FeaturedListFirstViewController"];
    featureList.listDictinfo = listDict2;
    [self.navigationController pushViewController:featureList animated:YES];
}

- (void)receiveLikedList:(NSNotification *)notification
{
    NSDictionary *listDict = [notification userInfo];
    //NSLog(@"listDict %@",listDict);
    NSMutableDictionary *listDict2 =[[NSMutableDictionary alloc]init];
    [listDict2 setObject:[listDict valueForKey:@"listid"] forKey:@"listid"];
    [listDict2 setObject:[listDict valueForKey:@"ownerid"] forKey:@"userid"];
    
    FeaturedListFirstViewController *featureList = [self.storyboard instantiateViewControllerWithIdentifier:@"FeaturedListFirstViewController"];
    featureList.listDictinfo = listDict2;
    [self.navigationController pushViewController:featureList animated:YES];
}

-(NSDate*)getNSDate:(NSString*)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ssa"];
    NSDate *dateFromString = [dateFormatter dateFromString:dateStr];
    //NSLog(@"%@",dateFromString);
    
    return dateFromString;
}


-(NSString*)remaningTime:(NSDate*)startDate endDate:(NSDate*)endDate {
    
    NSDateComponents *components;
    NSInteger days;
    NSInteger hour;
    NSInteger minutes;
    NSInteger seconds;
    NSString *durationString;
    
    components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond
                                                 fromDate: startDate toDate: endDate options: 0];
    days = [components day];
    hour = [components hour];
    minutes = [components minute];
    seconds = [components second];
    
    
    if (days > 0) {
        
        if (days > 1) {
            durationString = [NSString stringWithFormat:@"%ld days", (long)days];
        }
        else {
            durationString = [NSString stringWithFormat:@"%ld day", (long)days];
        }
        return durationString;
    }
    
    if (hour > 0) {
        
        if (hour > 1) {
            durationString = [NSString stringWithFormat:@"%ld hours", (long)hour];
        }
        else {
            durationString = [NSString stringWithFormat:@"%ld hour", (long)hour];
        }
        return durationString;
    }
    
    if (minutes > 0) {
        
        if (minutes > 1) {
            durationString = [NSString stringWithFormat:@"%ld minutes", (long)minutes];
        }
        else {
            durationString = [NSString stringWithFormat:@"%ld minute", (long)minutes];
        }
        return durationString;
    }
    if (seconds > 0) {
        
        if (seconds > 1) {
            durationString = [NSString stringWithFormat:@"%ld second", (long)seconds];
        }
        else {
            durationString = [NSString stringWithFormat:@"%ld second", (long)seconds];
        }
        return durationString;
    }
    
    return @"";
}



-(void)setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[notificationArray[indexPath.row] valueForKey:@"NotificationType"] isEqualToString:@"likeitem"]||[[notificationArray[indexPath.row] valueForKey:@"NotificationType"] isEqualToString:@"likelist"])
    {
        return 147;
    }
    if ([[notificationArray[indexPath.row] valueForKey:@"NotificationType"] isEqualToString:@"Comment"]||[[notificationArray[indexPath.row] valueForKey:@"NotificationType"] isEqualToString:@"saveitemlist"]||[[notificationArray[indexPath.row] valueForKey:@"NotificationType"] isEqualToString:@"CommentTag"])
    {
        return 147;
    }
    if ([[notificationArray[indexPath.row] valueForKey:@"NotificationType"] isEqualToString:@"savelist"])
    {
        return 80;
    }
        return 75;
}
@end
