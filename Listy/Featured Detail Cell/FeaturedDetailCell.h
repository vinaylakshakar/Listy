//
//  FeaturedDetailCell.h
//  Listy
//
//  Created by Silstone on 13/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeaturedDetailCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *backImage;
@property (strong, nonatomic) IBOutlet UIImageView *iconImage;
@property (strong, nonatomic) IBOutlet UILabel *categoryName;
@property (strong, nonatomic) IBOutlet UILabel *listName;
@property (strong, nonatomic) IBOutlet UILabel *listDescription;
@property (strong, nonatomic) IBOutlet UIImageView *gradientImage;
@property (strong, nonatomic) IBOutlet UILabel *likeCount;
@property (strong, nonatomic) IBOutlet UILabel *percentage;

@end
