//
//  DeletedListCell.h
//  Listy
//
//  Created by Silstone on 14/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeletedListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *btnSelected;
@property (strong, nonatomic) IBOutlet UIImageView *listImageVIew;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLable;
@property (strong, nonatomic) IBOutlet UILabel *listTitle;

@end
