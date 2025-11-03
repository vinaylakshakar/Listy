//
//  DeletedListsViewController.m
//  Listy
//
//  Created by Silstone on 14/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "DeletedListsViewController.h"
#import "Listy.pch"

@interface DeletedListsViewController ()
{
    NSMutableArray *selectedListArray,*listArray;
    NSMutableArray *finalListArray;
    NSString *searchTextString, *listidStr;
    NSDictionary * folderDict;
}

@end

@implementation DeletedListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.searchView.layer.cornerRadius = 5;
    selectedListArray = [[NSMutableArray alloc]init];
//    listImageArray = [[NSMutableArray alloc]initWithObjects:@"list_item_1",@"list_item_2",@"list_item_3",@"list_item_4",@"list_item_5",@"list_item_6",@"list_item_7",@"list_item_8", nil];
    // Do any additional setup after loading the view.
    [self Deletedlists];

  [self.searchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveFolderNotification:)
                                                 name:@"selectFolder"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.listTable.allowsMultipleSelectionDuringEditing = NO;
}


-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    [textField resignFirstResponder];
    return YES;
}
- (void)receiveFolderNotification:(NSNotification *)notification
{
    folderDict = [notification userInfo];
    //NSLog(@"folderDict %@",folderDict);
    [self Recoverlist];
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
        finalListArray = [NSMutableArray array];
        for ( NSDictionary* item in listArray ) {
            if ([[[item objectForKey:@"ListName"] lowercaseString] rangeOfString:[searchTextString lowercaseString]].location != NSNotFound)
            {
                [finalListArray addObject:item];
            }
        }
    } else {
        finalListArray = [[NSMutableArray alloc]initWithArray:listArray];
    }
    
    [self.listTable reloadData];
}

-(NSMutableDictionary *)removeNullFromDictionary:(NSMutableDictionary *)dic
{
    NSMutableDictionary *prunedDictionary = [NSMutableDictionary dictionary];
    for (NSString * key in [dic allKeys])
    {
        if (![[dic objectForKey:key] isKindOfClass:[NSNull class]])
            [prunedDictionary setObject:[dic objectForKey:key] forKey:key];
    }
    return prunedDictionary;
}


#pragma mark- Api methods

-(void)Deletedlists
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"Userid"];
    [dict setObject:@"3" forKey:@"offset"];
    
    //NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]Deletedlists:^(id object)
     {
         
         //NSLog(@"%@",object);
         
         
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];

             self.searchField.text =@"";
             listArray = [[object valueForKey:@"DeletedlistDetail"] mutableCopy];
             finalListArray = listArray;
             [self.listTable reloadData];
             
             
         } else
         {
             [listArray removeAllObjects];
             finalListArray = listArray;
             [self.listTable reloadData];
           //  [Utility showAlertMessage:nil message:[object valueForKey:@"Message"]];
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

-(void)Recoverlist
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"Userid"];
    [dict setObject:listidStr forKey:@"listid"];
    [dict setObject:[folderDict valueForKey:@"Categoryid"] forKey:@"categoryid"];
    
    //NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]Recoverlist:^(id object)
     {
         
         //NSLog(@"%@",object);
         
         
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             [self Deletedlists];
//             [self.listTable reloadData];
             
             
         } else
         {
             //  [Utility showAlertMessage:nil message:[object valueForKey:@"Message"]];
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


-(void)RemoveMultipleList
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
    
    NSError* error = nil;
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:jsonArray options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    //NSLog(@"jsonData as string:\n%@", jsonString);
    
    [dict setObject:jsonString forKey:@"listid_array"];
    [dict setObject:@"No" forKey:@"isSoftDelete"];

    
    //NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]RemoveMultipleList:^(id object)
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
//
                                                 [self Deletedlists];
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
    
    return finalListArray.count;
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
    
    cell.listTitle.text =[[finalListArray objectAtIndex:indexPath.row] valueForKey:@"ListName"];
    //cell.listImageVIew.image =[UIImage imageNamed:[listImageArray objectAtIndex:indexPath.row]];
    [cell.listImageVIew sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[finalListArray objectAtIndex:indexPath.row] valueForKey:@"Imageurl"]]] placeholderImage:[UIImage imageNamed:@"list_item_1"] options:0 progress:nil completed:nil];
    cell.listImageVIew.layer.cornerRadius = 4;
    cell.listImageVIew.clipsToBounds = YES;
 //   cell.iconImage.image = [UIImage imageNamed:[iconImageArray objectAtIndex:indexPath.row]];
    cell.btnSelected.tag = indexPath.row;
    if ([selectedListArray containsObject:[finalListArray objectAtIndex:indexPath.row]])
    {
        [cell.btnSelected setSelected:YES];
        
    } else
    {
        [cell.btnSelected setSelected:NO];
    }
    
    if (self.isfromdraft) {
        [cell.descriptionLable setHidden:YES];
    }else
    {

        NSString *dateString = [[finalListArray objectAtIndex:indexPath.row] valueForKey:@"Deletedtime"];
        dateString = [dateString stringByReplacingOccurrencesOfString:@" " withString:@"  "];
        
        NSString *localTime = [self getLocalTimeFromUTC:dateString];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM dd yyyy hh:mma"];
        NSDate *dateFromString = [dateFormatter dateFromString:localTime];
        //NSLog(@"%@",dateFromString);
        
         NSString* leftTimeStr = [self remaningTime:dateFromString endDate:[NSDate date]];
        cell.descriptionLable.text =[NSString stringWithFormat:@"Deleted %@ ago",leftTimeStr];
    }
    
    [cell.btnSelected addTarget:self action:@selector(selectList:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

-(NSString*)getLocalTimeFromUTC:(NSString*)utcDate
{
    // create dateFormatter with UTC time format
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM dd yyyy hh:mma"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *date = [dateFormatter dateFromString:utcDate]; // create date from string
    
    // change to a readable time format and change to local time zone
    [dateFormatter setDateFormat:@"MM dd yyyy hh:mma"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *timestamp = [dateFormatter stringFromDate:date];
    
    return timestamp;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *button = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Recover" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
                                    {
                                        //NSLog(@"Action to perform with Button 1");
                                        listidStr = [[finalListArray objectAtIndex:indexPath.row] valueForKey:@"listid"];
                                        MyFolderViewController *myfolder = [self.storyboard instantiateViewControllerWithIdentifier:@"navigationController"];
                                        [self presentViewController:myfolder animated:YES completion:nil];
                                    }];
    button.backgroundColor = [UIColor colorWithRed:0.33 green:0.79 blue:0.45 alpha:1.0];
    //arbitrary color

    return @[button]; //array with all the buttons you want. 1,2,3, etc...
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // you need to implement this method too or nothing will work:

}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES; //tableview must be editable or nothing will work...
}

-(NSString*)remaningTime:(NSDate*)startDate endDate:(NSDate*)endDate {
    
    NSDateComponents *components;
    NSInteger days;
    NSInteger hour;
    NSInteger minutes;
    NSInteger seconds;
    NSString *durationString;
    
    components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond
                                                 fromDate: startDate toDate: endDate options: 0];
    days = [components day];
    hour = [components hour];
    minutes = [components minute];
    seconds = [components second];
    
    
    if (days > 0) {
        
        if (days > 1) {
            durationString = [NSString stringWithFormat:@"%ld days", (long)days];
        }
        else {
            durationString = [NSString stringWithFormat:@"%ld day", (long)days];
        }
        return durationString;
    }
    
    if (hour > 0) {
        
        if (hour > 1) {
            durationString = [NSString stringWithFormat:@"%ld hours", (long)hour];
        }
        else {
            durationString = [NSString stringWithFormat:@"%ld hour", (long)hour];
        }
        return durationString;
    }
    
    if (minutes > 0) {
        
        if (minutes > 1) {
            durationString = [NSString stringWithFormat:@"%ld minutes", (long)minutes];
        }
        else {
            durationString = [NSString stringWithFormat:@"%ld minute", (long)minutes];
        }
        return durationString;
    }
    if (seconds > 0) {
        
        if (seconds > 1) {
            durationString = [NSString stringWithFormat:@"%ld second", (long)seconds];
        }
        else {
            durationString = [NSString stringWithFormat:@"%ld second", (long)seconds];
        }
        return durationString;
    }
    
    return @"";
}

-(void)selectList:(UIButton*)sender
{
    if (![selectedListArray containsObject:[finalListArray objectAtIndex:[sender tag]]])
    {
        [selectedListArray addObject:[finalListArray objectAtIndex:((UIButton *)sender).tag]];
    } else
    {
        [selectedListArray removeObject:[finalListArray objectAtIndex:((UIButton *)sender).tag]];
    }
    
    [self.listTable reloadData];

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
- (IBAction)removeMultpleLists:(id)sender
{
    if (selectedListArray.count==0)
    {
        [Utility showAlertMessage:nil message:@"No list selected!"];
        
    } else
    {
        
        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Trovy!"
                                                                      message:@"Sure to delete lists?"
                                                               preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes, Delete"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [self RemoveMultipleList];
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
@end
