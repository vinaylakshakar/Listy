//
//  OnboardingStep3ViewController.h
//  Listy
//
//  Created by Silstone on 07/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@interface OnboardingStep3ViewController : UIViewController<UNUserNotificationCenterDelegate>
- (IBAction)registerNotification:(id)sender;
- (IBAction)disallowNotification:(id)sender;

@end
