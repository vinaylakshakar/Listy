//
//  CommentNotificationViewCell.h
//  Listy
//
//  Created by Silstone on 13/11/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentNotificationViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *timeLbl;
@property (strong, nonatomic) IBOutlet UIImageView *listImage;
@property (strong, nonatomic) IBOutlet UITextView *commentTxt;
@property (strong, nonatomic) IBOutlet UIButton *profileBtn;
@property (strong, nonatomic) IBOutlet UIButton *listBtn;

@end

NS_ASSUME_NONNULL_END
