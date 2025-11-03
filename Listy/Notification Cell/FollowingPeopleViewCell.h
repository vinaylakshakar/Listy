//
//  FollowingPeopleViewCell.h
//  Listy
//
//  Created by Silstone on 13/11/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FollowingPeopleViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *followerImage;
@property (strong, nonatomic) IBOutlet UIView *countView;

@end

NS_ASSUME_NONNULL_END
