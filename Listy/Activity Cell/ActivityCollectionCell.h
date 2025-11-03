//
//  ActivityCollectionCell.h
//  Listy
//
//  Created by Silstone on 09/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityCollectionCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *activityImage;
@property (strong, nonatomic) IBOutlet UIImageView *iconImage;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *activityName;
@property (strong, nonatomic) IBOutlet UILabel *listName;
@property (strong, nonatomic) IBOutlet UIImageView *gradientImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleHeightConstant;

@end
