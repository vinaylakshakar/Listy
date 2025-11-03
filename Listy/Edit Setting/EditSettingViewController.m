//
//  EditSettingViewController.m
//  Listy
//
//  Created by Silstone on 27/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "EditSettingViewController.h"
#import "Listy.pch"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface EditSettingViewController ()
{
    NSString *emailSwitchStr,*notificationSwitchStr,*faceBookSwitchStr;
    NSMutableDictionary *userprofileinfo;
}

@end

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@implementation EditSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cacheUpdated:) name:@"MyCacheUpdatedNotification" object:nil];
    [self setLayout];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setSwitch
{
    if ([self.emailSwitch isOn])
    {
        emailSwitchStr =@"1";
    }
    else
    {
        emailSwitchStr =@"0";
    }
    
    if ([self.notificationSwitch isOn])
    {
        
        notificationSwitchStr =@"1";
    } else
    {
        notificationSwitchStr =@"0";
    }
    
    if ([self.facebookSwitch isOn])
    {
        faceBookSwitchStr = @"1";
    }
    else
    {
        faceBookSwitchStr = @"0";
    }
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
-(void)setLayout
{
    userprofileinfo = [[NSMutableDictionary alloc] initWithDictionary:[USERDEFAULTS valueForKey:kuserProfileDict]];
    //NSLog(@"userprofileinfo %@",userprofileinfo);
    self.emailField.text = [userprofileinfo valueForKey:@"email"];
    self.passwordField.text = [userprofileinfo valueForKey:@"Password"];
    
    if ([[userprofileinfo valueForKey:@"EmailNotification"] isEqualToString:@"No"]) {
        [self.emailSwitch setOn:NO];
    }
    
    if ([USERDEFAULTS valueForKey:fromFacebookLogin])
    {
        [self.facebookSwitch setUserInteractionEnabled:NO];
        [self.facebookSwitch setOn:YES];
    }
    
    
    if ([[userprofileinfo valueForKey:@"FacebookConnected"] isEqualToString:@"No"]) {
        [self.facebookSwitch setOn:NO];
    }else
    {
        [self.facebookSwitch setOn:YES];
        [self.emailField setUserInteractionEnabled:NO];
        [self.passwordField setUserInteractionEnabled:NO];
        [self.changeBtn setHidden:YES];
        [self.changePasswordBtn setHidden:YES];
    }
    
    //[self.facebookSwitch setUserInteractionEnabled:NO];
    NSArray *tokenArray = [[userprofileinfo valueForKey:@"devicetoken"] componentsSeparatedByString:@","];
    
    NSLog(@"device token-%@",[USERDEFAULTS valueForKey:deviceId]);
    
//    if (![tokenArray containsObject:[USERDEFAULTS valueForKey:deviceId]]||![[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
//        [self.notificationSwitch setOn:NO];
//    }
    if (![tokenArray containsObject:[USERDEFAULTS valueForKey:deviceId]])
    {
        [self.notificationSwitch setOn:NO];
    }
    [self setSwitch];
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

-(void)EditSetting
{
    
//    LoginProcess *sharedManager = [LoginProcess sharedManager];
//    bool emailValidate = [sharedManager emailValidate:self.emailField];
//
//    if (!emailValidate)
//    {
//
//        [Utility showAlertMessage:nil message:@"Please enter valid email."];
//
//    }
//    else if (self.passwordField.text.length==0)
//    {
//
//        [Utility showAlertMessage:nil message:@"Please enter your password."];
//
//    }else
    {

    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"userid"];
    [dict setObject:self.emailField.text forKey:@"email"];
    [dict setObject:self.passwordField.text forKey:@"password"];
    [dict setObject:emailSwitchStr forKey:@"emailnotification"];
    [dict setObject:notificationSwitchStr forKey:@"pushnotification"];
    [dict setObject:faceBookSwitchStr forKey:@"facebookconnected"];
    [dict setObject:@"" forKey:@"name"];
        
        if ([faceBookSwitchStr isEqualToString:@"1"]&&[USERDEFAULTS valueForKey:fbConnectid])
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
             NSDictionary *dict = [Utility removeNullFromDictionary:[object valueForKey:@"Data"]];
             
             [userprofileinfo setObject:[dict valueForKey:@"Email"] forKey:@""];
             [userprofileinfo setObject:[dict valueForKey:@"password"] forKey:@""];
             
             if ([[dict valueForKey:@"EmailNotification"] boolValue]) {
                 [userprofileinfo setObject:@"Yes" forKey:@"EmailNotification"];
             } else {
                 [userprofileinfo setObject:@"No" forKey:@"EmailNotification"];
             }
             
             if ([[dict valueForKey:@"FacebookConnected"] boolValue]) {
                 [userprofileinfo setObject:@"Yes" forKey:@"FacebookConnected"];
             } else {
                 [userprofileinfo setObject:@"No" forKey:@"FacebookConnected"];
             }
             
             if ([[dict valueForKey:@"PushNotification"] boolValue])
             {
                 [userprofileinfo setObject:@"Yes" forKey:@"PushNotification"];
                 NSString *devicetoken = [userprofileinfo valueForKey:@"devicetoken"];
                 devicetoken = [NSString stringWithFormat:@"%@,%@",devicetoken,[USERDEFAULTS valueForKey:deviceId]];
                 [userprofileinfo setObject:devicetoken forKey:@"devicetoken"];
                 
             } else {
                 [userprofileinfo setObject:@"No" forKey:@"PushNotification"];
             }
             
             [USERDEFAULTS setObject:userprofileinfo forKey:kuserProfileDict];
             [Utility showAlertMessage:nil message:@"Settings saved!"];
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
    
}


-(void)CloseAccount
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"Userid"];
    
    
    //NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]CloseAccount:^(id object)
     {
         //NSLog(@"%@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             [Utility showAlertMessage:nil message:[object valueForKey:@"Message"]];
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

- (void)resetDefaults {
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
}

- (IBAction)backBtnAction:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)changeBtnAction:(id)sender
{
    LoginProcess *sharedManager = [LoginProcess sharedManager];
    bool emailValidate = [sharedManager emailValidate:self.emailField];
    
        if (!emailValidate)
        {
 
            [Utility showAlertMessage:nil message:@"Please enter valid email."];
    
    
        }else
        {
             [self EditSetting];
        }
   
}

- (IBAction)changePasswordAction:(id)sender
{
       if (self.passwordField.text.length==0)
            {
 
                [Utility showAlertMessage:nil message:@"Please enter your password."];
        
            }else
            {
                [self EditSetting];
            }
}

- (IBAction)SwitchOnOff:(id)sender
{
//    LoginProcess *sharedManager = [LoginProcess sharedManager];
//    bool emailValidate = [sharedManager emailValidate:self.emailField];
    UISwitch *myswitch =[self.view viewWithTag:[sender tag]];
    
//    if (!emailValidate)
//    {
//        if (![myswitch isOn]) {
//            [myswitch setOn:YES];
//        } else {
//            [myswitch setOn:NO];
//        }
//        [Utility showAlertMessage:nil message:@"Please enter valid email."];
//
//
//    }
//    else if (self.passwordField.text.length==0)
//    {
//        if (![myswitch isOn]) {
//            [myswitch setOn:YES];
//        } else {
//            [myswitch setOn:NO];
//        }
//        [Utility showAlertMessage:nil message:@"Please enter your password."];
//
//    }
//    else
    if ((myswitch==self.notificationSwitch)&&[self.notificationSwitch isOn])
    {
        if (![[UIApplication sharedApplication] isRegisteredForRemoteNotifications]||[[USERDEFAULTS valueForKey:deviceId] isEqualToString:@""]) {
            [self.notificationSwitch setOn:NO];
            [self registerForRemoteNotifications];
        }
        if (![USERDEFAULTS valueForKey:deviceId])
        {
            [self registerForRemoteNotifications];
        }else
        {
            [self setSwitch];
            [self EditSetting];
        }
        
    }else
    if (myswitch==self.facebookSwitch&&[self.facebookSwitch isOn]) {
        [self.facebookSwitch setOn:NO];
        [self FBLogin];
    }
    else
    {
        [self setSwitch];
        [self EditSetting];
    }

}

- (void)cacheUpdated:(NSNotification *)notification
{
    [self.notificationSwitch setOn:YES];
    [self setSwitch];
    [self EditSetting];
}
- (IBAction)closeAccountAction:(id)sender
{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Trovy!"
                                                                  message:@"You will not be able to recover account once closed. Are you sure?"
                                                           preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes, Close"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                {
                                    [self CloseAccount];
                                }];
    
    UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"No, Cancel"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action)
                               {
                                   
                               }];
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

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
                 [self.facebookSwitch setOn:YES];
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
                 faceBookSwitchStr = @"1";
                 [USERDEFAULTS setObject:[result objectForKey:@"name"] forKey:fbConnectname];
                 [USERDEFAULTS setObject:[result objectForKey:@"id"] forKey:fbConnectid];
                 
                 [self EditSetting];
             }
         }];
    }
    
}

@end
