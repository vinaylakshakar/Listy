//
//  CommentViewCell.h
//  Listy
//
//  Created by Silstone on 22/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *commentTime;
@property (strong, nonatomic) IBOutlet UITextView *commentText;

@end
