//
//  AppDelegate.m
//  Listy
//
//  Created by Silstone on 06/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "Reachability.h"
#import "Listy.pch"
#import <StoreKit/StoreKit.h>
#import <Crashlytics/Crashlytics.h>
#import <Fabric/Fabric.h>
@import Firebase;
@import Crashlytics;
@import Fabric;

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface AppDelegate ()
{
    NSMutableDictionary *listDict2;
     BOOL handled;
}

@end

@implementation AppDelegate
{
    Reachability *networkReachability;
    NetworkStatus networkStatus;
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.folderCategoryID = @"";
    self.folderCategoryName = @"";
    [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];
    // Override point for customization after application launch.
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
   // [self applicationFont];
   // [[UIApplication sharedApplication] setApplicationIconBadgeNumber:12];
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
     [FIRApp configure];
    [[Fabric sharedSDK] setDebug: YES];
    [Fabric with:@[CrashlyticsKit]];
     [self checkLoginStatus];
     [self showRatingPopUp];
    sleep(3);
    return YES;
}

-(void)showRatingPopUp
{
    int shortestTime = 60;
    int longestTime = 300;
    int timeInterval = arc4random_uniform(longestTime - shortestTime) + shortestTime;
    
    [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(requestReview) userInfo:nil repeats:NO];

}

- (void)requestReview {
    [SKStoreReviewController requestReview];
}
-(void)applicationFont
{
    for(NSString *fontfamilyname in [UIFont familyNames])
    {
        for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname])
        {
            NSLog(@"\tfont:'%@'",fontName);
        }

    }
}

-(void)checkLoginStatus
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    bool isLoggedIn = [USERDEFAULTS boolForKey:kalreadyLoggedIn];
    bool isUsercategory = [USERDEFAULTS boolForKey:kuserCategoryDetail];
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    if ([USERDEFAULTS valueForKey:kuserID])
    {
        if (isUsercategory)
        {

            if(isLoggedIn)
            {
                TabBarViewController *tabbar = [storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
                self.window.rootViewController = tabbar;

            }else
            {
                OnboardingStep1ViewController *onboarding = [storyboard instantiateViewControllerWithIdentifier:@"OnboardingStep1ViewController"];
                UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:onboarding];
                navigationController.interactivePopGestureRecognizer.enabled = NO;
                navigationController.navigationBar.hidden = YES;
                self.window.rootViewController = navigationController;
            }


        }
        else
        {

            OnboardingStep1ViewController *onboarding = [storyboard instantiateViewControllerWithIdentifier:@"OnboardingStep1ViewController"];
            UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:onboarding];
            navigationController.interactivePopGestureRecognizer.enabled = NO;
            navigationController.navigationBar.hidden = YES;
            self.window.rootViewController = navigationController;

        }
    }
    else
    {
        UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationVC"];
        navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.window.rootViewController = navigationController;
    }



    [self.window makeKeyAndVisible];
    
}

- (NSString *)hexadecimalStringFromData:(NSData *)data
{
    NSUInteger dataLength = data.length;
    if (dataLength == 0) {
        return nil;
    }
      
    const unsigned char *dataBuffer = data.bytes;
    NSMutableString *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    for (int i = 0; i < dataLength; ++i) {
        [hexString appendFormat:@"%02x", dataBuffer[i]];
    }
    return [hexString copy];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    NSString *token;
    if (SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"13.0")) {
        // code here
         token = [self hexadecimalStringFromData:deviceToken];
    }else
    {
        token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    }
    
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"device token registered-%@",token);
    [[NSUserDefaults standardUserDefaults]setValue:token forKey:deviceId];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MyCacheUpdatedNotification" object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onboardingUpdatedNotification" object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MyCacheUpdatedNotificationDiscover" object:self];
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0"))
    {
        
        completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber +=1;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatedBudge" object:self];
    //    if ([[[notification.request.content.userInfo valueForKey:@"aps"] valueForKey:@"alert"]  rangeOfString:@"Property Deleted"].location == NSNotFound) {
    //
    //        completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
    //
    //    }
    
}


- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"ALERT !!!"
                                 
                                 message:[NSString stringWithFormat:@"Failed to get token, error: %@", error]
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * yesButton = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action) {
                                     //Handle your yes please button action here
                                     
                                     
                                     
                                 }];
    
    [alert addAction:yesButton];
    
    // [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    
}


//- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
//{
////    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:123];
//     NSLog(@"notification recieved");
//    [UIApplication sharedApplication].applicationIconBadgeNumber = [[[userInfo objectForKey:@"aps"] objectForKey: @"badgecount"] intValue];
//}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"notification recieved");
   // NSInteger counter = [[[userInfo valueForKey:@"aps"] valueForKey:@"badge"] integerValue];
    NSInteger counter = [UIApplication sharedApplication].applicationIconBadgeNumber+1;
//    {
//        "aps" : {
//            "alert" : "New notification!",
//            "badge" : 2
//        }
//    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:counter];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatedBudge" object:self];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)iCenter didReceiveNotificationResponse:(UNNotificationResponse *)iResponse withCompletionHandler:(void(^)(void))iCompletionHandler
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TabBarViewController *tabbar = [storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
    [tabbar setSelectedIndex:3];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    self.window.rootViewController = tabbar;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
   
    
    if ([url.absoluteString containsString:@"trovy"])
    {
        if ([USERDEFAULTS valueForKey:kuserID])
        {
            NSArray *separatedArray =[url.absoluteString componentsSeparatedByString:@"?"];
            NSArray *separatedArray2 =[[separatedArray objectAtIndex:1] componentsSeparatedByString:@"-"];
            NSLog(@"separatedArray-%@",separatedArray);
            
            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            TabBarViewController *tabbar = [storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
            [tabbar setSelectedIndex:1];
            self.window.rootViewController = tabbar;
            
            listDict2 =[[NSMutableDictionary alloc]init];
            [listDict2 setObject:[separatedArray2 objectAtIndex:0] forKey:@"listid"];
            [listDict2 setObject:[separatedArray2 objectAtIndex:1] forKey:@"userid"];
            
            [NSTimer scheduledTimerWithTimeInterval:2.0 target: self
                                           selector: @selector(callAfterSixtySecond:) userInfo: nil repeats: NO];
        }
        
    } else
    {
        handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                      openURL:url
                                                            sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                                   annotation:options[UIApplicationOpenURLOptionsAnnotationKey] ];
    }


    
   
                   
    // Add any custom logic here.
    return handled;
}

-(void)callAfterSixtySecond:(NSTimer*)t
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveDiscoverList" object:self userInfo:listDict2];
}

#pragma progressHUD

-(void)showProgressHUD
{
    
    networkReachability = [Reachability reachabilityForInternetConnection];
    networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Alert!"
                                                                      message:@"No Network Connection!."
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        
                                    }];
        
        [alert addAction:yesButton];
        
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
        
    }else
    {
        [self createProgressHud];
        [self.window bringSubviewToFront:_progressHUD];
        [_progressHUD showAnimated:YES];
        
    }
}

-(void)showProgressHUDInView:(UIView *)view
{
    
    networkReachability = [Reachability reachabilityForInternetConnection];
    networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"No NetWork Connection!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }else
    {
        [self createProgressHud];
        [view bringSubviewToFront:_progressHUD];
        [_progressHUD showAnimated:YES];
        
    }
}


//Hide Progress HUD
-(void)hideProgressHUD
{
    [_progressHUD hideAnimated:YES];
}
//Create Progress HUD
-(void)createProgressHud
{
    if(_progressHUD)
    {
        return;
    }
    else
    {
        _progressHUD=[[MBProgressHUD alloc]initWithView:self.window];
        _progressHUD.label.text = @"Loading...";
        [self.window addSubview:_progressHUD];
    }
}


@end
