//
//  CategoryTableViewCell.h
//  Listy
//
//  Created by Silstone on 09/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIButton *seeAllBtn;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) NSMutableArray *listArray;

@end
