//
//  CategoryDetailCell.h
//  Listy
//
//  Created by Silstone on 13/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TTGTagCollectionView/TTGTextTagCollectionView.h>

@interface CategoryDetailCell : UITableViewCell<TTGTextTagCollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *categoryImage;
@property (weak, nonatomic) IBOutlet TTGTextTagCollectionView *tagView;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UIButton *dotBtn;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *listName;
@property (strong, nonatomic) IBOutlet UILabel *percentageLable;
@property (strong, nonatomic) IBOutlet UILabel *likeLable;
@property (strong, nonatomic) IBOutlet UIImageView *gradientImage;

@end
