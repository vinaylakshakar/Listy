//
//  OwnerOptionsViewController.m
//  Listy
//
//  Created by Silstone on 23/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "OwnerOptionsViewController.h"
#import "Listy.pch"

@interface OwnerOptionsViewController ()
{
    NSDictionary* notificationDict;
}

@end

@implementation OwnerOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tabBarController.tabBar setHidden:YES];
    //NSLog(@"%@",self.detailDict);
    [self showOwnerOptions];
    
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

- (void)hideContentController:(UIViewController *)content {
    
    
    [content removeFromParentViewController];
    //vinay here-
    CATransition *transition = [CATransition animation];
    transition.duration = 0.7;
   // [self performSelector:@selector(removeView)  withObject:nil afterDelay:0.1];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromBottom;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self.view.layer addAnimation:transition forKey:nil];
    [content willMoveToParentViewController:nil];
    [content.view removeFromSuperview];

}


- (IBAction)cancelBtnAction:(id)sender {
    
    if (self.isfromDiscoverCategory) {
        [self.tabBarController.tabBar setHidden:NO];
    }
   // [self.navigationController popViewControllerAnimated:NO];
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self hideContentController:self];
}
-(void)removeView
{
    
    [self willMoveToParentViewController:nil];
     [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (IBAction)deleteList:(id)sender
{
    if (self.isfromList)
    {
        [self showAlertView:@"Are You sure to want to delete list?"];
        
    } else
    {
        [self showAlertView:@"Are You sure to want to delete list item?"];
    }
    
}

-(void)showAlertView:(NSString*)message
{
    
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Trovy!"
                                                                  message:message
                                                           preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                {
                                    if (self.isfromList)
                                    {
                                        [self deletelist:[[self.detailDict valueForKey:@"listid"] stringValue]];

                                    } else
                                    {
                                         [self DeletelistItem:[[self.detailDict valueForKey:@"listitemId"] stringValue]];
                                    }
                                    
                                }];
    UIAlertAction* CancelButton = [UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                {
                                    [self hideContentController:self];
                                    
                                }];
    
    [alert addAction:yesButton];
    [alert addAction:CancelButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)editlist:(id)sender
{
    [self.tabBarController setSelectedIndex:2];
    [self hideContentController:self];
    [kAppDelegate showProgressHUD];
    NSString * listID = [self.detailDict valueForKey:@"listid"];
    notificationDict = [NSDictionary dictionaryWithObjectsAndKeys:
                        listID, @"listID",
                        nil];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target: self
                                   selector: @selector(callAfterSixtySecond:) userInfo: nil repeats: NO];

}

-(void)callAfterSixtySecond:(NSTimer*) t
{
      [[NSNotificationCenter defaultCenter] postNotificationName:@"editListNotification" object:self userInfo:notificationDict];
}

- (void)showOwnerOptions
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Owner options" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Share" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // Distructive button tapped.
        [self shareList:nil];
    }]];

    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Edit list" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        //[self RenameFolderAction];
        [self editlist:nil];
        
    }]];

        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            
            // Distructive button tapped.
            [self deleteList:nil];
        }]];

    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // OK button tapped.
        [self cancelBtnAction:nil];
        //NSLog(@"cancel tapped");
        
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark-Api Methods

-(void)DeletelistItem:(NSString *)itemID
{
    [kAppDelegate showProgressHUD];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:itemID forKey:@"listitemid"];
    [dict setObject:[[USERDEFAULTS valueForKey:kuserID] stringValue] forKey:@"ownerid"];
    //NSLog(@"%@",dict);
    
    
    [[NetworkEngine sharedNetworkEngine]DeletelistItem:^(id object)
     {
         //NSLog(@"%@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             
             
//             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Trovy!"
//                                                                           message:[object valueForKey:@"Message"]
//                                                                    preferredStyle:UIAlertControllerStyleAlert];
//
//             UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
//                                                                 style:UIAlertActionStyleDefault
//                                                               handler:^(UIAlertAction * action)
//                                         {
                                            [self.navigationController popViewControllerAnimated:YES];
//                                         }];
//
//             [alert addAction:yesButton];
//
//             [self presentViewController:alert animated:YES completion:nil];
             
             
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


-(void)deletelist:(NSString*)listid
{
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:listid forKey:@"listid"];
    
    
    
    //NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]DeleteList:^(id object)
     {
         //NSLog(@"%@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {

             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Trovy!"
                                                                           message:@"List Deleted Successfully"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action)
                                         {
                                             [self.navigationController popViewControllerAnimated:YES];
                                             
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

-(void)list_share:(NSString*)listid
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"userid"];
    [dict setObject:listid forKey:@"listid"];
    
    
    //NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]list_share:^(id object)
     {
         //NSLog(@"%@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             [self hideContentController:self];
             
//             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Trovy!"
//                                                                           message:@"List shared successfully"
//                                                                    preferredStyle:UIAlertControllerStyleAlert];
//
//             UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
//                                                                 style:UIAlertActionStyleDefault
//                                                               handler:^(UIAlertAction * action)
//                                         {
//                                            // [self.navigationController popViewControllerAnimated:YES];
//                                             [self hideContentController:self];
//                                         }];
//
//             [alert addAction:yesButton];
//
//             [self presentViewController:alert animated:YES completion:nil];
             
             
             
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

- (IBAction)shareList:(id)sender
{
    //NSLog(@"%@",self.detailDict);
    NSString *listName;
    if (![self.detailDict valueForKey:@"listname"]) {
        listName = [self.detailDict valueForKey:@"ListName"];
    } else {
        listName = [self.detailDict valueForKey:@"listname"];
    }
    
    NSString *listDescription;
    if (![self.detailDict valueForKey:@"Description"]) {
        listDescription = [NSString stringWithFormat:@"%@",[self.detailDict valueForKey:@"listdescription"]];
    } else {
        listDescription = [NSString stringWithFormat:@"%@",[self.detailDict valueForKey:@"Description"]];
    }
    //NSString *userName = [NSString stringWithFormat:@"%@/n",cell.profileName.text];
    NSURL *myWebsite = [NSURL URLWithString:[NSString stringWithFormat:@"https://lsty.io?list_id=%@-%@",[self.detailDict valueForKey:@"listid"],[USERDEFAULTS valueForKey:kuserID]]];
    //NSURL *myWebsite = [NSURL URLWithString:@"https://lsty.io"];
    NSString *urlWithTitle =[NSString stringWithFormat:@"%@..Follow link to get more details - %@",listName,myWebsite];
    UIImage * image = self.listImage;
    
    NSArray *objectsToShare = @[image,urlWithTitle];
    NSArray * excludeActivities = @[UIActivityTypePrint, UIActivityTypePostToWeibo, UIActivityTypeCopyToPasteboard, UIActivityTypeAddToReadingList, UIActivityTypePostToVimeo];
    
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    activityVC.excludedActivityTypes = excludeActivities;
    // access the completion handler
    activityVC.completionWithItemsHandler = ^(NSString *activityType,
                                              BOOL completed,
                                              NSArray *returnedItems,
                                              NSError *error){
        // react to the completion
        if (completed) {
            
            // user shared an item
            //NSLog(@"We used activity type%@", activityType);
             [self list_share:[self.detailDict valueForKey:@"listid"]];
            
        } else {
            
            // user cancelled
            //NSLog(@"We didn't want to share anything after all.");
        }
        
        if (error) {
            //NSLog(@"An Error occured: %@, %@", error.localizedDescription, error.localizedFailureReason);
        }
    };
    
    [self presentViewController:activityVC animated:YES completion:^
     {
         [self hideContentController:self];
         //[self list_share:[self.detailDict valueForKey:@"listid"]];
     }];
    
}
@end
