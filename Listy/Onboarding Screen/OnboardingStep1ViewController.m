//
//  OnboardingStep1ViewController.m
//  Listy
//
//  Created by Silstone on 07/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "OnboardingStep1ViewController.h"
#import "OnboardingStep3ViewController.h"
#import "Listy.pch"

@interface OnboardingStep1ViewController ()
{
     NSArray *arrayOfCateGory,*tags;
    NSMutableArray *selectedCateGory;
    NSInteger offset;
}

@end

@implementation OnboardingStep1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    offset = 0;
    selectedCateGory = [[NSMutableArray alloc]init];
//    arrayOfCateGory = [[NSMutableArray alloc]initWithObjects:@"Music",@"Food",@"Sport",@"Travel",@"Art",@"Books",@"To do's",@"Fashion",@"Film & TV",@"News",@"Movies",@"History",@"Bucket List",@"DIY", nil];
  //  [self setTagView];
    [self getAllCategories];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
    
}

-(void)setTagView
{
//    tags = @[@"Music",@"Food",@"Sport",@"Travel",@"Art",@"Books",@"To do's",@"Fashion",@"Film & TV",@"News",@"Movies",@"History",@"Bucket List",@"DIY",@"Music",@"Food",@"Sport",@"Travel",@"Art",@"Books",@"To do's",@"Fashion",@"Film & TV",@"News",@"Movies",@"History",@"Bucket List",@"DIY",@"Music",@"Food",@"Sport",@"Travel",@"Art",@"Books",@"To do's",@"Fashion",@"Film & TV",@"News",@"Movies",@"History",@"Bucket List",@"DIY",@"Music",@"Food",@"Sport",@"Travel",@"Art",@"Books",@"To do's",@"Fashion",@"Film & TV",@"News",@"Movies",@"History",@"Bucket List",@"DIY"];

    // [_tagView removeAllTags];
    _tagView.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
    
    TTGTextTagConfig *config = [TTGTextTagConfig new];
    //config.tagTextFont = [UIFont fontWithName:@"SFProText-Regular" size:16];
    
   // config.tagTextColor = DARKBULE_COLOR;
     config.tagTextColor = [UIColor whiteColor];
    config.tagSelectedTextColor = RED_COLOR;
    config.tagExtraSpace = CGSizeMake(25, 25);
   // _tagView.horizontalSpacing =10;
    _tagView.verticalSpacing =15;
    
    NSUInteger location = 0;
    NSUInteger length = tags.count;
    config.tagBackgroundColor = PURPLE_COLOR_Category;
    config.tagShadowOpacity = 0.0;
    config.tagBorderColor = [UIColor clearColor];
    config.tagSelectedBackgroundColor = [UIColor whiteColor];
    config.tagTextFont = [UIFont fontWithName:@"SFProText-Regular" size:16];
    config.extraData = @{@"key": @"1"};
    [_tagView addTags:[tags subarrayWithRange:NSMakeRange(location, length)] withConfig:[config copy]];
    
    [_tagView setShowsHorizontalScrollIndicator:NO];
    [_tagView setShowsVerticalScrollIndicator:NO];
    
    _tagView.delegate = self;
    
}

- (IBAction)loadmoreCategories:(id)sender
{
    [self getAllCategories];
}

- (IBAction)nextBtnAction:(id)sender
{
    if ([self returnJsonArray].count<5)
    {
        [Utility showAlertMessage:nil message:@"Please select minimum 5 categories"];
    } else {
        
       // NSMutableArray *categoryArray = [Utility removeNullFromDictionary:[self returnJsonArray]];
        [USERDEFAULTS setObject:[self returnJsonArray] forKey:kselectCategoryArray];
        [USERDEFAULTS synchronize];
//        OnboardingStep2ViewController *step2 =[self.storyboard instantiateViewControllerWithIdentifier:@"OnboardingStep2ViewController"];
//        [self.navigationController pushViewController:step2 animated:YES];
        //vinay here-
        OnboardingStep3ViewController *step3 =[self.storyboard instantiateViewControllerWithIdentifier:@"OnboardingStep3ViewController"];
        [self.navigationController pushViewController:step3 animated:YES];
    }
    

}

-(NSMutableArray*)returnJsonArray
{
    NSMutableArray *jsonArray = [[NSMutableArray alloc]init];
    
    //NSLog(@"%@",_tagView.allSelectedTags);
    
    for (NSMutableDictionary *categoryDict in arrayOfCateGory)
    {
        if ([_tagView.allSelectedTags  containsObject:[categoryDict valueForKey:@"Keyword"]])
        {
            [jsonArray addObject:[Utility removeNullFromDictionary:categoryDict]];
        }
    }
    
    return jsonArray;
}

-(void)getAllCategories
{
    NSString *offsetStr = [NSString stringWithFormat:@"%ld",(long)offset];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:offsetStr forKey:@"offset"];
    
    //NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]Categorieslist:^(id object)
     {
         
         //NSLog(@"%@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];
             offset = offset+1;
             arrayOfCateGory = [[object valueForKey:@"KeywordList"] mutableCopy];
             tags = [[object valueForKey:@"KeywordList"] valueForKey:@"Keyword"];
             [self setTagView];
            
             
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - CollectionView Dalagates and Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:     (NSInteger)section{
    return arrayOfCateGory.count;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CategoryViewCell *cell = (CategoryViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"KeywordsCell" forIndexPath:indexPath];
    
    for (UIButton *lbl in cell.contentView.subviews)
    {
        if ([lbl isKindOfClass:[UIButton class]])
        {
            [lbl removeFromSuperview];
        }
    }
    
    
    
    UIButton* btntitle = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [btntitle setFrame:CGRectMake(0, 0, cell.bounds.size.width-10, 42)];
    
    [btntitle.titleLabel setFont:[UIFont fontWithName:@"SFProText-Regular" size:15]];
    
    [btntitle setTitle:(NSString *)[arrayOfCateGory objectAtIndex:indexPath.item] forState:UIControlStateNormal] ;
    
    if ([selectedCateGory containsObject:[arrayOfCateGory objectAtIndex:indexPath.row]])
    {
        btntitle.backgroundColor = [UIColor whiteColor];
        
        [btntitle setTitleColor:RED_COLOR forState:UIControlStateNormal];
    } else {
        btntitle.backgroundColor = PURPLE_COLOR_Category;
        
        [btntitle setTitleColor:DARKBULE_COLOR forState:UIControlStateNormal];
    }
    

    
    btntitle.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    btntitle.tag = indexPath.row;
    
    btntitle.layer.cornerRadius = btntitle.frame.size.height/2; // this value vary as per your desire
    btntitle.clipsToBounds = YES;
    
    [btntitle addTarget:self action:@selector(buttontapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btntitle];
    
    // [cell layoutIfNeeded];
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(IBAction)buttontapped:(id)sender
{
    if(![selectedCateGory containsObject:[arrayOfCateGory objectAtIndex:[sender tag]]])
    {
       
        [selectedCateGory addObject:[arrayOfCateGory objectAtIndex:((UIButton *)sender).tag]];
      
    }
    else
    {
        [selectedCateGory removeObject:[arrayOfCateGory objectAtIndex:((UIButton *)sender).tag]];
    }
    
      [self.categoryCollection reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CGSize size = CGSizeMake([(NSString *)[arrayOfCateGory objectAtIndex:indexPath.item] length]*20, CGFLOAT_MAX);
    
    size.height= 60;
    
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}


@end
