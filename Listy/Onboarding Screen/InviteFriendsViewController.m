//
//  InviteFriendsViewController.m
//  Listy
//
//  Created by Silstone on 07/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "InviteFriendsViewController.h"
#import "Listy.pch"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface InviteFriendsViewController ()
{
    NSMutableArray *friendArray,*selectedFriendArray,*friendImageArray;
}

@end

@implementation InviteFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    selectedFriendArray =[[NSMutableArray alloc]init];
   // friendArray = [[NSMutableArray alloc]initWithObjects:@"First Surname",@"Second Surname",@"Third Surname",@"Fourth Surname",@"Fifth Surname",@"Sixth Surname",@"Seventh Surname",@"Eight Surname", nil];
   // friendImageArray = [[NSMutableArray alloc]initWithObjects:@"Mask Group 1",@"Mask Group 2",@"Mask Group 3",@"Mask Group 4",@"Mask Group 5",@"Mask Group 6",@"Mask Group 7",@"Mask Group 8", nil];
    
    [self getfbFriendList:self.facebookId];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
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

-(void)getfbFriendList:(NSString*)facebookid
{
    //[NSString stringWithFormat:@"/%@/friendlists ",facebookid]
    //    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
    //                                  initWithGraphPath:[NSString stringWithFormat:@"%@/friendlists ",facebookid]
    //                                  parameters:nil
    //                                  HTTPMethod:@"GET"];
    //    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
    //                                          id result,
    //                                          NSError *error) {
    //        // Handle the result
    //        if(result)
    //        {
    //            NSLog(@"%@",result);
    //        }else
    //        {
    //             NSLog(@"%@",error);
    //        }
    //    }];
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:[NSString stringWithFormat:@"/%@/friends",facebookid]
                                  parameters:nil
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        // Handle the result
        if(result)
        {
            //NSLog(@"%@",result);
            friendArray = [result valueForKey:@"data"];
            [self.inviteTable reloadData];
        }else
        {
            //NSLog(@"%@",error);
        }
    }];
}

#pragma tableview methods-

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return friendArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    static NSString *propertyIdentifier = @"InviteFriendCell";
    
    InviteFriendCell *cell = (InviteFriendCell *)[tableView dequeueReusableCellWithIdentifier:propertyIdentifier];
    
    if (cell == nil)
    {
        
        NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"InviteFriendCell" owner:self options:nil];
        cell = [nib1 objectAtIndex:0];
    }
    
    cell.userName.text =[[friendArray objectAtIndex:indexPath.row] valueForKey:@"name"];
    cell.selectFriendBtn.tag = indexPath.row;
    cell.userImage.layer.cornerRadius = cell.userName.frame.size.height/2;
    cell.userImage.image = [UIImage imageNamed:@"user_profile"];
    
    if ([selectedFriendArray containsObject:[friendArray objectAtIndex:indexPath.row]])
    {
        [cell.selectFriendBtn setSelected:YES];
        
    } else
    {
       [cell.selectFriendBtn setSelected:NO];
    }
    
    [cell.selectFriendBtn addTarget:self action:@selector(selectFriend:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

-(void)selectFriend:(UIButton*)sender
{
    if (![selectedFriendArray containsObject:[friendArray objectAtIndex:[sender tag]]])
    {
        [selectedFriendArray addObject:[friendArray objectAtIndex:((UIButton *)sender).tag]];
    } else
    {
        [selectedFriendArray removeObject:[friendArray objectAtIndex:((UIButton *)sender).tag]];
    }

    [self.inviteTable reloadData];
}


- (IBAction)inviteAllAction:(id)sender
{
    selectedFriendArray = [[NSMutableArray alloc]initWithArray:friendArray];
    [self.inviteTable reloadData];
}

- (IBAction)skipBtnAction:(id)sender
{
    //[self dismissViewControllerAnimated:YES completion:nil];
}
@end
