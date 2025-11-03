//
//  ListItemViewCell.h
//  Listy
//
//  Created by Silstone on 29/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListItemViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *itemName;
@property (strong, nonatomic) IBOutlet UIImageView *itemImage;

@end
