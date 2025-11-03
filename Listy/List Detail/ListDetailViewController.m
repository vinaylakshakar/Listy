//
//  ListDetailViewController.m
//  Listy
//
//  Created by Silstone on 14/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "ListDetailViewController.h"
#import "Listy.pch"

@interface ListDetailViewController ()
{
    NSMutableArray *listImageArray,*categoryListArray,*selectedListArray;
    NSMutableArray *listArray;
    NSString *searchTextString;
    NSDictionary* notificationDict;
}

@end

@implementation ListDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    // Do any additional setup after loading the view.
    selectedListArray = [[NSMutableArray alloc]init];
    listArray = [[NSMutableArray alloc]init];
     self.searchView.layer.cornerRadius = 5;
    self.titleLable.text = self.titleStr;
    listImageArray = [[NSMutableArray alloc]initWithObjects:@"list_item_1",@"list_item_2",@"list_item_3",@"list_item_4",@"list_item_5",@"list_item_6",@"list_item_7",@"list_item_8", nil];
  
    [self.searchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    if (self.isfromdraft)
    {
        [self Draftlists];
    } else {
        [self UserCategorylist];
    }
    
    [self.tabBarController.tabBar setHidden:NO];
    self.listTable.allowsMultipleSelectionDuringEditing = NO;
    if (self.followerid)
    {
        del.folderCategoryName = @"";
        del.folderCategoryID = @"";
    } else {
        del.folderCategoryName = self.titleStr;
        del.folderCategoryID = self.categoryIDStr;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    [textField resignFirstResponder];
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Search Methods

-(void)textFieldDidChange:(UITextField*)textField
{
    searchTextString = textField.text;
    [self updateSearchArray];
}
//update seach method where the textfield acts as seach bar
-(void)updateSearchArray
{
    if (searchTextString.length != 0) {
        categoryListArray = [NSMutableArray array];
        for ( NSDictionary* item in listArray ) {
            if ([[[item objectForKey:@"ListName"] lowercaseString] rangeOfString:[searchTextString lowercaseString]].location != NSNotFound)
            {
                [categoryListArray addObject:item];
            }
        }
    } else {
        categoryListArray = [[NSMutableArray alloc]initWithArray:listArray];
    }
    
    [self.listTable reloadData];
}


#pragma mark- Api methods:-

-(void)createCategory:(NSString*)categoryname
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"userid"];
    [dict setObject:self.categoryIDStr forKey:@"categoryid"];
    [dict setObject:categoryname forKey:@"Categoryname"];
    
    
    //NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]CreateCategory:^(id object)
     {
         //NSLog(@"%@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             
             self.titleLable.text = categoryname;
             del.folderCategoryName = categoryname;
             del.folderCategoryID = self.categoryIDStr;
             
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


-(void)DeleteFolder
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"userid"];
    [dict setObject:self.categoryIDStr forKey:@"categoryid"];
    [dict setObject:@"1" forKey:@"offset"];
    
    //NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]DeleteFolder:^(id object)
     {
         
         //NSLog(@"%@",object);
         
         
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             del.folderCategoryName = @"";
             del.folderCategoryID = @"";
             [kAppDelegate hideProgressHUD];
             
             [self.navigationController popViewControllerAnimated:YES];
             
             
             
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


-(void)Draftlists
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"Userid"];
    [dict setObject:@"3" forKey:@"offset"];
    
    //NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]Draftlists:^(id object)
     {
         
         NSLog(@"%@",object);
         
         
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             
             self.searchField.text =@"";
             listArray = [[object valueForKey:@"Draftlists"] mutableCopy];
             categoryListArray = listArray;
             [self.listTable reloadData];
             
             
         } else
         {
             [listArray removeAllObjects];
             [self.listTable reloadData];
             //             [Utility showAlertMessage:nil message:[object valueForKey:@"Message"]];
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


-(void)UserCategorylist
{
    [categoryListArray removeAllObjects];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    if (self.followerid)
    {
        [dict setObject:self.followerid forKey:@"userid"];
        [self.editBtn setHidden:YES];
    } else {
        [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"userid"];
    }
    
    [dict setObject:self.categoryIDStr forKey:@"Categoryid"];
    
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]UserCategorylist:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             self.searchField.text =@"";
             listArray = [[object valueForKey:@"UserCategorylist"] mutableCopy];
             categoryListArray = listArray;
             [self.listTable reloadData];
             //             ItineraryQuestionArray = [[object valueForKey:@"Data"] mutableCopy];
             //[Utility showAlertMessage:nil message:@"Folder Created Successsfully!"];
             

         } else
         {
             [categoryListArray removeAllObjects];
             [self.listTable reloadData];
//             [Utility showAlertMessage:nil message:[object valueForKey:@"Message"]];

         }
         
         [kAppDelegate hideProgressHUD];
         
         
         
     }
                                               onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}

-(void)RemoveMultipleList:(NSString *)categoryid
{
    NSMutableArray *jsonArray = [[NSMutableArray alloc]init];
    
    for (NSMutableDictionary *dict in selectedListArray)
    {
        NSMutableDictionary *dictID =[[NSMutableDictionary alloc]init];
        [dictID setObject:[dict valueForKey:@"listid"] forKey:@"listid"];
        [jsonArray addObject:dictID];
    }
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"Userid"];
    [dict setObject:categoryid forKey:@"categoryid"];
    
    NSError* error = nil;
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:jsonArray options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    //NSLog(@"jsonData as string:\n%@", jsonString);
    
    [dict setObject:jsonString forKey:@"listid_array"];
    [dict setObject:@"Yes" forKey:@"isSoftDelete"];
    
    
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]RemoveMultipleList:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             [selectedListArray removeAllObjects];
             
//             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Trovy!"
//                                                                           message:[object valueForKey:@"Message"]
//                                                                    preferredStyle:UIAlertControllerStyleAlert];
//
//             UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
//                                                                 style:UIAlertActionStyleDefault
//                                                               handler:^(UIAlertAction * action)
//                                         {
                                             if (self.isfromdraft) {
                                                 [self Draftlists];
                                             } else {
                                                 [self UserCategorylist];
                                             }
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

#pragma tableview methods--

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return categoryListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    static NSString *propertyIdentifier = @"DeletedListCell";
    
    DeletedListCell *cell = (DeletedListCell *)[tableView dequeueReusableCellWithIdentifier:propertyIdentifier];
    
    
    if (cell == nil)
    {
        
        NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"DeletedListCell" owner:self options:nil];
        cell = [nib1 objectAtIndex:0];
    }
    
    //cell.listImageVIew.image =[UIImage imageNamed:[listImageArray objectAtIndex:indexPath.row]];
    
    if (self.isfromdraft)
    {
        NSMutableDictionary *itemDict = [categoryListArray objectAtIndex:indexPath.row];
      //  NSString *urlStr = [NSString stringWithFormat:kBaseURL@"CreateThumbnailURL?listid=%@&listitemid=%d&url=%@&width=%@&height=0",[itemDict valueForKey:@"listid"],0,[itemDict valueForKey:@"Imageurl"],kfolderdetail_width];
        
        NSURL *customUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[itemDict valueForKey:@"Imageurl"]]];
        
        [cell.listImageVIew sd_setImageWithURL:customUrl placeholderImage:[UIImage imageNamed:@"listy_folder"] options:0 progress:nil completed:nil];
        cell.listImageVIew.layer.cornerRadius = 4;
        cell.listImageVIew.clipsToBounds = YES;
        cell.listTitle.text = [[categoryListArray objectAtIndex:indexPath.row] valueForKey:@"ListName"];
        
        if ([self.editBtn isSelected])
        {
            cell.btnSelected.tag = indexPath.row;
            [cell.btnSelected setEnabled:true];
            
            if ([selectedListArray containsObject:[categoryListArray objectAtIndex:indexPath.row]])
            {
                [cell.btnSelected setSelected:YES];
                
            } else
            {
                [cell.btnSelected setSelected:NO];
            }
            
        } else {
            cell.btnSelected.tag = indexPath.row;
            [cell.btnSelected setEnabled:false];
        }
        
        [cell.btnSelected addTarget:self action:@selector(selectList:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;

    }
    
    
    NSMutableDictionary *itemDict = [categoryListArray objectAtIndex:indexPath.row];
   // NSString *urlStr = [NSString stringWithFormat:kBaseURL@"CreateThumbnailURL?listid=%@&listitemid=%d&url=%@&width=%@&height=0",[itemDict valueForKey:@"listid"],0,[itemDict valueForKey:@"list_image"],kfolderdetail_width];
    
    NSURL *customUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[itemDict valueForKey:@"list_image"]]];
    
    [cell.listImageVIew sd_setImageWithURL:customUrl placeholderImage:[UIImage imageNamed:@"listy_folder"] options:0 progress:nil completed:nil];
    cell.listImageVIew.layer.cornerRadius = 4;
    cell.listImageVIew.clipsToBounds = YES;
    cell.listTitle.text = [[categoryListArray objectAtIndex:indexPath.row] valueForKey:@"ListName"];
    
    //NSLog(@"%@",[USERDEFAULTS valueForKey:kuserID]);
    
    if ([[[categoryListArray objectAtIndex:indexPath.row] valueForKey:@"userid"] isEqualToString:[[USERDEFAULTS valueForKey:kuserID] stringValue]])
    {
            cell.descriptionLable.text = [NSString stringWithFormat:@"%@ Followers",[[categoryListArray objectAtIndex:indexPath.row] valueForKey:@"NoOfFollwers"]];
    } else {
            cell.descriptionLable.text = [NSString stringWithFormat:@"By %@",[[categoryListArray objectAtIndex:indexPath.row] valueForKey:@"Createdby"]];
    }
    

    //   cell.iconImage.image = [UIImage imageNamed:[iconImageArray objectAtIndex:indexPath.row]];
    if ([self.editBtn isSelected])
    {
        cell.btnSelected.tag = indexPath.row;
        [cell.btnSelected setEnabled:true];
        
        if ([selectedListArray containsObject:[categoryListArray objectAtIndex:indexPath.row]])
        {
            [cell.btnSelected setSelected:YES];
            
        } else
        {
            [cell.btnSelected setSelected:NO];
        }
        
        
    } else {
        cell.btnSelected.tag = indexPath.row;
        [cell.btnSelected setEnabled:false];
    }
       [cell.btnSelected addTarget:self action:@selector(selectList:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
//    if (categoryListArray.count>0&&[[[categoryListArray objectAtIndex:indexPath.row] valueForKey:@"userid"] isEqualToString:[[USERDEFAULTS valueForKey:kuserID] stringValue]])
//    {
//        return YES;
//    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [selectedListArray addObject:[categoryListArray objectAtIndex:indexPath.row]];
        
        if (self.isfromdraft)
        {
            [self RemoveMultipleList:[[categoryListArray objectAtIndex:indexPath.row] valueForKey:@"categoryid"]];
        }else
        {
            [self RemoveMultipleList:self.categoryIDStr];
        }
        
        [categoryListArray removeObjectAtIndex:indexPath.row];
       
    }
}

-(void)selectList:(UIButton*)sender
{
    if (![selectedListArray containsObject:[categoryListArray objectAtIndex:[sender tag]]])
    {
        [selectedListArray addObject:[categoryListArray objectAtIndex:((UIButton *)sender).tag]];
    } else
    {
        [selectedListArray removeObject:[categoryListArray objectAtIndex:((UIButton *)sender).tag]];
    }
    
    [self.listTable reloadData];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    del.folderCategoryName = @"";
    del.folderCategoryID = @"";
    
    if (self.isfromSaveItem)
    {
        NSString * listID = [[[categoryListArray objectAtIndex:indexPath.row] valueForKey:@"listid"] stringValue];
        notificationDict = [NSDictionary dictionaryWithObjectsAndKeys:
                            listID, @"listID",
                            nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"saveListItemNotification" object:self userInfo:notificationDict];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
    else if (self.isfromdraft)
    {
        if (![self.editBtn isSelected])
        {
            [self.tabBarController setSelectedIndex:2];
            [kAppDelegate showProgressHUD];
            [self sendNotification:[categoryListArray objectAtIndex:indexPath.row]];
        }
    }
    else
    {
        
        if (![self.editBtn isSelected])
        {
            FeaturedListFirstViewController *featureList = [self.storyboard instantiateViewControllerWithIdentifier:@"FeaturedListFirstViewController"];
            featureList.listDictinfo = [categoryListArray objectAtIndex:indexPath.row];
            featureList.followerid = self.followerid;
            [self.navigationController pushViewController:featureList animated:YES];
        }
      
    }
    
    

}

-(void)sendNotification:(NSMutableDictionary*)dict
{
    NSString * listID = [[dict valueForKey:@"listid"] stringValue];
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

- (IBAction)backBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)searchBtnAction:(id)sender
{
    SearchViewController *search =[self.storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [self.navigationController pushViewController:search animated:YES];
}

-(void)showActionsheetAlert
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Folder options" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Rename" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self RenameFolderAction];

    }]];
    
    if (listArray.count==0)
    {
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            
            // Distructive button tapped.
           [self DeleteFolder];
        }]];
    }

    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // OK button tapped.
        //NSLog(@"cancel tapped");
        
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}

-(void)RenameFolderAction
{
    //    [self.effectView setHidden:NO];
    //    [self.folderView setHidden:NO];
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Rename Folder"
                                                                              message: @"Give your folder a name"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        //textField.placeholder = @"Rename your folder";
        textField.text = self.titleLable.text;
        textField.textColor = [UIColor blackColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        //textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * namefield = textfields[0];
        
        if ([namefield.text isEqualToString:@""]) {
            [Utility showAlertMessage:nil message:@"Please Enter your folder name!"];
        } else {
            
            [self createCategory:namefield.text];
        }
        
        //        UITextField * passwordfiled = textfields[1];
        //        NSLog(@"%@:%@",namefield.text,passwordfiled.text);
        
    }]];
    
    [alertController.view setTintColor:[UIColor redColor]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)editBtnAction:(id)sender
{
    if (self.isfromdraft)
    {
        if (![sender isSelected])
        {
            [sender setSelected:YES];
            [self.listTable reloadData];
            [self.editBtn setTitleColor:[UIColor colorWithRed:0.96 green:0.19 blue:0.24 alpha:1.0] forState:UIControlStateSelected];
        } else {
            
            if (selectedListArray.count==0)
            {
                //[Utility showAlertMessage:nil message:@"No list selected!"];
                [sender setSelected:NO];
            } else
            {
                
                UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Trovy!"
                                                                              message:@"Sure to delete lists?"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes, Delete"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                            {
                                                [sender setSelected:NO];
                                                [self RemoveMultipleList:self.categoryIDStr];
                                            }];
                
                UIAlertAction* noButton = [UIAlertAction actionWithTitle:@"No, Cancel"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * action)
                                           {
                                               
                                           }];
                
                [alert addAction:yesButton];
                [alert addAction:noButton];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
            
        }
    }
    else
    {
        [self showActionsheetAlert];
    }

}


@end
