//
//  FeaturedListCell.h
//  Listy
//
//  Created by Silstone on 22/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeaturedListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *featuredListNamelbl;
@property (strong, nonatomic) IBOutlet UIImageView *listImageView;
@property (strong, nonatomic) IBOutlet UIView *linkView;
@property (strong, nonatomic) IBOutlet UIImageView *linkImage;
@property (strong, nonatomic) IBOutlet UIButton *changePicBtn;
@property (strong, nonatomic) IBOutlet UILabel *itemLikeNumber;
@property (strong, nonatomic) IBOutlet UIImageView *heartIcon;

@end
