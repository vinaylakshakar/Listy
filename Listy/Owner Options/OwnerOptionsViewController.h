//
//  OwnerOptionsViewController.h
//  Listy
//
//  Created by Silstone on 23/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OwnerOptionsViewController : UIViewController
- (IBAction)cancelBtnAction:(id)sender;
- (IBAction)deleteList:(id)sender;
- (IBAction)editlist:(id)sender;
@property BOOL isfromList;
@property BOOL isfromDiscoverCategory;
@property (strong, nonatomic) NSDictionary *detailDict;
@property (strong, nonatomic) UIImage *listImage;
- (IBAction)shareList:(id)sender;

@end
