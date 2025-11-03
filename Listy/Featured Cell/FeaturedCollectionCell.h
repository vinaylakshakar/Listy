//
//  FeaturedCollectionCell.h
//  Listy
//
//  Created by Silstone on 09/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeaturedCollectionCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iconImage;
@property (strong, nonatomic) IBOutlet UIImageView *activityImage;
@property (strong, nonatomic) IBOutlet UILabel *listTitle;

@end
