//
//  NewListViewController.m
//  Listy
//
//  Created by Silstone on 23/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "NewListViewController.h"
#import "Listy.pch"

@interface NewListViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, TOCropViewControllerDelegate>
{
    NSMutableArray *listItemArray ,*listImageArray,*keywordArray, *wikiSearchArray;
    NSDictionary * folderDict;
    NSString *listIDStr,*itemIDStr;
    UIImageView *btnImageView,*coverImageView;
    NSInteger ItemIndex;
    NSMutableArray *wikiArray;
    NSString *ItemOwner;
    int strLenght;
    BOOL isForCoverImage;
}


@property (nonatomic, strong) UIImage *image;           // The image we'll be cropping
@property (nonatomic, strong) UIImageView *imageView;   // The image view to present the cropped image

@property (nonatomic, assign) TOCropViewCroppingStyle croppingStyle; //The cropping style
@property (nonatomic, assign) CGRect croppedFrame;
@property (nonatomic, assign) NSInteger angle;
@property (nonatomic, assign) TOCropToolbar *toolbar;


@end

@implementation NewListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    del= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    listIDStr = @"0";
    itemIDStr = @"0";
    keywordArray = [[NSMutableArray alloc]init];
    listItemArray = [[NSMutableArray alloc]init];
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Enter item name" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.02 green:0.07 blue:0.25 alpha:1.0] }];
    self.itemTitleView.attributedPlaceholder = str;
    if (((int)[[UIScreen mainScreen] nativeBounds].size.height) == 1920)
    {
        btnImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.addImageBtn.frame.origin.x, self.addImageBtn.frame.origin.y, self.addImageBtn.frame.size.width+40, 200)];
        coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.addCoverImageBtn.frame.origin.x, self.addCoverImageBtn.frame.origin.y, self.addCoverImageBtn.frame.size.width+40, 200)];
    }else
    {
      
        
        if (IS_IPHONE_5)
        {
            btnImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.addImageBtn.frame.origin.x, self.addImageBtn.frame.origin.y, self.view.frame.size.width-self.addImageBtn.frame.origin.x*2, 200)];
            coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.addCoverImageBtn.frame.origin.x, self.addCoverImageBtn.frame.origin.y, self.view.frame.size.width-self.addCoverImageBtn.frame.origin.x*2, 200)];
        }else
        {
            btnImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.addImageBtn.frame.origin.x, self.addImageBtn.frame.origin.y, self.addImageBtn.frame.size.width, 200)];
            coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.addCoverImageBtn.frame.origin.x, self.addCoverImageBtn.frame.origin.y, self.addCoverImageBtn.frame.size.width, 200)];
        }
        
        
    }
 

    listImageArray  = [[NSMutableArray alloc]initWithObjects:@"list_item_1",@"list_item_2",@"list_item_8",@"list_item_7",@"list_item_6",@"list_item_5",@"list_item_4",@"list_item_3",@"list_item_2",@"list_item_1", nil];
    
    // Do any additional setup after loading the view.
    [self setLayout];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(editListNotification:)
                                                 name:@"editListNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"hideListContainer"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveFolderNotification:)
                                                 name:@"selectFolder"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(copyToClip) name:UIPasteboardChangedNotification object:nil];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self.tabBarController.tabBar setHidden:YES];
    [self.listTable setEditing:YES];
    [self.addCoverImageBtn setHidden:NO];
    if (!isForCoverImage) {
         [self.addCoverImageBtn setBackgroundColor:[UIColor colorWithRed:0.96 green:0.19 blue:0.24 alpha:1.0]];
    }
   
    
    //NSLog(@"wikiDescStr %@",wikiArray);
    if (wikiArray.count>0) {
        [self.wikiSwitch setOn:YES];
    } else {
         [self.wikiSwitch setOn:NO];
    }
    
   
    if (![del.folderCategoryID isEqual:@""]&&(del.folderCategoryID!=nil))
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:del.folderCategoryID forKey:@"Categoryid"];
        [dic setObject:del.folderCategoryName forKey:@"Categoryname"];
        [self.selectFolderBtn setTitle:del.folderCategoryName forState:UIControlStateNormal];
        folderDict = dic;
    }
    
}

-(void)setLayout
{
    self.addCoverConstraint.constant = 55;
    [coverImageView setHidden:YES];
    [self.addCoverImageBtn setHidden:NO];
    
    wikiArray = [[NSMutableArray alloc]init];
    [self.listView setHidden:YES];
    self.listTable.tableFooterView = [UIView new];
    self.keywordViewHeight.constant = 0;
    //self.keywordViewHeight.constant = 0;
    self.listItembottumConstant.constant = 0;
    self.listTableHeight.constant = 0;
    //    self.publishViewHeight.constant = 300;
    self.publishBtn.layer.cornerRadius = 4;
    self.publishBtn.layer.masksToBounds = YES;
    
    self.CreateListView.layer.cornerRadius = 4;
    self.CreateListView.layer.masksToBounds = YES;
    
    self.addImageBtn.layer.cornerRadius = 6;
    self.addImageBtn.layer.masksToBounds = YES;
    
    self.addCoverImageBtn.layer.cornerRadius = 6;
    self.addCoverImageBtn.layer.masksToBounds = YES;
    
    self.listBtn.layer.cornerRadius = 4;
    self.listBtn.layer.masksToBounds = YES;
    
//    [self setTagView];
    
    self.addListBtn.layer.cornerRadius = 8.0f;
    self.addListBtn.layer.masksToBounds = NO;
    self.addListBtn.layer.borderWidth = 0.0f;
    
    self.addListBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    self.addListBtn.layer.shadowOpacity = 0.1;
    self.addListBtn.layer.shadowRadius = 10;
    self.addListBtn.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
    
    [self.itemTitleView addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
}

#define ACCEPTABLE_CHARACTERS @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-& "

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if(textView == self.keywordTxtView)
    {
        if([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
            [self addKeywordWithoutPopup];
            return NO;
        }

        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
        NSString *filtered = [[text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [text isEqualToString:filtered];
    }
    
    if (textView==self.listDescriptionView||textView==self.listTitleView) {
//        strLenght = (int)_listTitleView.text.length;
//        _characterLength.text = [NSString stringWithFormat:@"%i/30", strLenght];
//        return textView.text.length + (text.length - range.length) <= 30;
        if([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
            return YES;
        }
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)receiveNotification:(NSNotification *)notification
{
//    [self.CreateListView setHidden:YES];
    self.listTableHeight.constant = 500;
//    NSDictionary* userInfo = notification.userInfo;
//    self.alertTextLable.text = [userInfo valueForKey:@"message"];
    [self.listTable layoutIfNeeded];
    [self.listTable reloadData];
    //CGSize tableViewSize2= self.listTable.contentSize;
    self.keywordViewHeight.constant = 90;
    self.listTableHeight.constant = listItemArray.count*76;
    del.folderCategoryName = @"";
    del.folderCategoryID = @"";
    
}

- (void)receiveFolderNotification:(NSNotification *)notification
{
    folderDict = [notification userInfo];
    [self.selectFolderBtn setTitle:[folderDict valueForKey:@"Categoryname"] forState:UIControlStateNormal];
    del.folderCategoryName = @"";
    del.folderCategoryID = @"";
}

- (void)editListNotification:(NSNotification *)notification
{
    NSDictionary *editDict = [notification userInfo];
    //NSLog(@"editDict %@",editDict);
    del.folderCategoryName = @"";
    del.folderCategoryID = @"";
    
    [self category_list_detail:[editDict valueForKey:@"listID"]];
    
}

-(void)copyToClip
{
    [kAppDelegate showProgressHUD];
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    NSString *str = [pb string];
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: str]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            // WARNING: is the cell still using the same data by this point??
            UIImage *imag = [UIImage imageWithData:data];
           //  [kAppDelegate hideProgressHUD];
            if (imag){
                
                //self.addImageBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
                
                // self.addImageBtn.contentMode = UIViewContentModeCenter;
                self.croppingStyle = TOCropViewControllerAspectRatioPreset5x4;
                self.image = imag;
                //  [self.addImageBtn setBackgroundImage:image forState:UIControlStateNormal];
                //[self.addImageBtn setTitle:@"" forState:UIControlStateNormal];
                //[self createImageView];
                
                TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:self.croppingStyle image:imag];
                cropController.delegate = self;
                cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetCustom;
                
                if (isForCoverImage) {
                    cropController.customAspectRatio = CGSizeMake(341, 229);
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self textViewDidChange:self.listTitleView];
//                    });
                    //vinay-
                    
                    if (self.addCoverConstraint.constant<200) {
                        self.addCoverConstraint.constant =200;
                        //self.listDetailHeight.constant =self.listDetailHeight.constant +200;
                    }
                } else {
                    cropController.customAspectRatio = CGSizeMake(320, 568);
                }
                
                //Set the initial aspect ratio as a square
                cropController.aspectRatioLockEnabled = YES; // The crop box is locked to the aspect ratio and can't be resized away from it
                cropController.resetAspectRatioEnabled = NO; // When tapping 'reset', the aspect ratio will NOT be reset back to default
                [self presentViewController:cropController animated:YES completion:nil];
                
                
                //        if (self.addListImage.constant<200) {
                //            self.addListImage.constant =200;
                //            self.addListViewHeight.constant = self.addListViewHeight.constant +self.addListImage.constant;
                //
                //        }
                
                
                //NSLog(@"%@",btnImage.image);
                  [kAppDelegate hideProgressHUD];
                
            } else
                        {
                              [kAppDelegate hideProgressHUD];
                            [Utility showAlertMessage:nil message:@"Something wrong! please try again."];
                        }
        });
        
      
    });

    
    
 //   [kAppDelegate hideProgressHUD];
    
    

//    UIImageView *btnImage = [[UIImageView alloc]init];
//    [btnImage sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil options:SDWebImageHighPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//
//        if (image)
//        {
//
//            //self.addImageBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
//
//            // self.addImageBtn.contentMode = UIViewContentModeCenter;
//            self.croppingStyle = TOCropViewControllerAspectRatioPreset5x4;
//            self.image = image;
//            //  [self.addImageBtn setBackgroundImage:image forState:UIControlStateNormal];
//            [self.addImageBtn setTitle:@"" forState:UIControlStateNormal];
//            //[self createImageView];
//
//            TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:self.croppingStyle image:image];
//            cropController.delegate = self;
//            cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetCustom;
//
//            if (isForCoverImage) {
//                 cropController.customAspectRatio = CGSizeMake(341, 229);
//            } else {
//                 cropController.customAspectRatio = CGSizeMake(320, 568);
//            }
//
//            //Set the initial aspect ratio as a square
//            cropController.aspectRatioLockEnabled = YES; // The crop box is locked to the aspect ratio and can't be resized away from it
//            cropController.resetAspectRatioEnabled = NO; // When tapping 'reset', the aspect ratio will NOT be reset back to default
//            [self presentViewController:cropController animated:YES completion:nil];
//
//
//            //        if (self.addListImage.constant<200) {
//            //            self.addListImage.constant =200;
//            //            self.addListViewHeight.constant = self.addListViewHeight.constant +self.addListImage.constant;
//            //
//            //        }
//
//
//            //NSLog(@"%@",btnImage.image);
//
//        } else
//        {
//            [Utility showAlertMessage:nil message:@"Something wrong! please try again."];
//        }
//    }];
    
}

-(void)addImageToButton:(UIImage*)image
{
    self.image = image;
    //[self.addImageBtn setBackgroundImage:image forState:UIControlStateNormal];
    
    if (isForCoverImage)
    {
      //  [self.addCoverImageBtn setTitle:@"" forState:UIControlStateNormal];
        [self createCoverImageView];
//
        if (self.addCoverConstraint.constant<200) {
            //self.addCoverConstraint.constant =200;
            //self.listDetailHeight.constant =self.listDetailHeight.constant +200;
        }
    } else
    {
        [self.addImageBtn setTitle:@"" forState:UIControlStateNormal];
        [self createImageView];
        
        if (self.addListImage.constant<200) {
            self.addListImage.constant =200;
            self.addListViewHeight.constant = self.addListViewHeight.constant +self.addListImage.constant;
        }
    }
    
    
    
}

-(void)createCoverImageView
{
    //    btnImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.addImageBtn.frame.origin.x, self.addImageBtn.frame.origin.y, self.addImageBtn.frame.size.width, 200)];
    [coverImageView setHidden:NO];
    [self.addCoverImageBtn setBackgroundColor:[UIColor clearColor]];
    coverImageView.image = self.image;
    coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    coverImageView.clipsToBounds = YES;
    coverImageView.layer.cornerRadius = 6;
   
    [self.scrollView insertSubview:coverImageView belowSubview:self.cancelCreateList];
   // [self checkItemTitleImage];
}


-(void)createImageView
{
//    btnImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.addImageBtn.frame.origin.x, self.addImageBtn.frame.origin.y, self.addImageBtn.frame.size.width, 200)];
    [btnImageView setHidden:NO];
    btnImageView.image = self.image;
    btnImageView.contentMode = UIViewContentModeScaleAspectFill;
    btnImageView.clipsToBounds = YES;
    btnImageView.layer.cornerRadius = 6;
   // btnImage.backgroundColor = [UIColor whiteColor];
   // [self.listView insertSubview:btnImageView aboveSubview:self.addImageBtn];
    [self.listView insertSubview:btnImageView belowSubview:self.cancelAddItem];
    [self checkItemTitleImage];
}


-(void)addList
{
    //    [self.CreateListView setHidden:YES];
   // self.listTableHeight.constant = 500;
    //    NSDictionary* userInfo = notification.userInfo;
    //    self.alertTextLable.text = [userInfo valueForKey:@"message"];
    [self.listTable layoutIfNeeded];
    [self.listTable reloadData];
   // CGSize tableViewSize2= self.listTable.contentSize;
    self.listTableHeight.constant = listItemArray.count*76;
    //self.listTableHeight.constant = tableViewSize2.height*2-110;
    [self ValidateListTextView];
    
    
}

-(void)setTagView:(NSMutableArray *)KeywordArray
{

    [_keywordView removeAllTags];
    NSArray *tags = [[NSArray alloc]initWithArray:keywordArray];
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
    [self.keywordView setShowsHorizontalScrollIndicator:NO];
    [self.keywordView setShowsVerticalScrollIndicator:NO];
    
}

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView
                    didTapTag:(NSString *)tagText
                      atIndex:(NSUInteger)index
                     selected:(BOOL)selected
                    tagConfig:(TTGTextTagConfig *)config
{
    [keywordArray removeObjectAtIndex:index];
    [self setTagView:keywordArray];
    
//    if (keywordArray.count%4==0)
//    {
//        //self.keywordViewHeight.constant = self.keywordViewHeight.constant-35;
//        self.keywordViewHeight.constant = self.keywordView.contentSize.height+5;
//        self.addListViewHeight.constant = self.addListViewHeight.constant-40;
//    }
//    if (keywordArray.count==0) {
//        self.keywordViewHeight.constant=0;
//        //self.addListViewHeight.constant= 748;
//    }
    //vinay here-
    CGSize keywordSize = self.keywordView.contentSize;
    self.keywordViewHeight.constant = keywordSize.height;
    self.addListViewHeight.constant = self.addListViewHeight.constant-keywordSize.height;
    [self checkItemTitleImage];
}

#pragma mark - text View delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    if(textView == self.listTitleView)
    {
        if([self.listTitleView.text isEqualToString:@"Enter list title"]){
            
            self.listTitleView.text = @"";
            //self.listTitleView.textColor = [UIColor darkGrayColor];
            
        }
    }else if (textView == self.listDescriptionView)
    {
        if([self.listDescriptionView.text isEqualToString:@"Enter list description"]){
            
            self.listDescriptionView.text = @"";
            //self.listTitleView.textColor = [UIColor darkGrayColor];
            
        }
        
    }else if (textView == self.keywordTxtView)
    {
        if([self.keywordTxtView.text isEqualToString:@"Enter a keyword"]){
            
            self.keywordTxtView.text = @"";
            //self.listTitleView.textColor = [UIColor darkGrayColor];
            
        }
        
    }else
    {
        if([self.addListDescription.text isEqualToString:@"Type your description (Optional)"]){
            
            self.addListDescription.text = @"";
            //self.listTitleView.textColor = [UIColor darkGrayColor];
            
        }
        
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if(textView == self.listTitleView)
    {
        if(self.listTitleView.text.length == 0){
            
            self.listTitleView.text = @"Enter list title";
            //self.listTitleView.textColor = Grey_COLOR;
            //self.listTitleView.hidden = YES;
        }
        
    }else if (textView == self.listDescriptionView)
    {
        if(self.listDescriptionView.text.length == 0){
            
            self.listDescriptionView.text = @"Enter list description";
            //self.listTitleView.textColor = [UIColor darkGrayColor];
            
        }
        
    }else if (textView == self.keywordTxtView)
    {
        if(self.keywordTxtView.text.length == 0){
            
            self.keywordTxtView.text = @"Enter a keyword";
            //self.listTitleView.textColor = [UIColor darkGrayColor];
            
        }
        
    }else
    {
        if(self.addListDescription.text.length == 0){
            
            self.addListDescription.text = @"Type your description (Optional)";
            //self.listTitleView.textColor = [UIColor darkGrayColor];
            
        }
    }
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView==self.addListDescription)
    {
//        NSInteger height =self.addListViewHeight.constant;
        self.itemDescriptionHeight.constant= [self.addListDescription intrinsicContentSize].height;
        if (self.image) {
            self.addListViewHeight.constant = self.itemDescriptionHeight.constant +870;
        } else {
            self.addListViewHeight.constant = self.itemDescriptionHeight.constant +750;
        }
        
        //NSLog(@"addListViewHeight %f itemDescriptionHeight %f",self.addListViewHeight.constant, self.itemDescriptionHeight.constant);
//        height=0;
    }
    if (textView==self.listDescriptionView)
    {
        //        NSInteger height =self.addListViewHeight.constant;
        self.listDescriptionHeight.constant= [self.listDescriptionView intrinsicContentSize].height;

        if (![coverImageView isHidden]) {
            self.listDetailHeight.constant = self.listDescriptionHeight.constant +550+[self.listTitleView intrinsicContentSize].height;
        } else {
          //  self.listDetailHeight.constant = self.listDescriptionHeight.constant +462+[self.listTitleView intrinsicContentSize].height;
            self.listDetailHeight.constant = self.listDescriptionHeight.constant +368+[self.listTitleView intrinsicContentSize].height;

        }
        

        //        height=0;
    }
    if (textView==self.listTitleView)
    {
        //        NSInteger height =self.addListViewHeight.constant;
        self.listTitleHeight.constant= [self.listTitleView intrinsicContentSize].height;
        
        if (![coverImageView isHidden])
        {
            coverImageView.frame = CGRectMake(self.addCoverImageBtn.frame.origin.x, self.addCoverImageBtn.frame.origin.y, coverImageView.frame.size.width, 200);
            self.listDetailHeight.constant = self.listDescriptionHeight.constant +550+[self.listTitleView intrinsicContentSize].height;
        } else {
            
            //NSLog(@"listDetailHeight- %f",self.listDetailHeight.constant);
            
            self.listDetailHeight.constant = self.listDescriptionHeight.constant +368+[self.listTitleView intrinsicContentSize].height;
            
            //NSLog(@"listDetailHeight- %f",self.listDetailHeight.constant);
        }
        
        
        
        //        height=0;
    }
    
    [self ValidateListTextView];
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [self textViewDidChange:self.listTitleView];
    //    });
    
}

- (void)textFieldDidChange:(UITextField *)textField
{
    [self checkItemTitleImage];
    
    if ([textField.text isEqualToString:@""])
    {
        [self.wikiSearchView setHidden:YES];
    } else
    {
        [self getWikiSearch:textField.text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.wikiSearchView setHidden:YES];
    return YES;
}

-(void)checkItemTitleImage
{
    if (![self.itemTitleView.text isEqualToString:@""]&&!(self.image==nil)&&keywordArray.count>0)
    {
        [self.listBtn setBackgroundColor:[UIColor colorWithRed:0.96 green:0.19 blue:0.24 alpha:1.0]];
        [self.listBtn setSelected:YES];
    }else
    {
        [self.listBtn setSelected:NO];
        [self.listBtn setBackgroundColor:[UIColor colorWithRed:0.71 green:0.72 blue:0.78 alpha:1.0]];
    }
    
}

-(void)ValidateListTextView
{
//    if ([self.selectFolderBtn.titleLabel.text isEqualToString:@"Select folder"]||[self.listTitleView.text isEqualToString:@"Enter list title"]||[self.listDescriptionView.text isEqualToString:@"Enter list description"])
if ([self.selectFolderBtn.titleLabel.text isEqualToString:@"Select folder"]||[self.listTitleView.text isEqualToString:@"Enter list title"])
    {
        [self.publishBtn setSelected:NO];
        [self.publishBtn setBackgroundColor:[UIColor colorWithRed:0.71 green:0.72 blue:0.78 alpha:1.0]];
    }
//    else if ([self.selectFolderBtn.titleLabel.text isEqualToString:@""]||[self.listTitleView.text isEqualToString:@""]||[self.listDescriptionView.text isEqualToString:@""])
    else if ([self.selectFolderBtn.titleLabel.text isEqualToString:@""]||[self.listTitleView.text isEqualToString:@""])
    {
        [self.publishBtn setSelected:NO];
        [self.publishBtn setBackgroundColor:[UIColor colorWithRed:0.71 green:0.72 blue:0.78 alpha:1.0]];
    }
    else if (listItemArray.count<1)
    {
        [self.publishBtn setSelected:NO];
        [self.publishBtn setBackgroundColor:[UIColor colorWithRed:0.71 green:0.72 blue:0.78 alpha:1.0]];
    }
     else
    {
        [self.publishBtn setSelected:YES];
        [self.publishBtn setBackgroundColor:[UIColor colorWithRed:0.96 green:0.19 blue:0.24 alpha:1.0]];
        
    }
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self textViewDidChange:self.listTitleView];
//    });
}

//-(void) textViewDidChange:(UITextView *)textView
//{
//
//    if(textView == _txtViewAddress)
//    {
//        if(_txtViewAddress.text.length == 0)
//        {
//            _addressTblView.hidden = true;
//            _txtViewAddress.textColor = Grey_COLOR;
//            _txtViewAddress.text = @"Enter list title";
//            [_txtViewAddress resignFirstResponder];
//        }
//        else{
//            [self SearchText:textView.text];
//        }
//    }
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)clearAlldata
{
    [keywordArray removeAllObjects];
    [listItemArray removeAllObjects];
    self.keywordViewHeight.constant = 0;
    self.listTableHeight.constant = 0;
    //[self.tabBarController.tabBar setHidden:NO];
    [self.tabBarController setSelectedIndex:0];
    listIDStr =@"0";
    itemIDStr =@"0";
    [self.selectFolderBtn setTitle:@"Select folder" forState:UIControlStateNormal];
    [self.listTitleView setText:@"Enter list title"];
    [self.listDescriptionView setText:@"Enter list description"];
    self.listDescriptionHeight.constant= 50;
    self.listDetailHeight.constant = 462;
    //vinay here-
    self.addCoverConstraint.constant = 55;
    [coverImageView setHidden:YES];
    [self.addCoverImageBtn setHidden:NO];
    self.listTitleHeight.constant =46;
    isForCoverImage =false;

}

-(void)editListLayout:(NSMutableDictionary*)dict
{
    if (![[dict valueForKey:@"Categoryname"] isEqual:[NSNull null]])
    {
        [self.selectFolderBtn setTitle:[dict valueForKey:@"Categoryname"] forState:UIControlStateNormal];
    }
    listIDStr = [[dict valueForKey:@"listid"] stringValue];
    self.listTitleView.text= [dict valueForKey:@"ListName"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
          [self textViewDidChange:self.listTitleView];
    });

    
    self.listDescriptionView.text= [dict valueForKey:@"listdescription"];
    [self textViewDidChange:self.listDescriptionView];
    
    folderDict =[[NSMutableDictionary alloc]initWithObjectsAndKeys:[dict valueForKey:@"Categoryname"], @"Categoryname",
    [dict valueForKey:@"Categoryid"],@"Categoryid", nil];
    strLenght = (int)_listTitleView.text.length;
    _characterLength.text = [NSString stringWithFormat:@"%i/30", strLenght];
    
    [coverImageView sd_setImageWithURL:[NSURL URLWithString:[dict valueForKey:@"CoverImage"]] placeholderImage:self.image options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image)
        {
            self.image =image;
            isForCoverImage = YES;
            [self createCoverImageView];
            //
            if (self.addCoverConstraint.constant<200) {
                self.addCoverConstraint.constant =200;
                self.listDetailHeight.constant =self.listDetailHeight.constant +200;
            }
        }
    }];

    
    [self addList];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target: self
                                   selector: @selector(callAfterSixtySecond:) userInfo: nil repeats: NO];
   

}

-(void)callAfterSixtySecond:(NSTimer*) t
{
    [self textViewDidChange:self.listTitleView];
    [self textViewDidChange:self.listDescriptionView];
    [self ValidateListTextView];
}

#pragma mark-Api methods

-(void)getCategorizedItem:(NSString*)category :(NSString*)itemname
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:category forKey:@"category"];
    [dict setObject:itemname forKey:@"itemname"];
    
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]CategorizedItems:^(id object)
     {
         NSLog(@"%@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             NSArray *editKeyWordArray;
             NSString *keywordStr = [[[object valueForKey:@"KeywordList"] objectAtIndex:0] valueForKey:@"keyword"];
             if (![keywordStr isEqualToString:@""]) {
                 editKeyWordArray  = [keywordStr componentsSeparatedByString:@","];
             }
             
             keywordArray = [[NSMutableArray alloc]initWithArray:editKeyWordArray];
             if (keywordArray.count>0)
             {
                 self.keywordViewHeight.constant = 50*keywordArray.count/4;
                 if (self.keywordViewHeight.constant<40) {
                     self.keywordViewHeight.constant =40;
                 }
                 self.addListViewHeight.constant = self.addListViewHeight.constant+self.keywordViewHeight.constant;
             }
             
             [_keywordView setShowsHorizontalScrollIndicator:NO];
             [_keywordView setShowsVerticalScrollIndicator:NO];
             
             [self setTagView:keywordArray];
             
             
         } else
         {
//             [self.keywordView removeAllTags];
//             self.keywordViewHeight.constant =0;
//             self.addListViewHeight.constant =850;
             CGSize keywordSize = self.keywordView.contentSize;
             self.keywordViewHeight.constant = keywordSize.height;
             self.addListViewHeight.constant = self.addListViewHeight.constant+keywordSize.height;
             
             
         }
         
         
         //[kAppDelegate hideProgressHUD];
         
         
         
     }
                                              onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
    
    
}

-(void)getWikiSearch:(NSString*)searchText
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"opensearch" forKey:@"action"];
    [dict setObject:searchText forKey:@"search"];
    [dict setObject:@"10" forKey:@"limit"];
    [dict setObject:@"0" forKey:@"namespace"];
    [dict setObject:@"json" forKey:@"format"];
    
    
    //NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]getWikiSearch:^(id object)
     {
         //NSLog(@"%@",object);
         
         //         self.wikiTextView.text = [[[[object valueForKey:@"query"] valueForKey:@"pages"] objectAtIndex:0] valueForKey:@"extract"];
         
         [self.wikiSearchView setHidden:NO];
         [self.CreateListView insertSubview:btnImageView belowSubview:self.wikiSearchView];
         wikiSearchArray = [[object objectAtIndex:1] mutableCopy];
         //searchWikiDescArray = [[object objectAtIndex:2] mutableCopy];
         [self.wikiSearhTableView reloadData];
         
         //[kAppDelegate hideProgressHUD];
         
         
         
     }
                                              onError:^(NSError *error)
     {
         NSLog(@"Error : %@",error);
     }params:dict];
    
    
}


-(void)category_list_detail:(NSString *)listId
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"userid"];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"ownerid"];
    [dict setObject:listId forKey:@"listId"];
    [dict setObject:@"1" forKey:@"offset"];
    
    //NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]category_list_detail:^(id object)
     {
         //NSLog(@"%@",object);
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             listItemArray = [[object valueForKey:@"item"] mutableCopy];
             NSMutableDictionary *editDict = [[[object valueForKey:@"Data"] objectAtIndex:0] mutableCopy];
             [self editListLayout:[Utility removeNullFromDictionary:editDict]];
             
             
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

-(void)Createlist:(NSString*)ispublished
{
    
    if ([self.selectFolderBtn.titleLabel.text isEqualToString:@"Select folder"])
    {
        [Utility showAlertMessage:nil message:@"Please select a folder."];
        
    } else if ([self.listTitleView.text isEqualToString:@"Enter list title"])
    {
        [Utility showAlertMessage:nil message:@"Please enter title."];
        
    }
    else if (!coverImageView.image)
        {
              [Utility showAlertMessage:nil message:@"Please Select List Cover."];
        }
else if (listItemArray.count<5 && [ispublished isEqualToString:@"Yes"])
        {
            [Utility showAlertMessage:nil message:@"A list must contain a minimum of 5 items to be published"];
        }
    else
    {
        
        NSMutableArray* itemArray = [listItemArray valueForKey:@"listitemId"];
        NSString *itemPriority =[itemArray componentsJoinedByString:@","];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"userid"];
        [dict setObject:[folderDict valueForKey:@"Categoryid"] forKey:@"categoryid"];
        [dict setObject:self.listTitleView.text forKey:@"listname"];
        [dict setObject:self.listDescriptionView.text forKey:@"listdescription"];
        
        NSString *userid =[NSString stringWithFormat:@"%@",[dict valueForKey:@"userid"]];
        
        if ([userid isEqualToString:@"107"])
        {
            [dict setObject:@"Yes" forKey:@"isfeaturedlist"];
        } else {
            [dict setObject:@"No" forKey:@"isfeaturedlist"];
        }
        
        [dict setObject:ispublished forKey:@"ispublished"];
        [dict setObject:listIDStr forKey:@"listid"];
        [dict setObject:itemPriority forKey:@"itempriorityArray"];
        //for height and width-
//        [dict setObject:@"341" forKey:@"width"];
//        [dict setObject:@"229" forKey:@"height"];
        
//        if (isForCoverImage) {
//           // cropController.customAspectRatio = CGSizeMake(341, 229);
//                    [dict setObject:@"341" forKey:@"width"];
//                    [dict setObject:@"229" forKey:@"height"];
//        } else {
//           // cropController.customAspectRatio = CGSizeMake(320, 568);
//                    [dict setObject:@"320" forKey:@"width"];
//                    [dict setObject:@"568" forKey:@"height"];
//        }

        
        
        
        NSLog(@"%@",dict);
        if (!coverImageView.image) {
            [[NetworkEngine sharedNetworkEngine]Createlist:^(id object)
                  {
                      NSLog(@"%@",object);
             
                      if ([[object valueForKey:@"status"] isEqualToString:@"success"])
                      {
                          NSString *msg;
                          if ([ispublished isEqualToString:@"Yes"]) {
                              msg = @"List Created Successsfully!";
                          } else {
                              msg = @"List Successsfully Saved in Draft!";
                          }
             
                          listIDStr = [[[object valueForKey:@"Data"] valueForKey:@"listid"] stringValue];
                          itemIDStr= @"0";
             
                          if ([self.listView isHidden])
                          {
                             [self clearAlldata];
             
                          }
             
             
             
             
             
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

        } else {
  
        NSString *filename = [NSString stringWithFormat:@"%ld%c%c.jpg", (long)[[NSDate date] timeIntervalSince1970], arc4random_uniform(26) + 'a', arc4random_uniform(26) + 'a'];
        
        NSLog(@"%@",dict);
        
        [[NetworkEngine sharedNetworkEngine]CreateListWithCover:^(id object)
         {
             NSLog(@"errekkjk %@",object);
             
             
             if ([[object valueForKey:@"status"] isEqualToString:@"success"])
                              {
                                  NSString *msg;
                                  if ([ispublished isEqualToString:@"Yes"]) {
                                      msg = @"List Created Successsfully!";
                                  } else {
                                      msg = @"List Successsfully Saved in Draft!";
                                  }
                 
                                  listIDStr = [[[object valueForKey:@"Data"] valueForKey:@"listid"] stringValue];
                                  itemIDStr= @"0";
                 
                                  if ([self.listView isHidden])
                                  {
                                      [self clearAlldata];
                 
                                  }
                 
                 
                 
                 
                 
                              } else
                              {
                                  [Utility showAlertMessage:nil message:[object valueForKey:@"Message"]];
                 
                 
                              }
             
                              [kAppDelegate hideProgressHUD];
             
             
         } onError:^(NSError *error)
         {
             NSLog(@"%@",error);
             [Utility showAlertMessage:nil message:@"internal server error! please try again later."];
         } filePath:filename imageName:coverImageView.image params:dict];
        
        }
        
    }
    
}


//-(void)Createlist:(NSString*)ispublished
//{
//
//    if ([self.selectFolderBtn.titleLabel.text isEqualToString:@"Select folder"])
//    {
//          [Utility showAlertMessage:nil message:@"Please select a folder."];
//
//    } else if ([self.listTitleView.text isEqualToString:@"Enter list title"])
//    {
//          [Utility showAlertMessage:nil message:@"Please enter title."];
//
//    }
////    else if ([self.listDescriptionView.text isEqualToString:@"Enter list description"])
////    {
////          [Utility showAlertMessage:nil message:@"Please enter list description."];
////    }
//    else
//    {
//
//    NSMutableArray* itemArray = [listItemArray valueForKey:@"listitemId"];
//    NSString *itemPriority =[itemArray componentsJoinedByString:@","];
//
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
//    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"userid"];
//    [dict setObject:[folderDict valueForKey:@"Categoryid"] forKey:@"categoryid"];
//    [dict setObject:self.listTitleView.text forKey:@"listname"];
//    [dict setObject:self.listDescriptionView.text forKey:@"listdescription"];
//    [dict setObject:@"No" forKey:@"isfeaturedlist"];
//    [dict setObject:ispublished forKey:@"ispublished"];
//    [dict setObject:listIDStr forKey:@"listid"];
//    [dict setObject:itemPriority forKey:@"itempriorityArray"];
//
//
//    NSLog(@"%@",dict);
//
//    [[NetworkEngine sharedNetworkEngine]Createlist:^(id object)
//     {
//         NSLog(@"%@",object);
//
//         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
//         {
//             NSString *msg;
//             if ([ispublished isEqualToString:@"Yes"]) {
//                 msg = @"List Created Successsfully!";
//             } else {
//                 msg = @"List Successsfully Saved in Draft!";
//             }
//
//             listIDStr = [[[object valueForKey:@"Data"] valueForKey:@"listid"] stringValue];
//             itemIDStr= @"0";
//
//             if ([self.listView isHidden])
//             {
//                [self clearAlldata];
//
//             }
//
//
//
//
//
//         } else
//         {
//             [Utility showAlertMessage:nil message:[object valueForKey:@"Message"]];
//
//
//         }
//
//         [kAppDelegate hideProgressHUD];
//
//
//
//     }
//                                               onError:^(NSError *error)
//     {
//         NSLog(@"Error : %@",error);
//     }params:dict];
//
//
//    }
//
//}

-(void)deleteList
{
    
    NSMutableArray *jsonArray = [[NSMutableArray alloc]init];
    NSMutableDictionary *dictID =[[NSMutableDictionary alloc]init];
    [dictID setObject:listIDStr forKey:@"listid"];
    [jsonArray addObject:dictID];

    
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
             

            [self clearAlldata];

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

-(void)CreatelistItem
{
    
    [kAppDelegate showProgressHUD];
    
    if ([itemIDStr isEqualToString:@"0"])
    {
        NSString *trimmedKeyword = [self.itemTitleView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        trimmedKeyword = [trimmedKeyword stringByReplacingOccurrencesOfString:@"." withString:@""];
        [keywordArray addObject:trimmedKeyword];
        
//        NSString *trimmedKeyword1 = [self.selectFolderBtn.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//        trimmedKeyword1 = [trimmedKeyword1 stringByReplacingOccurrencesOfString:@"." withString:@""];
//        [keywordArray addObject:trimmedKeyword1];
    }
   
    
    //[keywordArray addObject:self.selectFolderBtn.titleLabel.text];
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:keywordArray];
    NSArray *arrayWithoutDuplicates = [orderedSet array];
    NSString *keywordStr =[arrayWithoutDuplicates componentsJoinedByString:@","];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"userId"];
    [dict setObject:listIDStr forKey:@"listid"];
    [dict setObject:self.itemTitleView.text forKey:@"listItemname"];
    [dict setObject:self.itemUrlField.text forKey:@"url"];
    
    if ([self.addListDescription.text isEqualToString:@"Type your description (Optional)"]) {
        [dict setObject:@"" forKey:@"description"];
    } else
    {
        [dict setObject:self.addListDescription.text forKey:@"description"];
    }
    
    
    [dict setObject:keywordStr forKey:@"keyword"];
    [dict setObject:itemIDStr forKey:@"Itemid"];
    
    if ([self.wikiSwitch isOn])
    {
        [dict setObject:[wikiArray objectAtIndex:0] forKey:@"wikidescription"];
    } else {
        [dict setObject:@"" forKey:@"wikidescription"];
    }
    
    NSString *filename = [NSString stringWithFormat:@"%ld%c%c.jpg", (long)[[NSDate date] timeIntervalSince1970], arc4random_uniform(26) + 'a', arc4random_uniform(26) + 'a'];
    
    NSLog(@"%@",dict);
    
    [[NetworkEngine sharedNetworkEngine]CreateListItem:^(id object)
     {
         //NSLog(@"errekkjk %@",object);
         
         
         if ([[object valueForKey:@"status"] isEqualToString:@"success"])
         {
             if (![itemIDStr isEqualToString:@"0"])
             {
                 [listItemArray replaceObjectAtIndex:ItemIndex withObject:[object valueForKey:@"Data"]];
             } else
             {
                 [listItemArray addObject:[object valueForKey:@"Data"]];
             }
             
            
             if (coverImageView.image)
             {
                 isForCoverImage = YES;
             }
            [btnImageView setHidden:YES];
            [self.listView setHidden:YES];
            [self.view endEditing:YES];
            [self addList];
             
         } else
         {
             [Utility showAlertMessage:nil message:[object valueForKey:@"Message"]];
             
             
         }
         
         [kAppDelegate hideProgressHUD];
         
         
     } onError:^(NSError *error)
     {
         NSLog(@"%@",error);
         [Utility showAlertMessage:nil message:@"internal server error! please try again later."];
     } filePath:filename imageName:_image params:dict];
    
    
}

-(void)DeletelistItem:(NSString *)itemID
{
    
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:itemID forKey:@"listitemid"];
        [dict setObject:[[USERDEFAULTS valueForKey:kuserID] stringValue] forKey:@"ownerid"];
        
        //NSLog(@"%@",dict);
        
        [[NetworkEngine sharedNetworkEngine]DeletelistItem:^(id object)
         {
             //NSLog(@"%@",object);
             
             if ([[object valueForKey:@"status"] isEqualToString:@"success"])
             {

                 
                 
             } else
             {
                 [Utility showAlertMessage:nil message:[object valueForKey:@"Message"]];
                 
                 
             }
             
            // [kAppDelegate hideProgressHUD];
             
             
             
         }
                                               onError:^(NSError *error)
         {
             NSLog(@"Error : %@",error);
         }params:dict];
        
        
    }



#pragma mark tableview methods--

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==_wikiSearhTableView)
    {
        return wikiSearchArray.count;
    }
    return listItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    if (tableView==_wikiSearhTableView) {
        //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
        
        static NSString *simpleTableIdentifier = @"SimpleTableItem";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        cell.textLabel.text = wikiSearchArray[indexPath.row];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont fontWithName:@"SFProText-Regular" size:12];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.textColor =  [UIColor blackColor];
        cell.backgroundColor = [UIColor whiteColor];
        
        return cell;
    }
    static NSString *propertyIdentifier = @"FeaturedListCell";
    
    FeaturedListCell *cell = (FeaturedListCell *)[tableView dequeueReusableCellWithIdentifier:propertyIdentifier];
    
    
    if (cell == nil)
    {
        
        NSArray *nib1 = [[NSBundle mainBundle] loadNibNamed:@"FeaturedListCell" owner:self options:nil];
        cell = [nib1 objectAtIndex:1];
    }
    
    [cell.linkView setHidden:NO];
    
    NSString *urlStr = [[listItemArray objectAtIndex:indexPath.row] valueForKey:@"url"];
    if (urlStr.length>0) {
        [cell.linkImage setImage:[UIImage imageNamed:@"link_red"]];
    }
    
    
    
    if (![[listItemArray objectAtIndex:indexPath.row] valueForKey:@"Owernerid"]||[[[listItemArray objectAtIndex:indexPath.row] valueForKey:@"Owernerid"] isEqualToString:[[USERDEFAULTS valueForKey:kuserID] stringValue]])
    {
        [cell.changePicBtn setHidden:NO];
        cell.changePicBtn.tag = indexPath.row;
        [cell.changePicBtn addTarget:self action:@selector(editListItem:) forControlEvents:UIControlEventTouchUpInside];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    
    cell.featuredListNamelbl.text = [[listItemArray objectAtIndex:indexPath.row] valueForKey:@"listname"];
    [cell.listImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[listItemArray objectAtIndex:indexPath.row] valueForKey:@"Imageurl"]]] placeholderImage:self.image options:0 progress:nil completed:nil];
    cell.listImageView.clipsToBounds = YES;
    cell.listImageView.layer.cornerRadius = 4;
   // cell.listImageView.image =[UIImage imageNamed:[listImageArray objectAtIndex:indexPath.row]];
    //    cell.iconImage.image = [UIImage imageNamed:[iconImageArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    
//    if (listItemArray.count>0&&[[[listItemArray objectAtIndex:indexPath.row] valueForKey:@"Owernerid"] isEqualToString:[[USERDEFAULTS valueForKey:kuserID] stringValue]])
//    {
//        return YES;
//    }
//    if (![[listItemArray objectAtIndex:indexPath.row] valueForKey:@"Owernerid"])
//    {
//         return YES;
//    }
    if (tableView==self.wikiSearhTableView)
    {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [self DeletelistItem:[[listItemArray objectAtIndex:indexPath.row] valueForKey:@"listitemId"]];
        [listItemArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self addList];
        
    }
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSMutableDictionary *sourceDict = [listItemArray objectAtIndex:sourceIndexPath.row];
    [listItemArray removeObjectAtIndex:sourceIndexPath.row];
    [listItemArray insertObject:sourceDict atIndex:destinationIndexPath.row];
    
    [self.listTable reloadData];
    //NSLog(@"%@",listItemArray);
    
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@" is moving");
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.wikiSearhTableView)
    {
        [self.wikiSearchView setHidden:YES];
        self.itemTitleView.text = [wikiSearchArray objectAtIndex:indexPath.row];
        //[NSString stringWithFormat:@"%@",[folderDict valueForKey:@"Categoryname"]]
        [self getCategorizedItem:[folderDict valueForKey:@"Categoryname"] :self.itemTitleView.text];
    }
 
}

-(void)editListItem:(UIButton*)sender
{
    [self.wikiSearchView setHidden:YES];
    [self.listView setHidden:NO];
    UIScrollView *myscroll = [self.view viewWithTag:100];
    [myscroll setContentOffset:CGPointMake(0,0) animated:NO];
    [wikiArray removeAllObjects];
    
    NSMutableDictionary *editDict = [listItemArray objectAtIndex:[sender tag]];
    //NSLog(@"%@", editDict);
    if (![[editDict valueForKey:@"wikidescription"] isEqualToString:@""]) {
        [self.wikiSwitch setOn:YES];
        [wikiArray addObject:[editDict valueForKey:@"wikidescription"]];
    } else {
        [self.wikiSwitch setOn:NO];
    }
    
    itemIDStr= [[editDict valueForKey:@"listitemId"] stringValue];
    self.itemTitleView.text =[editDict valueForKey:@"listname"];
    self.itemUrlField.text =[editDict valueForKey:@"url"];
    
    if ([[editDict valueForKey:@"Description"] isEqualToString:@""])
    {
        self.addListDescription.text =@"Type your description (Optional)";
    } else {
        self.addListDescription.text =[editDict valueForKey:@"Description"];
    }
    
    
    
    NSArray *editKeyWordArray;
    if (![[editDict valueForKey:@"keyword"] isEqualToString:@""]) {
       editKeyWordArray  = [[editDict valueForKey:@"keyword"] componentsSeparatedByString:@","];
    }

    keywordArray = [[NSMutableArray alloc]initWithArray:editKeyWordArray];
    if (keywordArray.count>0)
    {
        CGSize keywordSize = self.keywordView.contentSize;
        self.keywordViewHeight.constant = 50*keywordArray.count/4;
        if (self.keywordViewHeight.constant<40) {
            self.keywordViewHeight.constant =40;
        }
        self.addListViewHeight.constant = self.addListViewHeight.constant+self.keywordViewHeight.constant;
    }
    
    [_keywordView setShowsHorizontalScrollIndicator:NO];
    [_keywordView setShowsVerticalScrollIndicator:NO];
    
    [self setTagView:keywordArray];
    self.keywordTxtView.text =@"Enter a keyword";
    [btnImageView setHidden:NO];
    NSIndexPath *myIP = [NSIndexPath indexPathForRow:[sender tag] inSection:0] ;
    FeaturedListCell *cell = [self.listTable cellForRowAtIndexPath:myIP];
    [btnImageView setImage:cell.listImageView.image];
    self.image = btnImageView.image;
    [self createImageView];
    self.addListImage.constant =200;
    self.addListViewHeight.constant = self.addListViewHeight.constant +self.addListImage.constant;
    [self checkItemTitleImage];
    ItemIndex = [sender tag];
    
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewCellEditingStyleNone;
//}

- (IBAction)addListAction:(id)sender
{
//    self.keywordViewHeight.constant = 0;
    [self.wikiSearchView setHidden:YES];
    UIScrollView *myscroll = [self.view viewWithTag:100];
    [myscroll setContentOffset:CGPointMake(0,0) animated:NO];
    [self.wikiSwitch setOn:NO];
    [wikiArray removeAllObjects];
    
    if ([listIDStr isEqualToString:@"0"])
    {

        
        if ([self.selectFolderBtn.titleLabel.text isEqualToString:@"Select folder"])
        {
            [Utility showAlertMessage:nil message:@"Please select a folder."];
            
        } else if ([self.listTitleView.text isEqualToString:@"Enter list title"])
        {
            [Utility showAlertMessage:nil message:@"Please enter list title."];
            
        }
        else if (!coverImageView.image)
        {
            [Utility showAlertMessage:nil message:@"Please Select List Cover."];
        }
        else
        {
            [self.listView setHidden:NO];
            [self Createlist:@"No"];
        }
        
    } else
    {
        [self.listView setHidden:NO];
        itemIDStr= @"0";
        [self.view endEditing:YES];
        
//        if ([USERDEFAULTS valueForKey:showTutorial]==nil)
//        {
//            [USERDEFAULTS setObject:@"showTutorial" forKey:showTutorial];
//            TutorialViewController *listTutorial =[self.storyboard instantiateViewControllerWithIdentifier:@"TutorialViewController"];
//            [self.navigationController pushViewController:listTutorial animated:NO];
//        }
        

    }

    [self setItemLayout];
}

-(void)setItemLayout
{
    //    self.addListViewHeight.constant = self.addListViewHeight.constant-self.keywordViewHeight.constant;
    [self.view endEditing:YES];
    keywordArray = [[NSMutableArray alloc]init];
    self.itemTitleView.text =@"";
    self.addListDescription.text =@"Type your description (Optional)";
    CGSize keywordSize = self.keywordView.contentSize;
    self.keywordViewHeight.constant = keywordSize.height;
    self.addListViewHeight.constant = 748+keywordSize.height;
    //self.keywordViewHeight.constant = 0;
    self.listItembottumConstant.constant = 0;
    self.itemUrlField.text = @"";
    self.keywordTxtView.text = @"Enter a keyword";
    [btnImageView setHidden:YES];
    [btnImageView setImage:nil];
    self.image = nil;
    [self.addImageBtn setTitle:@"Add an image" forState:UIControlStateNormal];
    
    self.CreateListView.layer.cornerRadius = 4;
    self.CreateListView.layer.masksToBounds = YES;
    
    self.addImageBtn.layer.cornerRadius = 6;
    self.addImageBtn.layer.masksToBounds = YES;
    
    self.addCoverImageBtn.layer.cornerRadius = 6;
    self.addCoverImageBtn.layer.masksToBounds = YES;
    
    self.listBtn.layer.cornerRadius = 4;
    self.listBtn.layer.masksToBounds = YES;
    
    //    [self setTagView];
    self.addListImage.constant =55;
    //vinay here-
    NSString *trimmedKeyword = [self.selectFolderBtn.titleLabel.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    trimmedKeyword = [trimmedKeyword stringByReplacingOccurrencesOfString:@"." withString:@""];
    [keywordArray addObject:trimmedKeyword];
    [self setTagView:keywordArray];
    self.keywordViewHeight.constant=40;
    
    
     [self checkItemTitleImage];
    
}

- (IBAction)cancelBtnAction:(id)sender
{

//    if ([listIDStr isEqualToString:@"0"])
//    {
        [self clearAlldata];
//
//    } else
//    {
//        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Listy!"
//                                                                      message:@"You have unsaved changes, would you like to save them as draft?"
//                                                               preferredStyle:UIAlertControllerStyleAlert];
//
//        UIAlertAction* DeleteButton = [UIAlertAction actionWithTitle:@"No, Delete"
//                                                               style:UIAlertActionStyleDefault
//                                                             handler:^(UIAlertAction * action)
//                                       {
//                                             [self deleteList];
//                                             [self setLayout];
//
//                                       }];
//        UIAlertAction* SaveButton =     [UIAlertAction actionWithTitle:@"Yes, Save as draft"
//                                                                 style:UIAlertActionStyleDefault
//                                                               handler:^(UIAlertAction * action)
//                                         {
//                                             [self clearAlldata];
//                                             [self setLayout];
//
//                                         }];
//
//        UIAlertAction* CancelButton =     [UIAlertAction actionWithTitle:@"Cancel"
//                                                                 style:UIAlertActionStyleDefault
//                                                               handler:^(UIAlertAction * action)
//                                         {
//
//
//                                         }];
//
//        [alert addAction:DeleteButton];
//        [alert addAction:SaveButton];
//        [alert addAction:CancelButton];
//
//        [self presentViewController:alert animated:YES completion:nil];
//    }
    


}
- (IBAction)tapguesture:(id)sender
{
    [self.listView setHidden:YES];
    [self.view endEditing:YES];
}
- (IBAction)createListItem:(id)sender
{
    
    if ([self.listBtn isSelected])
    {
        [self CreatelistItem];
        [self.addImageBtn setTitle:@"Add an image" forState:UIControlStateNormal];
        
    }

}
- (IBAction)addListImageAction:(id)sender
{
   //self.addListViewHeight.constant = 520;
//   self.addListImage.constant =300;
//   self.addListViewHeight.constant = self.addListViewHeight.constant +self.addListImage.constant;
    
    
//    UIPasteboard *pb = [UIPasteboard generalPasteboard];
//    NSString *str = [pb string];
//
//    NSLog(@"%@",str);
//    UIImageView *btnImage = [[UIImageView alloc]init];;
//    [btnImage sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        [self.addImageBtn setBackgroundImage:image forState:UIControlStateNormal];
//         [self.addImageBtn setTitle:@"" forState:UIControlStateNormal];
//
//        if (self.addListImage.constant<200) {
//            self.addListImage.constant =200;
//            self.addListViewHeight.constant = self.addListViewHeight.constant +self.addListImage.constant;
//        }
//
//
//        NSLog(@"%@",btnImage.image);
//    }];
    
    if ([sender tag]==101)
    {
        isForCoverImage =true;
    } else {
        isForCoverImage =false;
    }
    
    [self showCropViewController];
}

#pragma mark - Image Picker Delegate -
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:self.croppingStyle image:image];
    cropController.delegate = self;
    
    cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPresetCustom;
    
    //cropController.customAspectRatio = CGSizeMake(320, 320);
    if (isForCoverImage)
    {
        cropController.customAspectRatio = CGSizeMake(341, 229);
    } else
    {
        cropController.customAspectRatio = CGSizeMake(320, 568);
    }
    //Set the initial aspect ratio as a square
    cropController.aspectRatioLockEnabled = YES; // The crop box is locked to the aspect ratio and can't be resized away from it
    cropController.resetAspectRatioEnabled = NO; // When tapping 'reset', the aspect ratio will NOT be reset back to default
    
    self.image = image;
    [self addImageToButton:image];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self presentViewController:cropController animated:YES completion:nil];
        //[self.navigationController pushViewController:cropController animated:YES];
    }];
    //    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.addImageBtn setTitle:@"Add an image" forState:UIControlStateNormal];
    
//    if ([coverImageView isHidden]) {
//        //isForCoverImage = false;
//        self.addCoverConstraint.constant =55;
//    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Image Layout -
- (void)layoutImageView
{
    if (self.imageView.image == nil)
        return;
    
    CGFloat padding = 20.0f;
    
    CGRect viewFrame = self.view.bounds;
    viewFrame.size.width -= (padding * 2.0f);
    viewFrame.size.height -= ((padding * 2.0f));
    
    CGRect imageFrame = CGRectZero;
    imageFrame.size = self.imageView.image.size;
    
    if (self.imageView.image.size.width > viewFrame.size.width ||
        self.imageView.image.size.height > viewFrame.size.height)
    {
        CGFloat scale = MIN(viewFrame.size.width / imageFrame.size.width, viewFrame.size.height / imageFrame.size.height);
        imageFrame.size.width *= scale;
        imageFrame.size.height *= scale;
        imageFrame.origin.x = (CGRectGetWidth(self.view.bounds) - imageFrame.size.width) * 0.5f;
        imageFrame.origin.y = (CGRectGetHeight(self.view.bounds) - imageFrame.size.height) * 0.5f;
        self.imageView.frame = imageFrame;
    }
    else {
        self.imageView.frame = imageFrame;
        self.imageView.center = (CGPoint){CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)};
    }
}


#pragma mark - Bar Button Items -
- (void)showCropViewController
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Open Gallery", @"")
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              self.croppingStyle = TOCropViewCroppingStyleDefault;
                                                              
                                                              UIImagePickerController *standardPicker = [[UIImagePickerController alloc] init];
                                                              standardPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                              standardPicker.allowsEditing = NO;
                                                              standardPicker.delegate = self;
                                                              [self presentViewController:standardPicker animated:YES completion:nil];
                                                          }];
    
    UIAlertAction *profileAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Camera", @"")
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              self.croppingStyle = TOCropViewCroppingStyleDefault;
                                                              
                                                              UIImagePickerController *profilePicker = [[UIImagePickerController alloc] init];
                                                              profilePicker.modalPresentationStyle = UIModalPresentationPopover;
                                                              profilePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                              profilePicker.allowsEditing = NO;
                                                              profilePicker.delegate = self;
                                                              profilePicker.preferredContentSize = CGSizeMake(512,512);
                                                          profilePicker.popoverPresentationController.barButtonItem = self.navigationItem.leftBarButtonItem;
                                                              [self presentViewController:profilePicker animated:YES completion:nil];
                                                          }];
    
    //vinay here-
    UIAlertAction* googleBtn = [UIAlertAction actionWithTitle:@"Search on web"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                {
                                    //[self click_camera];
                                    WebViewController *webView = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
                                    //[folderDict valueForKey:@"Categoryname"]
                                    if (isForCoverImage)
                                    {
                                         webView.titleListItem = [NSString stringWithFormat:@"%@",[folderDict valueForKey:@"Categoryname"]];
                                    } else {
                                         webView.titleListItem = [NSString stringWithFormat:@"%@",self.itemTitleView.text];
                                    }
                                   
                                    //NSLog(@"%@",webView.titleListItem);
                                    
                                    [self.navigationController pushViewController:webView animated:YES];
                                }];
    UIAlertAction* CancelBtn = [UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                {
                                    if (!coverImageView.image)
                                    {
                                        isForCoverImage =false;
                                    }
                                }];
    
    [alertController addAction:googleBtn];
    [alertController addAction:defaultAction];
    [alertController addAction:profileAction];
    [alertController addAction:CancelBtn];
    [alertController setModalPresentationStyle:UIModalPresentationPopover];
    
    UIPopoverPresentationController *popPresenter = [alertController popoverPresentationController];
    popPresenter.barButtonItem = self.navigationItem.leftBarButtonItem;
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Cropper Delegate -
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    NSLog(@"Crop Image in new List");
    self.croppedFrame = cropRect;
    self.angle = angle;
    [self updateImageViewWithImage:image fromCropViewController:cropViewController];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToCircularImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    self.croppedFrame = cropRect;
    self.angle = angle;
    [self updateImageViewWithImage:image fromCropViewController:cropViewController];
}

- (void)updateImageViewWithImage:(UIImage *)image fromCropViewController:(TOCropViewController *)cropViewController
{
    self.imageView.image = image;
    [self addImageToButton:image];
    [self layoutImageView];
    
    if (isForCoverImage)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self textViewDidChange:self.listTitleView];
        });
    }
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    if (cropViewController.croppingStyle != TOCropViewCroppingStyleCircular) {
        self.imageView.hidden = YES;
        [cropViewController dismissAnimatedFromParentViewController:self
                                                   withCroppedImage:image
                                                             toView:self.imageView
                                                            toFrame:CGRectZero
                                                              setup:^{ [self layoutImageView]; }
                                                         completion:
         ^{
             self.imageView.hidden = NO;
         }];
    }
    else {
        
        self.imageView.hidden = NO;
        [cropViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled NS_SWIFT_NAME(cropViewController(_:didFinishCancelled:))
{
//    if (isForCoverImage)
//    {
//        isForCoverImage= false;
//    }
    
    if ([coverImageView isHidden]) {
        //isForCoverImage = false;
        self.addCoverConstraint.constant =55;
    }
    [cropViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)selectFolderAction:(id)sender
{
    MyFolderViewController *myfolder = [self.storyboard instantiateViewControllerWithIdentifier:@"navigationController"];
    [self presentViewController:myfolder animated:YES completion:nil];
}
- (IBAction)publishListAction:(id)sender
{
    if ([self.publishBtn isSelected]) {
        [self Createlist:@"Yes"];
    }

}

- (IBAction)saveListDraftAction:(id)sender
{
//    if (listItemArray.count<1)
//    {
//        [Utility showAlertMessage:nil message:@"Please create any list item to save list as a draft."];
//    } else
    {
        [self Createlist:@"No"];
    }
    
}
- (IBAction)addKeywordAction:(id)sender
{
    [self addKeyword];
}
-(void)addKeyword
{
    
    if ([self.keywordTxtView.text isEqualToString:@""] ||[self.keywordTxtView.text isEqualToString:@"Enter a keyword"])
    {
        [Utility showAlertMessage:nil message:@"Enter a keyword"];
    } else {
        
        //romve white space from start and end
        NSString *trimmedKeyword = [self.keywordTxtView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        trimmedKeyword = [trimmedKeyword stringByReplacingOccurrencesOfString:@"." withString:@""];
        [keywordArray addObject:trimmedKeyword];
        [self setTagView:keywordArray];
        
//        if (self.keywordViewHeight.constant>=40)
//        {
//
//            if (keywordArray.count%4==0)
//            {
//                self.keywordViewHeight.constant = self.keywordViewHeight.constant+40;
//                self.addListViewHeight.constant = self.addListViewHeight.constant+40;
//            }
//
//        } else {
//            self.keywordViewHeight.constant = 40;
//            self.addListViewHeight.constant = self.addListViewHeight.constant+40;
//        }
        
        //vinay here-
        CGSize keywordSize = self.keywordView.contentSize;
        self.keywordViewHeight.constant = keywordSize.height;
        self.addListViewHeight.constant = self.addListViewHeight.constant+keywordSize.height;
         self.keywordTxtView.text = @"Enter a keyword";
        [self.view endEditing:YES];
        
    }
    [self checkItemTitleImage];
   // self.keywordTxtView.text =@"";
   
}
-(void)addKeywordWithoutPopup
{

        //romve white space from start and end
    if (![self.keywordTxtView.text isEqualToString:@"Enter a keyword"])
    {
        NSString *trimmedKeyword = [self.keywordTxtView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        trimmedKeyword = [trimmedKeyword stringByReplacingOccurrencesOfString:@"." withString:@""];
        [keywordArray addObject:trimmedKeyword];
        [self setTagView:keywordArray];
        
//        if (self.keywordViewHeight.constant>=40)
//        {
//
//            if (keywordArray.count%4==0)
//            {
//                self.keywordViewHeight.constant = self.keywordViewHeight.constant+40;
//                self.addListViewHeight.constant = self.addListViewHeight.constant+40;
//            }
//
//        } else {
//            self.keywordViewHeight.constant = 40;
//            self.addListViewHeight.constant = self.addListViewHeight.constant+40;
//        }
        CGSize keywordSize = self.keywordView.contentSize;
        self.keywordViewHeight.constant = keywordSize.height;
        self.addListViewHeight.constant = self.addListViewHeight.constant+keywordSize.height;
        self.keywordTxtView.text = @"Enter a keyword";
    }


    [self checkItemTitleImage];
    //self.keywordTxtView.text =@"";
}

- (IBAction)cancelListItem:(id)sender
{
    [self.listView setHidden:YES];
    [self setItemLayout];
}
- (IBAction)viewFromWikiAction:(id)sender
{
//    WikiDescriptionViewController *wikiDesc = [self.storyboard instantiateViewControllerWithIdentifier:@"WikiDescriptionViewController"];
//    wikiDesc.wikiDescArray = wikiArray;
//    wikiDesc.titleStr = self.itemTitleView.text;
//    [self presentViewController:wikiDesc animated:YES completion:nil];
}
-(void)goToWikiDesc
{
        WikiDescriptionViewController *wikiDesc = [self.storyboard instantiateViewControllerWithIdentifier:@"WikiDescriptionViewController"];
        wikiDesc.wikiDescArray = wikiArray;
    //[folderDict valueForKey:@"Categoryname"]
        wikiDesc.titleStr = [NSString stringWithFormat:@"%@",self.itemTitleView.text];
        [self presentViewController:wikiDesc animated:YES completion:nil];
    
}
- (IBAction)switchValueChanged:(id)sender
{
    if ([self.wikiSwitch isOn])
    {
        [self.wikiSwitch setOn:YES];
        [self goToWikiDesc];
    }
    
}
@end
