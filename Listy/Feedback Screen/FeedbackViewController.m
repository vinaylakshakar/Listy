//
//  FeedbackViewController.m
//  Listy
//
//  Created by Silstone on 20/11/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "FeedbackViewController.h"
#import "Listy.pch"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.feedbackView.layer.borderWidth = 0.5f;
    self.feedbackView.layer.borderColor = [[UIColor colorWithRed:0.55 green:0.56 blue:0.60 alpha:1.0] CGColor];
    self.feedbackView.layer.cornerRadius = 5;
    self.feedbackBtn.layer.cornerRadius = 5;
    
}

#pragma mark - text View delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    if(textView == self.feedbackView)
    {
        if([self.feedbackView.text isEqualToString:@"Enter Your Feedback"]){
            
            self.feedbackView.text = @"";
            //self.listTitleView.textColor = [UIColor darkGrayColor];
            
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if(textView == self.feedbackView)
    {
        if(self.feedbackView.text.length == 0){
            
            self.feedbackView.text = @"Enter Your Feedback";
            //self.listTitleView.textColor = Grey_COLOR;
            //self.listTitleView.hidden = YES;
        }
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return textView.text.length + (text.length - range.length) <= 150;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark-Api methods


-(void)Sendfeedback
{
    
    
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"Userid"];
        [dict setObject:self.feedbackView.text forKey:@"Feedback"];
        
        
        [[NetworkEngine sharedNetworkEngine]Sendfeedback:^(id object)
         {
             NSLog(@"%@",object);
             
             if ([[object valueForKey:@"status"] isEqualToString:@"success"])
             {
                 
                 UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Trovy!"
                                                                               message:[object valueForKey:@"Message"]
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action)
                                             {
                                                  [self dismissViewControllerAnimated:YES completion:nil];
                                             }];
                 
                 [alert addAction:yesButton];
                 
                 [self presentViewController:alert animated:YES completion:nil];

                 
             } else
             {
                 
                 UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Trovy!"
                                                                               message:[object valueForKey:@"Message"]
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action)
                                             {
                                                 [self.navigationController popViewControllerAnimated:YES];
                                             }];
                 
                 [alert addAction:yesButton];
                 
                 [self presentViewController:alert animated:YES completion:nil];
                 
             }
             
             [kAppDelegate hideProgressHUD];
             
             
             
         }
                                                onError:^(NSError *error)
         {
             NSLog(@"Error : %@",error);
         }params:dict];

    
}


- (IBAction)backBtnAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)sendFeedback:(id)sender
{
    if ([self.feedbackView.text isEqualToString:@""]||[self.feedbackView.text isEqualToString:@"Enter Your Feedback"])
    {
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Trovy!"
                                                                      message:@"Please Enter Your Feedback"
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        
                                    }];
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else
    {
        [self Sendfeedback];
    }
}
@end
