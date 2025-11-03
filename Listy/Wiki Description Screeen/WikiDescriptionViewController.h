//
//  WikiDescriptionViewController.h
//  Listy
//
//  Created by Silstone on 22/11/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WikiDescriptionViewController : UIViewController

- (IBAction)cancelBtnAction:(id)sender;
- (IBAction)addDescrptionAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *wikiTextView;
@property (strong, nonatomic) NSMutableArray *wikiDescArray;
@property (strong, nonatomic) NSString *titleStr;
@property (strong, nonatomic) IBOutlet UIButton *addWikiTextBtn;
@property (strong, nonatomic) IBOutlet UITableView *wikisearchTable;
@property (strong, nonatomic) IBOutlet UIView *searchView;

@end

NS_ASSUME_NONNULL_END
