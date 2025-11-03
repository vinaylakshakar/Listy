//
//  TopListViewController.m
//  Listy
//
//  Created by Silstone on 18/01/19.
//  Copyright © 2019 Silstone. All rights reserved.
//

#import "TopListViewController.h"
#import "Listy.pch"

@interface TopListViewController ()
{
    NSMutableArray *featuredListArray;
    NSString *searchText;
}

@end

@implementation TopListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.listCollection registerNib:[UINib nibWithNibName:@"CategoryCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CategoryCollectionCell"];
    self.listCollection.backgroundColor = [UIColor clearColor];
    [self.searchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    if (self.isRelatedList)
    {
        self.titleLable.text =@"Related List";
        [self UserlistItem:self.relatedDict];
    }else
    {
       featuredListArray = self.topListArray;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark-Api method
-(void)UserlistItem:(NSMutableDictionary*)dict
{
    [kAppDelegate showProgressHUD];
    
    [dict setObject:@"1" forKey:@"offset"];
    
    [[NetworkEngine sharedNetworkEngine]UserlistItem:^(id object)
     {
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             
             featuredListArray = [object valueForKey:@"ListsWithKeywords"];
             self.topListArray = featuredListArray;
             [self.listCollection reloadData];
    
             
         } else
         {
             // [Utility showAlertMessage:nil message:[object valueForKey:@"Message"]];
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

#pragma mark - Search Methods

-(void)textFieldDidChange:(UITextField*)textField
{
    searchText = textField.text;
    [self updateSearchArray];
}
//update seach method where the textfield acts as seach bar
-(void)updateSearchArray
{
    if (searchText.length != 0) {
        featuredListArray = [NSMutableArray array];
        for ( NSDictionary* item in self.topListArray ) {
            if ([[[item objectForKey:@"ListName"] lowercaseString] rangeOfString:[searchText lowercaseString]].location != NSNotFound||[[[item objectForKey:@"listdescription"] lowercaseString] rangeOfString:[searchText lowercaseString]].location != NSNotFound)
            {
                [featuredListArray addObject:item];
            }
        }
    } else {
        featuredListArray = [[NSMutableArray alloc]initWithArray:self.topListArray];
    }
    
    [self.listCollection reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return featuredListArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CategoryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCollectionCell" forIndexPath:indexPath];
    
    cell.activityImage.layer.cornerRadius = 4;
    cell.activityImage.layer.masksToBounds = YES;
    cell.overlayImage.layer.cornerRadius = 4;
    cell.overlayImage.clipsToBounds = YES;
    //cell.activityImage.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
    
    NSMutableDictionary *itemDict = [featuredListArray objectAtIndex:indexPath.row];
//    NSString *urlStr;
//    if (![itemDict valueForKey:@"id"])
//    {
//        urlStr = [NSString stringWithFormat:kBaseURL@"CreateThumbnailURL?listid=%@&listitemid=%d&url=%@&width=%@&height=0",[itemDict valueForKey:@"listid"],0,[itemDict valueForKey:@"list_image"],kCover_width];
//    }else
//    {
//        urlStr = [NSString stringWithFormat:kBaseURL@"CreateThumbnailURL?listid=%@&listitemid=%d&url=%@&width=%@&height=0",[itemDict valueForKey:@"id"],0,[itemDict valueForKey:@"list_image"],kCover_width];
//    }
    
    
    NSURL *customUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[itemDict valueForKey:@"list_image"]]];
    
    [cell.activityImage sd_setImageWithURL:customUrl placeholderImage:[UIImage imageNamed:@"profile_background"] options:0 progress:nil completed:nil];
    cell.titleLable.text = [[featuredListArray objectAtIndex:indexPath.row] valueForKey:@"ListName"];
    CGSize  textSize = {122, 36};
    
    CGSize size = [[NSString stringWithFormat:@"%@", cell.titleLable.text]
                   sizeWithFont:[cell.titleLable font]
                   constrainedToSize:textSize
                   lineBreakMode:NSLineBreakByWordWrapping];
    cell.titleHeightConstant.constant = size.height+5;
    
    if (IS_IPHONE_5) {
        cell.imageHeightConstant.constant = 125;
    }
    
    
    if (self.isRelatedList)
    {
        cell.percentageLable.text = [NSString stringWithFormat:@"%@%%",[[featuredListArray objectAtIndex:indexPath.row] valueForKey:@"PercentageofMatches"]];
         cell.likeLable.text = [NSString stringWithFormat:@"%@",[[featuredListArray objectAtIndex:indexPath.row] valueForKey:@"NoOflikes"]];
    } else {
        cell.percentageLable.text = [NSString stringWithFormat:@"%@%%",[[featuredListArray objectAtIndex:indexPath.row] valueForKey:@"RecommendedPercentage"]];
         cell.likeLable.text = [[featuredListArray objectAtIndex:indexPath.row] valueForKey:@"LikeCount"];
    }
    
    cell.dotBtn.tag = indexPath.row;
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FeaturedListFirstViewController *featureList = [self.storyboard instantiateViewControllerWithIdentifier:@"FeaturedListFirstViewController"];
    featureList.listDictinfo = [featuredListArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:featureList animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(IS_IPHONE_5)
    {
        NSLog(@"i am an iPhone 5!");
        return CGSizeMake(134, 164);
    }
    
    return CGSizeMake(159, 189);
}

- (IBAction)backBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
