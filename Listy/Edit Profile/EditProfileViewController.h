//
//  EditProfileViewController.h
//  Listy
//
//  Created by Silstone on 27/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditProfileViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    BOOL click_reg;
    UIImage *imageOriginal;
    NSData *imgData;
    BOOL isChooseImage;
    
}
- (IBAction)backBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UITextView *aboutField;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *locationField;
@property (strong, nonatomic) IBOutlet UIImageView *coverImage;
- (IBAction)changeProfileImage:(id)sender;
- (IBAction)changeCoverImage:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *aboutLable;
- (IBAction)updateProfileAction:(id)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topProfileConstraint;

@end
