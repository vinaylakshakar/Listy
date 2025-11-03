//
//  TopListViewController.h
//  Listy
//
//  Created by Silstone on 18/01/19.
//  Copyright © 2019 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TopListViewController : UIViewController

@property (strong, nonatomic) IBOutlet UICollectionView *listCollection;
@property (strong, nonatomic) NSMutableArray *topListArray;
- (IBAction)backBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *searchField;
@property BOOL isRelatedList;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) NSMutableDictionary *relatedDict;
@end

NS_ASSUME_NONNULL_END
