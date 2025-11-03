//
//  ForgotPasswordViewController.h
//  Listy
//
//  Created by Silstone on 06/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : UIViewController

- (IBAction)backBtnAction:(id)sender;
- (IBAction)submitBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *emailField;

@end
