//
//  GeneralOptionsViewController.m
//  Listy
//
//  Created by Silstone on 23/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "GeneralOptionsViewController.h"
#import "Listy.pch"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface GeneralOptionsViewController ()
{
    NSDictionary * folderDict;
}

@end

@implementation GeneralOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tabBarController.tabBar setHidden:YES];
    
    if (self.isfromDiscoverCategory)
    {
    //NSLog(@"from discover");
        
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveFolderNotification:)
                                                 name:@"selectFolderSaved"
                                               object:nil];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(saveListItemNotification:)
                                                     name:@"saveListItemNotification"
                                                   object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cancelFolderNotification:)
                                                 name:@"cancelFolderNotification"
                                               object:nil];
    
    //NSLog(@"%@",self.detailDict);
    [self showGeneralOptions];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)receiveFolderNotification:(NSNotification *)notification
{
    NSDictionary *listDict = [notification userInfo];
    //NSLog(@"GeneralOptions listDict %@",listDict);
    [self ListSaved:[listDict valueForKey:@"Categoryid"]];
}

- (void)saveListItemNotification:(NSNotification *)notification
{
    folderDict = [notification userInfo];
    //NSLog(@"folderDict %@",folderDict);
    [self ListItemSaved:[folderDict valueForKey:@"listID"]];
}

-(void)viewWillAppear:(BOOL)animated
{
    //NSLog(@"%@",self.detailDict);
    if (self.isfromDiscoverCategory) {
        [self.tabBarController.tabBar setHidden:NO];
    }
    
}

- (void)cancelFolderNotification:(NSNotification *)notification
{
    [self hideContentController:self];
}

- (void)showGeneralOptions
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Options" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Share" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // Distructive button tapped.
        [self shareList:nil];
    }]];
    
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self saveBtnAction:nil];
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Report" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // Distructive button tapped.
        [self reportBtnAction:nil];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark-Api methods


-(void)ListSaved:(NSString *)categoryId
{
    
    [kAppDelegate showProgressHUD];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"userid"];
    //[dict setObject:[self.detailDict valueForKey:@"listid"] forKey:@"listid"];
    
    if (![self.detailDict valueForKey:@"listid"])
    {
        [dict setObject:[self.detailDict valueForKey:@"id"] forKey:@"listid"];
    }else
    {
        [dict setObject:[self.detailDict valueForKey:@"listid"] forKey:@"listid"];
    }
    [dict setObject:categoryId forKey:@"categoryid"];
    [dict setObject:[self.detailDict valueForKey:@"userid"] forKey:@"ownerid"];
    
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]ListSaved:^(id object)
     {
         
         NSLog(@"%@",object);
         
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Trovy!"
                                                                           message:[object valueForKey:@"Message"]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action)
                                         {
                                             //                                             [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                                              [self hideContentController:self];
                                         }];
             
             [alert addAction:yesButton];
             
             [self presentViewController:alert animated:YES completion:nil];
             
             
         } else
         {
             [Utility showAlertMessage:nil message:[object valueForKey:@"Message"]];
             
             
         }
        
         [self hideContentController:self];
         [kAppDelegate hideProgressHUD];
         
         
     }
                                              onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}



-(void)ListItemSaved:(NSString *)listid
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"Userid"];
    [dict setObject:listid forKey:@"listid"];
    [dict setObject:[self.detailDict valueForKey:@"listitemId"] forKey:@"listItemid"];
    [dict setObject:[self.detailDict valueForKey:@"userid"] forKey:@"ownerid"];
    
    
    //NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]ListItemSaved:^(id object)
     {
         
         //NSLog(@"%@",object);
         
         
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Trovy!"
                                                                           message:[object valueForKey:@"Message"]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action)
                                         {
//                                             [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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


-(void)reportListItem:(NSString *)reportStr
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[self.detailDict valueForKey:@"listitemId"] forKey:@"listItemid"];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"userid"];
    [dict setObject:reportStr forKey:@"message"];
    
    
    //NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]ListItemReport:^(id object)
     {
         //NSLog(@"%@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Trovy!"
                                                                           message:[object valueForKey:@"Message"]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action)
                                         {
                                             //[self.navigationController popViewControllerAnimated:NO];
                                             [self hideContentController:self];
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

-(void)ListReport:(NSString *)reportStr
{
 
    //NSLog(@"%@",self.detailDict);
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    if (![self.detailDict valueForKey:@"listid"])
    {
         [dict setObject:[self.detailDict valueForKey:@"id"] forKey:@"listid"];
    }else
    {
         [dict setObject:[self.detailDict valueForKey:@"listid"] forKey:@"listid"];
    }
   
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"Userid"];
    [dict setObject:reportStr forKey:@"message"];
    
    
    //NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]ListReport:^(id object)
     {
         //NSLog(@"%@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Trovy!"
                                                                           message:[object valueForKey:@"Message"]
                                                                    preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action)
                                         {
                                             //[self.navigationController popViewControllerAnimated:NO];
                                             [self hideContentController:self];
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
//                                                                           message:@"List Shared Successfully"
//                                                                    preferredStyle:UIAlertControllerStyleAlert];
//
//             UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
//                                                                 style:UIAlertActionStyleDefault
//                                                               handler:^(UIAlertAction * action)
//                                         {
///
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

- (void)hideContentController:(UIViewController *)content {
    [content willMoveToParentViewController:nil];
    [content.view removeFromSuperview];
    [content removeFromParentViewController];
}


- (IBAction)cancelBtnAction:(id)sender
{
    if (self.isfromDiscoverCategory) {
        [self.tabBarController.tabBar setHidden:NO];
    }
//    [self.navigationController popViewControllerAnimated:NO];
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self hideContentController:self];
}

- (IBAction)reportBtnAction:(id)sender
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Trovy!"
                                                                              message:@"Please enter your reason to report."
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Enter your reason.";
        textField.textColor = [UIColor blackColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        //textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self hideContentController:self];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * namefield = textfields[0];
        
        if ([namefield.text isEqualToString:@""]) {
            [self showFolderAlert];
        } else {
            
            if (self.isfromList)
            {
                [self ListReport:namefield.text];
            } else {
                [self reportListItem:namefield.text];
            }
            
            
        }
        
        //        UITextField * passwordfiled = textfields[1];
        //        NSLog(@"%@:%@",namefield.text,passwordfiled.text);
        
    }]];
    
   // [alertController.view setTintColor:[UIColor redColor]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)saveBtnAction:(id)sender
{
    MyFolderViewController *myfolder = [self.storyboard instantiateViewControllerWithIdentifier:@"MyFolderViewController"];
    if (self.isfromList) {
         myfolder.saveItemStr = @"List";
    } else {
         myfolder.saveItemStr = @"item";
    }
    UINavigationController *Navfolder = [[UINavigationController alloc]initWithRootViewController:myfolder];
    [Navfolder setNavigationBarHidden:YES];
    [self presentViewController:Navfolder animated:YES completion:nil];
    
    if (!self.isfromDiscoverCategory)
    {
        [self hideContentController:self];
    }
    //[self hideContentController:self];
}

-(void)showFolderAlert
{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Trovy!"
                                                                  message:@"Please enter some message!"
                                                           preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                {
                                     [self hideContentController:self];
                                }];
    
    [alert addAction:yesButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

//- (id) activityViewController:(UIActivityViewController *)activityViewController
//          itemForActivityType:(NSString *)activityType
//{
//    if ([activityType isEqualToString:UIActivityTypePostToFacebook]) {
//        
//        FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
//        content.contentURL = [NSURL URLWithString:@"https://developers.facebook.com"];
//        
//        FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
//        dialog.fromViewController = self;
//        dialog.shareContent = content;
//        dialog.mode = FBSDKShareDialogModeShareSheet;
//        [dialog show];
//    }
//    
//    return @"This is a facebook post!";
//}

- (IBAction)shareList:(id)sender
//{
//   // UIImage *image = self.listImage;
//    
////    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
////    content.contentURL = [NSURL URLWithString:@"https://developers.facebook.com"];
//    
//    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
//    photo.image = self.listImage;
//    photo.userGenerated = YES;
//    FBSDKSharePhotoContent *content1 = [[FBSDKSharePhotoContent alloc] init];
//    content1.photos = @[photo];
//   // content1.contentURL= [NSURL URLWithString:@"https://developers.facebook.com"];
//    
//    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
//    dialog.fromViewController = self;
//    dialog.shareContent = content1;
//    dialog.mode = FBSDKShareDialogModeShareSheet;
//    [dialog show];
// 
//}
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
    NSString *listidStr;
    if (![self.detailDict valueForKey:@"listid"])
    {
        listidStr = [self.detailDict valueForKey:@"id"];
    }else
    {
        listidStr = [self.detailDict valueForKey:@"listid"];
    }

  NSURL *myWebsite = [NSURL URLWithString:[NSString stringWithFormat:@"https://trovy.io?list_id=%@-%@",listidStr,[self.detailDict valueForKey:@"userid"]]];
//NSString *str = [NSString stringWithFormat:@"https://lsty.io/%@/%@",listidStr,[self.detailDict valueForKey:@"userid"]];
   // NSURL *myWebsite = [NSURL URLWithString:@"https://lsty.io"];
    NSString *urlWithTitle =[NSString stringWithFormat:@"%@..Follow link to get more details - %@",listName,myWebsite];
    UIImage * image = self.listImage;

   NSArray *objectsToShare = @[image,urlWithTitle];
   NSArray * excludeActivities = @[UIActivityTypePrint, UIActivityTypePostToWeibo, UIActivityTypeCopyToPasteboard, UIActivityTypeAddToReadingList, UIActivityTypePostToVimeo];


    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
     activityVC.excludedActivityTypes = excludeActivities;

    activityVC.completionWithItemsHandler = ^(NSString *activityType,
                                              BOOL completed,
                                              NSArray *returnedItems,
                                              NSError *error){
        // react to the completion

        if (completed) {

            // user shared an item
            //NSLog(@"We used activity type%@", activityType);
            [self list_share:listidStr];

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
         //[self list_share:[self.detailDict valueForKey:@"listid"]];
        [self hideContentController:self];
    }];


}
@end
