//
//  GeneralOptionsViewController.h
//  Listy
//
//  Created by Silstone on 23/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GeneralOptionsViewController : UIViewController<UIActivityItemSource>
- (IBAction)cancelBtnAction:(id)sender;
- (IBAction)reportBtnAction:(id)sender;
- (IBAction)saveBtnAction:(id)sender;
@property BOOL isfromList;
@property BOOL isfromDiscoverCategory;
@property (strong, nonatomic) NSDictionary *detailDict;
- (IBAction)shareList:(id)sender;
@property (strong, nonatomic) UIImage *listImage;

@end
