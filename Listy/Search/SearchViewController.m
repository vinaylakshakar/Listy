//
//  SearchViewController.m
//  Listy
//
//  Created by Silstone on 20/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "SearchViewController.h"
#import "Listy.pch"

@interface SearchViewController ()
{
    NSMutableArray *categoryArray,*searchKeywordArray;
}

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.searchView.layer.cornerRadius = 5;
    categoryArray = [[NSMutableArray alloc]initWithObjects:@"Movies",@"Music",@"Tv",@"Food",@"Travel",@"Art",@"Music",@"Tv", nil];
    // Do any additional setup after loading the view.
    if ([USERDEFAULTS valueForKey:kuserSearchKeyword]) {
         searchKeywordArray = [[USERDEFAULTS valueForKey:kuserSearchKeyword] mutableCopy];
    } else {
         searchKeywordArray= [[NSMutableArray alloc]init];
    }
    [self.searchField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    [textField resignFirstResponder];
    [self popToSearch:textField.text];
    return YES;
}

-(void)popToSearch:(NSString*)searchTxt
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSString *trimmedKeyword = [searchTxt stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [dict setObject:trimmedKeyword forKey:@"searchText"];
    
    if (searchTxt.length>0)
    {
        if (![searchKeywordArray containsObject:dict])
        {
            [searchKeywordArray addObject:dict];
            [USERDEFAULTS setObject:searchKeywordArray forKey:kuserSearchKeyword];
        }
       
    }
    
    
    if (self.isFromDiscover)
    {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"DiscoverList" object:self userInfo:dict];
        [self dismissViewControllerAnimated:YES completion:nil];

    }
    else if (self.isCategoryFeatured)
    {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"searchCategory" object:self userInfo:dict];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"categoryDetail" object:self userInfo:dict];
        [self dismissViewControllerAnimated:YES completion:nil];
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

#pragma tableview methods--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (searchKeywordArray.count>0) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section==0) {
        return searchKeywordArray.count;
    }
    return categoryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    
    if (cell == nil) {

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    

    if (indexPath.section>0) {
        cell.textLabel.text = [categoryArray objectAtIndex:indexPath.row];
    }else
    {
        cell.textLabel.text = [[searchKeywordArray objectAtIndex:indexPath.row] valueForKey:@"searchText"];
    }
    //[UIColor colorWithRed:0.71 green:0.72 blue:0.78 alpha:1.0];
    cell.textLabel.textColor = [UIColor colorWithRed:0.71 green:0.72 blue:0.78 alpha:1.0];
    cell.textLabel.font = [UIFont fontWithName:@"SFProText-Regular" size:21];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0f;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 1. The view for the header
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
    
    // 2. Set a custom background color and a border
    headerView.backgroundColor = [UIColor whiteColor];
//    headerView.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1.0].CGColor;
//    headerView.layer.borderWidth = 1.0;
    
    // 3. Add a label
    UILabel* headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(15, 0, tableView.frame.size.width - 5, 44);
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor colorWithRed:0.02 green:0.07 blue:0.26 alpha:1.0];
    headerLabel.font = [UIFont fontWithName:@"SFProDisplay-Bold" size:20];
    
    if (section==0) {
         headerLabel.text = @"Recent Searches";
        UIButton *closeBtn  =[[UIButton alloc]initWithFrame:CGRectMake(334, 5, 30, 30)];
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"clear"] forState:UIControlStateSelected];
        [closeBtn addTarget:self action:@selector(clearKeywords:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:closeBtn];
    } else {
         headerLabel.text = @"Categories";
    }
   
    headerLabel.textAlignment = NSTextAlignmentLeft;
    
    // 4. Add the label to the header view
    [headerView addSubview:headerLabel];
    
    
    
    // 5. Finally return
    return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [self popToSearch:[searchKeywordArray[indexPath.row] valueForKey:@"searchText"]];
}

-(void)clearKeywords:(UIButton*)button
{
    //NSLog(@"clear clicked");
    if (![button isSelected]) {
        [button setSelected:YES];
        button.frame = CGRectMake(self.view.frame.size.width-65, 5, 55, 30);
    } else {
        [searchKeywordArray removeAllObjects];
        [USERDEFAULTS setObject:searchKeywordArray forKey:kuserSearchKeyword];
        [self popToSearch:@""];
    }
    
}

- (IBAction)backBtnAction:(id)sender
{
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)cancelSearch:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
