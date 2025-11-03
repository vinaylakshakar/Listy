//
//  ActivityViewCell.m
//  Listy
//
//  Created by Silstone on 09/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "ActivityViewCell.h"
#import "Listy.pch"

@implementation ActivityViewCell
{
    NSMutableArray *imageArray,*iconImageArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    imageArray = [[NSMutableArray alloc]initWithObjects:@"dummy_image_square_1",@"dummy_image_square_2",@"dummy_image_square_3",@"dummy_image_square_4",@"dummy_image_square_5", nil];
    iconImageArray = [[NSMutableArray alloc]initWithObjects:@"images-1",@"Unknown",@"images-1",@"Unknown",@"images-1",@"Unknown", nil];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ActivityCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"ActivityCollectionCell"];
    self.collectionView.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.friendsActivity.count>10) {
        return 10;
    }
    return self.friendsActivity.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ActivityCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ActivityCollectionCell" forIndexPath:indexPath];
    
    cell.activityImage.layer.cornerRadius = 4;
    cell.activityImage.layer.masksToBounds = YES;
   // cell.activityImage.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
    cell.iconImage.layer.cornerRadius = cell.iconImage.frame.size.height/2;
    cell.iconImage.layer.masksToBounds = YES;
   // cell.iconImage.image = [UIImage imageNamed:[iconImageArray objectAtIndex:indexPath.row]];
    NSMutableDictionary *itemDict = [self.friendsActivity objectAtIndex:indexPath.row];
   // NSString *urlStr = [NSString stringWithFormat:kBaseURL@"CreateThumbnailURL?listid=%@&listitemid=%d&url=%@&width=%@&height=0",[itemDict valueForKey:@"id"],0,[itemDict valueForKey:@"list_image"],kCover_width];
    
    NSURL *customUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[itemDict valueForKey:@"list_image"]]];
    
    [cell.activityImage sd_setImageWithURL:customUrl placeholderImage:[UIImage imageNamed:@"profile_background"] options:0 progress:nil completed:nil];
    [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[self.friendsActivity objectAtIndex:indexPath.row] valueForKey:@"actionUserImage"]]] placeholderImage:[UIImage imageNamed:@"user_profile"] options:0 progress:nil completed:nil];
    cell.userName.text = [[self.friendsActivity objectAtIndex:indexPath.row] valueForKey:@"actionUserName"];
    
    if ([[[self.friendsActivity objectAtIndex:indexPath.row] valueForKey:@"actionPerformed"] isEqualToString:@"Created"])
    {
        cell.activityName.text = [NSString stringWithFormat:@"%@ a list",[[self.friendsActivity objectAtIndex:indexPath.row] valueForKey:@"actionPerformed"]];
    } else {
        cell.activityName.text = [NSString stringWithFormat:@"%@ %@'s list",[[self.friendsActivity objectAtIndex:indexPath.row] valueForKey:@"actionPerformed"],[[self.friendsActivity objectAtIndex:indexPath.row] valueForKey:@"listOwnerName"]];
    }
    
    cell.listName.text = [[self.friendsActivity objectAtIndex:indexPath.row] valueForKey:@"actionListName"];
    
    CGSize  textSize = {122, 36};
    
    CGSize size = [[NSString stringWithFormat:@"%@", cell.listName.text]
                   sizeWithFont:[cell.listName font]
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveDiscoverList" object:self userInfo:[self.friendsActivity objectAtIndex:indexPath.row]];
    
}

@end
