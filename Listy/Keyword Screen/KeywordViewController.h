//
//  KeywordViewController.h
//  Listy
//
//  Created by Silstone on 15/10/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TTGTagCollectionView/TTGTextTagCollectionView.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeywordViewController : UIViewController<TTGTextTagCollectionViewDelegate>

- (IBAction)backBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet TTGTextTagCollectionView *tagView;
@property (strong, nonatomic) NSString *keywords;
@end

NS_ASSUME_NONNULL_END
