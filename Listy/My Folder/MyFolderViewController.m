//
//  MyFolderViewController.m
//  Listy
//
//  Created by Silstone on 06/09/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "MyFolderViewController.h"
#import "Listy.pch"
#import <QuartzCore/QuartzCore.h>

@interface MyFolderViewController ()
{
    NSMutableArray *listImageArray;
    NSMutableArray *finalCategoryArray,*localCategoryAray,*categoryArray;;
    NSString *searchTextString;
}

@end

@implementation MyFolderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    listNameArray = [[NSMutableArray alloc]initWithObjects:@"Music",@"Film & TV",@"Food",@"Sport",@"DIY",@"Travel",@"To do’s",@"Bucket list",@"Fashion",@"Create new folder", nil];
//    listImageArray = [[NSMutableArray alloc]initWithObjects:@"image_22",@"image_23",@"image_24",@"image_25",@"image_26",@"image_27",@"image_28",@"image_29",@"image_30",@"Group 1490", nil];
    
    localCategoryAray =[[NSMutableArray alloc]initWithObjects:@"BOOKS",@"TECHNOLOGY",@"FILM",@"TV",@"FOOD & DRINK",@"GAMING",@"HOME & GARDEN",@"MUSIC",@"SPORTS",@"TRAVEL", nil];
    self.searchView.layer.cornerRadius = 5;
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyListViewCell" bundle:nil] forCellWithReuseIdentifier:@"MyListViewCell"];
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.searchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self UserCategories];
}


#define ACCEPTABLE_CHARACTERS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_.&"

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    
    if (textField.tag==30) {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        if ([string isEqualToString:filtered]) {
          return newLength <= 30;
        }
        
        return NO;
    }
    
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
        finalCategoryArray = [NSMutableArray array];
        for ( NSDictionary* item in categoryArray ) {
            if ([[[item objectForKey:@"Categoryname"] lowercaseString] rangeOfString:[searchTextString lowercaseString]].location != NSNotFound)
            {
                [finalCategoryArray addObject:item];
            }
        }
    } else {
        finalCategoryArray = [[NSMutableArray alloc]initWithArray:categoryArray];
    }
    
    [self.collectionView reloadData];
}


#pragma mark- collectionview delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
//    if (section==0)
//    {
//        return 10;
//    }
    if (finalCategoryArray.count==0)
    {
            return 1;
    }
    return finalCategoryArray.count+1;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MyListViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyListViewCell" forIndexPath:indexPath];
    
//    if (indexPath.section==0)
//    {
//        cell.listNameLable.text = [localCategoryAray objectAtIndex:indexPath.row];
//        [cell.listImage setImage:[UIImage imageNamed:@"user_profile"]];
//        cell.listImage.layer.cornerRadius = 4;
//        cell.listImage.layer.masksToBounds = YES;
//        [cell.listNumberlbl setHidden:YES];
//        return cell;
//    }
//    else
    {
        if (indexPath.row==finalCategoryArray.count)
        {
            // [cell.listNumberlbl setHidden:YES];
            cell.listNameLable.text = @"Create New Folder";
            [cell.listImage setImage:[UIImage imageNamed:@"Group 1490"]];
            [cell.listNumberlbl setHidden:YES];
            
        }else
        {
            cell.listNameLable.text = [[finalCategoryArray objectAtIndex:indexPath.row] valueForKey:@"Categoryname"];
            cell.listNumberlbl.text = [NSString stringWithFormat:@"%@ Lists",[[finalCategoryArray objectAtIndex:indexPath.row] valueForKey:@"no_of_lists"]];
            [cell.listNumberlbl setHidden:NO];
            //    cell.dotBtn.hidden = false;
            
            cell.listImage.layer.cornerRadius = 4;
            cell.listImage.layer.masksToBounds = YES;
            [cell.listImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[finalCategoryArray objectAtIndex:indexPath.row] valueForKey:@"CategoryImage"]]] placeholderImage:[UIImage imageNamed:@"listy_folder"] options:0 progress:nil completed:nil];
        }
        
    }

    
    
    return cell;
}

//- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return NO;
//}


//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    return CGSizeMake(self.collectionView.frame.size.width/2-5, 50);
//}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//
//
//    return 10.0;
//}

-(void)createCategory:(NSString*)categoryname
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"userid"];
    [dict setObject:@"0" forKey:@"categoryid"];
    [dict setObject:categoryname forKey:@"Categoryname"];
    
    
    //NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]CreateCategory:^(id object)
     {
         //NSLog(@"%@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             NSMutableDictionary *Categorydict = [[object valueForKey:@"CreateCategory"] mutableCopy];
             
             //             ItineraryQuestionArray = [[object valueForKey:@"Data"] mutableCopy];
            // [Utility showAlertMessage:nil message:@"Folder Created Successsfully!"];
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Trovy!"
                                                                           message:@"Folder Created Successsfully!"
                                                                    preferredStyle:UIAlertControllerStyleAlert];

             UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action)
                                         {
                                            // [self dismissViewControllerAnimated:YES completion:nil];
                                         }];

             [alert addAction:yesButton];

             [self presentViewController:alert animated:YES completion:nil];
             
             [self UserCategories];
             
             NSString *folderName = [Categorydict valueForKey:@"Categoryname"];
             NSString * folderID = [Categorydict valueForKey:@"Categoryid"];
             NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   folderName, @"Categoryname",
                                   folderID,@"Categoryid",
                                   nil];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"selectFolder" object:self userInfo:dict];
             
             
//             if ([self.saveItemStr isEqualToString:@"List"]||[self.saveItemStr isEqualToString:@"item"]) {
//                 [self dismissViewControllerAnimated:YES completion:nil];
//             }
            
             
             
         } else
         {
             //[Utility showAlertMessage:nil message:[object valueForKey:@"Message"]];
             
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Trovy!"
                                                                           message:@"Folder already exists!"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action)
                                         {
                                             // [self dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark- Api methods-

-(void)UserCategories
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"userid"];
    [dict setObject:@"1" forKey:@"offset"];
    
    
    //NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]UserCategories:^(id object)
     {
         //NSLog(@"%@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
//             categoryArray = [[object valueForKey:@"SelectedCategory"] mutableCopy];
//             categoryArray = [categoryArray arrayByAddingObjectsFromArray:[object valueForKey:@"UserCategory"]];
             //update
//             categoryArray = [[object valueForKey:@"UserCategory"] mutableCopy];
//             finalCategoryArray = [[NSMutableArray alloc]initWithArray:categoryArray];
             categoryArray = [[object valueForKey:@"SelectedCategory"] mutableCopy];
             //finalCategoryArray = [[NSMutableArray alloc]initWithArray:categoryArray];
             finalCategoryArray = [[object valueForKey:@"UserCategory"] mutableCopy];
             //vinay here-
             //[finalCategoryArray addObjectsFromArray:categoryArray];
              categoryArray = finalCategoryArray;
             //NSLog(@"%@",categoryArray);
             [self.collectionView reloadData];
             
         } else
         {
             //[Utility showAlertMessage:nil message:[object valueForKey:@"Message"]];
             //NSLog(@"%@",categoryArray);
             [self.collectionView reloadData];
             
         }
         
         [kAppDelegate hideProgressHUD];
         
         
         
     }
                                               onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        
        reusableview = footerview;
    }
    
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(IS_IPHONE_5)
    {
        NSLog(@"i am an iPhone 5!");
        return CGSizeMake(80, 120);
    }
    return CGSizeMake(101, 135);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    
    
    return 19.06;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath

{
    
//    if (indexPath.section==0)
//    {
//        [self createCategory:[localCategoryAray objectAtIndex:indexPath.row]];
//    } else
    {
        if (indexPath.row==finalCategoryArray.count)
        {
            [self CreateFolder];
        } else
        {
            
            if ([self.saveItemStr isEqualToString:@"item"])
            {
                ListDetailViewController *listDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"ListDetailViewController"];
                listDetail.categoryIDStr = [[finalCategoryArray objectAtIndex:indexPath.row] valueForKey:@"Categoryid"];
                listDetail.titleStr = [[finalCategoryArray objectAtIndex:indexPath.row] valueForKey:@"Categoryname"];
                listDetail.isfromSaveItem = YES;
                [self.navigationController pushViewController:listDetail animated:YES];
            } else
            {
                NSString *folderName = [[finalCategoryArray objectAtIndex:indexPath.row] valueForKey:@"Categoryname"];
                NSString * folderID = [[finalCategoryArray objectAtIndex:indexPath.row] valueForKey:@"Categoryid"];
                NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      folderName, @"Categoryname",
                                      folderID,@"Categoryid",
                                      nil];
                if ([self.saveItemStr isEqualToString:@"List"])
                {
                    //kunal
                    //NSLog(@"saved dict -%@",dict);
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectFolderSaved" object:self userInfo:dict];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectFolder" object:self userInfo:dict];
                }
                
                
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
            
            
        }
    }

    
}

-(void)CreateFolder
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"New Folder"
                                                                              message: @"Give your new folder a name"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Name your folder";
        textField.tag = 30;
        textField.delegate = self;
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
            [self showFolderAlert];
        } else {
            
            [self createCategory:namefield.text];
        }
        
        //        UITextField * passwordfiled = textfields[1];
        //        NSLog(@"%@:%@",namefield.text,passwordfiled.text);
        
    }]];
    
    [alertController.view setTintColor:[UIColor redColor]];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)showFolderAlert
{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Trovy!"
                                                                  message:@"Please Enter your folder name!"
                                                           preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                {
                                }];
    
    [alert addAction:yesButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)cancelBtnAction:(id)sender
{
     [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelFolderNotification" object:self userInfo:nil];
}
@end
