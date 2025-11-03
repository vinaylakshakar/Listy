//
//  KeywordViewController.m
//  Listy
//
//  Created by Silstone on 15/10/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "KeywordViewController.h"
#import "Listy.pch"


@interface KeywordViewController ()

@end

@implementation KeywordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self setTagView];
    [self.tabBarController.tabBar setHidden:YES];
    [self setTag:self.keywords];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)setTag:(NSString*)keywords
{
    //NSArray *tags = @[@"Movies",@"80's",@"Sound track",@"Cult",@"80's",@"Sound track",@"Cult"];
    NSArray *tags = [keywords componentsSeparatedByString:@","];
    
    self.tagView.alignment = TTGTagCollectionAlignmentFillByExpandingWidth;
    
    TTGTextTagConfig *config = [TTGTextTagConfig new];
    //config.tagTextFont = [UIFont fontWithName:@"SFProText-Regular" size:5];
    
    config.tagTextColor = [UIColor whiteColor];
    // config.tagSelectedTextColor = RED_COLOR;
    config.tagExtraSpace = CGSizeMake(25, 25);
    // _tagView.horizontalSpacing =10;
    _tagView.verticalSpacing =10;
    
    NSUInteger location = 0;
    NSUInteger length = tags.count;
    config.tagBackgroundColor = RED_COLOR;
    config.tagShadowOpacity = 0.0;
    config.tagBorderColor = [UIColor clearColor];
    config.tagShadowRadius =1;
    config.tagSelectedBackgroundColor = RED_COLOR;
    config.tagTextFont = [UIFont fontWithName:@"SFProText-Medium" size:13];
//    config.tagCornerRadius = 13;
//    config.tagSelectedCornerRadius =13;
    config.tagSelectedBorderColor = [UIColor clearColor];
    config.extraData = @{@"key": @"1"};
    [self.tagView addTags:[tags subarrayWithRange:NSMakeRange(location, length)] withConfig:[config copy]];
    
    self.tagView.delegate = self;
    [self.tagView setShowsVerticalScrollIndicator:NO];
    //[self.tagView setShowsHorizontalScrollIndicator:NO];
    
    
}
@end
