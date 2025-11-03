//
//  LikedViewCell.h
//  Listy
//
//  Created by Silstone on 13/11/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LikedViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *listname;
@property (strong, nonatomic) IBOutlet UILabel *timeLbl;
@property (strong, nonatomic) NSMutableArray *itemArray;
@property (strong, nonatomic) NSDictionary *notificationDict;
@property (strong, nonatomic) IBOutlet UIButton *profileBtn;

@end

NS_ASSUME_NONNULL_END
