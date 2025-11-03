//
//  ListItemDetailViewController.m
//  Listy
//
//  Created by Silstone on 29/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "ListItemDetailViewController.h"
#import "Listy.pch"

@interface ListItemDetailViewController ()
{
    NSMutableArray *itemNameArray,*relatedListArray;
    NSMutableDictionary *itemDict,*relatedDict;
    NSString *ownerID;
    NSDictionary* notificationDict;
}

@end

@implementation ListItemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.TableHeight.constant =0;
    self.linkView.constant=0;
//     self.descriptionHeight.constant = 350;
//    if (self.descriptionHeight.constant>350) {
//        self.descriptionHeight.constant = 350;
//    }
    
//       self.descriptionViewHeight.constant = 350;
    
    
   // imageArray = [[NSMutableArray alloc]initWithObjects:@"dummy_image_square_1",@"dummy_image_square_2",@"dummy_image_square_3",@"dummy_image_square_4",@"dummy_image_square_5", nil];
    itemNameArray = [[NSMutableArray alloc]initWithObjects:@"Watch on Netflix",@"More on IMDB",@"Buy on Amazon",@"Buy on ebay",@"Listen on Spotify",@"More on Wikipedia", nil];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CategoryCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CategoryCollectionCell"];
    self.collectionView.backgroundColor = [UIColor clearColor];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveListItemNotification:)
                                                 name:@"saveListItemNotification"
                                               object:nil];
    
    //NSLog(@"%@",self.itemArray);
    ownerID = [NSString stringWithFormat:@"%@",[[self.itemArray objectAtIndex:self.itemIndex] valueForKey:@"Owernerid"]];
    self.descriptionViewHeight.constant =0;
//    if (![ownerID isEqualToString:[[USERDEFAULTS valueForKey:kuserID] stringValue]])
//    {
//        [self.savelistItemBtn setHidden:YES];
//    }
    //self.linkView.constant =0;
   // self.linkTextView.text = @"www.listy.com";

    [self cleardata];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)saveListItemNotification:(NSNotification *)notification
{
    NSDictionary *ItemDict = [notification userInfo];
    //NSLog(@"ListItemSaved %@",ItemDict);
    [self ListItemSaved:[ItemDict valueForKey:@"listID"]];
}

-(void)cleardata
{
    self.listNameLable.text = @"";
    self.itemNamelbl.text = @"";
    self.itemDescription.text =@"";
    self.numberOfMached.text =@"";
    self.numberOfLikes.text =@"";
    self.numberOfFollowers.text = @"";
    self.numberOfComments.text = @"";
    self.descriptionView.text=@"";
    self.itemImage.layer.masksToBounds = YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    //NSLog(@"List item detail");
    [self UserlistItem];
}

- (IBAction)swipeRight:(id)sender {
    
    if (self.itemIndex==0) {
        [self.backwordBtn setHidden:YES];
    }else
    {
        [self.backwordBtn setHidden:NO];
        [self.forwordBtn setHidden:NO];
        self.itemIndex = self.itemIndex-1;
        [self UserlistItem];
    }
    
}

- (IBAction)swipeLeft:(id)sender {
    

    if (self.itemArray.count==self.itemIndex+1) {
        [self.forwordBtn setHidden:YES];
    }else
    {
        [self.forwordBtn setHidden:NO];
        [self.backwordBtn setHidden:NO];
        self.itemIndex = self.itemIndex+1;
        [self UserlistItem];
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

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
       // NSLog(@"descriptionViewHeight.constant %f",self.descriptionView.contentSize.height);
    self.descriptionViewHeight.constant = newSize.height+65;
}

-(void)setItemLayout
{
    [self.itemDetailView setHidden:NO];
    
    ownerID = [NSString stringWithFormat:@"%@",[[self.itemArray objectAtIndex:self.itemIndex] valueForKey:@"Owernerid"]];
//    if (![ownerID isEqualToString:[[USERDEFAULTS valueForKey:kuserID] stringValue]])
//    {
//        [self.savelistItemBtn setHidden:YES];
//    }

    
    self.listNameLable.text = [itemDict valueForKey:@"ListName"];
    self.itemNamelbl.text = [NSString stringWithFormat:@"%ld. %@",self.itemIndex+1,[itemDict valueForKey:@"Itemtitle"]];
    self.itemDescription.text =[itemDict valueForKey:@"ItemDetaildescription"];
    self.numberOfMached.text =[itemDict valueForKey:@"NoOfmached"];
    self.numberOfLikes.text =[NSString stringWithFormat:@"%@",[itemDict valueForKey:@"NoOfItemLiked"]];
    self.numberOfFollowers.text = [NSString stringWithFormat:@"%@",[itemDict valueForKey:@"NoofFollowers"]];
    self.numberOfComments.text = [NSString stringWithFormat:@"%@",[itemDict valueForKey:@"NoNumberofComment"]];
    self.numberOfMached.text = [NSString stringWithFormat:@"%@",[itemDict valueForKey:@"PercentageofMatches"]];
    
//    NSString *urlStr = [NSString stringWithFormat:kBaseURL@"CreateThumbnailURL?listid=%d&listitemid=%@&url=%@&width=%@&height=0",0,[itemDict valueForKey:@"listitemId"],[itemDict valueForKey:@"Imageurl"],klistdetail_width];
    
    [self.itemImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[itemDict valueForKey:@"Imageurl"]]] placeholderImage:nil options:0 progress:nil completed:nil];
    self.forwordBtn.transform = CGAffineTransformMakeScale(-1, 1);
    
    //NSLog(@"%lu, %ld",(unsigned long)self.itemArray.count,(long)self.itemIndex);
    NSString *like = [itemDict valueForKey:@"islike"];
    if ([like isEqualToString:@"Yes"]) {
        [self.likeUnlikeBtn setSelected:YES];
    } else {
        [self.likeUnlikeBtn setSelected:NO];
    }
    
    if (self.itemArray.count==self.itemIndex+1) {
        [self.forwordBtn setHidden:YES];
    }
    if (self.itemIndex==0) {
        [self.backwordBtn setHidden:YES];
    }
    if (self.itemArray.count==1) {
        [self.forwordBtn setHidden:YES];
        [self.backwordBtn setHidden:YES];
    }
    
    self.descriptionView.text = [itemDict valueForKey:@"wikidescription"];
    if ([self.descriptionView.text isEqualToString:@""]&&relatedListArray.count>0) {
        self.descriptionViewHeight.constant=0;
    } else {
        [self textViewDidChange:self.descriptionView];
    }
    
    if ([[itemDict valueForKey:@"Url"] isEqualToString:@""])
    {
        self.linkView.constant =0;
    }
    else
    {
        [self.itemLinkView setHidden:NO];
        self.linkView.constant =78;
        self.linkTextView.text = [NSString stringWithFormat:@"%@",[itemDict valueForKey:@"Url"]];
    }
    
//    NSLog(@"descriptionViewHeight.constant %f",self.descriptionView.contentSize.height);
//    self.descriptionViewHeight.constant = self.descriptionView.contentSize.height;
     [self.collectionView reloadData];
    
    if (relatedListArray.count<1)
    {
        self.relatedListViewHeight.constant= 0;
        [self.relatedView setHidden:YES];
    }
    else {
         self.relatedListViewHeight.constant= 277;
        [self.relatedView setHidden:NO];
        [self.collectionView layoutIfNeeded];
    }
    
     [self.collectionView reloadData];
}

#pragma mark- Api methods

-(void)ListItemSaved:(NSString *)listid
{
    NSString * itemIdStr = [[[self.itemArray objectAtIndex:self.itemIndex] valueForKey:@"listitemId"] stringValue];
    NSString * owneridStr = [[self.itemArray objectAtIndex:self.itemIndex] valueForKey:@"userid"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"Userid"];
    [dict setObject:listid forKey:@"listid"];
    [dict setObject:itemIdStr forKey:@"listItemid"];
    [dict setObject:owneridStr forKey:@"ownerid"];
    
    
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


-(void)UserlistItem
{
    NSString * itemIdStr = [[[self.itemArray objectAtIndex:self.itemIndex] valueForKey:@"listitemId"] stringValue];
    ownerID = [NSString stringWithFormat:@"%@",[[self.itemArray objectAtIndex:self.itemIndex] valueForKey:@"Owernerid"]];
    
//    if (![ownerID isEqualToString:[[USERDEFAULTS valueForKey:kuserID] stringValue]])
//    {
//        [self.savelistItemBtn setHidden:YES];
//    }else
//    {
//        [self.savelistItemBtn setHidden:NO];
//    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    if (self.followerid)
    {
        [dict setObject:self.followerid forKey:@"userid"];
    } else
    {
        [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"userid"];
    }
    
    [dict setObject:ownerID forKey:@"ownerid"];
    [dict setObject:itemIdStr forKey:@"listIemid"];
    [dict setObject:@"0" forKey:@"offset"];
    
    NSLog(@"%@",dict);
    relatedDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
    
    [kAppDelegate showProgressHUD];
    
    [[NetworkEngine sharedNetworkEngine]UserlistItem:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             itemDict = [[object valueForKey:@"UserlistItem"] objectAtIndex:0];
             itemDict = [Utility removeNullFromDictionary:itemDict];
             relatedListArray = [object valueForKey:@"ListsWithKeywords"];
             [self setItemLayout];
             
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

-(void)ListItemaddlike
{
    NSString * itemIdStr = [[[self.itemArray objectAtIndex:self.itemIndex] valueForKey:@"listitemId"] stringValue];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"Userid"];
    [dict setObject:itemIdStr forKey:@"listItemid"];
    
    if (![self.likeUnlikeBtn isSelected]) {
        [dict setObject:@"Yes" forKey:@"islike"];
        [self.likeUnlikeBtn setSelected:YES];
    } else {
        [dict setObject:@"No" forKey:@"islike"];
        [self.likeUnlikeBtn setSelected:NO];
    }
    
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]ListItemaddlike:^(id object)
     {
         
         NSLog(@"%@",object);
         
         
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             [kAppDelegate hideProgressHUD];

            // NSString *like = [[object valueForKey:@"like"] valueForKey:@"islike"];
             NSString *NumberoflikedStr = [[[object valueForKey:@"like"] valueForKey:@"Numberofliked"] stringValue];
             [self.numberOfLikes setText:NumberoflikedStr];
             
//             if ([like isEqualToString:@"Yes"]) {
//                 [self.likeUnlikeBtn setSelected:YES];
//             } else {
//                  [self.likeUnlikeBtn setSelected:NO];
//             }
             
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

    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];

    static NSString *propertyIdentifier = @"ListItemViewCell";
    
    ListItemViewCell *cell = (ListItemViewCell *)[tableView dequeueReusableCellWithIdentifier:propertyIdentifier];
    
    
    if (cell == nil)
    {
        
        NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"ListItemViewCell" owner:self options:nil];
        cell = [nib1 objectAtIndex:0];
    }
    
    cell.itemName.text = [itemNameArray objectAtIndex:indexPath.row];
//    cell.listImageView.image =[UIImage imageNamed:[listImageArray objectAtIndex:indexPath.row]];
//    //    cell.iconImage.image = [UIImage imageNamed:[iconImageArray objectAtIndex:indexPath.row]];
    //
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}


#pragma collectionView methods--

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return relatedListArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CategoryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCollectionCell" forIndexPath:indexPath];
    
    cell.activityImage.layer.cornerRadius = 4;
    cell.activityImage.clipsToBounds = YES;
    cell.overlayImage.layer.cornerRadius = 4;
    cell.overlayImage.clipsToBounds = YES;
    //cell.activityImage.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
    UIImage *placeHolderImage = [UIImage imageNamed:@"List_background"];
    
    NSMutableDictionary *itemDict = [relatedListArray objectAtIndex:indexPath.row];
//    NSString *urlStr = [NSString stringWithFormat:kBaseURL@"CreateThumbnailURL?listid=%@&listitemid=%d&url=%@&width=%@&height=0",[itemDict valueForKey:@"listid"],0,[itemDict valueForKey:@"list_image"],kCover_width];
    
    NSURL *customUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[itemDict valueForKey:@"list_image"]]];
    
    [cell.activityImage sd_setImageWithURL:customUrl placeholderImage:placeHolderImage options:0 progress:nil completed:nil];
    cell.titleLable.text = [[relatedListArray objectAtIndex:indexPath.row] valueForKey:@"ListName"];
    cell.likeLable.text = [NSString stringWithFormat:@"%@",[[relatedListArray objectAtIndex:indexPath.row] valueForKey:@"NoOflikes"]];
    cell.percentageLable.text = [NSString stringWithFormat:@"%@%%",[[relatedListArray objectAtIndex:indexPath.row] valueForKey:@"PercentageofMatches"]];
    
    CGSize  textSize = {122, 36};
    
    CGSize size = [[NSString stringWithFormat:@"%@", cell.titleLable.text]
                   sizeWithFont:[cell.titleLable font]
                   constrainedToSize:textSize
                   lineBreakMode:NSLineBreakByWordWrapping];
    cell.titleHeightConstant.constant = size.height+5;
    
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FeaturedListFirstViewController *featureList = [self.storyboard instantiateViewControllerWithIdentifier:@"FeaturedListFirstViewController"];
    featureList.listDictinfo = [relatedListArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:featureList animated:YES];
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

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    
    
    return 19.06;
}

- (IBAction)backBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)listBtnOptions:(id)sender
{
    
    if ([ownerID isEqualToString:[[USERDEFAULTS valueForKey:kuserID] stringValue]])
    {
        OwnerOptionsViewController *OwnerOptions =[self.storyboard instantiateViewControllerWithIdentifier:@"OwnerOptionsViewController"];
        OwnerOptions.detailDict = [self.itemArray objectAtIndex:self.itemIndex];
        OwnerOptions.listImage = self.listCoverImage;
        [self displayContentController:OwnerOptions];
        //[self presentViewController:OwnerOptions animated:YES completion:nil];
    }else
    {
        GeneralOptionsViewController *GeneralOptions =[self.storyboard instantiateViewControllerWithIdentifier:@"GeneralOptionsViewController"];
        GeneralOptions.detailDict = [self.itemArray objectAtIndex:self.itemIndex];
        GeneralOptions.listImage = self.listCoverImage;
        [self displayContentController:GeneralOptions];
        //[self presentViewController:GeneralOptions animated:YES completion:nil];
    }

}

- (void)displayContentController:(UIViewController *)content {
    [self addChildViewController:content];
    content.view.frame = [[UIScreen mainScreen] bounds];
    
    //vinay here-
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [content.view.layer addAnimation:transition forKey:nil];
    [self.view addSubview:content.view];

    
    [content didMoveToParentViewController:self];
}

- (IBAction)saveListItemAction:(id)sender
{
    if (![ownerID isEqualToString:[[USERDEFAULTS valueForKey:kuserID] stringValue]])
    {
        MyFolderViewController *myfolder = [self.storyboard instantiateViewControllerWithIdentifier:@"MyFolderViewController"];
        myfolder.saveItemStr = @"item";
        UINavigationController *Navfolder = [[UINavigationController alloc]initWithRootViewController:myfolder];
            [Navfolder setNavigationBarHidden:YES];
        [self presentViewController:Navfolder animated:YES completion:nil];
    }else
    {
        
        [self.tabBarController setSelectedIndex:2];
        [kAppDelegate showProgressHUD];
        NSString * listID = [[self.itemArray objectAtIndex:self.itemIndex] valueForKey:@"listid"];
        notificationDict = [NSDictionary dictionaryWithObjectsAndKeys:
                            listID, @"listID",
                            nil];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target: self
                                       selector: @selector(callAfterSixtySecond2:) userInfo: nil repeats: NO];
        
    }
    

}

-(void)callAfterSixtySecond2:(NSTimer*) t
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"editListNotification" object:self userInfo:notificationDict];
}

- (IBAction)likeDislikeAction:(id)sender
{
    [self ListItemaddlike];
}
- (IBAction)nextItemAction:(id)sender
{
    if (self.itemArray.count==self.itemIndex+1) {
        [self.forwordBtn setHidden:YES];
    }else
    {
        [self.forwordBtn setHidden:NO];
        [self.backwordBtn setHidden:NO];
        self.itemIndex = self.itemIndex+1;
        [self UserlistItem];
    }
}

- (IBAction)previousItemAction:(id)sender
{
    if (self.itemIndex==0) {
        [self.backwordBtn setHidden:YES];
    }else
    {
        [self.backwordBtn setHidden:NO];
        [self.forwordBtn setHidden:NO];
        self.itemIndex = self.itemIndex-1;
        [self UserlistItem];
    }
}
- (IBAction)seeAllList:(id)sender
{
    TopListViewController *featured = [self.storyboard instantiateViewControllerWithIdentifier:@"TopListViewController"];
    featured.isRelatedList = YES;
    featured.relatedDict = relatedDict;
    [self.navigationController pushViewController:featured animated:YES];
}
@end
