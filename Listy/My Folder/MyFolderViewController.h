//
//  MyFolderViewController.h
//  Listy
//
//  Created by Silstone on 06/09/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFolderViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *searchView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UITextField *searchField;
- (IBAction)cancelBtnAction:(id)sender;
@property (strong, nonatomic) NSString *saveItemStr;

@end
