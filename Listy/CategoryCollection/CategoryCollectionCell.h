//
//  CategoryCollectionCell.h
//  Listy
//
//  Created by Silstone on 09/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryCollectionCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *overlayImage;
@property (strong, nonatomic) IBOutlet UIButton *dotBtn;
@property (strong, nonatomic) IBOutlet UIImageView *activityImage;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UILabel *percentageLable;
@property (strong, nonatomic) IBOutlet UILabel *likeLable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleHeightConstant;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstant;

@end
