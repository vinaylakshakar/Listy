//
//  ForgotPasswordViewController.m
//  Listy
//
//  Created by Silstone on 06/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "Listy.pch"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitBtnAction:(id)sender
{
    [self.view endEditing:YES];
    LoginProcess *sharedManager = [LoginProcess sharedManager];
    bool emailValidate = [sharedManager emailValidate:self.emailField];
    
    if (!emailValidate)
    {
        
        [Utility showAlertMessage:nil message:@"Please enter valid email."];
        
    }else
    {
        [self forgotpassword];
    }
}

-(void)forgotpassword
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:self.emailField.text forKey:@"Email"];

    //NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]ForgetPassword:^(id object)
     {
         
         //NSLog(@"%@",object);
         
         
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Trovy!"
                                                                           message:@"Your password has been sent to your Email."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action)
                                         {
                                             [self.navigationController popToRootViewControllerAnimated:YES];
                                         }];
             
             [alert addAction:yesButton];
             
             [self presentViewController:alert animated:YES completion:nil];
             
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

@end
