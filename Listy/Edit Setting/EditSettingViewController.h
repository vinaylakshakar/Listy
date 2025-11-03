//
//  EditSettingViewController.h
//  Listy
//
//  Created by Silstone on 27/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@interface EditSettingViewController : UIViewController<UNUserNotificationCenterDelegate>
{
    UIViewController *currentView;
}
- (IBAction)backBtnAction:(id)sender;
- (IBAction)changeBtnAction:(id)sender;
- (IBAction)SwitchOnOff:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UISwitch *emailSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *notificationSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *facebookSwitch;
- (IBAction)closeAccountAction:(id)sender;
- (IBAction)changePasswordAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *changeBtn;
@property (strong, nonatomic) IBOutlet UIButton *changePasswordBtn;

@end
