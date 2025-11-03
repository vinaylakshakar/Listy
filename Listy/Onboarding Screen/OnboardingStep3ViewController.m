//
//  OnboardingStep3ViewController.m
//  Listy
//
//  Created by Silstone on 07/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "OnboardingStep3ViewController.h"
#import "Listy.pch"

@interface OnboardingStep3ViewController ()

@end
#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@implementation OnboardingStep3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cacheUpdated:) name:@"onboardingUpdatedNotification" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden{
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


-(void)registerForRemoteNotifications
{
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0"))
    {
        //        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge)
        //                              completionHandler:^(BOOL granted, NSError *error)
        //         {
        //             if (error == nil) [[UIApplication sharedApplication] registerForRemoteNotifications];
        //         }];
        
        //vinay here -
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if( !error ){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                });
                
            }
        }];
    }
    else {
        // Code for old versions
        
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        

    }
    
}

- (void)cacheUpdated:(NSNotification *)notification
{
     [self onboardingUser];
}

- (IBAction)registerNotification:(id)sender {
    
    [self registerForRemoteNotifications];
//    TabBarViewController *tabbar = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
//    [self.navigationController pushViewController:tabbar animated:YES];
}

- (IBAction)disallowNotification:(id)sender
{
    //NSLog(@"%@", [USERDEFAULTS valueForKey:kselectCategoryArray]);
    [self onboardingUser];
//    TabBarViewController *tabbar = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
//    [self.navigationController pushViewController:tabbar animated:YES];
}

-(void)onboardingUser
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"Userid"];
    
    NSError* error = nil;
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:[USERDEFAULTS valueForKey:kselectCategoryArray] options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    //NSLog(@"jsonData as string:\n%@", jsonString);
    
    [dict setObject:jsonString forKey:@"category_array"];
    
    
    if ([USERDEFAULTS valueForKey:deviceId]!=nil) {
        [dict setObject:[USERDEFAULTS valueForKey:deviceId] forKey:@"DeviceToken"];
        
    }
    else{
         [dict setObject:@"" forKey:@"DeviceToken"];
        
    }
    //    [dict setObject:@"1" forKey:@"DeviceType"];
    
    //NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]UserOnboarding:^(id object)
     {
         //NSLog(@"%@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"Sucess"])
         {
             
             [USERDEFAULTS setBool:YES forKey:kuserCategoryDetail];
             [USERDEFAULTS synchronize];
             TabBarViewController *tabbar = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
             [self.navigationController pushViewController:tabbar animated:YES];

            
             
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


@end
