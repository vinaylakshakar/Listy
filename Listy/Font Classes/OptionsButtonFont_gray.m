//
//  OptionsButtonFont_gray.m
//  Listy
//
//  Created by Silstone on 23/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "OptionsButtonFont_gray.h"

@implementation OptionsButtonFont_gray

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithCoder:(NSCoder *)aDecoder {
    if( (self = [super initWithCoder:aDecoder]) ){
        [self layoutIfNeeded];
        [self configurefont];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if( (self = [super initWithFrame:frame]) ){
        [self layoutIfNeeded];
        [self configurefont];
    }
    return self;
}

- (void) configurefont {
    // CGFloat newFontSize = (self.font.pointSize * SCALE_FACTOR_H);
    //    self.font = [UIFont fontWithName:@"ProximaNova-Regular" size:24];
    //
    //    CGFloat newFontSize = (self.font.pointSize * SCALE_FACTOR_H);
    
    //self.font = [UIFont fontWithName:@"SegoeUI" size:18];
    
    //self.titleLabel.textColor =  [UIColor colorWithRed:0.71 green:0.72 blue:0.78 alpha:1.0];
    [self setTitleColor:[UIColor colorWithRed:0.71 green:0.72 blue:0.78 alpha:1.0] forState:UIControlStateNormal];
    
    CGFloat newFontSize;
    if([[UIScreen mainScreen] bounds].size.height == 568.0)
    {
        //iphone 5
        newFontSize = 9;;
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667.0)
    {
        //iphone 6
        newFontSize = 22;
    }
    else {
        newFontSize = 22;
    }
    
    [self setFont:[UIFont fontWithName:@"SFProDisplay-Bold" size:newFontSize]];
}

@end
