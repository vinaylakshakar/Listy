//
//  FeaturedListFirstViewController.m
//  Listy
//
//  Created by Silstone on 22/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "FeaturedListFirstViewController.h"
#import "Listy.pch"
#import <QuartzCore/QuartzCore.h>

@interface FeaturedListFirstViewController ()
{
    NSMutableArray *listItemArray,*listCommentArray,*imageArray,*commentUserArray,*imageListArray;
    NSMutableDictionary *listDetailDict;
    NSDictionary* notificationDict;
    NSMutableArray *mutableKeyword;
    NSInteger index;
    int counterImage;
    NSTimer *timer;
      NSTimer *timer2Sec;
    UIImageView *listCoverImage;
}

@end

@implementation FeaturedListFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    listCommentArray = [[NSMutableArray alloc]init];
    listCoverImage =[[UIImageView alloc]init];
    //self.commentTable.tableFooterView = self.commentHeader;
    self.commentTableHeight.constant=0;
    self.featuredTableHeight.constant=0;

    // Do any additional setup after loading the view.
     self.mainViewHeight.constant = self.view.frame.size.height;
    self.detailVIewHeight.constant = self.view.frame.size.height;
    self.commentTxtWidth.constant = self.view.frame.size.width-32;
    self.postView.layer.cornerRadius = self.postView.frame.size.height/2;
    self.postView.layer.masksToBounds = YES;
    
    self.commentBtn.layer.cornerRadius = self.commentBtn.frame.size.height/2;
    
   // self.scrollView.contentInsetAdjustmentBehavior = false;
//    self.commentTableHeight.constant = 3000;
    
    //self.feturedTable.tableFooterView = self.featureFooter;
    //vinay here-
//    self.commentTable.tableHeaderView = self.commentHeader;
    self.commentTable.rowHeight = UITableViewAutomaticDimension;
    self.commentTable.estimatedRowHeight = 97;
    
    //NSLog(@"listDictinfo %@",self.listDictinfo);
    
//    NSString *useridStr = [NSString stringWithFormat:@"%@",[self.listDictinfo valueForKey:@"userid"]];
//    if (![useridStr isEqualToString:[[USERDEFAULTS valueForKey:kuserID] stringValue]])
//    {
//        [self.savelistBtn2 setHidden:YES];
//        [self.savelistBtn setHidden:YES];
//    }
    
    // self.mainView.delegate = self;
    self.view.backgroundColor =[UIColor blackColor];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveFolderNotification:)
                                                 name:@"selectFolderSaved"
                                               object:nil];
    
    //[self setTagView];
    self.userName2.text=@"";
    self.listName2.text=@"";
    self.categoryName2.text=@"";
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.keywordView removeAllTags];
    index = 0;
    self.pageControl.currentPage = index;
    [self.scrollView setContentOffset:CGPointMake(0,0) animated:YES];
    [self.tabBarController.tabBar setHidden:YES];
    [self.tagCommentView setHidden:YES];
    [self category_list_detail];
    [self GetListComment];
    [self ListCommentsWithUser];
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.listImageFirst.image = [UIImage imageNamed:@"List_background"];
    self.listimageFlipped.image = self.listImageFirst.image;
    [self.animationView stopAnimation];
    [timer invalidate];
    [timer2Sec invalidate];
}

-(BOOL)prefersHomeIndicatorAutoHidden{
    return YES;
}

- (void)receiveFolderNotification:(NSNotification *)notification
{
    NSDictionary *listDict = [notification userInfo];
    //NSLog(@"listDict %@",listDict);
    [self ListSaved:[listDict valueForKey:@"Categoryid"]];
}

-(void)setLayout
{
    if (!(imageArray.count>0))
    {
        [self.mainView setHidden:NO];
        [self.detailView setHidden:YES];
    }
   
    
    self.pageControl.numberOfPages = listItemArray.count;
    self.categoryName.text = [listDetailDict valueForKey:@"Categoryname"];
    self.categoryName2.text = [listDetailDict valueForKey:@"Categoryname"];
    self.listName.text =[listDetailDict valueForKey:@"ListName"];
    self.listName2.text = self.listName.text;
    self.userName.text = [NSString stringWithFormat:@"@%@",[listDetailDict valueForKey:@"UserName"]];
    self.userName2.text = self.userName.text;
    self.listDescription.text = [listDetailDict valueForKey:@"listdescription"];
    self.no_of_maches.text = [NSString stringWithFormat:@"%@",[listDetailDict valueForKey:@"PercentageofMatches"]];
    self.match_percentage.text = [NSString stringWithFormat:@"%@%% matched based on",[listDetailDict valueForKey:@"PercentageofMatches"]];
    
    self.userImage.layer.cornerRadius = self.userImage.frame.size.width/2;
    self.userImage2.layer.cornerRadius = self.userImage2.frame.size.width/2;
    self.userImage.layer.masksToBounds = YES;
    self.userImage2.layer.masksToBounds = YES;
    
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[listDetailDict valueForKey:@"UserImages"]]] placeholderImage:[UIImage imageNamed:@"user_profile"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.userImage2.image = self.userImage.image;
    }];
    
    [listCoverImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[listDetailDict valueForKey:@"CoverImage"]]] placeholderImage:[UIImage imageNamed:@"user_profile"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    
    if ([[listDetailDict valueForKey:@"NoOfComment"] integerValue]>=1)
    {
        self.no_of_comments.text = [NSString stringWithFormat:@"%@",[listDetailDict valueForKey:@"NoOfComment"]];
    }
    else
    {
        self.no_of_comments.text =@"0";
    }
    if ([[listDetailDict valueForKey:@"NoOfFollowers"] integerValue]>=1)
    {
        self.no_of_followers.text = [NSString stringWithFormat:@"%@",[listDetailDict valueForKey:@"NoOfFollowers"]];
    }
    else
    {
        self.no_of_followers.text =@"0";
    }
    if ([[listDetailDict valueForKey:@"NoOflikes"] integerValue]>=1)
    {
        self.no_of_likes.text = [NSString stringWithFormat:@"%@",[listDetailDict valueForKey:@"NoOflikes"]];
    }else
    {
        self.no_of_likes.text =@"0";
    }

    if ([[listDetailDict valueForKey:@"is_liked"] isEqualToString:@""]||[[listDetailDict valueForKey:@"is_liked"] isEqualToString:@"No"])
    {
         [self.likeUnlikeBtn setSelected:NO];
         [self.likeUnlikeBtn2 setSelected:NO];
    } else {
         [self.likeUnlikeBtn setSelected:YES];
         [self.likeUnlikeBtn2 setSelected:YES];
    }
    
    NSString *dateString = [listDetailDict valueForKey:@"Createdtime"];
    dateString = [dateString stringByReplacingOccurrencesOfString:@" " withString:@"  "];
    
    NSString *localTime = [self getLocalTimeFromUTC:dateString];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM dd yyyy hh:mma"];
    NSDate *dateFromString = [dateFormatter dateFromString:localTime];
    //NSLog(@"%@",dateFromString);
    
    NSString* leftTimeStr = [self remaningTime:dateFromString endDate:[NSDate date]];
    self.createdTime.text = [NSString stringWithFormat:@"%@ ago",leftTimeStr];
    
    self.featuredTableHeight.constant = listItemArray.count*75;
    
    NSString *inputString = [listDetailDict valueForKey:@"keyword"];
    NSSet *aSet = [NSSet setWithArray:[inputString componentsSeparatedByString:@","]];
    NSString *outputString = [aSet.allObjects componentsJoinedByString:@","];
    
    NSArray *keywordArray = [outputString componentsSeparatedByString:@","];
    mutableKeyword = [[NSMutableArray alloc]initWithArray:keywordArray];
    [mutableKeyword removeObject:@""];
    
    if ([[keywordArray objectAtIndex:0] isEqualToString:@""])
    {
        [self.seeAllKeywordBtn setHidden:YES];
    } else
    {
        [self setTagView:[mutableKeyword componentsJoinedByString:@","]];
    }
    
    
    
    if (listItemArray.count>0)
    {
        [self.feturedTable reloadData];
    }

    imageArray = [[NSMutableArray alloc]init];
    imageListArray=[[NSMutableArray alloc]init];
    for (NSMutableDictionary *dict in listItemArray)
    {
        [imageArray addObject:[UIImage imageNamed:@"List_background"]];
        [imageListArray addObject:[dict valueForKey:@"Imageurl"]];
    }
    counterImage = 0;
    [self downloadImageFromURL:[imageListArray objectAtIndex:counterImage]];
}

-(void)downloadImageFromURL:(NSString *)urlStr
{
    NSLog(@"urlStr is-- %@", urlStr);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                        NSURL *imageURL = [NSURL URLWithString:urlStr];
                       NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                       
                       //This is your completion handler
                       dispatch_sync(dispatch_get_main_queue(), ^{
                           //If self.image is atomic (not declared with nonatomic)
                           // you could have set it directly above
                           UIImage *image = [UIImage imageWithData:imageData];
                           
                           if (image==nil)
                           {
                               NSLog(@"no image loaded");
                           }
                           else
                           {
                               if(counterImage == 0)
                               {
                                 timer2Sec = [NSTimer scheduledTimerWithTimeInterval:2.0 target: self
                                                                  selector: @selector(callAfterSixtySecond:) userInfo: nil repeats: NO];
                               }
                               
                               if(imageArray.count == counterImage)
                               {
                               }
                               else{
                               
                               [imageArray replaceObjectAtIndex:counterImage withObject:image];
                               counterImage++;
                               if(imageListArray.count!=counterImage)
                               {
                                   NSLog(@"counterImage-%d",counterImage);
                                   
                                   //if (counterImage<imageListArray.count)
                                   {
                                       [self downloadImageFromURL:[imageListArray objectAtIndex:counterImage]];
                                   }
                                   
                               }
                               }
                               
                           }
                           
                       });
                   });
    
}

-(void)addImageInArray:(NSInteger)index
{
    UIImageView *image =[[UIImageView alloc]init];
    index= index;
    
    [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[listItemArray objectAtIndex:index] valueForKey:@"Imageurl"]]] placeholderImage:[UIImage imageNamed:@"List_background"] options:SDWebImageCacheMemoryOnly progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image==nil)
        {
            //[imageArray addObject:[UIImage imageNamed:@"List_background"]];
            [imageArray replaceObjectAtIndex:index withObject:[UIImage imageNamed:@"List_background"]];
        } else
        {
            [imageArray replaceObjectAtIndex:index withObject:image];
        }

        //NSLog(@"%lu",(unsigned long)listItemArray.count);
        
//        if (listItemArray.count!=index) {
//            [self addImageInArray:index];
//        }else
//        {
//        [NSTimer scheduledTimerWithTimeInterval:1.0 target: self
//                                               selector: @selector(callAfterSixtySecond:) userInfo: nil repeats: NO];
//        }
        
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
//    index =0;
//    self.pageControl.numberOfPages = imageArray.count;
//    [NSTimer scheduledTimerWithTimeInterval:30.0 target: self
//                                   selector: @selector(updateUIpageControl:) userInfo: nil repeats: NO];
}
-(void)viewDidDisappear:(BOOL)animated
{
    //[timer invalidate];
}




-(void)callAfterSixtySecond:(NSTimer*)t
{
    if (imageArray.count>0)
    {
        //NSLog(@"method called");
        NSArray *multipleImage = [[NSArray alloc]initWithArray:imageArray];
        [self.animationView stopAnimation];
        [self.animationView animateWithImages:multipleImage
                           transitionDuration:10.0
                                 initialDelay:0
                                         loop:NO
                                  isLandscape:YES];
        index =0;
    
      timer =  [NSTimer scheduledTimerWithTimeInterval:10.0 target: self
                                       selector: @selector(updateUIpageControl:) userInfo: nil repeats: YES];
    }else
    {
       timer =   [NSTimer scheduledTimerWithTimeInterval:0.5 target: self
                                       selector: @selector(callAfterSixtySecond:) userInfo: nil repeats: NO];
    }

}

-(void)updateUIpageControl:(NSTimer*)t
{
    
    if (index==imageArray.count-1) {
        index = 0;
        [self.animationView stopAnimation];
        [self.animationView animateWithImages:imageArray
                           transitionDuration:10.0
                                 initialDelay:0
                                         loop:NO
                                  isLandscape:YES];
    } else {
        index = index+1;
        
    }
    
    self.pageControl.currentPage = index;
}

- (BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2
{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    
    return [data1 isEqual:data2];
}

-(void)setTagView:(NSString*)keywords
{
    //NSArray *tags = @[@"Movies",@"80's",@"Sound track",@"Cult"];
    NSArray *tags;
    if ([keywords isEqualToString:@""]) {
        tags = [[NSArray alloc]init];
    } else {
        tags = [keywords componentsSeparatedByString:@","];
    }
    
    
    self.keywordView.alignment = TTGTagCollectionAlignmentLeft;
    
    TTGTextTagConfig *config = [TTGTextTagConfig new];
    //config.tagTextFont = [UIFont fontWithName:@"SFProText-Regular" size:5];
    
    config.tagTextColor = [UIColor whiteColor];
    // config.tagSelectedTextColor = RED_COLOR;
    config.tagExtraSpace = CGSizeMake(20, 15);
    
    NSUInteger location = 0;
    NSUInteger length = tags.count;
    config.tagBackgroundColor = RED_COLOR;
    config.tagShadowOpacity = 0.0;
    config.tagBorderColor = [UIColor clearColor];
    config.tagShadowRadius =1;
    config.tagSelectedBackgroundColor = RED_COLOR;
    config.tagTextFont = [UIFont fontWithName:@"SFProText-Medium" size:10];
    config.tagCornerRadius = 13;
    config.tagSelectedCornerRadius =13;
    config.tagSelectedBorderColor = [UIColor clearColor];
    config.extraData = @{@"key": @"1"};
    [self.keywordView addTags:[tags subarrayWithRange:NSMakeRange(location, length)] withConfig:[config copy]];
    
    self.keywordView.delegate = self;
    [self.keywordView setUserInteractionEnabled:NO];
    
    
}

#pragma mark - text View delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    if(textView == self.postCommentTxt)
    {
        if([self.postCommentTxt.text isEqualToString:@"What’s on your mind"]){
            
            self.postCommentTxt.text = @"";
            //self.listTitleView.textColor = [UIColor darkGrayColor];
            
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if(textView == self.postCommentTxt)
    {
        if(self.postCommentTxt.text.length == 0){
            
            self.postCommentTxt.text = @"What’s on your mind";
            //self.listTitleView.textColor = Grey_COLOR;
            //self.listTitleView.hidden = YES;
        }
    }
    
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"@"])
    {
        [self.tagCommentView setHidden:NO];
    }else
    {
        [self.tagCommentView setHidden:YES];
    }
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //This code will run in the main thread:
        self.commentViewHeight.constant = [self.postCommentTxt intrinsicContentSize].height+100;
        [self.commentTable layoutIfNeeded];
        [self.commentTable reloadData];
    });
    
    //vinay here-
   // CGSize tableViewSize2= self.commentTable.contentSize;
   // self.commentTableHeight.constant = tableViewSize2.height*2+200;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)setCommentLayout
{
    [self.commentTable reloadData];
    [self.commentTable layoutIfNeeded];

    dispatch_async(dispatch_get_main_queue(), ^{
        //This code will run in the main thread:
        [self.commentTable layoutIfNeeded];
        CGSize tableViewSize2= self.commentTable.contentSize;
        self.commentTableHeight.constant = tableViewSize2.height + (listCommentArray.count*10);
       
    });
    NSString *btnText = [NSString stringWithFormat:@"Comments (%lu)",(unsigned long)listCommentArray.count];
    [self.commentBtn setTitle:btnText forState:UIControlStateNormal];
    //    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.origin.x , self.scrollView.frame.origin.y+listCommentArray.count*200) animated:YES];
//    [self ListCommentsWithUser];
    [self.tagViewTable reloadData];
}


#pragma mark - Api methods-

-(void)ListSaved:(NSString *)categoryId
{
    
    [kAppDelegate showProgressHUD];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"userid"];
    
    if (![self.listDictinfo valueForKey:@"listid"]) {
        [dict setObject:[self.listDictinfo valueForKey:@"id"] forKey:@"listId"];
        
    } else {
        [dict setObject:[self.listDictinfo valueForKey:@"listid"] forKey:@"listId"];
        
    }
   // [dict setObject:[self.listDictinfo valueForKey:@"listid"] forKey:@"listid"];
    [dict setObject:categoryId forKey:@"categoryid"];
    [dict setObject:[self.listDictinfo valueForKey:@"userid"] forKey:@"ownerid"];
    
    
    //NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]ListSaved:^(id object)
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


-(void)ListaddLike
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"Userid"];
    
    if (![self.listDictinfo valueForKey:@"listid"]) {
         [dict setObject:[self.listDictinfo valueForKey:@"id"] forKey:@"listid"];
    } else {
         [dict setObject:[self.listDictinfo valueForKey:@"listid"] forKey:@"listid"];
    }
   
    
    if (![self.likeUnlikeBtn isSelected]&&![self.likeUnlikeBtn2 isSelected]) {
        [dict setObject:@"Yes" forKey:@"islike"];
        [self.likeUnlikeBtn setSelected:YES];
        [self.likeUnlikeBtn2 setSelected:YES];
    } else {
        [dict setObject:@"No" forKey:@"islike"];
        [self.likeUnlikeBtn setSelected:NO];
        [self.likeUnlikeBtn2 setSelected:NO];
    }
    
    
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]ListaddLike:^(id object)
     {
         //NSLog(@"%@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             NSString *NumberoflikedStr = [[[object valueForKey:@"like"] valueForKey:@"Numberofliked"] stringValue];
             [self.no_of_likes setText:NumberoflikedStr];
             
//             if (![self.likeUnlikeBtn isSelected]&&![self.likeUnlikeBtn2 isSelected])
//             {
//                 [self.likeUnlikeBtn setSelected:YES];
//                 [self.likeUnlikeBtn2 setSelected:YES];
//             } else {
//                 [self.likeUnlikeBtn setSelected:NO];
//                 [self.likeUnlikeBtn2 setSelected:NO];
//             }
//            
             
             
         } else
         {
             //[Utility showAlertMessage:nil message:[object valueForKey:@"Message"]];
             
             
         }
         
         [kAppDelegate hideProgressHUD];
         
         
         
     }
                                               onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
    
    
}



-(void)GetListComment
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    if (![self.listDictinfo valueForKey:@"listid"])
    {
        [dict setObject:[self.listDictinfo valueForKey:@"id"] forKey:@"listid"];
    } else {
        [dict setObject:[self.listDictinfo valueForKey:@"listid"] forKey:@"listid"];
        //[kAppDelegate showProgressHUD];
    }
    
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]GetListComment:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             listCommentArray = [object valueForKey:@"ListComment"];
             _no_of_comments.text = [NSString stringWithFormat:@"%lu",(unsigned long)listCommentArray.count];
             [self setCommentLayout];
             
             
             
         } else
         {
             //[Utility showAlertMessage:nil message:[object valueForKey:@"Message"]];
             [self setCommentLayout];
             
             
         }
         
         if ([self.listDictinfo valueForKey:@"listid"])
         {
            //[kAppDelegate hideProgressHUD];
         }
 
         
         
         
     }
                                               onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
    
    
}


-(void)listaddcomment
{    
    NSLog(@"%@",self.listDictinfo);
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"userid"];
    //[dict setObject:[self.listDictinfo valueForKey:@"id"] forKey:@"listid"];
    
    if (![self.listDictinfo valueForKey:@"listid"])
    {
        [dict setObject:[self.listDictinfo valueForKey:@"id"] forKey:@"listid"];
    } else {
        [dict setObject:[self.listDictinfo valueForKey:@"listid"] forKey:@"listid"];
    }
    
    [dict setObject:self.postCommentTxt.text forKey:@"comment"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]listaddcomment:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             self.postCommentTxt.text = @"";
             self.commentViewHeight.constant = 130;
             [self GetListComment];
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



-(void)category_list_detail
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
//    if (self.followerid)
//    {
//         [dict setObject:self.followerid forKey:@"userid"];
//    } else {
          [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"userid"];
 //   }
    
    if (![self.listDictinfo valueForKey:@"listid"]) {
         [dict setObject:[self.listDictinfo valueForKey:@"id"] forKey:@"listId"];
        
    } else {
         [dict setObject:[self.listDictinfo valueForKey:@"listid"] forKey:@"listId"];
       // [kAppDelegate showProgressHUD];
    }
  
   
    
    if ([[[USERDEFAULTS valueForKey:kuserID] stringValue] isEqualToString:[self.listDictinfo valueForKey:@"userid"]])
    {
        [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"ownerid"];
    } else
    {
        
        if (![self.listDictinfo valueForKey:@"Owernerid"])
        {
            [dict setObject:[self.listDictinfo valueForKey:@"userid"] forKey:@"ownerid"];
        } else
        {
             [dict setObject:[self.listDictinfo valueForKey:@"Owernerid"] forKey:@"ownerid"];
        }
       
    }
    
    
    [dict setObject:@"1" forKey:@"offset"];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]category_list_detail:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             listDetailDict = [[[object valueForKey:@"Data"] objectAtIndex:0] mutableCopy];
             listDetailDict = [Utility removeNullFromDictionary:listDetailDict];
             listItemArray = [[object valueForKey:@"item"] mutableCopy];
             [self.optionBtn setUserInteractionEnabled:YES];
             [self.savelistBtn setUserInteractionEnabled:YES];
             [self.savelistBtn2 setUserInteractionEnabled:YES];
             [self setLayout];
             
             
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
         
         if ([self.listDictinfo valueForKey:@"listid"])
         {
            //[kAppDelegate hideProgressHUD];
         }
    
         
         
         
     }
                                                     onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
    
    
}


-(void)ListCommentsWithUser
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    if (![self.listDictinfo valueForKey:@"listid"])
    {
        [dict setObject:[self.listDictinfo valueForKey:@"id"] forKey:@"listid"];
    } else {
        [dict setObject:[self.listDictinfo valueForKey:@"listid"] forKey:@"listid"];
    }
    
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"userid"];
    [dict setObject:@"0" forKey:@"offset"];
    
    
    //NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]ListCommentsWithUser:^(id object)
     {
         //NSLog(@"%@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             NSArray *newArray=[[object valueForKey:@"follower"] arrayByAddingObjectsFromArray:[object valueForKey:@"following"]];
             NSArray *taggedUserArray =[newArray arrayByAddingObjectsFromArray:[object valueForKey:@"listcomment"]];
             
             commentUserArray =[[NSMutableArray alloc]init];
             for (NSMutableDictionary *dict in taggedUserArray) {
                 //NSString *useridStr = [dict valueForKey:@"userid"];
                 
                // NSMutableDictionary* E1 = [Event_Array objectAtIndex:i];
                 BOOL hasDuplicate = [[commentUserArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"userid == %@", [dict objectForKey:@"userid"]]] count] > 0;
                 
                 if (!hasDuplicate)
                 {
                     [commentUserArray addObject:dict];
                 }
             }
             
             //NSLog(@"userArray %@",commentUserArray);
             [self.tagViewTable reloadData];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 //This code will run in the main thread:
                 CGSize tableViewSize2= self.tagViewTable.contentSize;
                 self.tagViewConstant.constant = tableViewSize2.height;
             });
             
         } else
         {
             //[Utility showAlertMessage:nil message:[object valueForKey:@"Message"]];
             
             
             
         }
         
         if ([self.listDictinfo valueForKey:@"listid"])
         {
             //[kAppDelegate hideProgressHUD];
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
    if (tableView==self.commentTable)
    {
        return listCommentArray.count;
    }
    if (tableView==self.tagViewTable)
    {
        return commentUserArray.count;
    }
    if (tableView==self.feturedTable)
    {
        return listItemArray.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    
    if (tableView==self.commentTable)
    {
        static NSString *propertyIdentifier = @"CommentViewCell";
        
        CommentViewCell *cell = (CommentViewCell *)[tableView dequeueReusableCellWithIdentifier:propertyIdentifier];
        
        
        if (cell == nil)
        {
            
            NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"CommentViewCell" owner:self options:nil];
            cell = [nib1 objectAtIndex:0];
        }
        cell.userName.text = [NSString stringWithFormat:@"@%@",[[listCommentArray objectAtIndex:indexPath.row] valueForKey:@"UserName"]];
       // cell.commentText.text = [[listCommentArray objectAtIndex:indexPath.row] valueForKey:@"Comment"];
        [cell.commentText setAttributedText:[self getMutableString:[[listCommentArray objectAtIndex:indexPath.row] valueForKey:@"Comment"]]];
        
        cell.userImage.layer.cornerRadius = cell.userImage.frame.size.width/2;
        cell.userImage.clipsToBounds = YES;
        
        [cell.userImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[listCommentArray objectAtIndex:indexPath.row] valueForKey:@"UserProfileImages"]]] placeholderImage:[UIImage imageNamed:@"user_profile"] options:0 progress:nil completed:nil];
        
        NSString *dateString = [[listCommentArray objectAtIndex:indexPath.row] valueForKey:@"Commenttime"];
        dateString = [dateString stringByReplacingOccurrencesOfString:@" " withString:@"  "];
        
        NSString *localTime = [self getLocalTimeFromUTC:dateString];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM dd yyyy hh:mma"];
        NSDate *dateFromString = [dateFormatter dateFromString:localTime];
        //NSLog(@"%@",dateFromString);
        
        NSString* leftTimeStr = [self remaningTime:dateFromString endDate:[NSDate date]];
        cell.commentTime.text =[NSString stringWithFormat:@"%@ ago, %@",leftTimeStr,[[listCommentArray objectAtIndex:indexPath.row] valueForKey:@"UserLocation"]];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    
    if (tableView==self.tagViewTable)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
        
        /*
         *   If the cell is nil it means no cell was available for reuse and that we should
         *   create a new one.
         */
        if (cell == nil) {
            
            /*
             *   Actually create a new cell (with an identifier so that it can be dequeued).
             */
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
            
           // cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        cell.textLabel.text = [[commentUserArray objectAtIndex:indexPath.row] valueForKey:@"username"];
        cell.textLabel.font = [UIFont fontWithName:@"SFProText-Medium" size:15];
        
        return cell;

    }
    
    static NSString *propertyIdentifier = @"FeaturedListCell";
    
    FeaturedListCell *cell = (FeaturedListCell *)[tableView dequeueReusableCellWithIdentifier:propertyIdentifier];
    
    
    if (cell == nil)
    {
        
        NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"FeaturedListCell" owner:self options:nil];
        cell = [nib1 objectAtIndex:0];
    }
    
//    cell.featuredListNamelbl.text = [listNameArray objectAtIndex:indexPath.row];
//    cell.listImageView.image =[UIImage imageNamed:[listImageArray objectAtIndex:indexPath.row]];
    //    cell.iconImage.image = [UIImage imageNamed:[iconImageArray objectAtIndex:indexPath.row]];
    cell.featuredListNamelbl.text = [NSString stringWithFormat:@"%ld. %@",(long)indexPath.row+1,[[listItemArray objectAtIndex:indexPath.row] valueForKey:@"listname"]];
    
    if ([[[listItemArray objectAtIndex:indexPath.row] valueForKey:@"NoOfLike"] intValue]>=1)
    {

        cell.itemLikeNumber.text = [NSString stringWithFormat:@"%@",[[listItemArray objectAtIndex:indexPath.row] valueForKey:@"NoOfLike"]];
    } else
    {
        cell.itemLikeNumber.text =@"0";
    }
    
    if (![[[listItemArray objectAtIndex:indexPath.row] valueForKey:@"is_liked"] isEqualToString:@"No"]) {
        cell.heartIcon.image =[UIImage imageNamed:@"heart_red"];
    }
    
    NSMutableDictionary *itemDict = [listItemArray objectAtIndex:indexPath.row];

    
//    NSString *urlStr1 = [NSString stringWithFormat:kBaseURL@"CreateThumbnailURL?listid=%@&listitemid=%@&url=%@&width=%@&height=0",[itemDict valueForKey:@"listid"],[itemDict valueForKey:@"listitemId"],[itemDict valueForKey:@"Imageurl"],kitem_width];
    
    NSURL *customUrl1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[itemDict valueForKey:@"Imageurl"]]];
    [cell.listImageView sd_setImageWithURL:customUrl1 placeholderImage:[UIImage imageNamed:@"profile_background"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        [self addImageInArray:indexPath.row];
    }];
    
    cell.listImageView.clipsToBounds = YES;
    cell.listImageView.layer.cornerRadius = 4;
//    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    if (indexPath.row==listItemArray.count-1&&imageArray.count==0) {
//        [self addImageInArray:0];
//    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.feturedTable)
    {
        ListItemDetailViewController *listItemDetail =[self.storyboard instantiateViewControllerWithIdentifier:@"ListItemDetailViewController"];
        listItemDetail.itemArray = listItemArray;
        listItemDetail.itemIndex = indexPath.row;
        listItemDetail.followerid = self.followerid;
        listItemDetail.listCoverImage = listCoverImage.image;
        [self.navigationController pushViewController:listItemDetail animated:YES];
    }

    if (tableView==self.tagViewTable)
    {
        [self.tagCommentView setHidden:YES];
        NSString *stringWithuser =[NSString stringWithFormat:@"%@%@",self.postCommentTxt.text,[[commentUserArray objectAtIndex:indexPath.row] valueForKey:@"username"]];
        
        [self.postCommentTxt setText:stringWithuser];
    }
}

-(NSMutableAttributedString*)getMutableString:(NSString*)Str
{
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:Str];
    
    NSArray *words=[Str componentsSeparatedByString:@" "];
    
    for (NSString *word in words)
    {
        if ([word hasPrefix:@"@"])
        {
            NSRange range=[Str rangeOfString:word];
           [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.96 green:0.19 blue:0.24 alpha:1.0] range:range];
        }
    }
    return string;

}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger )section {
//    return self.commentHeader.frame.size.height;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger )section {
//    return self.commentHeader;
//}


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



- (IBAction)backBtnAction:(id)sender
{
    [self.animationView stopAnimation];
    [timer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectFolderSaved" object:nil];
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
   
}

-(void)callAfterflipped
{
    NSArray *multipleImage = [[NSArray alloc]initWithArray:imageArray];
    self.listimageFlipped.animationImages = multipleImage;
    self.listimageFlipped.animationRepeatCount = 0; // 0 means repeat without stop.
    self.listimageFlipped.animationDuration = 30.0; // Animation duration
    
    [self.listimageFlipped startAnimating];
}

- (IBAction)flipViewAction:(id)sender
{
    float duration = 0.5;
    self.view.backgroundColor =[UIColor blackColor];
    if ([self.detailView isHidden])
    {
        
        [UIView transitionWithView:self.view
                          duration:duration
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            [self.mainView setHidden:TRUE];
                        }
                        completion:^(BOOL finished) {
                        }];
        
         [UIView transitionWithView:self.view
                          duration:duration
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            [self.detailView setHidden:false];
                        }
                         completion:^(BOOL finished) {
                             //self.view.backgroundColor =[UIColor whiteColor];
                         }];
        self.animationView.transform = CGAffineTransformMakeScale(-1, 1);
        
    } else {
       
        [UIView transitionWithView:self.view
                          duration:duration
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            [self.detailView setHidden:TRUE];
                        }
                        completion:NULL];
        
        [UIView transitionWithView:self.view
                          duration:duration
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            [self.mainView setHidden:FALSE];
                        }
                        completion:^(BOOL finished) {
                            //self.view.backgroundColor =[UIColor whiteColor];
                        }];
        
        self.animationView.transform = CGAffineTransformMakeScale(1, 1);
        
    }
    
    //[self callAfterflipped];
}
- (IBAction)listBtnOptions:(id)sender
{

    if ([[[listDetailDict valueForKey:@"userid"] stringValue] isEqualToString:[[USERDEFAULTS valueForKey:kuserID] stringValue]])
    {
        OwnerOptionsViewController *Owner =[self.storyboard instantiateViewControllerWithIdentifier:@"OwnerOptionsViewController"];
        Owner.isfromList = YES;
        Owner.detailDict = listDetailDict;
        Owner.listImage = listCoverImage.image;
        [self displayContentController:Owner];
        //[self presentViewController:Owner animated:YES completion:nil];
//        [UIView transitionWithView:self.view
//                          duration:1.0
//                           options:UIViewAnimationOptionCurveEaseIn
//                        animations:^{
//
//                        }
//                        completion:NULL];
//        [self.view addSubview:Owner.view];
        
    }else
    {
        GeneralOptionsViewController *General =[self.storyboard instantiateViewControllerWithIdentifier:@"GeneralOptionsViewController"];
        General.isfromList = YES;
        General.detailDict = listDetailDict;
        General.listImage = listCoverImage.image;
        [self displayContentController:General];
        //[self presentViewController:General animated:YES completion:nil];
        
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

- (IBAction)postBtnAction:(id)sender
{
    if (_postCommentTxt.text.length==0|| [self.postCommentTxt.text isEqualToString:@"What’s on your mind"])
    {
        [Utility showAlertMessage:nil message:@"Please Enter your comment."];
    } else {
        [self listaddcomment];
    }
}
- (IBAction)listLikeAction:(id)sender
{
    [self ListaddLike];
}

- (IBAction)showAllKeywordAction:(id)sender
{
    KeywordViewController *keywordView = [self.storyboard instantiateViewControllerWithIdentifier:@"KeywordViewController"];
    keywordView.keywords = [mutableKeyword componentsJoinedByString:@","];
    [self.navigationController pushViewController:keywordView animated:NO];
}
- (IBAction)savelistAction:(id)sender
{
    
    NSString *useridStr = [NSString stringWithFormat:@"%@",[self.listDictinfo valueForKey:@"userid"]];
    if (![useridStr isEqualToString:[[USERDEFAULTS valueForKey:kuserID] stringValue]])
    {
            MyFolderViewController *myfolder = [self.storyboard instantiateViewControllerWithIdentifier:@"MyFolderViewController"];
                myfolder.saveItemStr = @"List";
            UINavigationController *Navfolder = [[UINavigationController alloc]initWithRootViewController:myfolder];
            [Navfolder setNavigationBarHidden:YES];
            [self presentViewController:Navfolder animated:YES completion:nil];
    }else
    {
        [self.tabBarController setSelectedIndex:2];
        [kAppDelegate showProgressHUD];
        NSString * listID = [listDetailDict valueForKey:@"listid"];
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
- (IBAction)showUserProfile:(id)sender
{
    FollowingUserProfileViewController *follower = [self.storyboard instantiateViewControllerWithIdentifier:@"FollowingUserProfileViewController"];

    if ([[[USERDEFAULTS valueForKey:kuserID] stringValue] isEqualToString:[self.listDictinfo valueForKey:@"userid"]])
    {
       // [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"ownerid"];
         follower.followerIdStr = [self.listDictinfo valueForKey:@"userid"];
    } else {
        
        if (![self.listDictinfo valueForKey:@"Owernerid"])
        {
           // [dict setObject:[self.listDictinfo valueForKey:@"userid"] forKey:@"ownerid"];
            follower.followerIdStr = [self.listDictinfo valueForKey:@"userid"];
        } else {
           // [dict setObject:[self.listDictinfo valueForKey:@"Owernerid"] forKey:@"ownerid"];
            
            follower.followerIdStr = [self.listDictinfo valueForKey:@"Owernerid"];

        }
        
        
    }
    [self.navigationController pushViewController:follower animated:YES];
}
@end
