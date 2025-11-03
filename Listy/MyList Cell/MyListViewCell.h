//
//  MyListViewCell.h
//  Listy
//
//  Created by Silstone on 14/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyListViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *listNameLable;
@property (strong, nonatomic) IBOutlet UIImageView *listImage;
@property (strong, nonatomic) IBOutlet UILabel *listNumberlbl;

@end
