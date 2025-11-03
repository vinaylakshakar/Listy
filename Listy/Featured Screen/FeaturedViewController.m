//
//  FeaturedViewController.m
//  Listy
//
//  Created by Silstone on 13/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "FeaturedViewController.h"
#import "Listy.pch"

@interface FeaturedViewController ()
{
    
    NSMutableArray *imageArray,*iconImageArray,*featuredListArray;
    NSString *searchText;
    UIActivityIndicatorView *spinner;
    int offsetLimit;
}

@end

@implementation FeaturedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    offsetLimit =0;
    searchText =@"";
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner stopAnimating];
    spinner.hidesWhenStopped = YES;
    spinner.frame = CGRectMake(0, 0, 320, 44);
    self.featuredTable.tableFooterView = spinner;
    self.searchView.layer.cornerRadius = 5;
    imageArray = [[NSMutableArray alloc]initWithObjects:@"rs-225012-The_Beach_2000_15_",@"nicolas-winding-refn-drive",@"rs-225012-The_Beach_2000_15_",@"nicolas-winding-refn-drive", nil];
    iconImageArray = [[NSMutableArray alloc]initWithObjects:@"netflix_large",@"odeon_large",@"netflix_large",@"odeon_large", nil];
    featuredListArray = [[NSMutableArray alloc]initWithArray:self.featuredArray];
    [self.featuredTable reloadData];
    //[self discover_list];
    
    if (self.isfromUserProfile)
    {
        [self.searchBtn setHidden:YES];
        [self.searchField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    } else
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(searchCategory:)
                                                     name:@"searchCategory"
                                                   object:nil];
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

- (void)searchCategory:(NSNotification *)notification
{
    searchText = [notification.userInfo valueForKey:@"searchText"];
     offsetLimit=0;
    [self discover_list:searchText];
    
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
    searchText = textField.text;
    [self updateSearchArray];
}
//update seach method where the textfield acts as seach bar
-(void)updateSearchArray
{
    if (searchText.length != 0) {
        featuredListArray = [NSMutableArray array];
        for ( NSDictionary* item in self.featuredArray ) {
            if ([[[item objectForKey:@"ListName"] lowercaseString] rangeOfString:[searchText lowercaseString]].location != NSNotFound||[[[item objectForKey:@"listdescription"] lowercaseString] rangeOfString:[searchText lowercaseString]].location != NSNotFound)
            {
                [featuredListArray addObject:item];
            }
        }
    } else {
        featuredListArray = [[NSMutableArray alloc]initWithArray:self.featuredArray];
    }
    
    [self.featuredTable reloadData];
}

#pragma mark-Api methods

-(void)discover_list:(NSString*)searchText
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"userid"];
    //[dict setObject:@"1" forKey:@"userid"];
    [dict setObject:@"0" forKey:@"categoryid"];
    if (offsetLimit==0) {
        [featuredListArray removeAllObjects];
        [kAppDelegate showProgressHUD];
    }
    NSString *offsetStr = [NSString stringWithFormat:@"%d",offsetLimit];
    [dict setObject:offsetStr forKey:@"offset"];
    [dict setObject:searchText forKey:@"searchtext"];
    
    //NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]discover_list:^(id object)
     {
         
         //NSLog(@"%@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
             
         {
             
             if (offsetLimit==0)
             {
                 featuredListArray = [[object valueForKey:@"FeaturedList"] mutableCopy];
             }else
             {
                 [featuredListArray addObjectsFromArray:[object valueForKey:@"FeaturedList"]];
             }
            
             //NSLog(@"featuredListArray count %ld",(long)featuredListArray.count);
             
            [self.featuredTable reloadData];
             
         } else
         {
             [Utility showAlertMessage:nil message:[object valueForKey:@"Message"]];
         }
         
         if (offsetLimit==0) {
             [kAppDelegate hideProgressHUD];
         }else
         {
             [spinner stopAnimating];
         }
         
         
         
     }
                                              onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
}

#pragma tableview methods--

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return featuredListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    static NSString *propertyIdentifier = @"FeaturedDetailCell";
    
    FeaturedDetailCell *cell = (FeaturedDetailCell *)[tableView dequeueReusableCellWithIdentifier:propertyIdentifier];
    
    
    if (cell == nil)
    {
        
        NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"FeaturedDetailCell" owner:self options:nil];
        cell = [nib1 objectAtIndex:0];
    }
    
    //cell.backImage.image =[UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
    NSMutableDictionary *itemDict = [featuredListArray objectAtIndex:indexPath.row];
    //NSString *urlStr = [NSString stringWithFormat:kBaseURL@"CreateThumbnailURL?listid=%@&listitemid=%d&url=%@&width=%@&height=0",[itemDict valueForKey:@"id"],0,[itemDict valueForKey:@"list_image"],klistdetail_width];
    
    NSURL *customUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[itemDict valueForKey:@"list_image"]]];
    
    [cell.backImage sd_setImageWithURL:customUrl placeholderImage:[UIImage imageNamed:@"profile_background"] options:0 progress:nil completed:nil];
    cell.backImage.layer.cornerRadius = 10;
    cell.backImage.layer.masksToBounds = YES;
    cell.gradientImage.layer.cornerRadius = 10;
    cell.gradientImage.layer.masksToBounds = YES;
    cell.iconImage.image = [UIImage imageNamed:@"listy_round_icon"];
    cell.listName.text = [[featuredListArray objectAtIndex:indexPath.row] valueForKey:@"ListName"];
    if (self.isfromUserProfile) {
        cell.likeCount.text = [[featuredListArray objectAtIndex:indexPath.row] valueForKey:@"LikeCount"];
    } else {
        cell.likeCount.text = [[featuredListArray objectAtIndex:indexPath.row] valueForKey:@"likecount"];
    }
    
    cell.categoryName.text = [[featuredListArray objectAtIndex:indexPath.row] valueForKey:@"Categoryname"];
    cell.listDescription.text = [[featuredListArray objectAtIndex:indexPath.row] valueForKey:@"listdescription"];
    cell.percentage.text = [NSString stringWithFormat:@"%@%%",[[featuredListArray objectAtIndex:indexPath.row] valueForKey:@"recPercentage"]];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeaturedListFirstViewController *featureList = [self.storyboard instantiateViewControllerWithIdentifier:@"FeaturedListFirstViewController"];
    featureList.listDictinfo = [featuredListArray objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:featureList animated:YES];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionReveal;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController pushViewController:featureList animated:NO];
    
}


- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView
                  willDecelerate:(BOOL)decelerate{
    
    if (!self.isfromUserProfile)
    {
        CGPoint offset = aScrollView.contentOffset;
        CGRect bounds = aScrollView.bounds;
        CGSize size = aScrollView.contentSize;
        UIEdgeInsets inset = aScrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        
        float reload_distance = 50;
        if(y > h + reload_distance) {
            //NSLog(@"load more data");
            [spinner setHidden:NO];
            [spinner startAnimating];
            
            offsetLimit =offsetLimit+1;
            
            [self discover_list:searchText];
            
            
            
        }

    }
}



- (IBAction)backBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)searchBtnAction:(id)sender
{
    SearchViewController *search =[self.storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    search.isCategoryFeatured = YES;
   [self presentViewController:search animated:YES completion:nil];
}
@end
