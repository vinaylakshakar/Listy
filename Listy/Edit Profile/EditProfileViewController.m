//
//  EditProfileViewController.m
//  Listy
//
//  Created by Silstone on 27/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "EditProfileViewController.h"
#import "Listy.pch"

@interface EditProfileViewController ()
{
    NSMutableDictionary *userprofileinfo;
    NSString *imageType;
}

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    imageType =@"profileImage";
    // Do any additional setup after loading the view.
    //self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2;
    [self setRoundedView:self.profileImage toDiameter:111];
    _profileImage.clipsToBounds = YES;
    _coverImage.clipsToBounds= YES;
    [self setLayout];
}

-(void)setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)setLayout
{
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        if ((int)[[UIScreen mainScreen] nativeBounds].size.height>=2436) {
            self.topProfileConstraint.constant = self.topProfileConstraint.constant+20;
        }
        
    }
    
    userprofileinfo = [USERDEFAULTS valueForKey:kuserProfileDict];
    //NSLog(@"userprofileinfo %@",userprofileinfo);
    self.nameField.text = [userprofileinfo valueForKey:@"Name"];
    self.usernameField.text = [userprofileinfo valueForKey:@"UserName"];
    self.locationField.text = [userprofileinfo valueForKey:@"Location"];
    self.aboutField.text = [userprofileinfo valueForKey:@"About"];
    self.aboutLable.text = [NSString stringWithFormat:@"About %@",[userprofileinfo valueForKey:@"UserName"]];
    
    [self.profileImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[userprofileinfo valueForKey:@"UserProfileImages"]]] placeholderImage:[UIImage imageNamed:@"user_profile"] options:0 progress:nil completed:nil];
    [self.coverImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[userprofileinfo valueForKey:@"CoveredProfileImages"]]] placeholderImage:[UIImage imageNamed:@"profile_background"] options:0 progress:nil completed:nil];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return textView.text.length + (text.length - range.length) <= 150;
}

#pragma mark - text View delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    if(textView == self.aboutField)
    {
        if([self.aboutField.text isEqualToString:@"About Yourself"]){
            
            self.aboutField.text = @"";
            //self.listTitleView.textColor = [UIColor darkGrayColor];
            
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if(textView == self.aboutField)
    {
        if(self.aboutField.text.length == 0){
            
            self.aboutField.text = @"About Yourself";
            //self.listTitleView.textColor = Grey_COLOR;
            //self.listTitleView.hidden = YES;
        }
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
#pragma mark-Api methods


-(void)UpdateUserInfo
{
    
    [kAppDelegate showProgressHUD];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[USERDEFAULTS valueForKey:kuserID] forKey:@"Userid"];
    [dict setObject:self.nameField.text forKey:@"Name"];
    [dict setObject:self.usernameField.text forKey:@"UserName"];
    [dict setObject:self.locationField.text forKey:@"Location"];
    [dict setObject:[userprofileinfo valueForKey:@"email"] forKey:@"Email"];
    [dict setObject:self.aboutField.text forKey:@"About"];
    [dict setObject:imageType forKey:@"imageType"];
    
    NSString *filename = [NSString stringWithFormat:@"%ld%c%c.jpg", (long)[[NSDate date] timeIntervalSince1970], arc4random_uniform(26) + 'a', arc4random_uniform(26) + 'a'];
    
    //NSLog(@"%@",dict);
    
    if (isChooseImage==NO)
    {
         imageOriginal = self.profileImage.image;
    }
    
        [[NetworkEngine sharedNetworkEngine]UpdateUserInfo:^(id object)
         {
             //NSLog(@"errekkjk %@",object);
             
             
             if ([[object valueForKey:@"status"] isEqualToString:@"success"])
             {
                 [self.navigationController popToRootViewControllerAnimated:YES];
                 
             } else
             {
                 [Utility showAlertMessage:nil message:[object valueForKey:@"Message"]];
                 
                 
             }
             
             [kAppDelegate hideProgressHUD];
             
             
         } onError:^(NSError *error)
         {
             NSLog(@"%@",error);
         } filePath:filename imageName:imageOriginal params:dict];

    
}

-(void)showActionsheetAlert
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Select Image Options" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Open Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self click_gallery];
        
    }]];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            // Distructive button tapped.
        [self click_camera];
    }]];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // OK button tapped.
        
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}


-(void)click_camera
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        UIColor* color = [UIColor colorWithRed:46.0/255 green:127.0/255 blue:244.0/255 alpha:1];
        [imgPicker.navigationBar setTintColor:color];
        imgPicker.delegate = self;
        imgPicker.allowsEditing = YES;
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imgPicker animated:NO completion:Nil];
    }
    else
    {
        [Utility showAlertMessage:nil message:@"Device does not support camera"];
    }
}

-(void)click_gallery
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *imgPicker= [[UIImagePickerController alloc] init];
        UIColor* color = [UIColor colorWithRed:46.0/255 green:127.0/255 blue:244.0/255 alpha:1];
        [imgPicker.navigationBar setTintColor:color];
        imgPicker.delegate = self;
        imgPicker.allowsEditing = YES;
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imgPicker animated:NO completion:Nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    imageOriginal =  [info objectForKey:UIImagePickerControllerEditedImage];
    
    imgData=UIImageJPEGRepresentation(imageOriginal,0.5);
    
    if (click_reg==YES)
    {
        click_reg=NO;
        
        if (picker.sourceType==UIImagePickerControllerSourceTypeCamera)
        {
            
            if ([imageType isEqualToString:@"profileImage"])
            {
                _profileImage.image=imageOriginal;
            } else {
                _coverImage.image=imageOriginal;
            }
            
        }
        else
        {
            if ([imageType isEqualToString:@"profileImage"])
            {
                _profileImage.image=imageOriginal;
            } else {
                _coverImage.image=imageOriginal;
            }
            
        }
    }
    else
    {
        if (picker.sourceType==UIImagePickerControllerSourceTypeCamera)
        {
            if ([imageType isEqualToString:@"profileImage"])
            {
                _profileImage.image=imageOriginal;
            } else {
                _coverImage.image=imageOriginal;
            }
        }
        else
        {
            if ([imageType isEqualToString:@"profileImage"])
            {
                _profileImage.image=imageOriginal;
            } else {
                _coverImage.image=imageOriginal;
            }
            
        }
    }
    isChooseImage=YES;
    [picker dismissViewControllerAnimated:YES completion:Nil];
    [self UpdateUserInfo];
    
}

- (IBAction)backBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)changeProfileImage:(id)sender
{
    imageType =@"profileImage";
    [self showActionsheetAlert];
}
- (IBAction)changeCoverImage:(id)sender
{
    imageType =@"coverImage";
    [self showActionsheetAlert];
}
- (IBAction)updateProfileAction:(id)sender
{
    LoginProcess *sharedManager = [LoginProcess sharedManager];
    bool usernameValidate = [sharedManager usernameValidate:self.usernameField];
    
     if ([self.usernameField.text hasPrefix:@"Kraken"])
    {

        [Utility showAlertMessage:nil message:@"Please Select Valid UserName."];

    }
    else
    if (self.usernameField.text.length<5||self.usernameField.text.length>32)
     {
         
         [Utility showAlertMessage:nil message:@"UserName Must be a minimum of 5 characters and a maximum 32 characters."];
         
     }
    else if ((!usernameValidate && ![[self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqual: @""])||[self.nameField.text isEqualToString:self.usernameField.text])
    {
        
        [Utility showAlertMessage:nil message:@"'Username's should be alphanumeric and different to your account name'"];
        
    }else
    {
         [self UpdateUserInfo];
    }
   
}
@end
