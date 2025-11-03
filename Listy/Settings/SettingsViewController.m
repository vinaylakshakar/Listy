//
//  SettingsViewController.m
//  Listy
//
//  Created by Silstone on 27/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "SettingsViewController.h"
#import "Listy.pch"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)Userlogout
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"Userid"];
    if ([USERDEFAULTS valueForKey:deviceId]!=nil)
    {
        [dict setObject:[USERDEFAULTS valueForKey:deviceId] forKey:@"deviceid"];
        
    }
    else
    {
        [dict setObject:@"" forKey:@"deviceid"];
        
    }
    
    
    //NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]Userlogout:^(id object)
     {
         //NSLog(@"%@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
             [self resetDefaults];
             UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationVC"];
             navigationController.interactivePopGestureRecognizer.enabled = NO;
             del.window.rootViewController = navigationController;
             
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

- (IBAction)backBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editProfile:(id)sender
{
    EditProfileViewController *editProfile  =[self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
    [self.navigationController pushViewController:editProfile animated:YES];
}

- (IBAction)editSettings:(id)sender
{
    EditSettingViewController *editSettings  =[self.storyboard instantiateViewControllerWithIdentifier:@"EditSettingViewController"];
    [self.navigationController pushViewController:editSettings animated:YES];
}

- (IBAction)logoutBtnAction:(id)sender
{
    [self Userlogout];
}

- (IBAction)termsAndPrivacy:(id)sender
{
    TermsOfServiceViewController *termsAndService = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsOfServiceViewController"];
    [self.navigationController pushViewController:termsAndService animated:YES];
}

- (IBAction)feedbackBtnAction:(id)sender
{
    FeedbackViewController *feedback = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedbackViewController"];
    [self presentViewController:feedback animated:YES completion:nil];
}

- (IBAction)helpBtnAction:(id)sender
{
    WebViewController *help = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    help.isFromSetting = YES;
    [self.navigationController pushViewController:help animated:YES];
}

- (void)resetDefaults {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        
        if ([key isEqual:showTutorial]&&[USERDEFAULTS valueForKey:showTutorial]!=nil)
        {
            
        }else if([key isEqual:deviceId])
        {
            
        }else
        {
            [defs removeObjectForKey:key];
        }
        
    }
    [defs synchronize];
}
@end
