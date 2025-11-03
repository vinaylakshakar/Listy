//
//  OnboardingStep2ViewController.m
//  Listy
//
//  Created by Silstone on 07/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "OnboardingStep2ViewController.h"
#import "Listy.pch"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface OnboardingStep2ViewController ()

@end

@implementation OnboardingStep2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)FBLogin {
    
    currentView = [WINDOW rootViewController];
    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logInWithPermissions:@[@"public_profile",@"email"] fromViewController:currentView handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        
        if (error) {
            
        }
        else if (result.isCancelled) {
            
        }
        else {
            
            [self getFacebookProfileInfos];
        }
        
    }];
}

-(void)getFacebookProfileInfos {
    
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, email"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if(result)
             {
                 
                 if ([result objectForKey:@"email"]) {
                     //NSLog(@"User id : %@",[result objectForKey:@"email"]);
                 }
                 if ([result objectForKey:@"name"]) {
                     //NSLog(@"First Name : %@",[result objectForKey:@"name"]);
                 }
                 if ([result objectForKey:@"id"]) {
                     //NSLog(@"User id : %@",[result objectForKey:@"id"]);
                     // [self getfbFriendList:[result objectForKey:@"id"]];
                 }
                 
                 NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                 [dict setObject:[result objectForKey:@"name"] forKey:@"name"];
                 [dict setObject:@"" forKey:@"username"];
                 [dict setObject:[result objectForKey:@"email"] forKey:@"email"];
                 [dict setObject:@"" forKey:@"password"];
                 [dict setObject:[result objectForKey:@"id"] forKey:@"facebookid"];
                 
                 InviteFriendsViewController *inviteView = [self.storyboard instantiateViewControllerWithIdentifier:@"InviteFriendsViewController"];
                 inviteView.facebookId = [NSString stringWithFormat:@"%@",[result objectForKey:@"id"]];
                 UINavigationController *inviteFriends = [[UINavigationController alloc]initWithRootViewController:inviteView];
                 [inviteFriends setNavigationBarHidden:YES];
                 [self presentViewController:inviteFriends animated:YES completion:nil];
                 
             }
         }];
    }
    
}


- (IBAction)inviteFriendAction:(id)sender
{
//    if ([USERDEFAULTS valueForKey:fbConnectid]!=nil)
//    {
//        InviteFriendsViewController *inviteView = [self.storyboard instantiateViewControllerWithIdentifier:@"InviteFriendsViewController"];
//        inviteView.facebookId = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:fbConnectid]];
//        UINavigationController *inviteFriends = [[UINavigationController alloc]initWithRootViewController:inviteView];
//        [inviteFriends setNavigationBarHidden:YES];
//        [self presentViewController:inviteFriends animated:YES completion:nil];
//    } else {
//         [self FBLogin];
//    }
   
    //vinay here-
    [self FBLogin];
}
@end
