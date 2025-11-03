//
//  LoginProcess.h
//  Demo Validations
//
//  Created by Developer on 03/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface LoginProcess : NSObject<UITextFieldDelegate>
{
    UIDatePicker *datePicker;
}
+ (id)sharedManager;

- (BOOL)validateBudget:(UITextField *)phoneNumber;
-(BOOL)emailValidate :(UITextField *)login_email;
-(BOOL)passwordValidate :(UITextField *)login_password;
-(BOOL)usernameValidate :(UITextField *)login_username;
-(BOOL)loginValidation :(UITextField *)login_email :(UITextField *)login_password;
- (BOOL)validatePhone:(UITextField *)phoneNumber;
-(NSString *)setSelectedDate :(NSDate *)selectedDate;
@end

