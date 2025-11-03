//
//  WikiDescriptionViewController.m
//  Listy
//
//  Created by Silstone on 22/11/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "WikiDescriptionViewController.h"
#import "Listy.pch"

@interface WikiDescriptionViewController ()
{
    NSMutableArray *wikiSearchArray,*searchWikiDescArray;
}

@end

@implementation WikiDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.addWikiTextBtn.layer.cornerRadius = 4;
    self.addWikiTextBtn.layer.masksToBounds = YES;
    [self getWikiDesc];
    //[self getWikiSearch];
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

-(void)getWikiSearch
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"opensearch" forKey:@"action"];
    [dict setObject:@"thor" forKey:@"search"];
    [dict setObject:@"10" forKey:@"limit"];
    [dict setObject:@"0" forKey:@"namespace"];
    [dict setObject:@"json" forKey:@"format"];
    
    
    [[NetworkEngine sharedNetworkEngine]getWikiSearch:^(id object)
     {
         
//         self.wikiTextView.text = [[[[object valueForKey:@"query"] valueForKey:@"pages"] objectAtIndex:0] valueForKey:@"extract"];
         
         wikiSearchArray = [[object objectAtIndex:1] mutableCopy];
         searchWikiDescArray = [[object objectAtIndex:2] mutableCopy];
         [self.wikisearchTable reloadData];
         
         [kAppDelegate hideProgressHUD];
         
         
         
     }
                                            onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
    
    
}


-(void)getWikiDesc
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"query" forKey:@"action"];
    [dict setObject:@"extracts" forKey:@"prop"];
    [dict setObject:self.titleStr forKey:@"titles"];
    [dict setObject:@"" forKey:@"exintro"];
    [dict setObject:@"2" forKey:@"exsentences"];
    [dict setObject:@"" forKey:@"explaintext"];
    [dict setObject:@"" forKey:@"redirects"];
    [dict setObject:@"2" forKey:@"formatversion"];
    [dict setObject:@"json" forKey:@"format"];
    
    
    [[NetworkEngine sharedNetworkEngine]getWikiDesc:^(id object)
     {

        self.wikiTextView.text = [[[[object valueForKey:@"query"] valueForKey:@"pages"] objectAtIndex:0] valueForKey:@"extract"];
             

         
         [kAppDelegate hideProgressHUD];
         
         
         
     }
                                             onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return wikiSearchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];

        static NSString *simpleTableIdentifier = @"SimpleTableItem";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        cell.textLabel.text = wikiSearchArray[indexPath.row];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont fontWithName:@"SFProText-Regular" size:15];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.textColor =  [UIColor blackColor];
        cell.backgroundColor = [UIColor whiteColor];
        
        return cell;
    }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchView setHidden:YES];
    self.wikiTextView.text = [searchWikiDescArray objectAtIndex:indexPath.row];
}

- (IBAction)cancelBtnAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)addDescrptionAction:(id)sender
{
    [self.wikiDescArray addObject:self.wikiTextView.text];
    [self dismissViewControllerAnimated:YES completion:nil];

}

@end
