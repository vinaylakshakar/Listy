//
//  LoginProcess.m
//  Demo Validations
//
//  Created by Developer on 03/01/18.
//  Copyright © 2018 Developer. All rights reserved.
//

#import "LoginProcess.h"


@implementation LoginProcess

+ (id)sharedManager {
    static LoginProcess *loginProcess = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loginProcess = [[self alloc] init];
    });
    return loginProcess;
}

//Email Validation

-(BOOL)emailValidate :(UITextField *)login_email{
    login_email.delegate = self;
    // ( It also validates extra dots in email validation)
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:login_email.text];
}

// Validate Budget

- (BOOL)validateBudget:(UITextField *)phoneNumber
{
    NSString *phoneRegex = @"^[0-9]{2,}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    //    NSString *phone = phoneNumber.text;
    
    return [phoneTest evaluateWithObject: phoneNumber.text];
}

//Password Validation

-(BOOL)passwordValidate :(UITextField *)login_password{
    login_password.delegate = self;
    NSString *stricterFilterString = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{6,}";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    return [passwordTest evaluateWithObject:login_password.text];
}

// Username Validation

-(BOOL)usernameValidate :(UITextField *)login_username
{
    login_username.delegate = self;
    
   // NSString *emailRegex = @"[a-zA-z]+([ '-][a-zA-Z]+)*$";
    //vinay here-
//    NSString *emailRegex = @"^([a-zA-z0-9]+[-._])*[a-zA-Z0-9]+$";
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
//    BOOL isValid = [emailTest evaluateWithObject:login_username.text];
//    return isValid;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^(?=.*[a-z])(?=.*\\d)[a-z\\d]*$"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:login_username.text
                                      options:0
                                        range:NSMakeRange(0, [login_username.text length])];
    
    if([matches count] > 0)
    {
        // Valid input
        return true;
    }
    return false;

}

// Phone number Validation


- (BOOL)validatePhone:(UITextField *)phoneNumber
{
    NSString *phoneRegex = @"^[0-9]{6,10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    //    NSString *phone = phoneNumber.text;
    
    return [phoneTest evaluateWithObject: phoneNumber.text];
}


// Login Validation


-(BOOL)loginValidation :(UITextField *)login_email :(UITextField *)login_password
{
    bool isEmailValid = [self emailValidate:login_email];
    bool isPasswordValid = [self passwordValidate:login_password];
    
    
    if (isEmailValid) {
        if(isPasswordValid){
            return true;
        }
        else{
            return false;
        }
    }
    else{
        return false;
    }
    
}

// set date to button

-(NSString *)setSelectedDate :(NSDate *)selectedDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/YYYY"];
    NSString *dateSelected = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:selectedDate]];
    return dateSelected;
}

@end

