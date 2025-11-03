//
//  CategoryTableViewCell.m
//  Listy
//
//  Created by Silstone on 09/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "CategoryTableViewCell.h"
#import "Listy.pch"

@implementation CategoryTableViewCell
{
    NSMutableArray *imageArray;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    imageArray = [[NSMutableArray alloc]initWithObjects:@"dummy_image_square_1",@"dummy_image_square_2",@"dummy_image_square_3",@"dummy_image_square_4",@"dummy_image_square_5", nil];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CategoryCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CategoryCollectionCell"];
    self.collectionView.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.listArray.count>10) {
        return 10;
    }
    return self.listArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CategoryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCollectionCell" forIndexPath:indexPath];
    
    cell.activityImage.layer.cornerRadius = 4;
    cell.activityImage.layer.masksToBounds = YES;
    cell.overlayImage.layer.cornerRadius = 4;
    cell.overlayImage.clipsToBounds = YES;
    UIImage *placeHolderImage = [UIImage imageNamed:@"profile_background"];
    
    NSMutableDictionary *itemDict = [self.listArray objectAtIndex:indexPath.row];
    //NSString *urlStr = [NSString stringWithFormat:kBaseURL@"CreateThumbnailURL?listid=%@&listitemid=%d&url=%@&width=%@&height=0",[itemDict valueForKey:@"id"],0,[itemDict valueForKey:@"list_image"],kCover_width];
    
    NSURL *customUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[itemDict valueForKey:@"list_image"]]];
    
    [cell.activityImage sd_setImageWithURL:customUrl placeholderImage:placeHolderImage options:0 progress:nil completed:nil];
    cell.titleLable.text = [[self.listArray objectAtIndex:indexPath.row] valueForKey:@"ListName"];
    cell.likeLable.text = [[self.listArray objectAtIndex:indexPath.row] valueForKey:@"LikeCount"];
    cell.percentageLable.text = [NSString stringWithFormat:@"%@%%",[[self.listArray objectAtIndex:indexPath.row] valueForKey:@"recPercentage"]];
    
    CGSize  textSize = {122, 36};
    
    CGSize size = [[NSString stringWithFormat:@"%@", cell.titleLable.text]
                   sizeWithFont:[cell.titleLable font]
                   constrainedToSize:textSize
                   lineBreakMode:NSLineBreakByWordWrapping];
    cell.titleHeightConstant.constant = size.height+5;

    
    return cell;
}

//- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return NO;
//}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    return CGSizeMake(self.collectionView.frame.size.width/2-5, 50);
//}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//
//
//    return 10.0;
//}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    
    
    return 19.06;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath

{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveDiscoverList" object:self userInfo:[self.listArray objectAtIndex:indexPath.row]];
    
}


@end
