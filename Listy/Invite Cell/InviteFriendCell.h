//
//  InviteFriendCell.h
//  Listy
//
//  Created by Silstone on 07/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteFriendCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UIButton *selectFriendBtn;

@end
