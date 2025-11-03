//
//  CreateListItemViewController.h
//  Listy
//
//  Created by Silstone on 23/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateListItemViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *createListView;
- (IBAction)listBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *addImageBtn;
@property (strong, nonatomic) IBOutlet UIButton *listBtn;

@end
