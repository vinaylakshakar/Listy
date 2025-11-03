//
//  OnboardingStep1ViewController.h
//  Listy
//
//  Created by Silstone on 07/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TTGTagCollectionView/TTGTextTagCollectionView.h>

@interface OnboardingStep1ViewController : UIViewController<TTGTextTagCollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *categoryCollection;
@property (strong, nonatomic) IBOutlet TTGTextTagCollectionView *tagView;
- (IBAction)loadmoreCategories:(id)sender;
- (IBAction)nextBtnAction:(id)sender;
-(NSMutableArray*)returnJsonArray;

@end
