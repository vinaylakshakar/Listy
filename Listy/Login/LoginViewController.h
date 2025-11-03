//
//  LoginViewController.h
//  Listy
//
//  Created by Silstone on 06/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JVFloatLabeledTextField.h"

@interface LoginViewController : UIViewController
{
    UIViewController *currentView;
}
- (IBAction)fbLoginAction:(id)sender;
- (IBAction)loginBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *spaceConstant;

@end
