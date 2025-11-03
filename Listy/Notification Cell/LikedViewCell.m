//
//  LikedViewCell.m
//  Listy
//
//  Created by Silstone on 13/11/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "LikedViewCell.h"
#import "Listy.pch"

@implementation LikedViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.collectionView registerNib:[UINib nibWithNibName:@"LikedCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LikedCollectionViewCell"];
    self.collectionView.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.itemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LikedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LikedCollectionViewCell" forIndexPath:indexPath];
    [cell.itemImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[self.itemArray objectAtIndex:indexPath.row] valueForKey:@"listItemImage"]]] placeholderImage:[UIImage imageNamed:@"profile_background"] options:0 progress:nil completed:nil];
    cell.itemImage.layer.cornerRadius = 15;
    cell.itemImage.clipsToBounds =YES;
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath

{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveLikedList" object:self userInfo:self.notificationDict];
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    
    
    return 8.0;
}


@end
