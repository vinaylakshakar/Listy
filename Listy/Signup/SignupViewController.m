//
//  SignupViewController.m
//  Listy
//
//  Created by Silstone on 06/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "SignupViewController.h"
#import "Listy.pch"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface SignupViewController ()

@end

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.popupBtn.layer.cornerRadius = self.popupBtn.frame.size.width/2;
    self.popupBtn.clipsToBounds = true;
    if(IS_IPHONE_5)
    {
        NSLog(@"i am an iPhone 5!");
        self.spaceConstant.constant =12;
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

- (IBAction)backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)fbLoginAction:(id)sender
{
    [self FBLogin];
    [[NSUserDefaults standardUserDefaults] setValue:@"fb" forKey:@"fbLogin"];
}

- (IBAction)createAccountAction:(id)sender
{
    
    [self.view endEditing:YES];
    LoginProcess *sharedManager = [LoginProcess sharedManager];
    bool usernameValidate = [sharedManager usernameValidate:self.usernameField];
    bool emailValidate = [sharedManager emailValidate:self.emailField];
    
    if ([self.nameField.text isEqualToString:@""])
    {
        
        [Utility showAlertMessage:nil message:@"Please Enter Your Name."];
        
    }else if (!emailValidate)
    {
        
        [Utility showAlertMessage:nil message:@"Please enter valid email."];
        
    }
    else if ([self.usernameField.text hasPrefix:@"Kraken"])
    {
        
        [Utility showAlertMessage:nil message:@"Please Select Valid UserName."];
        
    }
    else if (self.usernameField.text.length<5||self.usernameField.text.length>32)
    {
        
        [Utility showAlertMessage:nil message:@"UserName Must be a minimum of 5 characters and a maximum 32 characters."];
        
    }
    else if (!usernameValidate||[self.nameField.text isEqualToString:self.usernameField.text])
    {
        
        [Utility showAlertMessage:nil message:@"'Username's should be alphanumeric and different to your account name'"];;
        
    }
    else if (self.passwordField.text.length==0)
    {
        
        [Utility showAlertMessage:nil message:@"Please enter your password."];
        
    }
    else
    {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:self.nameField.text forKey:@"name"];
        [dict setObject:self.usernameField.text forKey:@"username"];
        [dict setObject:self.emailField.text forKey:@"email"];
        [dict setObject:self.passwordField.text forKey:@"password"];
        [dict setObject:@"" forKey:@"facebookid"];
        [self RegisterUser:dict];
        
    }
 
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
             
             if ([[[object valueForKey:@"RegistrationDetail"] valueForKey:@"Facebookid"] isEqualToString:@""])
             {
                 
                 if ([[object valueForKey:@"Message"] isEqualToString:@"Successfully Registered !"])
                 {
                     [USERDEFAULTS setObject:[[object valueForKey:@"RegistrationDetail"] valueForKey:@"userid"] forKey:kuserID];
                     [self onboardUser];
                    
                 }else
                 {
                     UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Trovy!"
                                                                                   message:[object valueForKey:@"Message"]
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                     
                     UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                         style:UIAlertActionStyleDefault
                                                                       handler:^(UIAlertAction * action)
                                                 {
                                                     //                                                 if (![[object valueForKey:@"Message"] isEqualToString:@"This User already exist !"])
                                                     //                                                 {
                                                     [self.navigationController popToRootViewControllerAnimated:YES];
                                                     //                                                 }
                                                     
                                                 }];
                     
                     [alert addAction:yesButton];
                     
                     [self presentViewController:alert animated:YES completion:nil];
                 }
                 
             } else
             {
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
                     
                     TabBarViewController *tabbar = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
                     [self.navigationController pushViewController:tabbar animated:YES];
                 } else {
                    
                     OnboardingStep1ViewController *onboarding = [self.storyboard instantiateViewControllerWithIdentifier:@"OnboardingStep1ViewController"];
                     [self.navigationController pushViewController:onboarding animated:YES];
                 }
                
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

-(void)onboardUser
{
    [Answers logSignUpWithMethod:@"Digits"
                         success:@YES
                customAttributes:@{@"Signup via Email" : @"Normal"}];
    OnboardingStep1ViewController *onboarding = [self.storyboard instantiateViewControllerWithIdentifier:@"OnboardingStep1ViewController"];
    [self.navigationController pushViewController:onboarding animated:YES];
}


- (void)FBLogin {
    
    currentView = [WINDOW rootViewController];
    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
//    [loginManager logInWithReadPermissions:@[@"public_profile",@"email"] fromViewController:currentView handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
    
    [loginManager logInWithPermissions:@[@"public_profile",@"email"] fromViewController:currentView handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error)
        {
            [Utility showAlertMessage:@"Facebook Error" message:error.description];
            
        }
        else if (result.isCancelled) {
            
        }
        else {
            
            [self getFacebookProfileInfos];
        }
        
    }];
//    {
//        if (error)
//        {
//            [Utility showAlertMessage:@"Facebook Error" message:error.description];
//
//        }
//        else if (result.isCancelled) {
//
//        }
//        else {
//
//            [self getFacebookProfileInfos];
//        }
//
//    }];
}

-(void)getFacebookProfileInfos {
    
    //if ([FBSDKAccessToken currentAccessToken]) {
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
               //  [dict setObject:@"" forKey:@"username"];
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

                 //[self GetfriendList];
             }
         }];
   // }
    
}

-(void)GetfriendList
{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"me/friends"
                                  parameters:nil
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        // Handle the result
        //NSLog(@"friend list-%@",result);
    }];
    
}

-(NSString *)randomStringWithLength:(int) len {
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString;
}

- (IBAction)popupForUsername:(id)sender {
    
    //[Utility showAlertMessage:nil message:@"Please use only alphanumeric character for username.name and username should be different"];
    
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"\nUsername requirements:"];
    [string addAttribute: NSForegroundColorAttributeName value:[UIColor colorWithRed:0.96 green:0.19 blue:0.24 alpha:1.0] range: NSMakeRange(0, string.length)];
    
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:@"\n\n'Username's should be alphanumeric and different to your account name'."];
    
//    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:@"\n\nCan only contain letters, numbers, dashes (-), periods (.), and underscores (_)."];
//    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:@"\n\nCannot begin with 'Kraken'."];
//    NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc] initWithString:@"\n\nMust be a minimum of 5 characters and a maximum 32 characters."];
//
//    NSMutableAttributedString *string4 = [[NSMutableAttributedString alloc] initWithString:@"\n\nUsername tips:"];
//    [string4 addAttribute: NSForegroundColorAttributeName value:[UIColor colorWithRed:0.96 green:0.19 blue:0.24 alpha:1.0] range: NSMakeRange(0, string4.length)];
//
//    NSMutableAttributedString *string5 = [[NSMutableAttributedString alloc] initWithString:@"\n\nWe recommend long usernames."];
//    NSMutableAttributedString *string6 = [[NSMutableAttributedString alloc] initWithString:@"\n\nDo not make your username something common, obvious, or easy to guess."];
//    NSMutableAttributedString *string7 = [[NSMutableAttributedString alloc] initWithString:@"\n\nNever share your username — treat it as privately as your password."];
    
    [string appendAttributedString:string1];
//    [string appendAttributedString:string2];
//    [string appendAttributedString:string3];
//    [string appendAttributedString:string4];
//    [string appendAttributedString:string5];
//    [string appendAttributedString:string6];
//    [string appendAttributedString:string7];
    
    //NSString *message = [NSString stringWithFormat:@"%@",string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    // paragraphStyle.tailIndent = -18.0;
    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];

    
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Trovy!"
                                                                  message:@""
                                                           preferredStyle:UIAlertControllerStyleAlert];
    //alert.setValue(myAttribute, forKey: "attributedMessage")
    [alert setValue:string forKey:@"attributedMessage"];
    
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                {
                                    //                                                 if (![[object valueForKey:@"Message"] isEqualToString:@"This User already exist !"])
                                    //                                                 {
                                    //                                                 }
                                    
                                }];
    
    [alert addAction:yesButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}
@end
