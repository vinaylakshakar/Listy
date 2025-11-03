//
//  SignupViewController.h
//  Listy
//
//  Created by Silstone on 06/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController
{
    UIViewController *currentView;
}
- (IBAction)backBtnAction:(id)sender;
- (IBAction)fbLoginAction:(id)sender;
- (IBAction)createAccountAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)popupForUsername:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *popupBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *spaceConstant;

@end
