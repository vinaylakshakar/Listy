//
//  LoginViewController.m
//  Listy
//
//  Created by Silstone on 06/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "LoginViewController.h"
#import "Listy.pch"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Crashlytics/Answers.h>


@interface LoginViewController ()

@end

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.emailField.textContentType = UITextContentTypeUsername;
    self.emailField.textContentType = UITextContentTypeEmailAddress;
    self.passwordField.textContentType = UITextContentTypePassword;
    if(IS_IPHONE_5)
    {
        NSLog(@"i am an iPhone 5!");
        self.spaceConstant.constant =49;
    }
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

- (IBAction)fbLoginAction:(id)sender
{
    [self FBLogin];
    [[NSUserDefaults standardUserDefaults] setValue:@"fb" forKey:@"fbLogin"];
}

- (IBAction)loginBtnAction:(id)sender
{
    [self.view endEditing:YES];
    LoginProcess *sharedManager = [LoginProcess sharedManager];
    bool emailValidate = [sharedManager emailValidate:self.emailField];
    
    if (!emailValidate)
    {
        
        [Utility showAlertMessage:nil message:@"Please enter valid email."];
        
    }
    else if (self.passwordField.text.length==0)
    {
        
        [Utility showAlertMessage:nil message:@"Please enter your password."];
        
    }else
    {
        [self LoginUser];
    }
}


-(void)LoginUser
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:self.emailField.text forKey:@"Email"];
    [dict setObject:self.passwordField.text forKey:@"Password"];
    [dict setObject:@"ios" forKey:@"device_type"];
    
    if ([USERDEFAULTS valueForKey:deviceId]!=nil) {
        [dict setObject:[USERDEFAULTS valueForKey:deviceId] forKey:@"device_id"];
        
    }
    else{
        [dict setObject:@"TheirIsNoDeviceIdRegisterTillNow" forKey:@"device_id"];
        
    }
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]loginUser:^(id object)
     {
         
         [Answers logLoginWithMethod:@"Digits"
                             success:@YES
                    customAttributes:@{
                                       @"Login via Email" : @"Normal"}];
         
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             [USERDEFAULTS setObject:[[[object valueForKey:@"userdetail"] objectAtIndex:0] valueForKey:@"userid"] forKey:kuserID];
             
             NSArray * categorydetailArray = [object valueForKey:@"Categorydetail"];
             
             if (categorydetailArray.count>0)
             {
                 [USERDEFAULTS setBool:YES forKey:kuserCategoryDetail];
                 [USERDEFAULTS synchronize];
                 NSArray *tokenArray = [[[[object valueForKey:@"userdetail"] objectAtIndex:0] valueForKey:@"device_id"] componentsSeparatedByString:@","];
                 bool isPushRegistered = [[[[object valueForKey:@"userdetail"] objectAtIndex:0] valueForKey:@"pushnotification"] boolValue];
                 
                 if (![tokenArray containsObject:[USERDEFAULTS valueForKey:deviceId]]&& isPushRegistered)
                 {
                     [self registerForRemoteNotifications];
                 }

                 TabBarViewController *tabbar = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
                 [self.navigationController pushViewController:tabbar animated:YES];
             } else
             {
                 OnboardingStep1ViewController *onboarding = [self.storyboard instantiateViewControllerWithIdentifier:@"OnboardingStep1ViewController"];
                 [self.navigationController pushViewController:onboarding animated:YES];
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

- (void)FBLogin {
    
    currentView = [WINDOW rootViewController];
    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
//    [loginManager logInWithPermissions:@[@"public_profile",@"email",@"user_friends"] fromViewController:currentView handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
    //vinay here-
    [loginManager logInWithPermissions:@[@"public_profile",@"email"] fromViewController:currentView handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
     {
        
        if (error) {
            
        }
        else if (result.isCancelled) {
            
        }
        else {
            
            [self getFacebookProfileInfos];
        }
        
    }];
}

-(void)getFacebookProfileInfos
{
    
   // if ([FBSDKAccessToken currentAccessToken])
    {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, email, picture"}]
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
                 }
                 
//                 NSString * originalString= [[[result objectForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
            
                 NSString *originalString = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [result objectForKey:@"id"]];
                 [USERDEFAULTS setObject:originalString forKey:@"fbPicture"];
                 
                 NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                 [dict setObject:[result objectForKey:@"name"] forKey:@"name"];
                // [dict setObject:@"" forKey:@"username"];
                 [dict setObject:[self randomStringWithLength:5] forKey:@"username"];
                 
                 if (![result objectForKey:@"email"])
                 {
                     [dict setObject:@"" forKey:@"email"];
                 }else
                 {
                     [dict setObject:[result objectForKey:@"email"] forKey:@"email"];
                 }
                 
                 [dict setObject:@"" forKey:@"password"];
                 [dict setObject:[result objectForKey:@"id"] forKey:@"facebookid"];
                 [USERDEFAULTS setObject:[result objectForKey:@"id"] forKey:fbConnectid];
                 [self RegisterUser:dict];
                 
                 //[self getfbFriendList:[result objectForKey:@"id"]];
             }
             
             
         }];
    }
    
}

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
                }else
                {
                     //NSLog(@"%@",error);
                }
    }];
}

//NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

-(NSString *)randomStringWithLength:(int) len {
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString;
}

-(void)RegisterUser:(NSMutableDictionary *)userinfoDict
{
    [userinfoDict setObject:@"ios" forKey:@"device_type"];
    [userinfoDict setObject:@"" forKey:@"user_latitude"];
    [userinfoDict setObject:@"" forKey:@"user_longitude"];
    
    if ([USERDEFAULTS valueForKey:deviceId]!=nil) {
        [userinfoDict setObject:[USERDEFAULTS valueForKey:deviceId] forKey:@"device_id"];
        
    }
    else{
        [userinfoDict setObject:@"TheirIsNoDeviceIdRegisterTillNow" forKey:@"device_id"];
        
    }
    
    //name=Aji&username=887455&email=ajkd@gmail.com&MobileNo=8825478745
    NSLog(@"%@",userinfoDict);
    
    [[NetworkEngine sharedNetworkEngine]RegisterUser:^(id object)
     {
         
         NSLog(@"%@",object);
         
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             [USERDEFAULTS setObject:[[object valueForKey:@"RegistrationDetail"] valueForKey:@"userid"] forKey:kuserID];
             [USERDEFAULTS setObject:@"fromFacebookLogin" forKey:fromFacebookLogin];
             
             NSArray * categorydetailArray = [object valueForKey:@"Categorydetail"];
             
             if (categorydetailArray.count>0)
             {
                 [USERDEFAULTS setBool:YES forKey:kuserCategoryDetail];
                 [USERDEFAULTS synchronize];
                 
                 NSArray *tokenArray = [[[object valueForKey:@"RegistrationDetail"] valueForKey:@"device_id"] componentsSeparatedByString:@","];
                 bool isPushRegistered = [[[object valueForKey:@"RegistrationDetail"] valueForKey:@"pushnotification"] boolValue];
                 
                 if (![tokenArray containsObject:[USERDEFAULTS valueForKey:deviceId]]&& isPushRegistered)
                 {
                     [self registerForRemoteNotifications];
                 }
                 //amar here-
                 [Answers logLoginWithMethod:@"Digits"
                                     success:@YES
                            customAttributes:@{@"Login via facebook" : @"Facebook"}];
                 
                 TabBarViewController *tabbar = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
                 [self.navigationController pushViewController:tabbar animated:YES];
             } else {
                 
                 //amar here-
                 [Answers logSignUpWithMethod:@"Digits"
                                      success:@YES
                             customAttributes:@{@"Signup via facebook" : @"Facebook"}];
                 OnboardingStep1ViewController *onboarding = [self.storyboard instantiateViewControllerWithIdentifier:@"OnboardingStep1ViewController"];
                 [self.navigationController pushViewController:onboarding animated:YES];
             }
             
         }else
         {
             
             [Utility showAlertMessage:nil message:[object valueForKey:@"Message"]];
             
         }
         
         [kAppDelegate hideProgressHUD];
         
         
     }
                                             onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:userinfoDict];
}


@end
