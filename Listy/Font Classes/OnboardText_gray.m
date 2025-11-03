//
//  OnboardText_gray.m
//  Listy
//
//  Created by Silstone on 07/08/18.
//  Copyright © 2018 Silstone. All rights reserved.
//

#import "OnboardText_gray.h"

@implementation OnboardText_gray

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
    
    self.textColor =  [UIColor colorWithRed:0.71 green:0.72 blue:0.78 alpha:1.0];
    
    CGFloat newFontSize;
    if([[UIScreen mainScreen] bounds].size.height == 568.0)
    {
        //iphone 5
        newFontSize = 9;;
    }
    else if ([[UIScreen mainScreen] bounds].size.height == 667.0)
    {
        //iphone 6
        newFontSize = 13;
    }
    else {
        newFontSize = 13;
    }
    
    [self setFont:[UIFont fontWithName:@"SFProText-Medium" size:newFontSize]];
}


@end
