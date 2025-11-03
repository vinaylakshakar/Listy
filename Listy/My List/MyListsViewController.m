//
//  MyListsViewController.m
//  Listy
//
//  Created by Silstone on 14/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "MyListsViewController.h"
#import "Listy.pch"

@interface MyListsViewController ()
{
    NSMutableArray *listNameArray, *listImageArray;
    NSArray *categoryArray;
    NSString *draftListNumber, *deletedListNumber;
    NSMutableArray *finalCategoryArray;
    NSString *searchTextString;
}

@end

@implementation MyListsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    listNameArray = [[NSMutableArray alloc]initWithObjects:@"Music",@"Film & TV",@"Food",@"Sport",@"DIY",@"Travel",@"To do’s",@"Bucket list",@"Fashion", nil];
//    listImageArray = [[NSMutableArray alloc]initWithObjects:@"image_22",@"image_23",@"image_24",@"image_25",@"image_26",@"image_27",@"image_28",@"image_29",@"image_30", nil];
    self.searchView.layer.cornerRadius = 5;
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyListViewCell" bundle:nil] forCellWithReuseIdentifier:@"MyListViewCell"];
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    UIColor *borderColor = [UIColor colorWithRed:0.71 green:0.72 blue:0.78 alpha:1.0];
    
    self.folderNameField.layer.borderColor = borderColor.CGColor;
    self.folderNameField.layer.borderWidth = 1.0;
    self.folderView.layer.cornerRadius = 14.0;
    
    [self.searchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//    [self.tabBarController setSelectedIndex:1];
//    DiscoverViewController* vc = self.tabBarController.viewControllers[1];
//    [self.tabBarController setSelectedViewController:vc];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
    [self UserCategories];
}


-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    [textField resignFirstResponder];
    return YES;
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

#pragma mark - Api methods-

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
             

//             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Trovy!"
//                                                                           message:@"Folder Created Successsfully!"
//                                                                    preferredStyle:UIAlertControllerStyleAlert];
//
//             UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
//                                                                 style:UIAlertActionStyleDefault
//                                                               handler:^(UIAlertAction * action)
//                                         {
                                             [self UserCategories];
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

-(void)UserCategories
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"userid"];
    [dict setObject:@"1" forKey:@"offset"];
    
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]UserCategories:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             draftListNumber =[NSString stringWithFormat:@"%@ Lists",[object valueForKey:@"NoofDraft"]];
             deletedListNumber =[NSString stringWithFormat:@"%@ Lists",[object valueForKey:@"NooFDeleted"]];
             
            categoryArray = [[object valueForKey:@"SelectedCategory"] mutableCopy];
            //finalCategoryArray = [[NSMutableArray alloc]initWithArray:categoryArray];
             finalCategoryArray = [[object valueForKey:@"UserCategory"] mutableCopy];
             //vinay here-
             //[finalCategoryArray addObjectsFromArray:categoryArray];
             categoryArray = finalCategoryArray;
             //vinay here-
//              finalCategoryArray = [[NSMutableArray alloc]init];
//
//             for (NSMutableDictionary *dict in categoryArray)
//             {
//                 if ([[dict valueForKey:@"no_of_lists"] integerValue]>0) {
//                     [finalCategoryArray addObject:dict];
//                 }
//             }
//
             //NSLog(@"%@",categoryArray);
             [self.collectionView reloadData];
             
         } else
         {
            // [Utility showAlertMessage:nil message:[object valueForKey:@"Message"]];
             [finalCategoryArray removeAllObjects];
             [self.collectionView reloadData];
             
         }
         
         [kAppDelegate hideProgressHUD];
         
         
         
     }
                                               onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return finalCategoryArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MyListViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyListViewCell" forIndexPath:indexPath];
    
    cell.listNameLable.text = [[finalCategoryArray objectAtIndex:indexPath.row] valueForKey:@"Categoryname"];
    cell.listNumberlbl.text = [NSString stringWithFormat:@"%@ Lists",[[finalCategoryArray objectAtIndex:indexPath.row] valueForKey:@"no_of_lists"]];
    
//    cell.dotBtn.hidden = false;
    cell.listImage.layer.cornerRadius = 4;
    cell.listImage.layer.masksToBounds = YES;
    [cell.listImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[finalCategoryArray objectAtIndex:indexPath.row] valueForKey:@"CategoryImage"]]] placeholderImage:[UIImage imageNamed:@"listy_folder"] options:0 progress:nil completed:nil];
  //  cell.listImage.image = [UIImage imageNamed:[listImageArray objectAtIndex:indexPath.row]];
    
    
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        
        UILabel *draftNumber = [footerview viewWithTag:11];
        UILabel *deletedNumber = [footerview viewWithTag:12];
        draftNumber.text = draftListNumber;
        deletedNumber.text = deletedListNumber;
        
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

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 5, 5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{


    return 19.06;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath

{
    ListDetailViewController *listDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"ListDetailViewController"];
    listDetail.categoryIDStr = [[finalCategoryArray objectAtIndex:indexPath.row] valueForKey:@"Categoryid"];
    listDetail.titleStr = [[finalCategoryArray objectAtIndex:indexPath.row] valueForKey:@"Categoryname"];
    [self.navigationController pushViewController:listDetail animated:YES];
    
}

- (IBAction)deletedListAction:(id)sender
{
    
    DeletedListsViewController *deleted = [self.storyboard instantiateViewControllerWithIdentifier:@"DeletedListsViewController"];
    [self.navigationController pushViewController:deleted animated:YES];
    
}
- (IBAction)createFolderAction:(id)sender
{
//    [self.effectView setHidden:NO];
//    [self.folderView setHidden:NO];
    
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

- (IBAction)Cancel:(id)sender
{
    [self.view endEditing:YES];
    [self.effectView setHidden:YES];
    [self.folderView setHidden:YES];
}

- (IBAction)ok:(id)sender
{
    [self.view endEditing:YES];
    [self.effectView setHidden:YES];
    [self.folderView setHidden:YES];
}

- (IBAction)searchBtnAction:(id)sender
{
    SearchViewController *search =[self.storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    [self.navigationController pushViewController:search animated:YES];
}

- (IBAction)draftlistsAction:(id)sender
{
    ListDetailViewController *listDetail = [self.storyboard instantiateViewControllerWithIdentifier:@"ListDetailViewController"];
    listDetail.titleStr = @"Draft Lists";
    listDetail.isfromdraft= YES;
    [self.navigationController pushViewController:listDetail animated:YES];
}
@end
