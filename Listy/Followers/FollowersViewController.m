//
//  FollowersViewController.m
//  Listy
//
//  Created by Silstone on 27/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "FollowersViewController.h"
#import "Listy.pch"

@interface FollowersViewController ()
{
    NSMutableArray *followerImageArray;
    NSMutableArray *followerArray, *followingArray, *finalArray;
    NSString *searchTextString;
}

@end

@implementation FollowersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.searchView.layer.cornerRadius = 5;
    followerImageArray = [[NSMutableArray alloc]initWithObjects:@"Mask Group 1",@"Mask Group 2",@"Mask Group 3",@"Mask Group 4",@"Mask Group 5",@"Mask Group 6",@"Mask Group 7",@"Mask Group 8", nil];
    self.titleLable.text = self.titleStr;
    [self.searchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    if (!self.isfollowing)
    {
        [self UserFollowerlist];
    }else
    {
        [self Userfollowinglist];
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Search Methods

-(void)textFieldDidChange:(UITextField*)textField
{
    searchTextString = textField.text;

    //NSLog(@"search Sc%@",searchTextString);
    
    if (self.isfollowing)
    {
       [self followingSearchArray];
    } else {
       [self updateSearchArray];
    }
    
}
//update seach method where the textfield acts as seach bar
-(void)updateSearchArray
{
    if (searchTextString.length != 0) {
        finalArray = [NSMutableArray array];
        for ( NSDictionary* item in followerArray ) {
            if ([[[item objectForKey:@"Follwerusername"] lowercaseString] rangeOfString:[searchTextString lowercaseString]].location != NSNotFound)
            {
                [finalArray addObject:item];
            }
        }
    } else {
        finalArray = [[NSMutableArray alloc]initWithArray:followerArray];
    }
    
    [self.tableView reloadData];
}


-(void)followingSearchArray
{
    if (searchTextString.length != 0) {
        finalArray = [NSMutableArray array];
        for ( NSDictionary* item in followingArray ) {
            if ([[[item objectForKey:@"Followingusername"] lowercaseString] rangeOfString:[searchTextString lowercaseString]].location != NSNotFound)
            {
                [finalArray addObject:item];
            }
        }
    } else {
        finalArray = [[NSMutableArray alloc]initWithArray:followingArray];
    }
    
    [self.tableView reloadData];
}


# pragma mark- Api methods-

-(void)UserFollowerlist
{
    //NSLog(@"UserFollowerlist");
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:self.userIdStr  forKey:@"userid"];
    
    
    //NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]UserFollowerlist:^(id object)
     {
         //NSLog(@"%@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
            
                followerArray = [[object valueForKey:@"UserFollowerlist"] mutableCopy];
                finalArray = followerArray;
               [self.tableView reloadData];
             //[Utility showAlertMessage:nil message:@"Folder Created Successsfully!"];
             
             
         } else
         {
            [finalArray removeAllObjects];
             [self.tableView reloadData];
            [Utility showAlertMessage:nil message:[object valueForKey:@"Message"]];
             
         }
         
         [kAppDelegate hideProgressHUD];
         
         
         
     }
                                                 onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}

-(void)Userfollowinglist
{
    //NSLog(@"Userfollowinglist");
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:self.userIdStr forKey:@"userid"];
    
    
    //NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]Userfollowinglist:^(id object)
     {
         //NSLog(@"%@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             
            followingArray = [[object valueForKey:@"UserFollowinglist"] mutableCopy];
            finalArray = followingArray;
             [self.tableView reloadData];
             //[Utility showAlertMessage:nil message:@"Folder Created Successsfully!"];
             
             
         } else
         {
             [finalArray removeAllObjects];
             [self.tableView reloadData];
            [Utility showAlertMessage:nil message:[object valueForKey:@"Message"]];
             
         }
         
         [kAppDelegate hideProgressHUD];
         
         
         
     }
                                                 onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}


#pragma tableview methods--

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return finalArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    static NSString *propertyIdentifier = @"FollowersCell";
    
    FollowersCell *cell = (FollowersCell *)[tableView dequeueReusableCellWithIdentifier:propertyIdentifier];
    
    
    if (cell == nil)
    {
        
        NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"FollowersCell" owner:self options:nil];
        cell = [nib1 objectAtIndex:0];
    }
    
   // cell.followerImage.image =[UIImage imageNamed:[followerImageArray objectAtIndex:indexPath.row]];
    
    [cell.followerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[finalArray objectAtIndex:indexPath.row] valueForKey:@"userImage"]]] placeholderImage:[UIImage imageNamed:@"user_profile"] options:0 progress:nil completed:nil];
    cell.followerImage.layer.cornerRadius = cell.followerImage.frame.size.height/2;
    cell.followerImage.clipsToBounds = YES;
    cell.numberList.text = [NSString stringWithFormat:@"%@ Lists",[[finalArray objectAtIndex:indexPath.row] valueForKey:@"numberoflist"]];
    
    if (self.isfollowing) {
        cell.followerName.text = [[finalArray objectAtIndex:indexPath.row] valueForKey:@"Followingusername"];
    } else {
        cell.followerName.text = [[finalArray objectAtIndex:indexPath.row] valueForKey:@"Follwerusername"];
    }
    

    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FollowingUserProfileViewController *follower = [self.storyboard instantiateViewControllerWithIdentifier:@"FollowingUserProfileViewController"];
    if (self.isfollowing) {
        follower.followerIdStr = [[finalArray objectAtIndex:indexPath.row] valueForKey:@"followingid"];
    } else {
        follower.followerIdStr = [[finalArray objectAtIndex:indexPath.row] valueForKey:@"followerid"];
    }
    
    
    if (![follower.followerIdStr isEqualToString:[[USERDEFAULTS valueForKey:kuserID] stringValue]])
    {
        [self.navigationController pushViewController:follower animated:YES];
    }
    
}


- (IBAction)backBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
