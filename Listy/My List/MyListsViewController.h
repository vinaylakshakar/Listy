//
//  MyListsViewController.h
//  Listy
//
//  Created by Silstone on 14/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyListsViewController : UIViewController<UITextFieldDelegate,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UIView *searchView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *folderView;
- (IBAction)deletedListAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *folderNameField;
@property (strong, nonatomic) IBOutlet UIVisualEffectView *effectView;
- (IBAction)createFolderAction:(id)sender;
- (IBAction)Cancel:(id)sender;
- (IBAction)ok:(id)sender;
- (IBAction)searchBtnAction:(id)sender;
- (IBAction)draftlistsAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *searchField;


@end
