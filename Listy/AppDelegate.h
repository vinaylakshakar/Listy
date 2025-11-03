//
//  AppDelegate.h
//  Listy
//
//  Created by Silstone on 06/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>
{
    MBProgressHUD *_progressHUD;
    
}
@property(nonatomic,strong)NSString *folderCategoryID;
@property(nonatomic,strong)NSString *folderCategoryName;
@property (strong, nonatomic) UIWindow *window;
- (void)showProgressHUD;
- (void)hideProgressHUD;
-(void)showProgressHUDInView:(UIView *)view;

@end

