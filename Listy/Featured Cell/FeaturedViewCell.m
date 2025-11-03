//
//  FeaturedViewCell.m
//  Listy
//
//  Created by Silstone on 09/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "FeaturedViewCell.h"
#import "Listy.pch"

@implementation FeaturedViewCell
{
    NSMutableArray *imageArray,*iconImageArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //Set Main Cell in Collection View
    imageArray = [[NSMutableArray alloc]initWithObjects:@"dummy_image_portrait_1",@"dummy_image_portrait_2",@"dummy_image_portrait_3",@"dummy_image_portrait_1",@"dummy_image_portrait_2",@"dummy_image_portrait_3", nil];
    iconImageArray = [[NSMutableArray alloc]initWithObjects:@"experia",@"netflix",@"spotify",@"experia",@"netflix",@"spotify", nil];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"FeaturedCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"FeaturedCollectionCell"];
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
    FeaturedCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeaturedCollectionCell" forIndexPath:indexPath];

    cell.iconImage.layer.cornerRadius = cell.iconImage.frame.size.height/2;
    cell.iconImage.layer.masksToBounds = YES;
    //[cell.iconImage setHidden:YES];
    //cell.iconImage.image = [UIImage imageNamed:[iconImageArray objectAtIndex:indexPath.row]];
    
    cell.activityImage.layer.cornerRadius = 4;
    cell.activityImage.layer.masksToBounds = YES;
    UIImage *placeholderImage = [UIImage imageNamed:@"profile_background"];
    
    NSMutableDictionary *itemDict = [self.listArray objectAtIndex:indexPath.row];
    //NSString *urlStr = [NSString stringWithFormat:kBaseURL@"CreateThumbnailURL?listid=%@&listitemid=%d&url=%@&width=%@&height=0",[itemDict valueForKey:@"id"],0,[itemDict valueForKey:@"list_image"],kCover_width];
    
    NSURL *customUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[itemDict valueForKey:@"list_image"]]];
    [cell.activityImage sd_setImageWithURL:customUrl placeholderImage:placeholderImage options:0 progress:nil completed:nil];
    cell.listTitle.text = [[self.listArray objectAtIndex:indexPath.row] valueForKey:@"ListName"];
    
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
